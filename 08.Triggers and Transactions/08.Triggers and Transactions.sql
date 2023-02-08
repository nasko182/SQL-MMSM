--PROBLEM 1
CREATE TABLE Logs
(
	LogId INT PRIMARY KEY IDENTITY,
	AccountId INT REFERENCES Accounts(Id),
	OldSum MONEY NOT NULL,
	NewSum MONEY NOT NULL
)

CREATE TRIGGER tr_SaveTransactionLogs
ON Accounts FOR UPDATE
AS
BEGIN
	INSERT INTO Logs(AccountId,OldSum,NewSum)
	SELECT i.Id,
		   d.Balance,
		   i.Balance
	  FROM inserted as i
	  JOIN deleted as d
	    ON i.Id = d.Id
     WHERE i.Balance<>d.Balance
END
--PROBLEM 2
CREATE TABLE NotificationEmails
(
	Id INT PRIMARY KEY IDENTITY,
	Recipient INT NOT NULL,
	Subject VARCHAR(100) NOT NULL,
	Body VARCHAR(200) NOT NULL
)

CREATE TRIGGER tr_CreateEmailsInEmailsTable
ON Logs FOR INSERT
AS
BEGIN 
	INSERT INTO NotificationEmails(Recipient,Subject,Body)
	SELECT AccountId,
		   CONCAT('Balance change for account: ',AccountId),
		   CONCAT('On ',GETDATE(),' your balance was changed from ',OldSum,' to ',NewSum,'.')
	  FROM inserted
END
--PROBLEM 3
CREATE PROCEDURE usp_DepositMoney @accountId INT, @moneyAmount MONEY
AS
BEGIN TRANSACTION
	IF NOT EXISTS ( SELECT * FROM Accounts WHERE Id = @accountId)
	BEGIN
		ROLLBACK;
		THROW 50001,'Account doesn`t exist',1
	END

	IF (@moneyAmount<0)
	BEGIN
		ROLLBACK;
		THROW 50002,'Invalid money amount',1
	END
	UPDATE Accounts
	 SET Balance+= @moneyAmount
   WHERE Id=@accountId
COMMIT

--PROBLEM 4
CREATE PROCEDURE usp_WithdrawMoney @accountId INT, @moneyAmount MONEY
AS
BEGIN TRANSACTION
	IF NOT EXISTS ( SELECT * FROM Accounts WHERE Id = @accountId)
	BEGIN
		ROLLBACK;
		THROW 50001,'Account doesn`t exist',1
	END

	IF (@moneyAmount<0)
	BEGIN
		ROLLBACK;
		THROW 50002,'Invalid money amount',1
	END
	DECLARE @moneyInAccount MONEY = (SELECT Balance FROM Accounts WHERE Id=@accountId)
	IF (@moneyInAccount<@moneyAmount)
	BEGIN
		ROLLBACK;
		THROW 50002,'You don`t have enought money in your balance',1
	END
	 IF(@moneyInAccount < 0)
	  BEGIN
	  ROLLBACK;
	   THROW 50002,'You don`t have enought money in your balance',2
	  END
	UPDATE Accounts
	 SET Balance-=@moneyAmount
   WHERE Id=@accountId
	COMMIT

--PROBLEM 5
CREATE OR ALTER PROCEDURE usp_TransferMoney @senderId INT,@reciverId INT, @amount MONEY
AS
BEGIN TRANSACTION
	UPDATE Accounts
	   SET Balance += @amount
	 WHERE Id = @reciverId
	UPDATE Accounts
	   SET Balance -=@amount
	 WHERE Id = @senderId

	 IF NOT EXISTS ( SELECT * FROM Accounts WHERE Id = @senderId)
	BEGIN
		ROLLBACK;
		THROW 50001,'Sender Account doesn`t exist',1
	END

	IF NOT EXISTS ( SELECT * FROM Accounts WHERE Id = @reciverId)
	BEGIN
		ROLLBACK;
		THROW 50002,'Reciver account doesn`t exist',1
	END
	IF @amount<0
	BEGIN
		ROLLBACK;
		THROW 50003,'Sender don`t have enought money',1
	END

	IF @amount>(SELECT Balance FROM Accounts WHERE ID=@senderId)
	BEGIN
		ROLLBACK;
		THROW 50003,'Sender don`t have enought money',2
	END
COMMIT

--PROBLEM 6


--PROBLEM 7
--PROBLEM 8
CREATE PROCEDURE usp_AssignProject @employeeId INT, @projectId INT
AS
BEGIN TRANSACTION
	INSERT INTO EmployeesProjects (EmployeeID,ProjectID) VALUES
	(@employeeId,@projectId)

	IF NOT EXISTS ( SELECT * FROM Employees WHERE EmployeeID=@employeeId)
	BEGIN
		ROLLBACK;
		THROW 50001,'Employee doesn`t exist',1
	END

	IF NOT EXISTS ( SELECT * FROM Projects WHERE ProjectID=@projectId)
	BEGIN
		ROLLBACK;
		THROW 50002,'Project doesn`t exist',1
	END

	IF (SELECT COUNT(*) 
				 FROM EmployeesProjects 
			 GROUP BY EmployeeID
			   HAVING EmployeeID=@employeeId) >=3
	BEGIN 
		ROLLBACK;
		THROW 50003,'The employee has too many projects!',1
	END
COMMIT

EXECUTE usp_AssignProject 4,1

--PROBLEM 9
CREATE TABLE Deleted_Employees
(
	EmployeeId INT PRIMARY KEY, 
	FirstName VARCHAR(50), 
	LastName VARCHAR(50), 
	MiddleName VARCHAR(50), 
	JobTitle VARCHAR(50), 
	DepartmentId INT, 
	Salary MONEY 
)

CREATE TRIGGER tr_MoveDeletedEmployessToTable
ON Employees FOR DELETE
AS
BEGIN
	INSERT INTO Deleted_Employees(EmployeeId, FirstName, LastName, MiddleName, JobTitle, DepartmentId, Salary) 
	SELECT EmployeeID,
		   FirstName,
		   LastName,
		   MiddleName,
		   JobTitle,
		   DepartmentID,
		   Salary
	  FROM deleted	
END

