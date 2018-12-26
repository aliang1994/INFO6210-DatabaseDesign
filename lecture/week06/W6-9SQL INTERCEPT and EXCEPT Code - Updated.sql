
-- SQL INTERSECT and EXCEPT

-- Set the Database Context
USE Northwind;

-- Which countries are common to both suppliers and customers?
-- Below are 3 different queries to accomplish the same result.

-- Uses INTERSECT
SELECT country FROM suppliers
INTERSECT
SELECT country FROM customers;

-- Uses IN and a subquery
SELECT DISTINCT country 
FROM suppliers
WHERE country IN (SELECT DISTINCT country FROM customers);

-- Uses INNER JOIN
SELECT DISTINCT suppliers.country 
FROM suppliers INNER JOIN customers
	ON suppliers.country = customers.country;

-----------------------------------------------------------

-- Which products have never been sold before?
-- Below are 3 different queries to accomplish the same result

-- Set the Database Context
USE AdventureWorks2008R2;

-- Uses EXCEPT
SELECT ProductID FROM Production.Product
EXCEPT
SELECT ProductID FROM Sales.SalesOrderDetail;

-- Uses IN and a subquery
SELECT DISTINCT ProductID 
FROM Production.Product
WHERE ProductID NOT IN (SELECT DISTINCT ProductID FROM Sales.SalesOrderDetail);

-- Uses LEFT JOIN
SELECT DISTINCT P.ProductID 
FROM Production.Product P
LEFT JOIN Sales.SalesOrderDetail S
ON P.ProductID = S.ProductID
WHERE S.ProductID IS NULL;

----------------------------------------------------------

-- How to further process results produced by EXCEPT

-- List the product id and name for products that have never been sold before

SELECT Temp.ProductID, P.Name 
FROM Production.Product P
JOIN  (SELECT ProductID FROM Production.Product
       EXCEPT
       SELECT ProductID FROM Sales.SalesOrderDetail) Temp
ON Temp.ProductID = P.ProductID
ORDER BY Temp.ProductID;

WITH Temp
AS
(SELECT ProductID FROM Production.Product
 EXCEPT
 SELECT ProductID FROM Sales.SalesOrderDetail)
SELECT T.ProductID, P.Name 
FROM Temp T
JOIN Production.Product P
ON T.ProductID = P.ProductID
ORDER BY T.ProductID;
