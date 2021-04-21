SELECT TOP (3) [Name]
	FROM Towns 
	WHERE [Name] LIKE '%ea%';

SELECT ManagerID
	FROM Departments
	WHERE ManagerID =12;

UPDATE Employees
	SET Salary -=20000
	WHERE Salary >=30000 AND Salary <=50000;

Select * FROM Employees;

DELETE FROM EmployeesProjects
	WHERE EmployeeID IN (
	SELECT EmployeeID
	FROM Employees
	WHERE Salary < 10000);

DELETE FROM Employees	
	WHERE Salary < 10000;

SELECT FirstName + ' '+ LastName AS FullName
	FROM Employees
	WHERE FirstName LIKE 'J%';

SELECT * 
	FROM Departments;

SELECT [Name],ManagerId
	FROM Departments;

SELECT EmployeeId AS ID, FirstName +' '+LastName AS FullName, JobTitle, Salary
	FROM Employees;

SELECT FirstName+' '+LastName AS FullName, DepartmentId, Salary
	FROM Employees
	Where DepartmentID = 2


SELECT FirstName+' '+LastName AS FullName, DepartmentId, Salary
	FROM Employees
	Where DepartmentID = 2
	ORDER BY  Salary ASC

SELECT LastName, ManagerID
	FROM Employees
	WHERE ManagerID = 3 OR ManagerID=6

SELECT LastName, ManagerId
	FROM Employees
	WHERE NOT( ManagerID=3 OR ManagerID=6)

SELECT FirstName, LastName, ManagerId
	FROM Employees
	WHERE ManagerID IN (3,6,12,16)

SELECT FirstName, LastName, JobTitle,HireDate
	FROM Employees
	WHERE  YEAR(HireDate) >=2000-01-01 And YEAR(HireDate)<=2001-01-01
	ORDER BY HireDate ASC

CREATE VIEW  v_EmployeeSalary AS
	SELECT FirstName +' '+LastName AS FullName, JobTitle, Salary
	FROM Employees
	
SELECT * FROM [dbo].[v_EmployeeSalary]


USE Geography

CREATE VIEW v_HighestPeak AS
	SELECT TOP(1) PeakName, Elevation
	FROM Peaks
	ORDER BY Elevation DESC

USE SoftUniBase

INSERT INTO Projects([Name],StartDate)
	SELECT [Name] +' Reestructuring', GETDATE()
	FROM Departments

DELETE 
	FROM Projects
	WHERE [Name] LIKE  '%Reestructuring' 
 
USE Diablo

SELECT Username,Email,RegistrationDate
	INTO UsersEmail
	FROM Users

USE SoftUniBase

UPDATE Employees
	SET JobTitle = 'Senior '+ JobTitle
	WHERE DepartmentID IN(3)

SELECT FirstName, JobTitle, DepartmentID
	FROM Employees
	WHERE DepartmentID IN (3)

