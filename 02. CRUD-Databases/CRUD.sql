USE SoftUni

-- PROBLEM 02
SELECT [Name] 
	FROM Departments

-- PROBLEM 03
SELECT [Name] 
	FROM Departments

-- PROBLEM 04
SELECT [FirstName], [LastName] , [Salary]
	FROM Employees

-- PROBLEM 05
SELECT [FirstName], [MiddleName] , [LastName]
	FROM Employees

-- PROBLEM 06
SELECT CONCAT([FirstName], '.' , [LastName] , '@softuni.bg')
	AS [Full Email Address]
	FROM Employees

-- PROBLEM 07
SELECT DISTINCT Salary
	FROM Employees

-- PROBLEM 08
SELECT *
	FROM Employees
	WHERE [JobTitle] = 'Sales Representative'

-- PROBLEM 09
SELECT [FirstName], [LastName], [JobTitle]
	FROM Employees
	WHERE [Salary] BETWEEN 20000 AND 30000

-- PROBLEM 10
SELECT CONCAT([FirstName], ' ', [MiddleName] , ' ', [LastName])
	FROM Employees
	WHERE [Salary] IN (25000, 14000, 12500, 23600)

-- PROBLEM 11
SELECT [FirstName], [LastName]
	FROM Employees
	WHERE [ManagerID] IS NULL

-- PROBLEM 12
SELECT [FirstName], [LastName], [Salary]
	FROM Employees
	WHERE [Salary] > 50000
	ORDER BY [Salary] DESC

-- PROBLEM 13
SELECT TOP(5) [FirstName], [LastName]
	FROM Employees
	WHERE [Salary] > 50000
	ORDER BY [Salary] DESC

-- PROBLEM 14
SELECT [FirstName], [LastName]
	FROM Employees
	WHERE [DepartmentID] != 4

-- PROBLEM 15
SELECT *
	FROM Employees
	ORDER BY [Salary] DESC,
			 [FirstName] ASC,
			 [LastName] DESC,
			 [MiddleName] ASC

-- PROBLEM 16
CREATE VIEW [v_EmployeesSalaries] AS
SELECT [FirstName], [LastName], [Salary]
	FROM Employees

-- PROBLEM 17
CREATE VIEW [v_EmployeeNameJobTitle] AS
SELECT CONCAT([FirstName], ' ', [MiddleName] , ' ', [LastName]) AS [Full Name],
[JobTitle]
	FROM [Employees]

-- PROBLEM 18
SELECT Distinct [JobTitle]
	FROM [Employees]

-- PROBLEM 19
SELECT TOP(10) *
	FROM [Projects]
	ORDER BY [StartDate], [Name]

-- PROBLEM 20
SELECT TOP(7) [FirstName], [LastName], [HireDate]
	FROM [Employees]
	ORDER BY [HireDate] DESC

-- PROBLEM 21
UPDATE [Employees]
	SET [Salary] += [Salary]*0.12
	WHERE [DepartmentID] IN (1,2,4,11)

SELECT [Salary]
	FROM [Employees]

USE Geography

-- PROBLEM 22
SELECT [PeakName]
	FROM [Peaks]
	ORDER BY [PeakName] ASC

-- PROBLEM 23
SELECT TOP(30) [CountryName], [Population]
	FROM [Countries]
	WHERE [ContinentCode] = 'EU'
	ORDER BY [Population] DESC, [CountryName] ASC

-- PROBLEM 24
SELECT [CountryName], [CountryCode],
	CASE 
		WHEN [CurrencyCode] = 'EUR' THEN 'Euro'
		ELSE 'Not Euro'
	END AS [Currency]
	FROM [Countries]
	ORDER BY [CountryName] ASC

USE Diablo

-- PROBLEM 25
SELECT [Name]
	FROM [Characters]
	ORDER BY [Name]
	