
USE SoftUni
-- PROBLEM 1
	SELECT FirstName, LastName
		FROM Employees
		WHERE LEFT(FirstName,2) = 'Sa'

-- PROBLEM 2
	SELECT FirstName, LastName
		FROM Employees
		WHERE LastName LIKE '%ei%'
	
-- PROBLEM 3
	SELECT FirstName
		FROM Employees
		WHERE DepartmentID=3
		OR DepartmentID=10
		AND YEAR(HireDate) > 1994
		AND YEAR(HireDate) < 2006

-- PROBLEM 4
	SELECT FirstName,LastName
		FROM Employees
		WHERE JobTitle NOT Like '%engineer%'

-- PROBLEM 5
	SELECT [Name]
		FROM Towns
		WHERE LEN([Name]) =5
		OR LEN([Name]) =6
		ORDER BY [Name]

-- PROBLEM 6
	SELECT TownID,[Name]
		FROM Towns
		WHERE LEFT([Name],1) ='M'
		OR LEFT([Name],1) ='K'
		OR LEFT([Name],1) ='B'
		OR LEFT([Name],1) ='E'
		ORDER BY [Name]

-- PROBLEM 7
	SELECT TownID,[Name]
		FROM Towns
		WHERE LEFT([Name],1) NOT LIKE 'R'
		AND LEFT([Name],1) NOT LIKE 'D'
		AND LEFT([Name],1) NOT LIKE 'B'
		ORDER BY [Name]

-- PROBLEM 8
	CREATE VIEW V_EmployeesHiredAfter2000 AS
	SELECT FirstName,LastName
		FROM Employees
		WHERE YEAR(HireDate) > 2000

-- PROBLEM 9
	SELECT FirstName,LastName
		FROM Employees
		WHERE LEN(LastName) = 5

-- PROBLEM 10
SELECT EmployeeID
	  ,FirstName
	  ,LastName
	  ,Salary
	  ,DENSE_RANK() OVER (PARTITION BY Salary ORDER BY EmployeeID) AS [Rank]
	FROM Employees
	WHERE Salary BETWEEN 10000 AND 50000
	ORDER BY Salary DESC

-- PROBLEM 11
SELECT *
	FROM(SELECT EmployeeID
		  ,FirstName
		  ,LastName
		  ,Salary
		  ,DENSE_RANK() OVER (PARTITION BY Salary ORDER BY EmployeeID) AS [Rank]
		FROM Employees
		WHERE Salary BETWEEN 10000 AND 50000
	) AS InsideSelect
	WHERE [Rank] =2
	ORDER BY Salary DESC

-- PROBLEM 12
USE Geography
SELECT CountryName, IsoCode
	FROM Countries
	WHERE LEN(CountryName)-3 >= LEN(REPLACE(CountryName,'a',''))
	ORDER BY IsoCode

-- PROBLEM 13
SELECT p.PeakName
	  ,r.RiverName
	  ,LOWER(CONCAT(SUBSTRING(PeakName,0,LEN(PeakName)),RiverName)) AS Mix
	FROM Peaks AS p,
	Rivers AS r
	WHERE RIGHT(PeakName,1) = LEFT(RiverName,1)
	ORDER BY Mix

-- PROBLEM 14
USE Diablo
SELECT TOP(50) [Name]
			   , FORMAT([Start],'yyyy-MM-dd','bg-BG') AS [Start]
			FROM Games
			WHERE YEAR([Start]) BETWEEN 2011 AND 2012
			ORDER BY [Start] , [Name]

-- PROBLEM 15
SELECT Username
	  ,RIGHT(Email,CHARINDEX('@',REVERSE(Email),0)-1) AS [Email Provider]
	FROM Users
	ORDER BY [Email Provider], Username

-- PROBLEM 16
SELECT Username, IpAddress AS [IP Address]
	FROM Users
	WHERE IpAddress LIKE '___.1_%._%.___'
	ORDER BY Username

-- PROBLEM 17
SELECT [Name]
	  ,CASE
	  WHEN DATEPART(HH,[Start]) BETWEEN 0 AND 11 THEN 'Morning'
	  WHEN DATEPART(HH,[Start]) BETWEEN 12 AND 17 THEN 'Afternoon'
	  WHEN DATEPART(HH,[Start]) BETWEEN 18 AND 23 THEN 'Evening'
	  END AS [Part of the Day]
	  ,CASE
	  WHEN Duration <=3 THEN 'Extra Short'
	  WHEN Duration BETWEEN 4 AND 6 THEN 'Short'
	  WHEN Duration >=6 THEN 'Long'
	  WHEN Duration IS NULL THEN 'Extra Long'
	  END AS [Duration]
	FROM Games
	ORDER BY [Name], Duration, [Part of the Day]

	select * from Games order by [Name]

-- PROBLEM 18
SELECT ProductName
	  ,OrderDate
	  ,DATEADD(DD,3,OrderDate) AS [Pay Due]
	  ,DATEADD(MM,1,OrderDate) AS [Deliver Due]
	FROM Orders