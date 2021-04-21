CREATE TABLE Logs 
(LogId INT PRIMARY KEY IDENTITY,
AccountId INT, 
OldSum DECIMAL (15,2), 
NewSum DECIMAL (15,2))

CREATE OR ALTER TRIGGER tr_LogsInfo ON Accounts
FOR UPDATE
AS
DECLARE @Id INT = (SELECT Id FROM inserted)
DECLARE @OldSum DECIMAL(15,2) = (SELECT Balance FROM deleted)
DECLARE @NewSum DECIMAL (15,2) = (SELECT Balance FROM inserted)

INSERT INTO Logs (AccountId, OldSum, NewSum) VALUES
(@Id,@OldSum,@NewSum)

CREATE TABLE NotificationEmails
(Id INT PRIMARY KEY IDENTITY, 
Recipient INT, 
[Subject] NVARCHAR(100), 
Body NVARCHAR(MAX))

CREATE OR ALTER TRIGGER tr_EmailInfo ON Logs
FOR INSERT 
AS
DECLARE @Id INT = (SELECT TOP(1) AccountId  FROM inserted)
DECLARE @Old DECIMAL(15,2) = (SELECT OldSum FROM inserted)
DECLARE @New DECIMAL(15,2) = (SELECT NewSum FROM inserted)

INSERT INTO NotificationEmails(Recipient,[Subject],Body) VALUES
(@Id,
CONCAT('Balance change for account: ',@Id),
CONCAT('On ', GETDATE(),' ','your balance was changed from ',@Old,' ','to ', @New,'.'))

UPDATE Accounts
SET Balance +=100
WHERE Id=1

SELECT * FROM Logs
SELECT * FROM NotificationEmails

CREATE PROCEDURE usp_DepositMoney (@AccountId INT, @MoneyAmount DECIMAL(15,4))
AS
BEGIN TRANSACTION
DECLARE @account INT = (SELECT Id FROM Accounts WHERE Id=@AccountId)

IF(@AccountId IS NULL)
BEGIN
		ROLLBACK
		RAISERROR ('Invalid Id.',16,1)
		RETURN
END

IF(@MoneyAmount<0)
BEGIN
	ROLLBACK
		RAISERROR ('The record does not exist.', 16,1)		
	RETURN
END
UPDATE Accounts
SET Balance += @MoneyAmount
WHERE Id = @AccountId
COMMIT

CREATE OR ALTER PROCEDURE usp_WithdrawMoney (@AccountId INT, @MoneyAmount DECIMAL(15,4))
AS
BEGIN TRANSACTION
DECLARE @Id INT =(SELECT Id FROM Accounts WHERE Id=@AccountId)
DECLARE @UserBalance DECIMAL(15,4) = (SELECT Balance FROM Accounts WHERE Id=@AccountId)
IF(@Id IS NULL)
BEGIN
	ROLLBACK
	RAISERROR('Invalid ID.',16,1)
	RETURN
END

IF(@MoneyAmount < 0)
BEGIN
	ROLLBACK
	RAISERROR('Negative Amount.',16,1)
	RETURN
END

IF(@UserBalance < @MoneyAmount)
BEGIN
	ROLLBACK
	RAISERROR('Not enought money in balance',16,1)
	RETURN
END
UPDATE Accounts
SET Balance -= @MoneyAmount
WHERE Id=@AccountId
COMMIT


CREATE OR ALTER PROCEDURE usp_TransferMoney(@SenderId INT, @ReceiverId INT, @Amount DECIMAL (15,4)) 
AS
BEGIN TRANSACTION
EXECUTE usp_WithdrawMoney @SenderId,@Amount
EXECUTE usp_DepositMoney @ReceiverId, @Amount
COMMIT

