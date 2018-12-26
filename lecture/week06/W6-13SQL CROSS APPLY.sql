
/* Use CROSS APPLY with Table-Valued Function and Correlated Subquery */

-- Create a demo database

CREATE DATABASE DemoAPPLY;

USE DemoAPPLY;

-- Create a table-valued function

CREATE FUNCTION uf_GetLastOrdersForCustomerWithItemCount 
(@CustomerID int, @NumberOfOrders int)
RETURNS TABLE
AS
RETURN (SELECT TOP(@NumberOfOrders)
               CustomerID,
               H.SalesOrderID,
               OrderDate, COUNT(D.SalesOrderID) AS ItemCount
        FROM AdventureWorks2008R2.Sales.SalesOrderHeader H
		JOIN AdventureWorks2008R2.Sales.SalesOrderDetail D
		ON H.SalesOrderID = D.SalesOrderID 
        WHERE CustomerID = @CustomerID
		GROUP BY H.SalesOrderID, OrderDate, CustomerID
        ORDER BY OrderDate DESC, H.SalesOrderID DESC
        );
GO

/* Must use CROSS APPLY to join a table with a Table-Valued Function.
   THE INNER JOIN will not work below. */

-- INNER JOIN doesn't work: C out of bound

SELECT
	  C.CustomerID, C.PersonID, P.FirstName, P.LastName,
	  UF.SalesOrderID, UF.OrderDate, UF.ItemCount
FROM AdventureWorks2008R2.Sales.Customer C 
JOIN AdventureWorks2008R2.Person.Person P
ON C.PersonID = P.[BusinessEntityID]
JOIN dbo.uf_GetLastOrdersForCustomerWithItemCount(C.CustomerID,2) UF
ON C.CustomerID = UF.CustomerID
WHERE C.CustomerID = 17288
ORDER BY UF.SalesOrderID;

-- CROSS APPLY does work

SELECT
	  C.CustomerID, C.PersonID, P.FirstName, P.LastName, UF.SalesOrderID, UF.OrderDate, UF.ItemCount
FROM AdventureWorks2008R2.Sales.Customer C 
JOIN AdventureWorks2008R2.Person.Person P
ON C.PersonID = P.[BusinessEntityID]
CROSS APPLY 
dbo.uf_GetLastOrdersForCustomerWithItemCount(C.CustomerID,2) UF
WHERE C.CustomerID = 17288
ORDER BY UF.SalesOrderID;

/* Must use CROSS APPLY to join a table with a correlated subquery.
   THE INNER JOIN will not work below. */

-- INNER JOIN doesn't work
--"The multi-part identifier "C.CustomerID" could not be bound."

SELECT
	  C.CustomerID, C.PersonID, P.FirstName, P.LastName, O.SalesOrderID, O.OrderDate,
	  (SELECT COUNT(SalesOrderID)
	  FROM AdventureWorks2008R2.Sales.SalesOrderDetail OD
	  WHERE OD.SalesOrderID = O.SalesOrderID) 
	  AS ItemCount  
FROM AdventureWorks2008R2.Sales.Customer C  
JOIN AdventureWorks2008R2.Person.Person P
ON C.PersonID = P.BusinessEntityID
JOIN (SELECT * FROM AdventureWorks2008R2.Sales.SalesOrderHeader H WHERE H.CustomerID = C.CustomerID) O
on c.customerid = o.customerid
WHERE C.CustomerID = 17288
ORDER BY O.SalesOrderID;

-- CROSS APPLY does work

SELECT
	  C.CustomerID, C.PersonID, P.FirstName, P.LastName, O.SalesOrderID, O.OrderDate,
	  (SELECT COUNT(SalesOrderID) 
	  FROM AdventureWorks2008R2.Sales.SalesOrderDetail OD 
	  WHERE OD.SalesOrderID = O.SalesOrderID) 
	  AS ItemCount  
FROM AdventureWorks2008R2.Sales.Customer C  
JOIN AdventureWorks2008R2.Person.Person P
ON C.PersonID = P.BusinessEntityID
CROSS APPLY (SELECT * FROM AdventureWorks2008R2.Sales.SalesOrderHeader H WHERE H.CustomerID = C.CustomerID) O
WHERE C.CustomerID = 17288
ORDER BY O.SalesOrderID;

-- Housekeeping

USE MASTER;
DROP DATABASE DemoAPPLY;

