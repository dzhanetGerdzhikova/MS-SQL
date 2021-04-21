SELECT FirstName,LastName
	FROM Employees
	WHERE FirstName LIKE 'Sa%';


SELECT FirstName, LastName
	FROM Employees
	WHERE LastName LIKE '%ei%';


SELECT FirstName
		FROM Employees
		WHERE DATEPART (YEAR,HireDate )  BETWEEN 1995 AND 2005 AND DepartmentID = 10 OR DepartmentID = 3;


SELECT FirstName, LastName,JobTitle
	FROM Employees
	WHERE JobTitle NOT LIKE '%engineer%';

	   
SELECT	[Name]
	FROM Towns
	WHERE LEN([Name]) = 5 OR LEN([Name]) = 6
	ORDER BY [Name] ASC;


SELECT *
	FROM Towns
	WHERE [Name] LIKE '[MKBE]%'
	ORDER BY [Name] ASC;


SELECT *
	FROM Towns
	WHERE [Name] NOT LIKE '[R,B,D]%'
	ORDER BY [Name] ASC;


GO
CREATE VIEW V_EmployeesHiredAfter2000  AS
SELECT	FirstName,LastName
	FROM Employees
	WHERE DATEPART(YEAR,HireDate)>2000;

SELECT * FROM [dbo].[V_EmployeesHiredAfter2000];

SELECT FirstName, LastName
	FROM Employees
	WHERE LEN(LastName)=5;


SELECT EmployeeID,FirstName,LastName,Salary,
	DENSE_RANK() OVER(PARTITION BY Salary ORDER BY EmployeeID ASC)AS [Rank]
	FROM Employees
	WHERE Salary BETWEEN 10000 AND 50000
	ORDER BY Salary DESC



SELECT * FROM
	(SELECT EmployeeID,FirstName,LastName,Salary,
	DENSE_RANK() OVER(PARTITION BY Salary ORDER BY EmployeeID ASC)AS [Rank]
	FROM Employees
	WHERE Salary BETWEEN 10000 AND 50000) AS Temp
WHERE [Rank] = 2
ORDER BY Salary DESC;


USE Geography;

SELECT	CountryName AS [Country Name],IsoCode AS [ISO Code]
	FROM Countries
	WHERE CountryName LIKE '%A%a%a%'
	ORDER BY IsoCode;


SELECT PeakName, RiverName,LOWER(CONCAT(PeakName,SUBSTRING (RiverName,2,LEN(RiverName)-1))) AS Mix
	FROM Peaks,Rivers  
	WHERE RIGHT(PeakName,1)= LEFT (RiverName,1)
	ORDER BY Mix ASC;


SELECT PeakName, RiverName, LOWER(CONCAT(PeakName,SUBSTRING (RiverName,2,LEN(RiverName)-1))) AS Mix
	FROM Peaks
	JOIN Rivers ON RIGHT(PeakName,1)= LEFT (RiverName,1)
	ORDER BY Mix ASC;


USE Diablo;


SELECT TOP(50) [Name], FORMAT([Start],'yyyy-MM-dd') AS [Start]
	FROM Games
	WHERE YEAR(Start)>=2011 AND YEAR(Start)<=2012
	ORDER BY [Start] ASC, [Name] ASC;


SELECT Username,SUBSTRING(Email,CHARINDEX('@',Email,1)+1,LEN(Email)-CHARINDEX('@',Email,1)) AS [Email Provider]
	FROM UsersEmail
	ORDER BY [Email Provider] ASC, Username ASC;


SELECT UserName, IpAddress
	FROM Users
	WHERE IpAddress LIKE '___.1_%._%.___'
	ORDER BY Username ASC;


SELECT [Name] AS Game, 
	CASE
		WHEN DATEPART(HOUR,[Start]) BETWEEN 0 AND 11 THEN 'Morning'
		WHEN DATEPART(HOUR,[Start]) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
		END AS  [Part of the Day],
	CASE 
		WHEN Duration <=3 THEN 'Extra Short'
		WHEN Duration BETWEEN 4 AND 6 THEN 'Short'
		WHEN Duration > 6 THEN 'Long'
		ELSE 'Extra Long'
		END AS Duration
	FROM Games
	ORDER BY Game ASC, Duration ASC, [Part of the Day] ASC;


USE Orders;


SELECT ProductName,
	DATEADD(DAY,3,OrderDate) AS [Pay Due],
	DATEADD(MONTH,1,OrderDate) AS [Deliver Due]
	FROM Orders;


CREATE TABLE People
(
ID INT PRIMARY KEY IDENTITY NOT NULL,
[Name] NVARCHAR(50) NOT NULL,
Birthday DATETIME2 NOT NULL
);


INSERT INTO People ([Name], Birthday)
VALUES
	('Victor','2000-12-07 00:00:00.000'),
	('Steven','1992-09-10 00:00:00.000'),
	('Stephen','1910-09-19 00:00:00.000'),
	('John','2010-01-06 00:00:00.000');


SELECT [Name],
	ABS(DATEDIFF(YEAR,GETDATE(),Birthday)) AS [Age in Years],
	ABS(DATEDIFF(MONTH,GETDATE(),Birthday)) AS [Age in Months],
	ABS(DATEDIFF(DAY,GETDATE(),Birthday)) AS [Age in Days],
	ABS(DATEDIFF(MINUTE, GETDATE(),Birthday)) AS [Age in Minutes]
FROM People;