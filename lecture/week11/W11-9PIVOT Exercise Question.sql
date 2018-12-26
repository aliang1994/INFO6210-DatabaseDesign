PIVOT Exercise Question
Convert the following SQL query into a PIVOT query.
USE AdventureWorks2012;

-- SQL statement to create the vertical format


SELECT TerritoryID, SalesPersonID, COUNT(SalesOrderID) AS [Order Count]
FROM Sales.SalesOrderHeader
WHERE SalesPersonID IN (280, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294, 295)
GROUP BY TerritoryID, SalesPersonID
ORDER BY TerritoryID, SalesPersonID;


