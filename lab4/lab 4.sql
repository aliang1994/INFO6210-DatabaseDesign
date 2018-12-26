--Lab 4 
--Wenqing Liang
--001873144



--Part A

--step 1: create database

CREATE DATABASE LIANG_WENQING_TEST;
GO
USE LIANG_WENQING_TEST;


--step 2: 20 queries

CREATE SCHEMA LAB4;

CREATE TABLE LAB4.Customers (
	CustomerID varchar(5),
	Name varchar(40)
);
GO
ALTER TABLE LAB4.Customers ALTER COLUMN CustomerID varchar(5) NOT NULL;
GO
ALTER TABLE LAB4.Customers ADD CONSTRAINT pk2 PRIMARY KEY (CustomerID);
GO
ALTER TABLE LAB4.Customers ALTER COLUMN Name varchar(40) NOT NULL;
GO
INSERT LAB4.Customers VALUES ('aaa', 'customer1');
GO
INSERT LAB4.Customers VALUES ('aab', 'customer2');
GO
INSERT LAB4.Customers VALUES ('aba', 'customer3');
GO
INSERT LAB4.Customers VALUES ('baa', 'customer4');
GO
INSERT LAB4.Customers VALUES ('bab', 'customer5');
GO
CREATE TABLE LAB4.Orders (
	OrderID int IDENTITY,
	CustomerID varchar(40),
	OrderDate datetime DEFAULT Current_Timestamp
);
GO
ALTER TABLE LAB4.Orders ALTER COLUMN OrderID int NOT NULL; 
GO
ALTER TABLE LAB4.Orders ALTER COLUMN CustomerID varchar(5) not null; 
GO
ALTER TABLE LAB4.Orders ADD CONSTRAINT pk1 PRIMARY KEY (OrderID);
GO
ALTER TABLE LAB4.Orders ADD CONSTRAINT fk1 FOREIGN KEY (CustomerID) REFERENCES LAB4.Customers(CustomerID);
GO
INSERT LAB4.Orders (CustomerID) VALUES ('aaa');
GO
INSERT LAB4.Orders (CustomerID) VALUES ('aba');
GO
INSERT LAB4.Orders (CustomerID) VALUES ('baa');

DROP TABLE LAB4.Orders;

DROP TABLE LAB4.Customers;



--step 3: implement ERD

CREATE TABLE LAB4.TargetCustomers (
	TargetID int IDENTITY NOT NULL PRIMARY KEY,
	FirstName varchar(40) NOT NULL,
	LastName varchar(40) NOT NULL,
	Address varchar(40) NOT NULL,
	City varchar(40) NOT NULL,
	State varchar(40) NOT NULL,
	ZipCode int NOT NULL
);

CREATE TABLE LAB4.MailingLists (
	MailingListID int IDENTITY NOT NULL PRIMARY KEY,
	MailingList varchar(40) NOT NULL
);

CREATE TABLE LAB4.TargetMailingLists (
	TargetID int NOT NULL REFERENCES LAB4.TargetCustomers(TargetID),
	MailingListID int NOT NULL REFERENCES LAB4.MailingLists(MailingListID),
	CONSTRAINT PKTargetMailingLists PRIMARY KEY CLUSTERED (TargetID, MailingListID)
);




--PART B

USE AdventureWorks2008R2;


WITH temp AS
   (SELECT DISTINCT 
	    CustomerID, 
	    SalesPersonID,
	    ISNULL(CAST(SalesPersonID AS varchar(20)), '') idNEW
	FROM Sales.SalesOrderHeader) 
	
SELECT DISTINCT t2.CustomerID, STUFF(
	(SELECT  ', '+RTRIM(CAST(idNEW as char))  
	FROM temp t1 
	WHERE t1.CustomerID = t2.CustomerID 
	FOR XML PATH('')) , 1, 2, '') AS listSalesPersonID
FROM temp t2
ORDER BY CustomerID DESC;




--PART C

WITH Parts (AssemblyID, ComponentID, PerAssemblyQty, EndDate, ComponentLevel) AS (
    -- Top-level compoments
	SELECT b.ProductAssemblyID, b.ComponentID, b.PerAssemblyQty,
        b.EndDate, 0 AS ComponentLevel
    FROM Production.BillOfMaterials AS b
    WHERE b.ProductAssemblyID = 992
          AND b.EndDate IS NULL

    UNION ALL

	-- All other sub-compoments
    SELECT bom.ProductAssemblyID, bom.ComponentID, p.PerAssemblyQty,
        bom.EndDate, ComponentLevel + 1
    FROM Production.BillOfMaterials AS bom 
        INNER JOIN Parts AS p
        ON bom.ProductAssemblyID = p.ComponentID
        AND bom.EndDate IS NULL
)
SELECT SUM(temp.ListPrice) AS TotalCost FROM (
	SELECT AssemblyID, ComponentID, Name, PerAssemblyQty, ListPrice, ComponentLevel
	FROM Parts AS p
	    INNER JOIN Production.Product AS pr
	    ON p.ComponentID = pr.ProductID
	WHERE ComponentLevel = 0 OR ComponentLevel = 1
	/*ORDER BY ComponentLevel, AssemblyID, ComponentID*/
)  AS temp;






