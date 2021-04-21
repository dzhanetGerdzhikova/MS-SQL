CREATE DATABASE Minions;

USE Minions;

CREATE TABLE Minions
(
	Id INT PRIMARY KEY not NULL,
	[Name] NVARCHAR(50) NOT NULL,
	Age INT
);

CREATE TABLE Towns
(
	Id int PRIMARY KEY NOT NULL,
	[Name] NVARCHAR(50) NOT NULL
);

ALTER TABLE Minions ADD TownId INT NOT NULL;

ALTER TABLE Minions ADD FOREIGN KEY(TownId) REFERENCES Towns(Id);

INSERT INTO Towns
	(Id,[Name])
VALUES
	(1, 'Sofia'),
	(2, 'Plovdiv'),
	(3, 'Varna');

INSERT INTO Minions
	(Id,[Name], Age, TownId)
VALUES
	(1, 'Kevin', 22, 1),
	(2, 'Bob', 15, 3),
	(3, 'Steward', NULL, 2);

SELECT *
FROM Minions;

SELECT *
FROM Towns;

TRUNCATE TABLE Minions;

DROP TABLE Minions;

DROP TABLE Towns;

CREATE TABLE People
(
	Id INT PRIMARY KEY IDENTITY NOT NULL,
	[Name] NVARCHAR(200) NOT NULL,
	Picture VARBINARY (MAX) CHECK (DATALENGTH (Picture) <= 2*1048576),
	Height DECIMAL(4,2),
	[Weight] DECIMAL(5,2),
	Gender CHAR CHECK(Gender='m' or Gender='f') NOT NULL,
	BirthDate DATE NOT NULL,
	Biography NVARCHAR(max)
);

INSERT INTO People
	([Name],Picture,Height,[Weight],Gender,BirthDate,Biography)
VALUES
	('Pesho', null, 1.68, 52.3, 'm', '02.02.1990', 'Pleven'),
	('Qvor', null, 1.88, 89.6, 'm', '1993-02-05', 'Pernik'),
	('Anna', null, 1.54, 43.6, 'f', '1993-02-05', 'Varna'),
	('Reni', null, 1.75, 78.6, 'f', '1993-02-05', 'Burgas'),
	('Desi', null, 1.81, 69.6, 'f', '1993/03/05', 'Sofia');

CREATE TABLE Users
(
	Id BIGINT PRIMARY KEY IDENTITY,
	Username VARCHAR(30) UNIQUE NOT NULL,
	[Password] VARCHAR(26) NOT NULL,
	ProfilePicture VARBINARY(max) CHECK (DATALENGTH(ProfilePicture) <= 900*1024),
	LastLoginTime DATETIME2,
	IsDeleted BIT NOT NULL
);

INSERT INTO USERS
	(Username,[Password],LastLoginTime,IsDeleted)
VALUES
	('pesho15', 1235, '02-10-2019 12:16:09', 0),
	('ivancho03', 2451, '10-06-2020 16:25:23', 1),
	('niko94', 25658, '03-04-2020 20:32:15', 1),
	('polinka43', 213, '06-11-2019 23:12:45', 0),
	('gancho06', 21568, '06-08-2020 08:23:55', 0);

ALTER TABLE Users

DROP CONSTRAINT [PK__Users__3214EC078EC4A96C];

ALTER TABLE Users ADD CONSTRAINT PK_Users_CompositeIdUsername PRIMARY KEY(Id,Username);

ALTER TABLE Users ADD CONSTRAINT CK_Users_PasswsordLength CHECK (LEN([Password])>=5);

INSERT INTO USERS
	(Username,[Password],IsDeleted)
VALUES('pesho125', 121235, 0);

ALTER TABLE Users DROP CONSTRAINT [PK_Users_CompositeIdUsername];

ALTER TABLE Users ADD CONSTRAINT PK_Users_Id PRIMARY KEY(Id);

ALTER TABLE Users ADD CONSTRAINT CK_Users_LengthOfUsers CHECK (LEN(Username)>=3);

CREATE DATABASE Movies;

Use Movies;

CREATE TABLE Directors
(
	Id INT PRIMARY KEY NOT NULL,
	DirectorName NVARCHAR(30) NOT NULL,
	Notes NVARCHAR(max)
);

CREATE TABLE Genres
(
	Id INT PRIMARY KEY NOT NULL,
	GenreName NVARCHAR(30) NOT NULL,
	Notes NVARCHAR(max)
);

CREATE TABLE Categories
(
	Id INT PRIMARY KEY NOT NULL,
	CategoryName NVARCHAR(30),
	Notes NVARCHAR (max)
);

CREATE TABLE Movies
(
	Id INT PRIMARY KEY NOT NULL,
	Title NVARCHAR (150) not null,
	DirectorId INT FOREIGN KEY REFERENCES Directors(Id),
	CopyrightYear DATE,
	[Length] TIME,
	GenreId INT FOREIGN KEY REFERENCES Genres(Id),
	CategoryId INT FOREIGN KEY REFERENCES Categories(Id),
	Rating DECIMAL(2,1) CHECK (Rating >0 AND Rating <=10 ),
	Notes NVARCHAR(MAX)
) ;

ALTER TABLE Movies ALTER COLUMN CopyrightYear INT;

ALTER TABLE Movies ALTER COLUMN [Length] INT;

INSERT INTO Movies(Id,Title,CopyrightYear,[Length],Rating)
VALUES(5,'Pets',2019,240,8.0);

CREATE DATABASE SoftUni;

USE SoftUni;

CREATE TABLE Towns 
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
[Name] NVARCHAR(50) NOT NULL,
);

CREATE TABLE Addresses 
(
Id INT PRIMARY KEY NOT NULL,
AddressText NVARCHAR(100) NOT NULL,
TownId INT FOREIGN KEY REFERENCES Towns(Id)
);

CREATE TABLE Departments 
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
[Name] NVARCHAR(50) NOT NULL
);

CREATE TABLE Employees 
(
Id INT PRIMARY KEY IDENTITY NOT NULL,
FirstName NVARCHAR(50) NOT NULL,
MiddleName NVARCHAR(50),
LastName NVARCHAR (50) NOT NULL,
JobTitle NVARCHAR(50) NOT NULL,
DepartmentId INT FOREIGN KEY REFERENCES Departments(Id) NOT NULL,
HireDate DATE NOT NULL,
Salary DECIMAL(7,2) NOT NULL,
AddressId INT FOREIGN KEY REFERENCES Addresses(Id) 
);

BACKUP DATABASE Movies
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\Movies.bak';


DROP DATABASE Movies;

INSERT INTO Towns([Name])
VALUES
('Sofia'),
('Plovdiv'),
('Varna'),
('Burgas');

INSERT INTO Departments([Name])
VALUES 
('Engineering'),
('Sales'),
('Marketing'),
('Software Development'),
('Quality Assurance');


INSERT INTO Employees(FirstName,MiddleName,LastName,JobTitle, DepartmentId,HireDate, Salary)
VALUES
('Ivan', 'Ivanov','Ivanov','.NET Developer',4,'02/01/2013',3500.00),
('Petar','Petrov','Petrov','Senior Engineer',1,'03/02/2004',4000.00),
('Maria','Petrova','Ivanova','Intern',5,'08/28/2016',525.25),
('Peter','Pan','Pan','Intern',3,'08/28/2016',599.88);


SELECT * FROM Towns;

SELECT * FROM Departments;

SELECT * FROM Employees;

SELECT * FROM Towns ORDER BY [Name] ASC;

SELECT * FROM Departments ORDER BY [Name] ASC;

SELECT * FROM Employees ORDER BY Salary DESC;

SELECT [Name] FROM Towns ORDER BY [Name] ASC;

SELECT [Name] FROM Departments  ORDER BY [Name] ASC;

SELECT FirstName,LastName, JobTitle, Salary FROM Employees ORDER BY Salary DESC;

UPDATE Employees SET Salary +=Salary*0.1;

SELECT Salary FROM Employees;

BACKUP DATABASE Minions
TO DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\Backup\Minions.bak';

