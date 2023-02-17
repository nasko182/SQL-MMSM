--PROBLEM 1
CREATE TABLE Owners
(
	Id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50) NOT NULL,
	PhoneNumber VARCHAR(15) NOT NULL,
	Address VARCHAR(50)
)

CREATE TABLE AnimalTypes
(
	Id INT PRIMARY KEY IDENTITY,
	AnimalType VARCHAR(30) NOT NULL
)

CREATE TABLE Cages
(
	Id INT PRIMARY KEY IDENTITY,
	AnimalTypeId INT REFERENCES AnimalTypes(Id) NOT NULL
)

CREATE TABLE Animals
(
	Id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(30) NOT NULL,
	BirthDate DATE NOT NULL,
	OwnerId INT REFERENCES Owners(Id),
	AnimalTypeId INT REFERENCES AnimalTypes(Id) NOT NULL
)

CREATE TABLE AnimalsCages
(
	CageId INT REFERENCES Cages(Id),
	AnimalId INT REFERENCES Animals(Id),
	CONSTRAINT PK_AnimalsCages PRIMARY KEY(CageId,AnimalId)
)


CREATE TABLE VolunteersDepartments
(
	Id INT PRIMARY KEY IDENTITY,
	DepartmentName VARCHAR(30) NOT NULL
)


CREATE TABLE Volunteers
(
	Id INT PRIMARY KEY IDENTITY,
	Name VARCHAR(50) NOT NULL,
	PhoneNumber VARCHAR(15) NOT NULL,
	Address VARCHAR(50),
	AnimalId INT REFERENCES Animals(Id) NULL,
	DepartmentId INT REFERENCES VolunteersDepartments(Id) NOT NULL
)

--PROBLEM 2
INSERT INTO Volunteers (Name, PhoneNumber, Address, AnimalId, DepartmentId) VALUES
('Anita Kostova', '0896365412', 'Sofia,	5 Rosa str.', 15, 1),
('Dimitur Stoev' ,'0877564223',	NULL, 42, 4),
('Kalina Evtimova' ,'0896321112', 'Silistra, 21 Breza str.', 9, 7),
('Stoyan Tomov' ,'0898564100', 'Montana, 1 Bor str.', 18, 8),
('Boryana Mileva' ,'0888112233', NULL, 31, 5)

INSERT INTO Animals (Name, BirthDate, OwnerId, AnimalTypeId) VALUES
('Giraffe', '2018-09-21', 21, 1),
('Harpy Eagle', '2015-04-17', 15, 3),
('Hamadryas Baboon', '2017-11-02', NULL, 1),
('Tuatara', '2021-06-30', 2, 4)

--PROBLEM 3
UPDATE Animals
 SET OwnerId = (SELECT Id FROM Owners WHERE Name = 'Kaloqn Stoqnov')
WHERE OwnerId IS NULL

--PROBLEM 4
	DELETE
	  FROM Volunteers
	 WHERE DepartmentId =(
							SELECT Id
							  FROM VolunteersDepartments
							 WHERE DepartmentName = 'Education program assistant'
						 )

	DELETE
	  FROM VolunteersDepartments
	 WHERE DepartmentName = 'Education program assistant'

--PROBLEM 5 ??????
	SELECT Name,
		   PhoneNumber,
		   Address,
		   AnimalId,
		   DepartmentId
	  FROM Volunteers
  ORDER BY Name,AnimalId,DepartmentId

--PROBLEM 6]
	SELECT a.Name,
		   at.AnimalType,
		   CONVERT(varchar, a.BirthDate, 104)
	  FROM Animals AS a
	  JOIN AnimalTypes AS at
	    ON a.AnimalTypeId=at.Id
  ORDER BY A.Name

--PROBLEM 7
SELECT TOP(5) o.Name AS Owner,
		      COUNT(a.Id)
	   	 FROM Animals AS a
	   	 JOIN Owners AS o
	   	   ON a.OwnerId=o.Id
	 GROUP BY o.Name
	 ORDER BY COUNT(a.Id) DESC,o.Name

--PROBLEM 8 ?????
	SELECT CONCAT(o.Name,'-',a.Name) AS OwnersAnimals,
		   o.PhoneNumber,
		   ac.CageId
	  FROM Animals AS a
	  JOIN Owners AS o
	    ON a.OwnerId = o.Id
	  JOIN AnimalTypes AS at
	    ON a.AnimalTypeId = at.Id
	  JOIN AnimalsCages AS ac
	    ON a.Id = ac.AnimalId
     WHERE at.AnimalType = 'Mammals'
  ORDER BY o.Name , a.Name DESC

--PROBLEM 9
	SELECT v.Name,
		   v.PhoneNumber,
		   RIGHT(v.Address,LEN(v.Address)-CHARINDEX(',',v.Address)-1) AS Address,
		   v.Address
	  FROM Volunteers AS v
	  JOIN VolunteersDepartments AS vd
	    ON v.DepartmentId = vd.Id
	 WHERE vd.DepartmentName = 'Education program assistant'
	   AND v.Address LIKE '%Sofia%'
  ORDER BY v.Name
--PROBLEM 10 ????
	SELECT a.Name,
		   YEAR(a.BirthDate) AS BirthYear,
		   at.AnimalType
	  FROM Animals AS a
	  JOIN AnimalTypes AS at
	    ON a.AnimalTypeId = at.Id
	 WHERE DATEDIFF(YEAR,a.BirthDate,'01/01/2022')<5 
	   AND at.AnimalType <> 'Birds'
	   AND OwnerId IS NULL
  ORDER BY a.Name

--PROBLEM 11 ???
CREATE FUNCTION udf_GetVolunteersCountFromADepartment (@VolunteersDepartment VARCHAR(30))
RETURNS INT
AS
BEGIN
	RETURN (SELECT COUNT(v.Id)
	  FROM Volunteers AS v
	  JOIN VolunteersDepartments AS vd
	    ON v.DepartmentId = vd.Id
  GROUP BY DepartmentId,vd.DepartmentName
    HAVING vd.DepartmentName = @VolunteersDepartment)
END

SELECT [dbo].[udf_GetVolunteersCountFromADepartment] ('Education program assistant')

SELECT dbo.udf_GetVolunteersCountFromADepartment ('Guest engagement')
--PROBLEM 12
CREATE PROCEDURE usp_AnimalsWithOwnersOrNot (@AnimalName VARCHAR(50))
AS
BEGIN
	SELECT a.Name,
		   CASE
		   WHEN a.OwnerId IS NULL THEN 'For adoption'
		   ELSE o.Name
		   END AS OwnersName
	  FROM Animals AS a
	  JOIN Owners AS o
	    ON a.OwnerId = o.Id
	 WHERE a.Name = @AnimalName 
END

EXEC [dbo].[usp_AnimalsWithOwnersOrNot] 'Hippo'