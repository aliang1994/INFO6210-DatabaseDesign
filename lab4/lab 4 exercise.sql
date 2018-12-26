--Lab 4 Exercise

--Create Database
CREATE DATABASE LIANG_WENQING_TEST;

USE LIANG_WENQING_TEST;

CREATE TABLE dbo.Customers (
	CustomerID varchar(5) NOT NULL PRIMARY KEY ,
	Name varchar(40) NOT NULL
);

CREATE TABLE dbo.Orders (
	OrderID int IDENTITY NOT NULL PRIMARY KEY,
	CustomerID varchar(5) NOT NULL
	REFERENCES Customers(CustomerID),
	OrderDate datetime DEFAULT Current_Timestamp
);

CREATE TABLE dbo.Products (
	ProductID int IDENTITY NOT NULL PRIMARY KEY,
	Name varchar(40) NOT NULL,
	UnitPrice money NOT NULL
);

CREATE TABLE dbo.OrderItems (
	OrderID int NOT NULL
	REFERENCES dbo.Orders(OrderID),
	ProductID int NOT NULL
	REFERENCES dbo.Products(ProductID),
	UnitPrice money NOT NULL,
	Quantity int NOT NULL
	CONSTRAINT PKOrderItem PRIMARY KEY CLUSTERED
	(OrderID, ProductID)
);


--Insert data into database

INSERT dbo.Customers
VALUES ('ABC', 'Bob''s Pretty Good Garage');

INSERT dbo.Orders (CustomerID)
VALUES ('ABC');

INSERT dbo.Products
VALUES ('Widget', 5.55),
('Thingamajig', 8.88);

INSERT dbo.OrderItems
VALUES (1, 1, 5.55, 3);

--sql variables: counter
DECLARE @counter INT
SET @counter = 0
WHILE @counter <> 5
BEGIN
SET @counter = @counter + 1
PRINT 'The counter : ' + CAST(@counter AS CHAR)
END;

--sql variables: nested while loop
CREATE TABLE PART (Part_Id int, Category_Id int,
Description varchar(50));
-- The statements highlighted in yellow must be executed together
-- Declare SQL variables.
DECLARE @Part_Id int; DECLARE @Category_Id int; DECLARE @Desc varchar(50);
-- Initilize SQL variables.
SET @Part_Id = 0; SET @Category_Id = 0;
-- Populate the test table.
WHILE @Part_Id < 10 
	BEGIN 
	SET @Part_Id = @Part_Id + 1; 
	WHILE @Category_Id < 3 
		BEGIN 
		SET @Category_Id = @Category_Id + 1; 
		SET @Desc = 'Part_Id is ' + cast(@Part_Id as char(1)) + ' Category_Id ' + cast(@Category_Id as char(1)); 
		INSERT INTO PART VALUES (@Part_Id, @Category_Id, @Desc ); 
		END; 
	SET @Category_Id = 0; 
	END;


SELECT * FROM PART;
DROP TABLE PART;


--sql view
USE AdventureWorks2008R2;

CREATE VIEW vwEmployeeContactInfo AS 
SELECT e.[BusinessEntityID] as [ContactID], FirstName, MiddleName, LastName, JobTitle
FROM Person.Person c
INNER JOIN HumanResources.Employee e
ON c.BusinessEntityID = e.BusinessEntityID;

SELECT * FROM vwEmployeeContactInfo;

EXEC sp_helptext vwEmployeeContactInfo;

DROP VIEW vwEmployeeContactInfo;


CREATE VIEW vwEmployeeContactInfo 
WITH ENCRYPTION, SCHEMABINDING AS 
SELECT e.[BusinessEntityID] as [ContactID], FirstName, MiddleName, LastName, JobTitle
FROM Person.Person c
INNER JOIN HumanResources.Employee e
ON c.BusinessEntityID = e.BusinessEntityID;

ALTER VIEW vwEmployeeContactInfo 
WITH ENCRYPTION AS 
SELECT e.[BusinessEntityID] as [ContactID], FirstName, MiddleName, LastName, JobTitle
FROM Person.Person c
INNER JOIN HumanResources.Employee e
ON c.BusinessEntityID = e.BusinessEntityID;