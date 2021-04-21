CREATE DATABASE TripService

CREATE TABLE Cities(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(20) NOT NULL,
CountryCode VARCHAR(2) NOT NULL CHECK (LEN(CountryCode)=2))

CREATE TABLE Hotels(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(30) NOT NULL,
CityId INT FOREIGN KEY REFERENCES Cities(Id) NOT NULL,
EmployeeCount INT NOT NULL,
BaseRate DECIMAL(15,2))


CREATE TABLE Rooms(
Id INT PRIMARY KEY IDENTITY,
Price DECIMAL(15,2) NOT NULL,
[Type] NVARCHAR(20) NOT NULL,
Beds INT NOT NULL,
HotelId INT FOREIGN KEY REFERENCES Hotels(Id) NOT NULL)


CREATE TABLE Trips(
Id INT PRIMARY KEY IDENTITY,
RoomId INT FOREIGN KEY REFERENCES Rooms(Id) NOT NULL,
BookDate DATE NOT NULL ,
ArrivalDate DATE NOT NULL ,
ReturnDate DATE NOT NULL,
CancelDate DATE ,
CONSTRAINT CHKBook_Arriv CHECK (BookDate<ArrivalDate),
CONSTRAINT CHKArriv_Return CHECK(ArrivalDate<ReturnDate))


CREATE TABLE Accounts(
Id INT PRIMARY KEY IDENTITY,
FirstName NVARCHAR(50) NOT NULL,
MiddleName NVARCHAR(20),
LastName NVARCHAR(50) NOT NULL,
CityId INT FOREIGN KEY REFERENCES Cities(Id) NOT NULL,
BirthDate DATE NOT NULL,
Email VARCHAR(100) UNIQUE NOT NULL)

CREATE TABLE AccountsTrips(
AccountId INT FOREIGN KEY REFERENCES Accounts(Id) NOT NULL,
TripId INT FOREIGN KEY REFERENCES Trips(Id) NOT NULL,
Luggage INT CHECK(Luggage>=0) NOT NULL,
PRIMARY KEY(AccountId, TripId))