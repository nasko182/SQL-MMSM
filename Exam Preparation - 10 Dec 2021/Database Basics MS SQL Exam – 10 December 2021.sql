
-- Problem 1
CREATE TABLE Passengers
(
	Id INT PRIMARY KEY IDENTITY,
	FullName VARCHAR(100) UNIQUE NOT NULL,
	Email VARCHAR(50) UNIQUE NOT NULL
)

CREATE TABLE Pilots
(
	Id INT PRIMARY KEY IDENTITY,
	FirstName VARCHAR(30) UNIQUE NOT NULL,
	LastName VARCHAR(30) UNIQUE NOT NULL,
	Age TINYINT NOT NULL CHECK(Age BETWEEN 21 AND 62),
	Rating FLOAT CHECK(Rating BETWEEN 0.0 AND 10.0)
)

CREATE TABLE AircraftTypes
(
	Id INT PRIMARY KEY IDENTITY,
	TypeName VARCHAR(30) UNIQUE NOT NULL
)

CREATE TABLE Aircraft
(
	Id INT PRIMARY KEY IDENTITY,
	Manufacturer VARCHAR(25) NOT NULL,
	Model VARCHAR(30) NOT NULL,
	[Year] INT NOT NULL,
	FlightHours INT ,
	Condition CHAR(1) NOT NULL,
	TypeId INT FOREIGN KEY REFERENCES AircraftTypes(Id) NOT NULL
)

CREATE TABLE PilotsAircraft
(
	AircraftId INT REFERENCES Aircraft(Id),
	PilotId INT REFERENCES Pilots(Id),
	CONSTRAINT PK_AirctaftPilots PRIMARY KEY (AircraftId,PilotId)
)

CREATE TABLE Airports
(
	Id INT PRIMARY KEY IDENTITY,
	AirportName VARCHAR(70) UNIQUE NOT NULL,
	Country VARCHAR(100) UNIQUE NOT NULL
)

CREATE TABLE FlightDestinations
(
	Id INT PRIMARY KEY IDENTITY,
	AirportId INT REFERENCES Airports(Id) NOT NULL,
	[Start] DATETIME NOT NULL,
	AircraftId INT REFERENCES Aircraft(Id) NOT NULL,
	PassengerId INT REFERENCES Passengers(Id) NOT NULL,
	TicketPrice DECIMAL(18,2) DEFAULT(15) NOT NULL
)

--Problem 2
INSERT INTO Passengers (FullName,Email)
SELECT CONCAT(FirstName,' ',LastName) AS FullName,
	   CONCAT(FirstName,LastName,'@gmail.com')
   FROM Pilots
  WHERE Id  BETWEEN 5 AND 15

--Problem 3
UPDATE Aircraft
SET Condition ='A'
WHERE Condition IN ('C','B') 
AND (FlightHours IS NULL OR FlightHours <= 100)
AND Year >=2013

--Problem 4
DELETE Passengers
WHERE LEN(FullName) <=10

--Problem 5
SELECT Manufacturer,
	   Model,
	   FlightHours,
	   Condition
  FROM Aircraft
  ORDER BY FlightHours DESC

--Problem 6
SELECT FirstName,
	   LastName,
	   Manufacturer,
	   Model,
	   FlightHours
  FROM Aircraft AS A
  JOIN PilotsAircraft AS pa
  ON pa.AircraftId = a.Id
  JOIN Pilots AS p
  ON pa.PilotId=p.Id
  WHERE FlightHours IS NOT NULL
  AND FlightHours < 304
  ORDER BY FlightHours DESC,FirstName

--Problem 7
SELECT TOP(20) fd.Id AS DestinarionId,
	   fd.Start,
	   p.FullName,
	   a.AirportName,
	   fd.TicketPrice
  FROM FlightDestinations AS fd
  JOIN Passengers AS p
    ON p.Id = fd.PassengerId
  JOIN Airports AS a
    ON fd.AirportId=a.Id
 WHERE DAY(Start) %2 =0
ORDER BY  TicketPrice DESC, AirportName

--Problem 8
SELECT a.Id AS AircraftId,
	   Manufacturer,
	   FlightHours,
	   COUNT(*) AS FlightDestinationsCount,
	   ROUND(AVG(d.TicketPrice),2) AS AvgPrice
  FROM Aircraft AS a
  JOIN FlightDestinations AS d
  ON d.AircraftId = a.Id
  GROUP BY a.Id, a.Manufacturer,a.FlightHours
  HAVING COUNT(*)>1
  ORDER BY FlightDestinationsCount DESC, a.Id ASC

--Problem 9
SELECT p.FullName,
	   COUNT(AircraftId) AS CountOfAircraft,
	   SUM(TicketPrice) AS TotalPayed
  FROM Passengers AS p
  JOIN FlightDestinations AS d
    ON p.Id =d.PassengerId
  GROUP BY FullName
  HAVING SUBSTRING(p.FullName,2,1) LIKE 'a'
  AND COUNT(AircraftId) >1
  ORDER BY p.FullName 

--Problem 10
SELECT a.AirportName,
	   d.Start AS DayTime,
	   d.TicketPrice,
	   p.FullName,
	   ac.Manufacturer,
	   ac.Model
  FROM FlightDestinations AS d
  JOIN Passengers AS p
    ON p.Id = d.PassengerId
  JOIN Aircraft AS ac
    ON ac.Id = d.AircraftId
  JOIN Airports AS a
    ON d.AirportId=a.Id
  WHERE DATEPART(HH,d.Start) BETWEEN 6 AND 20
    AND d.TicketPrice>2500
  ORDER BY ac.Model
--Problem 11
CREATE OR ALTER FUNCTION udf_FlightDestinationsByEmail (@email VARCHAR(100))
RETURNS INT
AS
BEGIN
 DECLARE @result INT = (SELECT COUNT(*)
   FROM FlightDestinations AS d
   JOIN Passengers AS p
   ON d.PassengerId = p.Id
   GROUP BY p.Email
   HAVING p.Email=@email)
   IF (@result IS NULL)
   SET @result = 0

   RETURN @result
END

SELECT dbo.udf_FlightDestinationsByEmail('MerisShale@gmail.com')

--Problem 12
CREATE OR ALTER PROCEDURE usp_SearchByAirportName @airportName VARCHAR(70)
AS
BEGIN
	SELECT a.AirportName,
	       p.FullName,
		   CASE
		   WHEN d.TicketPrice <=400 THEN 'Low'
		   WHEN d.TicketPrice BETWEEN 401 AND 1500 THEN 'Medium'
		   WHEN d.TicketPrice >=1501 THEN 'High'
		   END AS LevelOfTickerPrice,
		   ac.Manufacturer,
		   ac.Condition,
		   at.TypeName
	  FROM Airports AS a
	  JOIN FlightDestinations AS d
	    ON a.Id = d.AirportId
	  JOIN Passengers AS p
	    ON d.PassengerId = p.Id
	  JOIN Aircraft AS ac
	    ON d.AircraftId = ac.Id
	  JOIN AircraftTypes AS at
	    ON ac.TypeId = at.Id
	  WHERE AirportName = @airportName
	  ORDER BY ac.Manufacturer,p.FullName
END

EXEC usp_SearchByAirportName 'Sir Seretse Khama International Airport'