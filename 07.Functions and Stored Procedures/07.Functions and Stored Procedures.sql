--PROBLEM 1
CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000
AS
	SELECT FirstName AS [First Name],
		   LastName AS [Last Name]
	  FROM Employees
	  WHERE Salary > 35000

--PROBLEM 2
CREATE PROCEDURE usp_GetEmployeesSalaryAboveNumber @Number DECIMAL(18,4)
AS
BEGIN
	SELECT FirstName AS [First Name],
		   LastName AS [Last Name]
	  FROM Employees
	  WHERE Salary >= @Number
END

--PROBLEM 3
CREATE PROCEDURE usp_GetTownsStartingWith @String VARCHAR(100)
AS
BEGIN
	SELECT Name AS Town
	  FROM Towns
	 WHERE Name LIKE @String+'%'
END

--PROBLEM 4
CREATE PROCEDURE usp_GetEmployeesFromTown @TownName VARCHAR(100)
AS
BEGIN
	SELECT FirstName AS [First Name],
		   LastName AS [Last Name]
	  FROM Employees AS e
	  JOIN Addresses AS a
	  ON e.AddressID = a.AddressID
	  JOIN Towns AS t
	  ON t.TownID = a.TownID
	  WHERE t.Name = @TownName
END

--PROBLEM 5
CREATE OR ALTER FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18,4))
RETURNS VARCHAR(10)
AS
BEGIN
	DECLARE @LevelOfSalary VARCHAR(10)
	IF (@salary < 30000)
		SET @LevelOfSalary = 'Low'
	ELSE IF ( @salary BETWEEN 30000 AND 50000)
		SET @LevelOfSalary = 'Average'
	ELSE
		SET @LevelOfSalary = 'High'
	RETURN @LevelOfSalary 
END

--PROBLEM 6
CREATE PROCEDURE usp_EmployeesBySalaryLevel
				 @LevelOfSalary VARCHAR(10)
AS
BEGIN
	SELECT FirstName AS [First Name],
		   LastName AS [Last Name]
	  FROM Employees
	  WHERE dbo.ufn_GetSalaryLevel(Salary) = @LevelOfSalary
END

--PROBLEM 7
CREATE OR ALTER FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(50), @word VARCHAR(50))
RETURNS BIT
AS
BEGIN
	SET @word = LOWER(@word);
	SET @setOfLetters= LOWER(@setOfLetters)

	DECLARE @Counter INT = 0;
	DECLARE @Letter VARCHAR(1) = SUBSTRING(@word,@counter+1,1)
	WHILE (@Counter <> LEN(@word)+1)
	BEGIN
		IF(@setOfLetters NOT LIKE '%'+@Letter+'%')
			RETURN 0
		SET @Counter += 1;
		SET @Letter = SUBSTRING(@word,@counter,1)
	END
	RETURN 1
END

--PROBLEM 8


--PROBLEM 9
CREATE PROCEDURE usp_GetHoldersFullName 
AS
BEGIN
	SELECT CONCAT(FirstName,' ',LastName)
	  FROM AccountHolders
END

--PROBLEM 10
CREATE OR ALTER PROCEDURE usp_GetHoldersWithBalanceHigherThan @Number DECIMAL(16,2)
AS 
BEGIN
	SELECT FirstName,
		   LastName
	  FROM (SELECT ah.FirstName,
		   ah.LastName,
		   SUM(Balance) AS Balance
	  FROM AccountHolders AS ah
	  JOIN Accounts AS a
	  ON a.AccountHolderId= ah.Id
	  GROUP BY ah.FirstName, LastName) AS SortedTable
	  WHERE SortedTable.Balance > @Number
	  ORDER BY FirstName,LastName
END



--PROBLEM 11
CREATE OR ALTER FUNCTION ufn_CalculateFutureValue
						(@Sum DECIMAL(18,4),
						 @InterestRate FLOAT,
						 @Years INT)
RETURNS DECIMAL(18,4)
AS
BEGIN
	SET @InterestRate +=1
	RETURN @Sum * Power(@InterestRate,@Years)
END


--PROBLEM 12
CREATE OR ALTER PROCEDURE usp_CalculateFutureValueForAccount
						  @AcountID INT,
						  @InterstRate FLOAT
AS
BEGIN
	SELECT Id,
	       FirstName AS [First Name],
		   LastName AS [Last Name],
		   Balance AS [Current Balence],
		   dbo.ufn_CalculateFutureValue(Balance,@InterstRate,5)
	  FROM (
		SELECT ah.FirstName,
			   a.Id,
			   ah.LastName,
			   SUM(Balance) AS Balance
		  FROM AccountHolders AS ah
		  JOIN Accounts AS a
		  ON a.AccountHolderId= ah.Id
		  GROUP BY ah.FirstName, LastName, a.Id) AS SortedTable
		  WHERE Id= @AcountID
END

--PROBLEM 13
CREATE FUNCTION ufn_CashInUsersGames (@gameName VARCHAR(100))
RETURNS TABLE
AS
	   
	    RETURN (SELECT SUM(SumCash) AS SumCash
		FROM (SELECT Cash AS SumCash,
					 ROW_NUMBER() OVER (ORDER BY Cash DESC) AS RowNumber
			    FROM UsersGames AS ug
			    JOIN Games AS g
			    ON ug.GameId = g.Id
			    WHERE Name LIKE @gameName) AS GamesByName
			    WHERE RowNumber % 2 = 1)

