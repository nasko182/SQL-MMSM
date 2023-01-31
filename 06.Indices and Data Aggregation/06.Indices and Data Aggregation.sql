USE Gringotts
-- PROBLEM 1
SELECT COUNT(*) AS Count
	FROM WizzardDeposits

-- PROBLEM 2
SELECT MAX(MagicWandSize) AS LongestMagicWand
	FROM WizzardDeposits

-- PROBLEM 3
SELECT DepositGroup
	  ,MAX(MagicWandSize) AS LongestMagicWand
	FROM WizzardDeposits
	GROUP BY DepositGroup

-- PROBLEM 4
SELECT TOP(2) DepositGroup
	FROM WizzardDeposits
	GROUP BY DepositGroup
	ORDER BY AVG(MagicWandSize) 

-- PROBLEM 5
SELECT DepositGroup
	  ,SUM(DepositAmount) AS TotalSum
	FROM WizzardDeposits
	GROUP BY DepositGroup

-- PROBLEM 6
SELECT DepositGroup
	  ,SUM(DepositAmount) AS TotalSum
	FROM WizzardDeposits
	WHERE MagicWandCreator='Ollivander family'
	GROUP BY DepositGroup

-- PROBLEM 7
SELECT DepositGroup
	  ,SUM(DepositAmount) AS TotalSum
	FROM WizzardDeposits
	WHERE MagicWandCreator='Ollivander family'
	GROUP BY DepositGroup
	HAVING SUM(DepositAmount) < 150000
	ORDER BY TotalSum DESC

-- PROBLEM 8
SELECT DepositGroup
	  ,MagicWandCreator
	  ,MIN(DepositCharge) AS MinDepositCharge
	FROM WizzardDeposits
	GROUP BY MagicWandCreator,DepositGroup
	ORDER BY MagicWandCreator,DepositGroup

-- PROBLEM 9
SELECT AgeGroup
	  ,COUNT(AgeGroup) AS WizardCount
	FROM (SELECT CASE
	   WHEN Age >=0 AND Age <=10 THEN '[0-10]'
	   WHEN Age >=11 AND Age <=20 THEN '[11-20]'
	   WHEN Age >=21 AND Age <=30 THEN '[21-30]'
	   WHEN Age >=31 AND Age <=40 THEN '[31-40]'
	   WHEN Age >=41 AND Age <=50 THEN '[41-50]'
	   WHEN Age >=51 AND Age <=60 THEN '[51-60]'
	   WHEN Age >=61 THEN '[61+]'
	   END AS AgeGroup
	FROM WizzardDeposits) AS SeparateBYAge
	GROUP BY AgeGroup

-- PROBLEM 10
SELECT LEFT(FirstName,1)
	FROM WizzardDeposits
   WHERE DepositGroup = 'Troll Chest'
	GROUP BY LEFT(FirstName,1)

-- PROBLEM 11
SELECT DepositGroup
	  ,IsDepositExpired
	  ,AVG(DepositInterest) AS AverageInterst
	FROM WizzardDeposits
	WHERE DepositStartDate > '1-1-1985'
	GROUP BY DepositGroup, IsDepositExpired
	ORDER BY DepositGroup DESC, IsDepositExpired
	

-- PROBLEM 12
SELECT SUM(Diference)
  FROM (SELECT w1.FirstName AS [Host Wizard]
	  ,w1.DepositAmount AS [Host Wizard Deposit]
	  ,w2.FirstName AS [Guest Wizard]
	  ,w2.DepositAmount AS [Guest Wizard Deposit]
	  ,w1.DepositAmount-w2.DepositAmount AS Diference
  FROM WizzardDeposits AS w1
  JOIN WizzardDeposits AS w2
    ON w1.Id+1 = w2.id) AS TableWithDiff

-- PROBLEM 13
USE SoftUni

SELECT DepartmentID
	  ,SUM(Salary) AS TotalSalary
  FROM Employees
  GROUP BY DepartmentID
  ORDER BY DepartmentID

-- PROBLEM 14
SELECT DepartmentID
	  ,MIN(Salary) AS MinimumSalary
  FROM Employees
  WHERE DepartmentID LIKE '[5,2,7]'
  GROUP BY DepartmentID

-- PROBLEM 15
SELECT * INTO NewTable
  FROM Employees
 WHERE Salary>30000

DELETE FROM NewTable
WHERE ManagerID = 42

UPDATE NewTable
SET Salary+=5000
WHERE DepartmentID=1

SELECT DepartmentID
	  ,AVG(Salary)
  FROM NewTable
  GROUP BY DepartmentID



-- PROBLEM 16
SELECT DepartmentID
	  ,MAX(Salary)
  FROM Employees
  GROUP BY DepartmentID
  HAVING MAX(Salary) NOT BETWEEN 30000 AND  70000

-- PROBLEM 17
SELECT COUNT(*) AS Count
  FROM Employees
  WHERE ManagerID IS NULL

-- PROBLEM 18
SELECT DISTINCT Ranked.DepartmentID
	  ,Ranked.Salary
  FROM (SELECT DepartmentID
			  ,Salary
	          ,DENSE_RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS [DenseRank]
		  FROM Employees) AS Ranked
 WHERE DenseRank =3

SELECT DepartmentID
	  ,Salary
	  ,DENSE_RANK() OVER (PARTITION BY DepartmentID ORDER BY Salaru DESC) AS Ranked
  FROM Employees

-- PROBLEM 18
SELECT TOP(10) FirstName
      ,LastName
	  ,e.DepartmentID
  FROM Employees AS e
  JOIN (SELECT DepartmentID
			  ,AVG(Salary) AS averageSalary
	      FROM Employees
	  Group BY DepartmentID) AS avarageSalaries
  ON e.DepartmentID=avarageSalaries.DepartmentID
  WHERE e.Salary>avarageSalaries.averageSalary