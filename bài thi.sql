CREATE DATABASE AZBank;
GO

USE AZBank;
GO

IF OBJECT_ID('CustomerTransaction', 'U') IS NOT NULL
    DROP TABLE CustomerTransaction;

IF OBJECT_ID('CustomerAccount', 'U') IS NOT NULL
    DROP TABLE CustomerAccount;

IF OBJECT_ID('Customer', 'U') IS NOT NULL
    DROP TABLE Customer;
    
CREATE TABLE Customer (
    CustomerId INT PRIMARY KEY,
    Name NVARCHAR(50),
    City NVARCHAR(50),
    Country NVARCHAR(15),
    Phone NVARCHAR(50),
    Email NVARCHAR(50)
);

CREATE TABLE CustomerAccount (
    AccountNumber CHAR(9),
    CustomerId INT,
    Balance MONEY,
    MinAccount MONEY,
    PRIMARY KEY (AccountNumber),
    FOREIGN KEY (CustomerId) REFERENCES Customer(CustomerId)
);

CREATE TABLE CustomerTransaction (
    TransactionId INT PRIMARY KEY,
    AccountNumber CHAR(9),
    TransactionDate SMALLDATETIME,
    Amount MONEY,
    DepositorWithdraw NVARCHAR(10),
    FOREIGN KEY (AccountNumber) REFERENCES CustomerAccount(AccountNumber)
);

INSERT INTO Customer (CustomerId, Name, City, Country, Phone, Email)
VALUES
    (1, N'John Doe', N'Hanoi', N'Vietnam', N'123456789', N'john.doe@example.com'),
    (2, N'Jane Smith', N'Ho Chi Minh City', N'Vietnam', N'987654321', N'jane.smith@example.com'),
    (3, N'David Johnson', N'Hanoi', N'Vietnam', N'555555555', N'david.johnson@example.com');

SELECT *
FROM Customer
WHERE City = 'Hanoi';

SELECT *
FROM Customer
WHERE City = 'Ho Chi Minh City';

INSERT INTO CustomerAccount (AccountNumber, CustomerId, Balance, MinAccount)
VALUES
    ('NO01', 1, 1090.0, 100.0),
    ('NO02', 2, 2080.0, 200.0),
    ('NO03', 3, 3900.0, 300.0);

SELECT *
FROM CustomerAccount;

INSERT INTO CustomerTransaction (TransactionId, AccountNumber, TransactionDate, Amount, DepositorWithdraw)
VALUES
    (1, 'AC001', '2023-01-01', 500.0, N'Deposit'),
    (2, 'AC002', '2023-01-02', 1000.0, N'Withdrawal'),
    (3, 'AC003', '2023-01-03', 1500.0, N'Deposit');

SELECT *
FROM CustomerTransaction;

SELECT *
FROM Customer
WHERE City = 'Hanoi';

SELECT c.Name, ca.Phone, ca.Email, ca.AccountNumber, ca.Balance
FROM Customer c
JOIN CustomerAccount ca ON c.CustomerId = ca.CustomerId;

ALTER TABLE CustomerTransaction
ADD CONSTRAINT CHK_CustomerTransaction_Amount
CHECK (Amount > 0 AND Amount <= 1000000);

CREATE VIEW vCustomerTransactions
AS
SELECT c.Name, ct.AccountNumber, ct.TransactionDate, ct.Amount, ct.DepositorWithdraw
FROM Customer c
JOIN CustomerAccount ca ON c.CustomerId = ca.CustomerId
JOIN CustomerTransaction ct ON ca.AccountNumber = ct.AccountNumber;

ALTER TABLE CustomerAccount
DROP CONSTRAINT FK_CustomerAccount_Customer;

DROP TABLE Customer;