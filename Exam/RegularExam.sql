-- CREATE DATABASE Boardgames
-- USE Boardgames

--PROBLEM 1
CREATE TABLE Categories
(
	Id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50) NOT NULL
)
CREATE TABLE Addresses
(
	Id INT PRIMARY KEY IDENTITY,
	StreetName NVARCHAR(100) NOT NULL,
	StreetNumber INT NOT NULL,
	Town VARCHAR(30) NOT NULL,
	Country VARCHAR(50) NOT NULL,
	ZIP INT NOT NULL
)
CREATE TABLE Publishers
(
	Id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(30) UNIQUE NOT NULL,
	AddressId INT REFERENCES Addresses(Id) NOT NULL,
	Website NVARCHAR(40),
	Phone NVARCHAR(20)
)
CREATE TABLE PlayersRanges
(
	Id INT PRIMARY KEY IDENTITY,
	PlayersMin INT NOT NULL,
	PlayersMax INT NOT NULL
)
CREATE TABLE Boardgames
(
	Id INT PRIMARY KEY IDENTITY,
	Name NVARCHAR(30) NOT NULL,
	YearPublished INT NOT NULL,
	Rating DECIMAL(18,2) NOT NULL,
	CategoryId	INT REFERENCES Categories(Id) NOT NULL,
	PublisherId INT REFERENCES Publishers(Id) NOT NULL,
	PlayersRangeId INT REFERENCES PlayersRanges(Id) NOT NULL
)
CREATE TABLE Creators
(
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(30) NOT NULL,
	LastName NVARCHAR(30) NOT NULL,
	Email NVARCHAR(30) NOT NULL
)
CREATE TABLE CreatorsBoardgames
(
	CreatorId INT REFERENCES Creators(Id) NOT NULL,
	BoardgameId INT REFERENCES Boardgames(Id) NOT NULL,
	CONSTRAINT PK_CreatorsBoardgames PRIMARY KEY (CreatorId,BoardgameId)
)
--PROBLEM 2
INSERT INTO Boardgames VALUES
('Deep Blue',2019,5.67,1,15,7),
('Paris',2016,9.78,7,1,5),
('Catan: Starfarers',2021,9.87,7,13,6),
('Bleeding Kansas',2020,3.25,3,7,4),
('One Small Step',2019,5.75,5,9,2)

INSERT INTO Publishers VALUES
('Agman Games',5,'www.agmangames.com','+16546135542'),
('Amethyst Games',7,'www.amethystgames.com','+15558889992'),
('BattleBooks',13,'www.battlebooks.com','+12345678907')

--PROBLEM 3
	UPDATE PlayersRanges
	   SET PlayersMax += 1
	 WHERE PlayersMin = 2 AND PlayersMax=2

	UPDATE Boardgames
	   SET Name = CONCAT(Name,'V2')
	 WHERE YearPublished >= 2020


--PROBLEM 4
	DELETE
	  FROM CreatorsBoardgames
	 WHERE BoardgameId IN (
							SELECT Id
							  FROM Boardgames
							WHERE PublisherId IN (
							SELECT Id
							  FROM Publishers
							 WHERE AddressId  IN (
													 SELECT Id
													   FROM Addresses
													  WHERE Town LIKE 'L%' 
												 )
						  )
						  )



	DELETE
	  FROM Boardgames
	 WHERE PublisherId IN (
							SELECT Id
							  FROM Publishers
							 WHERE AddressId  IN (
													 SELECT Id
													   FROM Addresses
													  WHERE Town LIKE 'L%' 
												 )
						  )

	DELETE
	  FROM Publishers
	 WHERE AddressId  IN (
						SELECT Id
						  FROM Addresses
						 WHERE Town LIKE 'L%' 
						)

	DELETE
	  FROM Addresses
						 WHERE Town LIKE 'L%'

--PROBLEM 5
	SELECT Name,
		   Rating
	  FROM Boardgames
  ORDER BY YearPublished,Name DESC

--PROBLEM 6
	SELECT b.Id,
		   b.Name,
		   b.YearPublished,
		   c.Name AS categoryName
	  FROM Boardgames AS b
	  JOIN Categories AS c
	    ON b.CategoryId=c.Id
	 WHERE c.Name = 'Wargames' OR c.Name = 'Strategy Games'
  ORDER BY b.YearPublished DESC

--PROBLEM 7
	SELECT c.Id,
		   CONCAT(c.FirstName,' ',c.LastName) AS CreatorName,
		   c.Email
	  FROM Creators AS c
	 WHERE c.Id NOT IN (
					    SELECT DISTINCT CreatorId
						  FROM CreatorsBoardgames
					   )
  ORDER BY CONCAT(c.FirstName,c.LastName)

--PROBLEM 8
	SELECT TOP(5) b.Name,
				  b.Rating,
				  c.Name AS CategoryName
	  FROM Boardgames AS b
	  JOIN PlayersRanges AS pr
	    ON b.PlayersRangeId = pr.Id
	  JOIN Categories AS c
	    ON c.Id=b.CategoryId
	 WHERE (b.Rating>7 AND b.Name LIKE '%a%')
	    OR (b.Rating>7.50 AND pr.PlayersMin=1 AND pr.PlayersMax=5)
  ORDER BY b.Name,b.Rating DESC

--PROBLEM 9
  SELECT CONCAT(c.FirstName,' ',c.LastName) AS FullName,
		 c.Email,
		 MAX(b.Rating) AS Rating
    FROM Creators AS c
	JOIN CreatorsBoardgames AS cb
	  ON cb.CreatorId = c.Id
	JOIN Boardgames AS b
	  ON cb.BoardgameId = b.Id
GROUP BY c.FirstName,c.LastName,c.Email
  HAVING Email LIKE '%.com'
ORDER BY FullName


--PROBLEM 10
	SELECT LastName,
		   CAST(CEILING(AverageRating) AS INT) AS AverageRating,
		   PublisherName
	  FROM (SELECT c.LastName,
		   AVG(b.Rating) AS AverageRating,
		   p.Name AS PublisherName
	  FROM Creators AS c
	  JOIN CreatorsBoardgames AS cb
	  ON cb.CreatorId = c.Id
	JOIN Boardgames AS b
	  ON cb.BoardgameId = b.Id
	JOIN Publishers as p
	  ON b.PublisherId = p.Id
   WHERE p.Name = 'Stonemaier Games'
     AND c.Id IN (
				  SELECT DISTINCT CreatorId
				    FROM CreatorsBoardgames
				 )
GROUP BY c.LastName,p.Name) AS k
ORDER BY k.AverageRating DESC

--PROBLEM 11
CREATE OR ALTER FUNCTION udf_CreatorWithBoardgames  (@name VARCHAR(30))
RETURNS INT
AS
BEGIN
	

	DECLARE @result INT = (SELECT COUNT(cb.BoardgameId)
	  FROM Creators AS c
	  LEFT JOIN CreatorsBoardgames AS cb
	    ON c.Id = cb.CreatorId
	  LEFT JOIN Boardgames AS b
	    ON cb.BoardgameId = b.Id
	 WHERE c.FirstName LIKE '%'+@name+'%'
  GROUP BY c.FirstName)

  RETURN @result
END

--PROBLEM 12

CREATE PROCEDURE usp_SearchByCategory @category VARCHAR(30)
AS
BEGIN
	SELECT b.Name,
		   b.YearPublished,
		   b.Rating,
		   c.Name AS CategoryName,
		   p.Name AS PublisherName,
		   CONCAT(PlayersMin,' ','people') AS MinPlayers,
		   CONCAT(PlayersMax,' ','people') AS MaxPlayers
	  FROM Boardgames AS b
	  JOIN Categories AS c
	    ON b.CategoryId = c.Id
	  JOIN Publishers AS p
	    ON p.Id=b.PublisherId
	  JOIN PlayersRanges AS pr
	    ON pr.Id = b.PlayersRangeId
	 WHERE c.Name = @category
  ORDER BY p.Name,b.YearPublished
END

EXEC usp_SearchByCategory 'Wargames'