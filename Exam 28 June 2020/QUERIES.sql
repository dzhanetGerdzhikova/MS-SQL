SELECT Id, FORMAT(JourneyStart,'dd/MM/yyyy'), FORMAT(JourneyEnd,'dd/MM/yyyy') 
FROM Journeys
WHERE Purpose = 'Military '
ORDER BY JourneyStart

SELECT c.Id, CONCAT(c.FirstName,' ',c.LastName) AS [full_name]
FROM Colonists AS c
JOIN TravelCards AS tc ON tc.ColonistId=c.Id
WHERE tc.JobDuringJourney='Pilot'
ORDER BY c.Id ASC 

SELECT COUNT(*) AS count
FROM Colonists AS c
JOIN TravelCards AS tc ON tc.ColonistId=c.Id
JOIN Journeys AS j ON j.Id=tc.JourneyId
WHERE j.Purpose = 'Technical'

SELECT s.Name, s.Manufacturer
FROM Colonists AS c
 JOIN TravelCards AS tc ON tc.ColonistId=c.Id
 JOIN Journeys AS j ON j.id=tc.JourneyId
 JOIN Spaceships AS s ON s.Id=j.SpaceshipId 
Where DATEDIFF(YEAR,c.BirthDate,'2019-01-01')<30 and tc.JobDuringJourney = 'Pilot'
ORDER BY s.Name ASC 


SELECT p.[Name], COUNT(j.Id) AS JourneysCount 
FROM Planets AS p
JOIN Spaceports AS s ON s.PlanetId=p.Id
JOIN Journeys AS j ON j.DestinationSpaceportId=s.Id
GROUP BY p.[Name]
ORDER BY JourneysCount DESC,p.[Name] ASC

SELECT * FROM 
(SELECT tc.JobDuringJourney,
CONCAT(FirstName, ' ', LastName) AS FullName,
ROW_NUMBER()  OVER (PARTITION BY tc.JobDuringJourney ORDER BY c.BirthDate) AS JobRank
FROM Colonists AS c
JOIN TravelCards AS tc ON tc.ColonistId=c.Id) AS Temp
WHERE JobRank=2

GO
CREATE FUNCTION udf_GetColonistsCount(@PlanetName VARCHAR (30)) 
RETURNS INT
BEGIN

	RETURN (SELECT COUNT(c.Id) AS [Count]
	FROM Colonists AS c
	JOIN TravelCards AS tc ON c.Id=tc.ColonistId
	JOIN Journeys AS j ON tc.JourneyId=j.Id
	JOIN Spaceports AS s ON j.DestinationSpaceportId=s.Id
	JOIN Planets AS p ON s.PlanetId=p.Id
	WHERE p.Name=@PlanetName) 

END


GO
CREATE PROCEDURE usp_ChangeJourneyPurpose(@JourneyId INT, @NewPurpose VARCHAR(11))
AS
BEGIN
	DECLARE @journey INT
		SET @Journey=(SELECT Id FROM Journeys WHERE Id=@JourneyId)
	
	DECLARE @purpose VARCHAR(11)
		SET @purpose=(SELECT Purpose FROM Journeys WHERE Id=@JourneyId)

		IF(@journey IS NULL)
			THROW 50011, 'The journey does not exist!',1
		ELSE IF(@purpose = @NewPurpose )
			THROW 50012, 'You cannot change the purpose!',1
		ELSE 
			UPDATE Journeys
			SET @purpose=@NewPurpose
END

