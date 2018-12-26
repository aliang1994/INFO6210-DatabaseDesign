
-- GROUP BY with ROLLUP and CUBE options.

USE AdventureWorks2012;

-- Demo SELECT without ROLLUP or CUBE option.

SELECT ProductID, SpecialOfferID, SUM(OrderQty) AS [Total Sold]
FROM Sales.SalesOrderDetail
GROUP BY ProductID, SpecialOfferID
ORDER BY ProductID, SpecialOfferID;

-- Demo above with use of ROLLUP option
-- No total rows are produced for the second field listed in the GROUP BY clause. 
SELECT ProductID, SpecialOfferID, SUM(OrderQty) AS [Total Sold]
FROM Sales.SalesOrderDetail
GROUP BY ProductID, SpecialOfferID WITH ROLLUP
ORDER BY ProductID, SpecialOfferID;

-- Demo above with use of CUBE option
-- Total rows are produced for every combination of fields listed in the GROUP BY clause. 
SELECT ProductID, SpecialOfferID, SUM(OrderQty) AS [Total Sold]
FROM Sales.SalesOrderDetail
GROUP BY ProductID, SpecialOfferID WITH CUBE
ORDER BY ProductID, SpecialOfferID;

