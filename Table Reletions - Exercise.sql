CREATE  DATABASE Relations;

USE Relations;

CREATE TABLE Passports
(
PassportID INT PRIMARY KEY NOT NULL,
PassportNumber VARCHAR(10) NOT NULL
);

INSERT INTO Passports(PassportID,PassportNumber)
VALUES				(101,'N34FG21B'),
					(102,'K65LO4R7'),
					(103,'ZE657QP2');

CREATE TABLE Persons
(
PersonID INT PRIMARY KEY NOT NULL,
[FirstName] NVARCHAR(30) NOT NULL,
Salary DECIMAL(7,2) NOT NULL,
PassportID INT NOT NULL FOREIGN KEY REFERENCES Passports(PassportID) UNIQUE
);

INSERT INTO Persons(PersonID,FirstName,Salary,PassportID)
VALUES
	(1,'Roberto',43300.00,102),
	(2,'Tom',56100.00,103),
	(3,'Yana',60200.00,101);

SELECT * FROM Passports;
SELECT * FROM Persons;

CREATE TABLE Manufacturers
(
ManufacturerID INT PRIMARY KEY IDENTITY NOT NULL,
[Name] VARCHAR(30) NOT NULL,
EstablishedOn DATE NOT NULL
);

INSERT INTO Manufacturers ([Name],EstablishedOn)
VALUES
	('BMV','1916-03-07'),
	('Tesla','2003-01-01'),
	('Lada','1966-05-01');

CREATE TABLE Models
(
ModelID INT PRIMARY KEY NOT NULL,
[Name] VARCHAR(30) NOT NULL,
ManufacturerID INT NOT NULL FOREIGN KEY REFERENCES Manufacturers(ManufacturerId)
)

INSERT INTO Models(ModelID,[Name],ManufacturerID)
VALUES
	(101,'X1',1),
	(102,'i6',1),
	(103,'Model S',2),
	(104,'Model X',2),
	(105,'Model 3',2),
	(106,'Nova',3);

SELECT * FROM Manufacturers;
SELECT * FROM Models;

CREATE TABLE Students
(
StudentID INT PRIMARY KEY NOT NULL IDENTITY,
[Name] VARCHAR (30) NOT NULL
);

INSERT INTO Students ([Name])
VALUES
	('Mila'),
	('Toni'),
	('Ron');

CREATE TABLE Exams
(
ExamID INT PRIMARY KEY NOT NULL,
[Name] VARCHAR(20) NOT NULL
);

INSERT INTO Exams(ExamID,[Name])
VALUES
	(101,'SpringMVC'),
	(102,'Neo4j'),
	(103,'Oracle 11g');

CREATE TABLE StudentsExams
(
StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
ExamID INT FOREIGN KEY REFERENCES Exams(ExamID),
PRIMARY KEY (StudentID,ExamID)
);


INSERT INTO StudentsExams(StudentID,ExamID)
VALUES
	(1,101),
	(1,102),
	(2,101),
	(3,103),
	(2,102),
	(2,103);


CREATE TABLE Teachers
(
TeacherID INT PRIMARY KEY NOT NULL,
[Name] VARCHAR(30) NOT NULL,
ManagetID INT FOREIGN KEY REFERENCES Teachers(TeacherID)
);

INSERT INTO Teachers(TeacherID,[Name],ManagetID)
VALUES
	(101,'John',NULL),
	(102,'Maya',106),
	(103,'Silvia',106),
	(104,'Ted',105),
	(105,'Mark',101),
	(106,'Greta',101);

CREATE DATABASE OnlineStore;

Use OnlineStore;

CREATE TABLE Cities
(
CityID INT PRIMARY KEY NOT NULL,
[Name] VARCHAR(50) NOT NULL,
);


CREATE TABLE Customers
(
CustomerID INT PRIMARY KEY NOT NULL,
[Name] VARCHAR(50) NOT NULL,
Birthday DATE,
CityID INT FOREIGN KEY REFERENCES Cities(CityID)
);

CREATE TABLE Orders
(
OrderID INT PRIMARY KEY NOT NULL,
CustomerID INT FOREIGN KEY REFERENCES  Customers(CustomerID)
);

CREATE TABLE ItemTypes
(
ItemTypeID INT PRIMARY KEY NOT NULL,
[Name] VARCHAR(50) NOT NULL
);

CREATE TABLE Items
(
ItemID INT PRIMARY KEY NOT NULL,
[Name] VARCHAR(50) NOT NULL,
ItemTypeID INT FOREIGN KEY REFERENCES ItemTypes(ItemTypeID)
);

CREATE TABLE OrderItems
(
OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
ItemID INT FOREIGN KEY REFERENCES Items(ItemID),
PRIMARY KEY(OrderID,ItemID)
);


CREATE DATABASE University;

USE University;

CREATE TABLE Majors
(
MajorID INT PRIMARY KEY NOT NULL,
[Name] VARCHAR(50) NOT NULL
);

CREATE TABLE Students
(
StudentID INT PRIMARY KEY NOT NULL,
StidentNumber NVARCHAR(50) NOT NULL,
StudentName VARCHAR(50) NOT NULL,
MajorID INT FOREIGN KEY REFERENCES Majors(MajorID)
);

CREATE  TABLE Payments
(
PaymentID INT PRIMARY KEY NOT NULL,
PaymentDate Date NOT NULL,
PaymentAmount DECIMAL(10,2) NOT NULL,
StudentID INT FOREIGN kEY REFERENCES Students(StudentID)
);


CREATE TABLE Subjects
(
SubjectID INT PRIMARY KEY NOT NULL,
SubjectName VARCHAR(100) NOT NULL
);

CREATE TABLE Agenda
(
StudentID INT FOREIGN KEY REFERENCES Students(StudentID),
SubjectID INT FOREIGN KEY REFERENCES Subjects(SubjectID),
PRIMARY KEY(StudentID,SubjectID)
);


USE Geography;

SELECT * FROM Peaks;

SELECT * FROM Mountains;

SELECT Mountains.MountainRange, Peaks.PeakName, Peaks.Elevation 
FROM Peaks
JOIN Mountains ON Peaks.MountainId = Mountains.Id
WHERE MountainRange = 'Rila'
ORDER BY Elevation DESC;