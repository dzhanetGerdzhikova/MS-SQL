SELECT Id, Message, RepositoryId, ContributorId
FROM Commits
ORDER BY Id,Message, RepositoryId, ContributorId


SELECT Id, Name, Size
FROM Files
WHERE Size > 1000 AND Name LIKE '%html%'
ORDER BY Size DESC, Id ASC, Name ASC

SELECT i.Id, CONCAT(u.Username, ' : ', i.Title) AS IssueAssignee
FROM Issues AS i
JOIN Users AS u ON u.Id=i.AssigneeId
ORDER BY i.Id DESC, AssigneeId ASC

--f.Id,f.Name,CONCAT(f.SIze,'KB') AS Size

SELECT  f.Id,f.Name,CONCAT(f.SIze,'KB') AS Size
FROM Files AS f 
WHERE f.Id NOT IN (SELECT ParentId FROM Files WHERE ParentId IS NOT NULL)
ORDER BY f.Id, f.Name, f. Size DESC
 

SELECT TOP(5) r.id,r.Name, COUNT(c.Id) AS COmmits
FROM Repositories  AS r
JOIN RepositoriesContributors AS rc ON r.Id=rc.RepositoryId
JOIN Users AS u ON rc.ContributorId=u.Id
JOIN Commits AS c ON c.RepositoryId=r.Id
GROUP BY r.Id,r.Name
ORDER BY COmmits DESC, r.Id,r.Name

SELECT u.Username, AVG(f.Size) AS Size
FROM Users AS u
JOIN Commits AS c ON c.ContributorId=u.Id
JOIN Files AS f ON c.Id=f.CommitId
GROUP BY u.Username
ORDER BY Size DESC, u.Username


GO
CREATE FUNCTION udf_AllUserCommits(@username VARCHAR(30))
RETURNS INT
AS
BEGIN
	RETURN (SELECT COUNT(c.Id)
			FROM Users AS u
			JOIN Commits AS c ON c.ContributorId=u.Id
			WHERE u.Username = @username)
			
END

GO
CREATE PROCEDURE usp_SearchForFiles(@fileExtension VARCHAR(100))
AS
SELECT Id, Name, CONCAT(Size,'KB') AS Size
FROM Files
WHERE SUBSTRING(Name, CHARINDEX('.', Name) + 1,LEN(@fileExtension)) =@fileExtension
ORDER BY Id ASC, Name ASC, Size DESC