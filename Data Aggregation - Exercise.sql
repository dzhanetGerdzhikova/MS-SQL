USE Gringotts;

SELECT COUNT(*) AS [Count]
	FROM WizzardDeposits;


SELECT MAX(MagicWandSize) AS LongestMagicWand
	FROM WizzardDeposits;


SELECT DepositGroup, MAX(MagicWandSize) AS LongestMagicWand
	FROM WizzardDeposits
	GROUP BY DepositGroup;

SELECT DepositGroup FROM(
		SELECT TOP(2) DepositGroup, AVG(MagicWandSize) AS Size
			FROM WizzardDeposits
			GROUP BY DepositGroup
			ORDER BY Size ASC) AS Temp;


SELECT DepositGroup, SUM(DepositAmount)
	FROM WizzardDeposits
	GROUP BY DepositGroup;


SELECT DepositGroup, SUM(DepositAmount) AS TotalSum
	FROM WizzardDeposits
	WHERE MagicWandCreator = 'Ollivander family'
	GROUP BY DepositGroup;


SELECT DepositGroup, SUM(DepositAmount) AS TotalSum
	FROM WizzardDeposits
	WHERE MagicWandCreator = 'Ollivander family'  
	GROUP BY DepositGroup
	HAVING SUM(DepositAmount)< 150000
	ORDER BY TotalSum DESC;


SELECT DepositGroup, MagicWandCreator, MIN(DepositCharge) AS MinDepositCharge
	FROM WizzardDeposits
	GROUP BY DepositGroup, MagicWandCreator
	ORDER BY MagicWandCreator ASC, DepositGroup ASC;


SELECT AgeGroup , COUNT(*) AS WizzardsCount
FROM
	(SELECT 
			CASE 
			WHEN Age >= 0 AND Age <= 10 THEN '[0-10]'
			WHEN Age >10 AND Age <=20 THEN '[11-20]'
			WHEN Age >20 AND Age <=30 THEN '[21-30]'
			WHEN Age >30 AND Age <=40 THEN '[31-40]'
			WHEN Age >40 AND Age <=50 THEN '[41-50]'
			WHEN Age >50 AND Age <=60 THEN '[51-60]'
			ELSE '[61+]'
			END AS AgeGroup
	 FROM WizzardDeposits) AS Temp
GROUP BY AgeGroup


SELECT LEFT(FirstName,1) AS FirstLetter
	FROM WizzardDeposits
	WHERE DepositGroup='Troll Chest'
	GROUP BY (LEFT(FirstName,1))
	ORDER BY FirstLetter ASC;


SELECT DepositGroup,IsDepositExpired, AVG(DepositInterest) AS AverageInterest
	FROM WizzardDeposits
	WHERE DepositStartDate > '1985.01.01'
	GROUP BY DepositGroup,IsDepositExpired 
	ORDER BY DepositGroup DESC, IsDepositExpired ASC;

SELECT SUM([Difference])
FROM
	(SELECT FirstName AS [Host Wizard], DepositAmount AS [Host Wizard Deposit],
		LEAD(FirstName) OVER (ORDER BY Id ASC ) AS [Guest Wizard],
		LEAD(DepositAmount) OVER (ORDER BY ID ASC) AS [Guest Wizard Deposit], 
		DepositAmount - LEAD(DepositAmount) OVER (ORDER BY ID ASC) AS [Difference]
		FROM WizzardDeposits) AS TempResult
WHERE [Guest Wizard Deposit] IS NOT NULL;



USE SoftUni;


SELECT DepartmentID, SUM(Salary) AS [Totol Salary]
	FROM Employees
	GROUP BY DepartmentID
	ORDER BY DepartmentID;


SELECT DepartmentID,MIN(Salary) AS[MinimumSalary]
	FROM Employees
	WHERE HireDate >'2000.01.01'
	GROUP BY DepartmentID
	HAVING DepartmentID IN(2,5,7);


SELECT * INTO EmployeesSalaryOver30000
	FROM Employees
	WHERE Salary > 30000;

DELETE
FROM EmployeesSalaryOver30000
WHERE ManagerID=42;


UPDATE EmployeesSalaryOver30000
SET Salary += 5000
WHERE DepartmentID = 1;


SELECT DepartmentID, AVG (Salary) AS [AvarageSalary]
	FROM EmployeesSalaryOver30000
	GROUP BY DepartmentID;



SELECT * FROM
		(SELECT DepartmentID, Max(Salary) AS [MaxSalary]
			FROM Employees
			GROUP BY DepartmentID) AS Temp
WHERE MaxSalary < 30000 OR MaxSalary > 70000;



SELECT COUNT(*) AS [COUNT]
	FROM Employees
	WHERE ManagerID IS NULL;

SELECT DepartmentID, Salary AS ThirdHighestSalary
FROM (
		SELECT DepartmentID, Salary,
		DENSE_RANK() OVER(PARTITION BY DepartmentID ORDER BY Salary DESC) AS [Rank]
		FROM Employees
		GROUP BY DepartmentID, Salary
	) AS Temp
WHERE [Rank]=3;


SELECT TOP(10) e1.FirstName, e1.LastName, e1.DepartmentID
	FROM Employees AS e1
	WHERE e1.Salary >(
						SELECT  AVG (Salary)
						FROM Employees AS e2
						WHERE e2.DepartmentID=e1.DepartmentID
						GROUP BY DepartmentID
					 )
	ORDER BY DepartmentID