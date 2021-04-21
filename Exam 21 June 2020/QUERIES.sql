SELECT a.FirstName,a.LastName, FORMAT(a.BirthDate,'MM-dd-yyyy') AS BirthDate,c.Name AS Hometown,Email FROM Accounts AS a
JOIN Cities AS c ON a.CityId=c.Id
WHERE a.Email LIKE 'e%'
ORDER BY c.Name

SELECT c.[Name] AS City, COUNT(h.Id)AS Hotels FROM Cities AS c
JOIN Hotels AS h ON c.Id=h.CityId
GROUP BY c.[Name]
ORDER BY Hotels DeSC, c.[Name]

SELECT ac.Id, CONCAT(ac.FirstName, ' ', ac.LastName) AS FullName,
MAX(DATEDIFF(day,t.ArrivalDate,t.ReturnDate)) AS LongestTrip,
Min(DATEDIFF(day,t.ArrivalDate,t.ReturnDate)) AS ShortestTrip
FROM Accounts AS ac
LEFT JOIN AccountsTrips AS at ON ac.Id=at.AccountId
JOIN Trips AS t ON t.Id=at.TripId
WHERE ac.MiddleName IS NULL AND t.CancelDate IS NULL
GROUP BY ac.Id,CONCAT(ac.FirstName, ' ', ac.LastName)
ORDER BY LongestTrip DESC, ShortestTrip ASC

SELECT TOP (10) c.Id,c.Name AS City,c.CountryCode AS Country, COUNT(ac.Id) AS Accounts 
FROM Cities AS c
JOIN Accounts AS ac ON ac.CityId=c.Id
GROUP BY c.Id,c.Name,c.CountryCode
ORDER BY Accounts DESC 


SELECT ac.Id,ac.Email,c.Name,COUNT(at.TripId) AS Trips
FROM Accounts AS ac
JOIN AccountsTrips AS at ON ac.Id=at.AccountId
JOIN Trips AS t ON t.Id = at.TripId
JOIN Rooms AS r ON r.Id=t.RoomId
JOIN Hotels AS h ON h.Id=r.HotelId
JOIn Cities AS c ON c.id=h.CityId
WHERE ac.CityId=h.CityId 
GROUP BY ac.Id, ac.Email,c.Name
HAVING COUNT(at.TripId) >=1
ORDER BY Trips DESC, ac.Id 


SELECT t.Id,
		CONCAT (ac.FirstName, ' ',ac.MiddleName,' ',ac.LastName) AS [Full Name],
		accountCities.[Name] AS [From],
		hotelCities.[Name] AS [To],
		CASE
		WHEN CancelDate IS  NULL THEN CONCAT(DATEDIFF(DAY,t.ArrivalDate,t.ReturnDate),' days')
		ELSE 'Canceled' 
		END AS Duration	
FROM Accounts AS ac
JOIN Cities AS accountCities ON accountCities.Id=ac.CityId
JOIN AccountsTrips AS act ON act.AccountId=ac.Id
JOIN Trips AS t ON t.Id=act.TripId
JOIN Rooms as r on r.Id = t.RoomId
JOIN Hotels AS h ON h.Id = r.HotelId
JOIN Cities As hotelCities on hotelCities.Id = h.CityId
ORDER BY [Full Name], t.Id


GO
CREATE PROCEDURE usp_SwitchRoom(@TripId INT, @TargetRoomId INT)
AS
BEGIN
DECLARE @countAccountsForTrip INT 
	SET @countAccountsForTrip =( SELECT COUNT(TripId)
							FROM AccountsTrips
							WHERE TripId=@TripId)

DECLARE @countOfBeds INT
	SET @countOfBeds = (SELECT Beds FROM Rooms
					WHERE Id=@TargetRoomId)

DECLARE @tripHotelId INT
	SET @tripHotelId = (SELECT h.Id FROM Trips AS t
						JOIN Rooms AS r ON r.Id=t.RoomId
						JOIN Hotels AS h ON h.Id=r.HotelId
						WHERE t.Id=@TripId)

DECLARE @roomHotelId INT
	SET @roomHotelId = (SELECT HotelId FROM Rooms
						WHERE Id=@TargetRoomId)

IF(@countAccountsForTrip>@countOfBeds)
	THROW 50011, 'Not enough beds in target room!', 1
ELSE IF(@roomHotelId != @tripHotelId)
	THROW 50012, 'Target room is in another hotel!',1
ELSE
	DECLARE @result INT
	UPDATE Trips
	SET RoomId=@TargetRoomId
	WHERE Id = @TripId
END
