
-- Use Common Table Expressions (CTEs) to query multiple data sources.

USE AdventureWorks2008R2;

-- Use a subquery. 

SELECT * FROM (SELECT ProductID, Name, ListPrice FROM Production.Product) Prod;

-- Use a CTE. Same results as above.

WITH Prod AS 
	(SELECT ProductID, Name, ListPrice FROM Production.Product)
SELECT * FROM Prod;

-- Use subqueries.

SELECT
	  Name, ListPrice
	  ,(SELECT AVG(ListPrice) FROM Production.Product ) AS AvgPrice
	  ,(ListPrice - (SELECT AVG(ListPrice) FROM Production.Product)) AS PriceDiff
FROM Production.Product
WHERE ListPrice > (SELECT AVG(ListPrice) FROM Production.Product);

/* Use CTE to perform subquery once and apply the result in multiple places
   of SELECT statement in a much more efficient manner. */

WITH AP AS 
	(SELECT AVG(ListPrice) AS AvgPrice FROM Production.Product)
SELECT
	  Name, ListPrice, AP.AvgPrice,
	  (ListPrice - AP.AvgPrice) AS PriceDiff
FROM Production.Product CROSS JOIN AP
WHERE ListPrice > AP.AvgPrice;

/* Provide order information on orders with 5 or more products ordered.
   CTE creates a much smaller virtual table before joining
   with SalesOrderHeader table in SELECT statement. Join operation performs much better. */

WITH OrdDet AS
	(SELECT SalesOrderID, COUNT(ProductID) [Line Item Count]
	 FROM Sales.SalesOrderDetail
	 GROUP BY SalesOrderid
	 HAVING COUNT(ProductID) > 4)
SELECT o.SalesOrderID, o.OrderDate, o.CustomerID, od.[Line Item Count]
FROM Sales.SalesOrderHeader o INNER JOIN OrdDet od
	ON o.SalesOrderID = od.SalesOrderID;

