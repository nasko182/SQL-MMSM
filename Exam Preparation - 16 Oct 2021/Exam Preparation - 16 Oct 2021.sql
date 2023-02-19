--CREATE DATABASE CigarShop
--USE CigarShop

CREATE TABLE Sizes
(
	Id INT PRIMARY KEY IDENTITY,
	Length INT CHECK(Length BETWEEN 10 AND 25) NOT NULL,
	RingRange DECIMAL(18,2) CHECK(RingRange BETWEEN 1.5 AND 7.5) NOT NULL
)

CREATE TABLE Tastes
(
	Id INT PRIMARY KEY IDENTITY,
	TasteType VARCHAR(20) NOT NULL,
	TasteStrength VARCHAR(15) NOT NULL,
	ImageURL NVARCHAR(100) NOT NULL

)
CREATE TABLE Brands
(
	Id INT PRIMARY KEY IDENTITY,
	BrandName VARCHAR(30) UNIQUE NOT NULL,
	BrandDescription VARCHAR(MAX)

)
CREATE TABLE Cigars
(
	Id INT PRIMARY KEY IDENTITY,
	CigarName VARCHAR(80) NOT NULL,
	BrandId INT REFERENCES Brands(Id) NOT NULL,
	TastId INT REFERENCES Tastes(Id) NOT NULL,
	SizeId INT REFERENCES Sizes(Id) NOT NULL,
	PriceForSingleCigar MONEY NOT NULL,
	ImageURL NVARCHAR(100) NOT NULL
)
CREATE TABLE Addresses
(
	Id INT PRIMARY KEY IDENTITY,
	Town VARCHAR(30) NOT NULL,
	Country NVARCHAR(30) NOT NULL,
	Streat NVARCHAR(100) NOT NULL,
	ZIP VARCHAR(20) NOT NULL
)
CREATE TABLE Clients
(
	Id INT PRIMARY KEY IDENTITY,
	FirstName NVARCHAR(30) NOT NULL,
	LastName NVARCHAR(30) NOT NULL,
	Email NVARCHAR(50) NOT NULL,
	AddressId INT REFERENCES Addresses(Id) NOT NULL
)

CREATE TABLE ClientsCigars
(
	ClientId INT REFERENCES Clients(Id) NOT NULL,
	CigarId INT REFERENCES Cigars(Id) NOT NULL,
	CONSTRAINT PK_ClientsCigars PRIMARY KEY (ClientId,CigarId)
)
--PROBLEM 2

INSERT INTO Cigars (CigarName,BrandId,TastId,SizeId,PriceForSingleCigar,ImageURL)VALUES
('COHIBA ROBUSTO',9,1,5,15.50,'cohiba-robusto-stick_18.jpg'),
('COHIBA SIGLO I',9,1,10,410.00,'cohiba-siglo-i-stick_12.jpg'),
('HOYO DE MONTERREY LE HOYO DU MAIRE',14,5,11,7.50,'hoyo-du-maire-stick_17.jpg'),
('HOYO DE MONTERREY LE HOYO DE SAN JUAN',14,4,15,32.00,'hoyo-de-san-juan-stick_20.jpg'),
('TRINIDAD COLONIALES',2,3,8,85.21,'trinidad-coloniales-stick_30.jpg')

INSERT INTO Addresses VALUES
('Sofia','Bulgaria','18 Bul. Vasil levski',1000),
('Athens','Greece','4342 McDonald Avenue',10435),
('Zagreb','Croatia','4333 Lauren Drive',10000)
--PROBLEM 3
	UPDATE Cigars
	   SET PriceForSingleCigar += PriceForSingleCigar * 0.2
     WHERE TastId = 1

   UPDATE Brands
      SET BrandDescription = 'New description'
	WHERE BrandDescription IS NULL

--PROBLEM 4
	DELETE
	  FROM Clients
	 WHERE AddressId IN (SELECT Id
								FROM Addresses
							   WHERE LEFT(Country,1)='C')
	
	DELETE
	  FROM Addresses
	 WHERE LEFT(Country,1)='C'
--PROBLEM 5
	SELECT CigarName,
		   PriceForSingleCigar,
		   ImageURL
	  FROM Cigars
  ORDER BY PriceForSingleCigar,CigarName DESC

-- Problem 06

  SELECT c.Id,
	 c.CigarName,
	 c.PriceForSingleCigar,
	 t.TasteType,
	 t.TasteStrength
    FROM Cigars AS c
    JOIN Tastes AS t ON c.TastId = t.Id
   WHERE t.TasteType IN ('Earthy', 'Woody')
ORDER BY c.PriceForSingleCigar DESC


-- Problem 07

   SELECT c.Id,
	  CONCAT(c.FirstName, ' ', c.LastName) AS ClientName,
	  c.Email
     FROM Clients AS c
LEFT JOIN ClientsCigars AS cc ON c.Id = cc.ClientId
    WHERE cc.CigarId IS NULL
 ORDER BY CLientName 


-- Problem 08

  SELECT TOP(5)
	 c.CigarName,
	 c.PriceForSingleCigar,
	 c.ImageURL
    FROM Cigars AS c
    JOIN Sizes AS s ON c.SizeId = s.Id
   WHERE s.[Length] >= 12 AND (c.CigarName LIKE '%ci%' 
	 OR c.PriceForSingleCigar > 50) AND s.RingRange > 2.55
ORDER BY c.CigarName,
	 c.PriceForSingleCigar DESC


-- Problem 09

  SELECT 
         CONCAT(c.FirstName, ' ', c.LastName) AS FullName,
         a.Country,
         a.ZIP,
         CONCAT('$', MAX(cg.PriceForSingleCigar)) AS CigarPrice
    FROM Addresses AS a
    JOIN Clients AS c ON a.Id = c.AddressId
    JOIN ClientsCigars AS cc ON cc.ClientId = c.Id
    JOIN Cigars AS cg ON cc.CigarId = cg.Id
   WHERE a.ZIP NOT LIKE '%[^0-9]%'
GROUP BY c.Id, c.FirstName, c.LastName, a.Country, a.ZIP
ORDER BY FullName


-- Problem 10

  SELECT
         cl.LastName,
         AVG(s.[Length]) AS CigarLength,
         CEILING(AVG(s.RingRange)) AS CigarRingRange
    FROM Cigars AS c
    JOIN Sizes AS s ON c.SizeId = s.Id
    JOIN ClientsCigars AS cc ON c.Id = cc.CigarId
    JOIN Clients AS cl ON cc.ClientId = cl.Id
GROUP BY cl.LastName
ORDER BY AVG(s.[Length]) DESC

GO


-- Problem 11

CREATE FUNCTION udf_ClientWithCigars(@name NVARCHAR(30))
RETURNS INT
AS
BEGIN
	RETURN ISNULL((
		  SELECT COUNT(cc.CigarId)  FROM Clients AS cl
		    JOIN ClientsCigars AS cc ON cl.Id = cc.ClientId
		    JOIN Cigars AS cg ON cc.CigarId = cg.Id
		   WHERE cl.FirstName = @name
		GROUP BY cl.Id
	), 0)
END

GO

SELECT dbo.udf_ClientWithCigars('Betty')
SELECT dbo.udf_ClientWithCigars('Carol')
SELECT dbo.udf_ClientWithCigars('Jason')

GO


-- Problem 12

CREATE PROCEDURE usp_SearchByTaste(@taste VARCHAR(20))
AS
BEGIN
	SELECT 
		c.CigarName,
		CONCAT('$', c.PriceForSingleCigar) AS Price,
		t.TasteType,
		b.BrandName,
		CONCAT(s.[Length], ' ', 'cm') AS CigarLength,
		CONCAT(s.RingRange, ' ', 'cm') AS CigarRingRange
	   FROM Cigars AS c
	   JOIN Brands AS b ON c.BrandId = b.Id
	   JOIN Sizes AS s ON c.SizeId = s.Id
	   JOIN Tastes AS t ON c.TastId = t.Id
	  WHERE t.TasteType = @taste
       ORDER BY s.[Length],
		s.RingRange DESC
END

GO

EXEC usp_SearchByTaste 'Woody'