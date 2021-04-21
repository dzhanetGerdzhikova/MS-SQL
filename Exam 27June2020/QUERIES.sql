SELECT CONCAT(m.FirstName,' ', m.LastName) AS Mechanic , j.Status, j.IssueDate
FROM Mechanics AS m
LEFT JOIN Jobs AS j ON j.MechanicId=m.MechanicId
ORDER BY m.MechanicId,j.IssueDate, j.JobId


SELECT CONCAT(c.FirstName, ' ',c.LastName) AS Client, DATEDIFF(DAY,j.IssueDate,'2017.04.24') AS 'Days going',j.Status
FROM Clients AS c
JOIN Jobs AS j ON j.ClientId=c.ClientId
WHERE j.Status != 'Finished'
ORDER BY [Days going] DESC, c.ClientId


SELECT CONCAT(m.FirstName,' ',m.LastName) AS Mechanic,AVG( DATEDIFF(DAY,j.IssueDate,j.FinishDate)) AS 'Average Days' 
FROM Mechanics AS m
JOIN Jobs AS j ON m.MechanicId=j.MechanicId
GROUP BY m.MechanicId, CONCAT(m.FirstName,' ',m.LastName)
ORDER BY m.MechanicId

SELECT FirstName + ' '+ LastName AS Available
FROM Mechanics as m
WHERE MechanicId NOT IN(
						SELECT MechanicId From Jobs as j
						WHERE [Status] !='Finished' and j.MechanicId=m.MechanicId  )
						--AND MechanicId IS NOT NULL)


SELECT j.JobId ,ISNULL(SUM(p.Price*op.Quantity),0) AS Total
FROM  Jobs AS j
LEFT JOIN Orders AS o ON o.JobId=j.JobId
 LEFT JOIN OrderParts AS op ON op.OrderId=o.OrderId
 LEFT JOIN Parts AS p ON p.PartId=op.PartId
WHERE j.Status='Finished'
GROUP BY j.JobId
ORDER BY Total DESC, j.JobId ASC


SELECT  p.PartId,p.[Description],
pn.Quantity as [Required],
p.StockQty as 'In Stock',
IIF(o.Delivered=0,op.Quantity,0) as [Order]
FROM Parts as p
LEFT JOIN PartsNeeded as pn ON pn.PartId=p.PartId
LEFT JOIN OrderParts as op ON op.PartId=p.PartId
LEFT JOIN Jobs as j ON j.JobId=pn.JobId
Left JOIN Orders as o ON o.JobId=j.JobId
WHERE j.Status != 'Finished' AND p.StockQty + IIF(o.Delivered=0,op.Quantity,0)<pn.Quantity 
ORDER BY PartId

GO
CREATE FUNCTION udf_GetCost(@jobId INT)
RETURNS DECIMAL(15,2)
AS
BEGIN
DECLARE @result DECIMAL(15,2);
SET @result=(SELECT SUM(p.Price*op.Quantity) AS Result
			FROM Orders AS o
			JOIN OrderParts AS op ON o.OrderId=op.OrderId
			JOIN Parts AS p ON op.PartId=p.PartId
			WHERE o.JobId=@jobId
			GROUP BY o.JobId)

IF(@result IS NULL)
SET @result=0
	
RETURN @result
END
GO

SELECT dbo.udf_GetCost(1)

