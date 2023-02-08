--PROBLEM 1
CREATE TABLE Categories
(
	Id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50) NOT NULL
)

CREATE TABLE Locations
(
	Id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50) NOT NULL,
	Municipality VARCHAR(50),
    Province VARCHAR(50)
)

CREATE TABLE Sites
(
	Id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(100) NOT NULL,
	LocationId INT REFERENCES Locations(Id) NOT NULL,
	CategoryId INT REFERENCES Categories(Id) NOT NULL,
	Establishment VARCHAR(15)
)

CREATE TABLE Tourists
(
	Id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50) NOT NULL,
	Age INT CHECK(Age BETWEEN 0 AND 120) NOT NULL,
	PhoneNumber VARCHAR(20) NOT NULL,
	Nationality VARCHAR(30) NOT NULL,
	Reward VARCHAR(20)
)

CREATE TABLE SitesTourists
(
	TouristId INT REFERENCES Tourists(Id) NOT NULL,
	SiteId INT REFERENCES Sites(Id) NOT NULL,
	CONSTRAINT PK_SitesTourists PRIMARY KEY (TouristId, SiteId)
)

CREATE TABLE BonusPrizes
(
	Id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50) NOT NULL,
)

CREATE TABLE TouristsBonusPrizes
(
	TouristId INT REFERENCES Tourists(Id) NOT NULL,
	BonusPrizeId INT REFERENCES BonusPrizes(Id) NOT NULL,
	CONSTRAINT PK_TouristsBonusPrizes PRIMARY KEY (TouristId, BonusPrizeId)
)
--PROBLEM 2
INSERT INTO Tourists (Name,Age,PhoneNumber,Nationality,Reward) VALUES
('Borislava Kazakova',52,   '+359896354244',    'Bulgaria',NULL),
('Peter Bosh'	     ,48,	'+447911844141',	'UK'      ,NULL),
('Martin Smith'	     ,29,	'+353863818592',	'Ireland' ,'Bronze badge'),
('Svilen Dobrev'	 ,49,	'+359986584786',	'Bulgaria','Silver badge'),
('Kremena Popova'	 ,38,	'+359893298604',	'Bulgaria',NULL)

INSERT INTO Sites VALUES
('Ustra fortress'				 ,90,7,'X'),
('Karlanovo Pyramids'			 ,65,7,NULL),
('The Tomb of Tsar Sevt'		 ,63,8,'V BC'),
('Sinite Kamani Natural Park'	 ,17,1,NULL),
('St. Petka of Bulgaria – Rupite',92,6,'1994')

--PROBLEM 3 
UPDATE Sites
	SET Establishment = '(not defined)'
  WHERE Establishment IS NULL

--PROBLEM 4
DELETE
  FROM TouristsBonusPrizes
 WHERE BonusPrizeId =5

DELETE
  FROM BonusPrizes
 WHERE Name = 'Sleeping bag'

--PROBLEM 5
SELECT Name,
	   Age,
	   PhoneNumber,
	   Nationality
  FROM Tourists
ORDER BY Nationality,Age DESC, Name

--PROBLEM 6
	SELECT s.Name AS Site,
		   l.Name AS Location,
		   s.Establishment,
		   c.Name AS Category
	  FROM Sites AS s
	  JOIN Locations AS l
	    ON s.LocationId=l.Id
	  JOIN Categories AS c
	    ON c.Id = s.CategoryId
  ORDER BY c.Name DESC,l.Name,s.Name

--PROBLEM 7
	SELECT l.Province,
		   l.Municipality,
		   l.Name AS Location,
		   COUNT(s.Id) AS CountOfSites
	  FROM Sites AS s
	  JOIN Locations AS l
	    ON s.LocationId=l.Id
  GROUP BY l.Name, l.Province,l.Municipality
    HAVING l.Province LIKE 'Sofia'
  ORDER BY COUNT(s.Id) DESC, l.Name

--PROBLEM 8
	SELECT s.Name,
		   l.Name AS Location,
		   l.Municipality,
		   l.Province,
		   s.Establishment
	  FROM Sites AS s
	  JOIN Locations AS l
	    ON s.LocationId=l.Id
	 WHERE LEFT(l.Name,1) NOT IN ('B','M','D')
	   AND s.Establishment LIKE '% BC'
  ORDER BY s.Name

--PROBLEM 9
	SELECT t.Name,
	       t.Age,
		   t.PhoneNumber,
		   t.Nationality,
		    CASE
		   WHEN b.Name IS NULL THEN '(no bonus prize)'
		   WHEN b.Name IS NOT NULL THEN b.Name
		   END AS Reward
	  FROM Tourists AS t
	  FULL JOIN TouristsBonusPrizes AS tb
	    ON tb.TouristId = t.Id
	  LEFT JOIN BonusPrizes AS b
	    ON b.Id= tb.BonusPrizeId
  ORDER BY t.Name

  SELECT *
	  FROM Tourists
  ORDER BY Name

--PROBLEM 10
	SELECT DISTINCT RIGHT(t.Name,LEN(t.Name)-CHARINDEX(' ',t.Name)) AS LastName,
		   t.Nationality,
		   t.Age,
		   t.PhoneNumber
	  FROM Tourists AS t
	  JOIN SitesTourists AS st
	    ON t.Id = st.TouristId
	  JOIN Sites as s
	    ON s.Id = st.SiteId
	  JOIN Categories AS c
	    ON c.Id = s.CategoryId
	 WHERE c.Name = 'History and archaeology'
  ORDER BY RIGHT(t.Name,LEN(t.Name)-CHARINDEX(' ',t.Name))

--PROBLEM 11
CREATE FUNCTION udf_GetTouristsCountOnATouristSite (@Site VARCHAR(50))
RETURNS INT
AS
BEGIN
	RETURN (
			SELECT COUNT(TouristId)
			  FROM SitesTourists AS st
			  JOIN Sites AS s
			    ON s.Id= st.SiteId
		  GROUP BY SiteId,s.Name
		    HAVING s.Name = @Site
		   )
END

--PROBLEM 12
CREATE OR ALTER PROCEDURE usp_AnnualRewardLottery @TouristName VARCHAR(50)
AS
BEGIN
	IF (
		SELECT COUNT(st.SiteId)
		  FROM SitesTourists AS st
		  JOIN Tourists As t
		    ON t.Id = st.TouristId
      GROUP BY st.TouristId,t.Name
		HAVING t.Name = @TouristName
	   ) >=25
	BEGIN
		UPDATE Tourists
		   SET Reward = 'Bronze badge'
		 WHERE Name = @TouristName
	END
	IF (
		SELECT COUNT(st.SiteId)
		  FROM SitesTourists AS st
		  JOIN Tourists As t
		    ON t.Id = st.TouristId
      GROUP BY st.TouristId,t.Name
		HAVING t.Name = @TouristName
	   ) >=50
	BEGIN
		UPDATE Tourists
		   SET Reward = 'Silver badge'
		 WHERE Name = @TouristName
	END
	IF (
		SELECT COUNT(st.SiteId)
		  FROM SitesTourists AS st
		  JOIN Tourists As t
		    ON t.Id = st.TouristId
      GROUP BY st.TouristId,t.Name
		HAVING t.Name = @TouristName
	   ) >=100
	BEGIN
		UPDATE Tourists
		   SET Reward = 'Gold badge'
		 WHERE Name = @TouristName
	END

	SELECT Name,
		   Reward
	  FROM Tourists
	 WHERE Name =@TouristName
END

EXEC usp_AnnualRewardLottery 'Gerhild Lutgard'
