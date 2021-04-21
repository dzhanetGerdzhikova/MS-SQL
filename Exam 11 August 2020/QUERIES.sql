SELECT Name, Price, Description  FROM Products
ORDER BY Price DESC, Name ASC

SELECT ProductId, Rate,Description, CustomerId, Age,Gender 
FROM Feedbacks AS f
JOIN Customers AS c ON c.Id=f.CustomerId
WHERE Rate<5
ORDER BY ProductId DESC, Rate ASC

SELECT CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName, PhoneNumber, Gender
FROM Customers AS c
LEFT JOIN Feedbacks AS f ON c.Id=f.CustomerId
WHERE f.Id IS NULL


SELECT FirstName, Age, PhoneNumber
FROM Customers AS cu
JOIN Countries AS c ON c.Id=cu.CountryId
WHERE (Age>=21 AND FirstName LIKE '%an%') OR (RIGHT(PhoneNumber,2)='38' AND c.Name != 'Greece' )
ORDER BY FirstName ASC, Age DESC


SELECT * FROM
(SELECT d.Name AS DistributorName,i.Name AS IngredientName,p.Name AS ProductName, AVG(f.Rate) AS AverageRate
FROM Distributors AS d
JOIN Ingredients AS i ON d.Id=i.DistributorId
JOIN ProductsIngredients AS pri ON pri.IngredientId=i.Id
JOIN Products AS p ON p.Id = pri.ProductId
JOIN Feedbacks AS f ON f.ProductId=p.id
GROUP BY d.Name,i.Name,p.Name) AS Temp
WHERE AverageRate >=5 AND AverageRate <=8


SELECT CountryName, DistributorName
FROM
		(SELECT c.Name as CountryName, 
		d.Name as DistributorName,
		DENSE_RANK()  OVER (PARTITION BY c.Name ORDER BY COUNT(i.Id)) AS RankIngred
						 FROM Countries AS c
						 JOIN Distributors AS d ON c.Id=d.CountryId
						 JOIN Ingredients as i on i.DistributorId =d.Id
						 Group by c.Name, d.Name) AS Ranking
WHERE RankIngred=1
ORDER BY CountryName, DistributorName

GO
CREATE VIEW  v_UserWithCountries
AS 
SELECT CONCAT(c.FirstName ,' ',c.LastName) AS CustomerName, c.Age, c.Gender, co.Name
FROM Customers AS c
JOIN Countries AS co ON c.CountryId=co.Id


