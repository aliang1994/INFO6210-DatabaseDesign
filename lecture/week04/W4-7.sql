--Lecture Slides W4-7
USE AdventureWorks2008R2;


SELECT TerritoryID, Name, CountryRegionCode
FROM Sales.SalesTerritory;


SELECT TerritoryID, Name, CountryRegionCode
FROM Sales.SalesTerritory
WHERE CountryRegionCode='US';


--Order By
SELECT TerritoryID, Name, CountryRegionCode
FROM Sales.SalesTerritory
WHERE CountryRegionCode='US'
ORDER BY Name;


--Inner Join
SELECT T.TerritoryID, T.Name, S.BusinessEntityID AS [Sales Person ID]
FROM Sales.SalesTerritory T
INNER JOIN Sales.SalesPerson S
ON T.TerritoryID=S.TerritoryID;


--Aggregation Function: Count
SELECT T.TerritoryID, T.Name, Count(S.BusinessEntityID) AS [Total Sales People]
FROM Sales.SalesTerritory T
INNER JOIN Sales.SalesPerson S
ON T.TerritoryID=S.TerritoryID
GROUP BY T.TerritoryID, T.Name;


--HAVING: on aggreation functions only
SELECT T.TerritoryID,T.Name, Count(S.BusinessEntityID) AS [Total Sales People]
FROM Sales.SalesTerritory T
INNER JOIN Sales.SalesPerson S
ON T.TerritoryID=S.TerritoryID
GROUP BY T.TerritoryID, T.Name
HAVING Count(S.BusinessEntityID)>1;


SELECT T.TerritoryID,T.Name, Count(S.BusinessEntityID) AS [Total Sales People]
FROM Sales.SalesTerritory T
INNER JOIN Sales.SalesPerson S
ON T.TerritoryID=S.TerritoryID
WHERE T.CountryRegionCode='US'
GROUP BY T.TerritoryID, T.Name
HAVING Count(S.BusinessEntityID)>1;


SELECT T.TerritoryID,T.Name, Count(S.BusinessEntityID) AS [Total Sales People]
FROM Sales.SalesTerritory T
INNER JOIN Sales.SalesPerson S
ON T.TerritoryID=S.TerritoryID
WHERE T.CountryRegionCode='US'
GROUP BY T.TerritoryID, T.Name
HAVING Count(S.BusinessEntityID)>1
ORDER BY Count(S.BusinessEntityID);
