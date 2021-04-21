USE SoftUni;


CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000 
AS
	SELECT FirstName, LastName
		FROM Employees
		WHERE Salary > 35000
GO;

EXEC usp_GetEmployeesSalaryAbove35000 ;


CREATE PROCEDURE usp_GetEmployeesSalaryAboveNumber (@Salary DECIMAL (18,4))
AS
	SELECT FirstName, LastName
		FROM Employees
		WHERE Salary >= @Salary
GO;

EXEC usp_GetEmployeesSalaryAboveNumber 48100;


CREATE PROCEDURE usp_GetTownsStartingWith (@Text NVARCHAR(50))
AS 
	SELECT [Name] AS Town
		FROM Towns
		WHERE LEFT([Name],LEN(@Text)) = @Text
GO;

EXEC usp_GetTownsStartingWith 'b';


CREATE PROCEDURE usp_GetEmployeesFromTown (@TownName NVARCHAR(50))
AS
	SELECT FirstName, LastName
	FROM Employees
	JOIN Addresses ON Employees.AddressID = Addresses.AddressID
	JOIN Towns ON Addresses.TownID=Towns.TownID
	WHERE Towns.[Name]=@TownName
GO;

EXEC usp_GetEmployeesFromTown 'Sofia';


CREATE FUNCTION ufn_GetSalaryLevel(@Salary DECIMAL(18,4)) 
RETURNS VARCHAR(10)
AS
BEGIN
	DECLARE @SalaryLevel VARCHAR(10);

		IF (@Salary < 30000)
		SET @SalaryLevel = 'Low' 
		ELSE IF(@Salary < 50000)
		SET @SalaryLevel = 'Average'
		ELSE 
		SET @SalaryLevel = 'High'

	RETURN @SalaryLevel 
END;


SELECT Salary, dbo.ufn_GetSalaryLevel(Salary) AS [Salary Level]
	FROM Employees;


CREATE PROCEDURE usp_EmployeesBySalaryLevel(@Level VARCHAR(10))
AS
	SELECT FirstName, LastName
		FROM Employees
		WHERE dbo.ufn_GetSalaryLevel(Salary)=@Level
GO;

EXEC usp_EmployeesBySalaryLevel 'High';


CREATE OR Alter FUNCTION ufn_IsWordComprised(@SetOfLetters NVARCHAR(MAX), @Word NVARCHAR(MAX)) 
RETURNS INT
AS
BEGIN
DECLARE @Count INT = 1;

	WHILE(@Count<=LEN(@Word))
		BEGIN
			IF(CHARINDEX(Substring(@Word,@Count,1),@SetOfLetters,1) > 0)
				SET @Count +=1
			ELSE 
				RETURN 0 
		END
RETURN 1
END;


SELECT  dbo.ufn_IsWordComprised('pppp','Guy') AS [Result];
SELECT  dbo.ufn_IsWordComprised('oistmiahf','Sofia') AS [Result];
SELECT  dbo.ufn_IsWordComprised('oistmiahf','halves') AS [Result];
SELECT  dbo.ufn_IsWordComprised('bobr','Rob') AS [Result];


CREATE PROCEDURE usp_DeleteEmployeesFromDepartment (@departmentId INT) 
AS
	BEGIN
		DELETE FROM EmployeesProjects 
		WHERE EmployeeID IN (SELECT EmployeeID FROM Employees
							WHERE DepartmentID=@departmentId)

		UPDATE Employees
		SET ManagerID = NULL
		WHERE ManagerID IN (SELECT EmployeeID FROM Employees
							WHERE DepartmentID=@departmentId)
		ALTER TABLE Departments
		ALTER COLUMN ManagerID INT

		UPDATE Departments
		SET ManagerID = NULL
		WHERE ManagerID IN (SELECT EmployeeID FROM Employees
							WHERE DepartmentID=@departmentId)

		DELETE FROM Employees
		WHERE DepartmentID = @departmentId

		DELETE FROM Departments
		WHERE DepartmentID = @departmentId

		SELECT COUNT (*) FROM Employees
		WHERE DepartmentID = @departmentId
	END
GO;

EXEC usp_DeleteEmployeesFromDepartment 1;


USE Bank;


CREATE PROCEDURE usp_GetHoldersFullName 
AS
	SELECT CONCAT(FirstName, LastName, ' ') FROM [dbo].[AccountHolders]
GO;


CREATE OR ALTER PROCEDURE usp_GetHoldersWithBalanceHigherThan (@Number DECIMAL(18,4))
AS
BEGIN
				SELECT FirstName,LastName FROM Accounts
				JOIN AccountHolders  ON Accounts.AccountHolderId=AccountHolders.Id
				GROUP BY FirstName, LastName
				HAVING SUM(Balance) > @Number
				ORDER BY FirstName, LastName
END
GO

EXEC usp_GetHoldersWithBalanceHigherThan 25000; 


CREATE FUNCTION ufn_CalculateFutureValue (@Sum DECIMAL(18,4),@Rate FLOAT, @Year INT)
RETURNS DECIMAL(18,4)
AS
BEGIN
RETURN POWER(1+@Rate,@Year) * @Sum
END;

SELECT dbo.ufn_CalculateFutureValue(1000,0.1,5);


CREATE PROCEDURE usp_CalculateFutureValueForAccount
				(@AccountId INT, @FirstName NVARCHAR(50), @LastName NVARCHAR(50), @Balance DECIMAL(18,4), @Rate FLOAT)
AS
BEGIN
	SELECT dbo.ufn_CalculateFutureValue(@Balance,@Rate,5);
END;

EXEC usp_CalculateFutureValueForAccount 1,'Susan','Cane',123.12,0.1;


USE [Diablo];


GO
CREATE FUNCTION ufn_CashInUsersGames (@Name NVARCHAR(50))
RETURNS TABLE
AS
RETURN (
SELECT SUM(Cash) AS [SumCash] FROM
		(SELECT g.[Name], Cash,
		ROW_NUMBER() OVER (PARTITION BY [Name] ORDER BY Cash DESC) AS [Row Number]
		FROM Games AS g
		JOIN UsersGames ON g.Id = [dbo].[UsersGames].GameId
		WHERE g.[Name]=@Name) AS Temp
WHERE [Row Number] % 2 <> 0);


SELECT * FROM ufn_CashInUsersGames ('Ablajeck')



