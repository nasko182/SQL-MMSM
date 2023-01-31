-- PROBLEM 1
SELECT TOP(5) EmployeeID,JobTitle,e.AddressID,AddressText
	FROM Employees AS e
	JOIN Addresses AS a
	ON e.AddressID=a.AddressID
	ORDER BY e.AddressID

-- PROBLEM 2
SELECT TOP(50) FirstName, LastName, T.Name AS Town, a.AddressText
	FROM Employees AS e
	JOIN Addresses AS a
	ON e.AddressID=a.AddressID
	JOIN Towns AS t
	ON a.TownID=t.TownID
	ORDER BY FirstName, LastName

-- PROBLEM 3
SELECT EmployeeID ,FirstName, LastName, d.Name
	FROM Employees AS e
	JOIN Departments AS d
	ON e.DepartmentID=d.DepartmentID
	WHERE d.Name = 'Sales'
	ORDER BY e.EmployeeID

-- PROBLEM 4
SELECT TOP(5) EmployeeID, FirstName,Salary, d.Name AS DepartmentName
	FROM Employees AS e
	JOIN Departments AS d
	ON e.DepartmentID = d.DepartmentID
	WHERE Salary>15000
	ORDER BY d.DepartmentID

-- PROBLEM 5
SELECT TOP(3) e.EmployeeID, FirstName
	FROM Employees AS e
	FULL OUTER JOIN EmployeesProjects AS ep
	ON e.EmployeeID = ep.EmployeeID
	WHERE e.EmployeeID NOT IN (SELECT EmployeeID FROM EmployeesProjects)

-- PROBLEM 6
SELECT	FirstName, LastName, HireDate, d.Name AS DeptName
	FROM  Employees AS e
	JOIN Departments AS d
	ON e.DepartmentID = d.DepartmentID
	WHERE e.HireDate > '1999-1-1' AND d.Name ='Sales' OR d.Name= 'Finance'
	ORDER BY HireDate ASC

-- PROBLEM 7
SELECT TOP(5) e.EmployeeID, FirstName, p.Name AS ProjectName
	FROM Employees AS e
	JOIN EmployeesProjects AS ep
	ON e.EmployeeID = ep.EmployeeID
	JOIN Projects AS p
	ON p.ProjectID = ep.ProjectID
	WHERE p.StartDate >'2002-8-13' AND p.EndDate IS NULL
	ORDER BY e.EmployeeID

-- PROBLEM 8
SELECT e.EmployeeID
			 ,FirstName
			 ,CASE
			 WHEN YEAR(p.StartDate) < 2004 THEN p.Name
			 END AS ProjectName
	FROM Employees AS e
	JOIN EmployeesProjects AS ep
	ON e.EmployeeID = ep.EmployeeID
	JOIN Projects AS p
	ON p.ProjectID = ep.ProjectID
	WHERE e.EmployeeID = 24

-- PROBLEM 9
SELECT e.EmployeeID, e.FirstName, e.ManagerID, m.FirstName
	FROM Employees AS e
	FULL JOIN Employees AS m
	ON e.ManagerID = m.EmployeeID
	WHERE e.ManagerID=3 OR e.ManagerID = 7
	ORDER BY EmployeeID

-- PROBLEM 10
SELECT TOP(50) e.EmployeeID
			  ,CONCAT(e.FirstName,' ',e.LastName) AS EmployeeName
			  ,CONCAT(m.FirstName,' ',m.LastName) AS ManagerName
			  ,d.Name AS DepartmentName
	FROM Employees AS e
	FULL JOIN Employees AS m
	ON e.ManagerID = m.EmployeeID
	JOIN Departments AS d
	ON e.DepartmentID = d.DepartmentID
	ORDER BY e.EmployeeID

-- PROBLEM 11
SELECT MIN(AverageSalaries.Salaries) AS MinAverageSalary
	FROM (SELECT AVG(Salary) AS Salaries
				FROM Employees
				GROUP BY DepartmentID
		 ) AS AverageSalaries

-- PROBLEM 12
SELECT c.CountryCode, m.MountainRange, p.PeakName,p.Elevation
	FROM Countries AS c
	JOIN MountainsCountries AS mc
	ON c.CountryCode = mc.CountryCode
	JOIN Mountains as m
	ON mc.MountainId= m.Id
	JOIN Peaks AS p
	ON m.Id=p.MountainId
	WHERE c.CountryName LIKE 'Bulgaria'
	AND p.Elevation> 2835
	ORDER BY p.Elevation DESC

-- PROBLEM 13
SELECT *
	FROM (SELECT mc.CountryCode
	  ,COUNT(*) AS MountainRanges
	FROM MountainsCountries AS mc
	GROUP BY mc.CountryCode) AS table1
	WHERE table1.CountryCode IN ('BG','RU','US')

-- PROBLEM 14
SELECT TOP(5) c.CountryName, r.RiverName
	FROM Countries AS c
	LEFT JOIN CountriesRivers AS cr
	ON c.CountryCode=cr.CountryCode
	LEFT JOIN Rivers AS r
	ON cr.RiverId=r.Id
	WHERE c.ContinentCode LIKE 'AF'
	ORDER BY CountryName

-- PROBLEM 15
SELECT ContinentCode
	  ,CurrencyCode
	  ,CurencyUsage
	FROM (
			SELECT ContinentCode
				  ,CurrencyCode
				  ,CurencyUsage
				  ,CurencyRank
				FROM (
						SELECT ContinentCode
							  ,CurrencyCode
							  ,CurencyUsage
							  ,DENSE_RANK() OVER (PARTITION BY ContinentCode ORDER BY CurencyUsage DESC)
							   AS CurencyRank
						FROM (
							SELECT ContinentCode
								  ,CurrencyCode
								  ,COUNT(*) AS CurencyUsage
							  FROM Countries
						  GROUP BY ContinentCode, CurrencyCode
						 ) AS CurenciesCountSubquery
						 WHERE CurencyUsage >1
						 ) AS CurenciesCountSubqueryAbove1
		 ) AS CurenciesCountSubqueryRanked
		 WHERE CurencyRank =1
		 ORDER BY ContinentCode

-- PROBLEM 16
SELECT COUNT(*) AS Count
	FROM Countries AS c
	FULL JOIN MountainsCountries AS mc
	ON c.CountryCode=mc.CountryCode
	WHERE mc.MountainId IS NULL

-- PROBLEM 17
SELECT TOP(5) c.CountryName
	  ,MAX(p.Elevation) AS HighestPeakElevation
	  ,MAX(r.Length) AS LongestRiverLength
	FROM Countries AS c
	JOIN MountainsCountries AS mc
	ON c.CountryCode= mc.CountryCode
	JOIN Mountains AS m
	ON mc.MountainId=m.Id
	JOIN Peaks AS p
	ON m.Id=p.MountainId
	JOIN CountriesRivers AS cr
	ON c.CountryCode=cr.CountryCode
	JOIN Rivers AS r
	ON r.Id=cr.RiverId
	GROUP BY c.CountryName
	ORDER BY HighestPeakElevation DESC, LongestRiverLength DESC, c.CountryName

-- PROBLEM 18
