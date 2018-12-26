--Lab 3 Examples

USE AdventureWorks2008R2;


--CASE function allows conditional processing 

SELECT ProductID, Name, ListPrice, 
	(SELECT ROUND(AVG(ListPrice), 2) FROM Production.Product) AS AP, 
	CASE
		WHEN ListPrice - (SELECT ROUND(AVG(ListPrice), 2) FROM Production.Product) = 0
		THEN 'Average Price'
		WHEN ListPrice - (SELECT ROUND(AVG(ListPrice), 2) FROM Production.Product) < 0
		THEN 'Below Average Price'
		ELSE 'Above Average Price' END 
	AS PriceComparison
FROM Production.Product
ORDER BY ListPrice DESC;


--RANK: does not always return consecutive integers; creating gaps.
--RANK function: without PARTITION BY

SELECT
	RANK() OVER (ORDER BY OrderQty DESC) as [Rank],
	SalesOrderID, ProductID, UnitPrice, OrderQty
FROM Sales.SalesOrderDetail
WHERE UnitPrice >75;

--RANK function: with PARTITION BY

SELECT
	RANK() OVER (PARTITION BY ProductID ORDER BY OrderQty DESC) as [Rank],
	SalesOrderID, ProductID, UnitPrice, OrderQty
FROM Sales.SalesOrderDetail
WHERE UnitPrice >75;


--Dense Rank: numbers returned by the DENSE_RANK function do not have gaps and always have consecutive ranks.
SELECT 
	i.ProductID, p.Name, i.LocationID, i.Quantity,
	DENSE_RANK() OVER (PARTITION BY i.LocationID ORDER BY i.Quantity DESC) AS Rank
FROM Production.ProductInventory AS i
INNER JOIN Production.Product AS p
ON i.ProductID = p.ProductID
WHERE i.LocationID BETWEEN 3 AND 4
ORDER BY i.LocationID;

