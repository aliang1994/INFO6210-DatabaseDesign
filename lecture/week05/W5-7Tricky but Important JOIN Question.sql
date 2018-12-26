
-- Find out what state an order is related to for TerritoryID 1

/* Territories are at a higher level than states in the geographical hierarchy. */

SELECT Name
FROM Person.StateProvince
WHERE TerritoryID = 1
ORDER BY Name;

/* Can't JOIN on TerritoryID if we want to determine the state. */

/* The JOIN below creates multiple rows for every order, each containing
   a different state that is in TerritoryID 1 for that order. */

/* Every state in TerritoryID 1 will return the same order count. */

SELECT c.Name, COUNT(DISTINCT SalesOrderID)
FROM Sales.SalesOrderHeader a
INNER JOIN Sales.SalesTerritory b
     ON a.TerritoryID = b.TerritoryID
INNER JOIN Person.StateProvince c 
     ON b.TerritoryID = c.TerritoryID
WHERE c.Name IN (SELECT Name FROM Person.StateProvince WHERE TerritoryID = 1)
GROUP BY c.Name
ORDER BY c.Name;

/* The correct way to identify which state an order was related to
   is using either BillToAddressID or ShipToAddressId,
   since these can be uniquely tied to a single state. */

/* Use BillToAddressID */

SELECT c.Name, COUNT(DISTINCT SalesOrderID)
FROM Sales.SalesOrderHeader a
INNER JOIN Person.Address b
     ON a.BillToAddressID = b.AddressID
INNER JOIN Person.StateProvince c
     ON b.StateProvinceID = c.StateProvinceID
WHERE c.Name IN (SELECT Name FROM Person.StateProvince WHERE TerritoryID = 1)
GROUP BY c.Name
ORDER BY c.Name;

/* Use ShipToAddressId */

SELECT c.Name, COUNT(DISTINCT SalesOrderID)
FROM Sales.SalesOrderHeader a
INNER JOIN Person.Address b
     ON a.ShipToAddressID = b.AddressID
INNER JOIN Person.StateProvince c
     ON b.StateProvinceID = c.StateProvinceID
WHERE c.Name IN (SELECT Name FROM Person.StateProvince WHERE TerritoryID = 1)
GROUP BY c.Name
ORDER BY c.Name;
