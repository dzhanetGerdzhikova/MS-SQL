USE SoftUni;

SELECT TOP(5) EmployeeID, JobTitle, Employees.AddressID, A ddressText
	FROM Employees
	JOIN Addresses ON Employees.AddressID=Addresses.AddressID
	ORDER BY Employees.AddressID ASC;


SELECT TOP(50) FirstName,LastName,[Name] AS Town, AddressText AS AddressText
	FROM Employees
	JOIN Addresses ON Employees.AddressID=Addresses.AddressID
	JOIN Towns ON Addresses.TownID=Towns.TownID
	ORDER BY FirstName ASC, LastName ASC;


SELECT EmployeeID,FirstName,LastName,[Name] AS DepartnemtName
	FROM Employees
	JOIN Departments ON Employees.DepartmentID=Departments.DepartmentID
	WHERE Departments.[Name] = 'Sales'
	ORDER BY EmployeeID ASC;


SELECT TOP(5) EmployeeID, FirstName, Salary,[Name] AS DepartmentName
	FROM Employees
	JOIN Departments ON Employees.DepartmentID=Departments.DepartmentID
	WHERE Salary > 15000
	ORDER BY Departments.DepartmentID ASC;


SELECT TOP(3) Employees.EmployeeID,FirstName
	FROM Employees
    LEFT JOIN EmployeesProjects ON Employees.EmployeeID=EmployeesProjects.EmployeeID
	WHERE EmployeesProjects.ProjectID IS NULL
	ORDER BY Employees.EmployeeID ASC;

	--SELECT TOP(3) Employees.EmployeeID,FirstName
	--FROM Employees
	--where exists ( select 1 from 


SELECT FirstName, LastName, HireDate,Departments.[Name] AS DeptName
	FROM Employees
	JOIN Departments ON Employees.DepartmentID=Departments.DepartmentID
	WHERE Employees.HireDate >'1999.01.01'	
	AND  Departments.[Name] IN ('Sales','Finance')
	ORDER BY Employees.HireDate ASC;


SELECT TOP(5) Employees.EmployeeID,Employees.FirstName, Projects.[Name]
	FROM Employees
	JOIN EmployeesProjects ON Employees.EmployeeID=EmployeesProjects.EmployeeID
	JOIN Projects ON EmployeesProjects.ProjectID=Projects.ProjectID
	WHERE Projects.StartDate> '2002.08.13' 
	AND Projects.EndDate IS NULL
	ORDER BY Employees.EmployeeID ASC;



SELECT Employees.EmployeeID, Employees.FirstName,
CASE 
	WHEN Year(Projects.StartDate) >= 2005 THEN NULL
	ELSE Projects.Name
END AS ProjectName
	FROM  Employees
	JOIN EmployeesProjects ON Employees.EmployeeID=EmployeesProjects.EmployeeID
	JOIN Projects ON EmployeesProjects.ProjectID=Projects.ProjectID
	WHERE Employees.EmployeeID = 24;



SELECT e1.EmployeeID, e1.FirstName, e1.ManagerID, e2.FirstName AS ManagerName
	FROM Employees AS e1
	JOIN Employees AS e2 ON e1.ManagerID=e2.EmployeeID
	WHERE e1.ManagerID IN (3,7)
	ORDER BY e1.EmployeeID ASC;


SELECT TOP(50) e1.EmployeeID, 
				CONCAT(e1.FirstName,' ', e1.LastName) AS EmployeeName,
				CONCAT(e2.FirstName, ' ', e2.LastName) AS ManagerName,
				Departments.[Name] AS DepartmentName
	FROM Employees AS e1
	LEFT JOIN Employees AS e2 ON e1.ManagerID=e2.EmployeeID
	JOIN Departments ON e1.DepartmentID=Departments.DepartmentID
	ORDER BY e1.EmployeeID;



SELECT MIN([Avarage Salary]) AS MinAverageSalary
FROM (SELECT DepartmentID, AVG(Salary) AS [Avarage Salary]
	FROM Employees
	GROUP BY DepartmentID) AS temp;


USE Geography;


SELECT CountryCode,MountainRange,PeakName,Elevation
	FROM Peaks
	JOIN MountainsCountries ON Peaks.MountainId=MountainsCountries.MountainId
	JOIN Mountains ON MountainsCountries.MountainId = Mountains.Id
	WHERE Elevation > 2835 AND CountryCode='BG'
	ORDER BY Elevation DESC;

	
	
SELECT CountryCode, COUNT(CountryCode) AS [MountainRanges]
	FROM MountainsCountries
	WHERE CountryCode IN ('BG', 'RU', 'US')
	GROUP BY CountryCode;


SELECT  TOP(5) CountryName, RiverName
	FROM Countries
	LEFT JOIN CountriesRivers ON Countries.CountryCode=CountriesRivers.CountryCode
	LEFT JOIN Rivers ON CountriesRivers.RiverId = Rivers.Id
	WHERE ContinentCode='AF'
	ORDER BY CountryName ASC;

SELECT ContinentCode, CurrencyCode, CurrencyCount AS CurrencyUsagge
FROM (SELECT ContinentCode, CurrencyCode, CurrencyCount,
	DENSE_RANK () OVER (PARTITION BY ContinentCode ORDER BY CurrencyCount DESC) AS CurrencyRank
	FROM 
		(SELECT ContinentCode, CurrencyCode, COUNT(*) AS [CurrencyCount]
		FROM Countries
		GROUP BY ContinentCode, CurrencyCode) AS CurrencyCountQuery
WHERE CurrencyCount >1)	AS CurrencyRankinQuery
WHERE CurrencyRank=1
ORDER BY ContinentCode;


SELECT COUNT(Countries.CountryCode) AS [Count]
	FROM Countries
	LEFT JOIN MountainsCountries ON Countries.CountryCode=MountainsCountries.CountryCode
	WHERE MountainId IS NULL;


SELECT TOP(5) c.CountryName,
	MAX(p.Elevation) AS [HighestPeakElevation],
	MAX(ri.[Length]) AS [LongestRiverLength]
FROM Countries AS c
LEFT JOIN CountriesRivers AS cr ON c.CountryCode=cr.CountryCode
LEFT JOIN Rivers AS ri ON cr.RiverId=ri.Id
LEFT JOIN MountainsCountries AS mc ON c.CountryCode=mc.CountryCode
LEFT JOIN Mountains AS m ON mc.MountainId=m.Id
LEFT JOIN Peaks AS p ON m.Id=p.MountainId
GROUP BY c.CountryName
ORDER BY [HighestPeakElevation] DESC, [LongestRiverLength] DESC, CountryName ASC;



SELECT TOP(5) Country,
CASE	
	WHEN [Highest Peak Name] IS NULL THEN '(no highest peak)'
	ELSE [Highest Peak Name]
END AS [Highest Peak Name],
CASE
	WHEN [Highest Peak Elevation] IS NULL THEN '0'
	ELSE [Highest Peak Elevation]
END AS [Highest Peak Elevation],
CASE
	WHEN Mountain IS NULL THEN '(no mountain)'
	ELSE Mountain
END AS Mountain
FROM
(SELECT Country,PeakName AS [Highest Peak Name],Elevation AS [Highest Peak Elevation],MountainRange AS Mountain,
DENSE_RANK() OVER(PARTITION BY Country ORDER BY Elevation  DESC) AS RankElevation
		FROM
			(SELECT CountryName AS Country, PeakName ,Elevation , MountainRange 
			FROM Countries  AS c
			LEFT JOIN MountainsCountries AS mc ON c.CountryCode=mc.CountryCode
			LEFT JOIN Mountains AS m ON mc.MountainId=m.Id
			LEFT JOIN Peaks AS p ON m.Id=p.MountainId ) AS Info) AS Temp
WHERE RankElevation = 1
ORDER BY Country ASC, [Highest Peak Name] ASC