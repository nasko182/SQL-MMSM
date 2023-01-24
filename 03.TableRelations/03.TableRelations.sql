--PROBLEM 1
CREATE TABLE [Passports]
(
	[PassportID] INT PRIMARY KEY IDENTITY(101, 1),
	[PassportNumber] VARCHAR(8) UNIQUE
)

CREATE TABLE [Persons]
(
	[PersonID] INT PRIMARY KEY IDENTITY,
	[FirstName] VARCHAR(30) NOT NULL,
	[Salary] DECIMAL(8,2) NOT NULL,
	[PassportID] INT  FOREIGN KEY REFERENCES [Passports](PassportID) UNIQUE NOT NULL
)

INSERT INTO Passports VALUES
('N34FG21B'),
('K65LO4R7'),
('ZE657QP2')

INSERT INTO Persons VALUES
('Roberto',43300.00,102),
('Tom',56100.00,103),
('Yana',60200.00,101)

--PROBLEM 2
CREATE TABLE Manufacturers
(
	[ManufacturerID] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL UNIQUE,
	[EstablishedOn] DATE NOT NULL,
)

CREATE TABLE Models
(
	[ModelID] INT PRIMARY KEY IDENTITY(101, 1),
	[Name] VARCHAR(50) UNIQUE NOT NULL,
	[ManufacturerID] INT FOREIGN KEY REFERENCES [Manufacturers](ManufacturerID) NOT NULL
)

--PROBLEM 3
CREATE TABLE Students
(
	[StudentID] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(30) NOT NULL
)

CREATE TABLE Exams
(
	[ExamID] INT PRIMARY KEY IDENTITY(101,1),
	[Name] VARCHAR(30) NOT NULL
)


CREATE TABLE StudentsExams
(
	[StudentID] INT REFERENCES Students([StudentID]),
	[ExamID] INT REFERENCES Exams([ExamID]),
	CONSTRAINT CK_StudentsExams PRIMARY KEY([StudentID],[ExamID])
)

--PROBLEM 4
CREATE TABLE Teachers
(
	[TeacherID] INT PRIMARY KEY IDENTITY(101, 1),
	[Name] NVARCHAR(50) NOT NULL,
	[ManagerID] INT FOREIGN KEY REFERENCES [Teachers](TeacherID) 
)

INSERT INTO [Teachers] VALUES
('John',NULL),
('Maya',106),
('Silvia', 106),
('Ted', 105),
('Mark',101),
('Greta', 101)

--PROBLEM 5
CREATE TABLE [ItemTypes]
(
	[ItemTypeID] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE [Cities]
(
	[CityID] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE [Customers]
(
	[CustomerID] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	[Birthday] DATE NOT NULL,
	[CityID] INT FOREIGN KEY REFERENCES [Cities](CityID)
)

CREATE TABLE [Items]
(
	[ItemID] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL,
	[ItemTypeID] INT FOREIGN KEY REFERENCES [ItemTypes](ItemTypeID)
)

CREATE TABLE [Orders]
(
	[OrderID] INT PRIMARY KEY IDENTITY,
	[CustomerID] INT FOREIGN KEY REFERENCES [Customers](CustomerID)
)

CREATE TABLE [OrderItems]
(
	[OrderID] INT FOREIGN KEY REFERENCES [Orders](OrderID),
	[ItemID] INT FOREIGN KEY REFERENCES [Items](ItemID),
	CONSTRAINT CK_ItemsOrders PRIMARY KEY (OrderID,ItemID)
)


--PROBLEM 6

CREATE TABLE [Majors]
(
	[MajorID] INT PRIMARY KEY IDENTITY,
	[Name] VARCHAR(50) NOT NULL
)

CREATE TABLE [Subjects]
(
	[SubjectID] INT PRIMARY KEY IDENTITY,
	[SubjectName] VARCHAR(50) NOT NULL
)

CREATE TABLE [Students]
(
	[StudentID] INT PRIMARY KEY IDENTITY,
	[StudentNumber] VARCHAR(10) NOT NULL,
	[StudentName] VARCHAR(50) NOT NULL,
	[MajorID] INT FOREIGN KEY REFERENCES [Majors](MajorID)
)

CREATE TABLE [Agenda]
(
	[StudentID] INT FOREIGN KEY REFERENCES [Students](studentID),
	[SubjectID] INT FOREIGN KEY REFERENCES [Subjects](SubjectID),
	CONSTRAINT CK_StudentsSubjects PRIMARY KEY(StudentID,SubjectID)
)


CREATE TABLE [Payments]
(
	[PaymentID] INT PRIMARY KEY IDENTITY,
	[PaymentDate] DATE,
	[PaymentAmount] DECIMAL(6,2),
	[StudentID] INT FOREIGN KEY REFERENCES [Students](StudentID)
)

--PROBLEM 9
USE Geography
SELECT m.MountainRange,p.PeakName,p.Elevation
	FROM Peaks As p
	JOIN Mountains As m 
	ON p.MountainId = m.Id
	WHERE m.MountainRange='Rila'
	ORDER BY P.Elevation DESC