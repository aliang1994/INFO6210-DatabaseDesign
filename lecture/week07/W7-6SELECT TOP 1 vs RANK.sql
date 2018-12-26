
/* Retrieve the customer(s) who have placed the most orders */
USE AdventureWorks2012;

SELECT TOP 1 CustomerID, COUNT(SalesOrderID) TotalOrder
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY TotalOrder DESC;

SELECT CustomerID, COUNT(SalesOrderID) TotalOrder
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY TotalOrder DESC;

SELECT * FROM
(SELECT CustomerID, COUNT(SalesOrderID) TotalOrder,
 RANK() OVER (ORDER BY COUNT(SalesOrderID) DESC) AS CustomerRank 
 FROM Sales.SalesOrderHeader
 GROUP BY CustomerID) temp
WHERE CustomerRank = 1; 

