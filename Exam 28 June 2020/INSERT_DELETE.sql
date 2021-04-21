INSERT INTO Planets([Name])
VALUES ('Mars'),
		('Earth'),
		('Jupiter'),
		('Saturn')
	
INSERT INTO Spaceships ([Name], Manufacturer, LightSpeedRate)
VALUES ('Golf',	'VW',	3),
		('WakaWaka',	'Wakanda',	4),
		('Falcon9',	'SpaceX',	1),
		('Bed',	'Vidolov',	6)


UPDATE Spaceships
SET LightSpeedRate +=1
WHERE Id >=8 AND Id <= 12


DELETE FROM TravelCards WHERE JourneyId IN (1,2,3)
DELETE FROM Journeys WHERE Id IN (1,2,3)

