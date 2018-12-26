--Lab 3 Questions

USE AdventureWorks2008R2;
--3-1

SELECT 
	CustomerID, 
	ROUND(SUM(TotalDue), 2) [Total Purchase], 
	COUNT(SalesOrderid) [Total # of Orders],
	COUNT(CustomerID) [Customer Frequency],
	CASE
		WHEN COUNT(CustomerID) = 1 THEN 'One Time'
		WHEN COUNT(CustomerID) >= 2 AND COUNT(CustomerID) <= 5 THEN 'Regular'
		WHEN COUNT(CustomerID) > 5 THEN 'Loyal'
		END
	AS Loyalty
FROM Sales.SalesOrderHeader
WHERE DATEPART(year, OrderDate) = 2007
GROUP BY CustomerID;



--3-2

SELECT 
	CustomerID, TerritoryID, 
	ROUND(SUM(TotalDue), 2) [Total Purchase], 
	COUNT(SalesOrderid) [Total # of Orders],
	RANK() OVER (PARTITION BY TerritoryID ORDER BY ROUND(SUM(TotalDue), 2) DESC) as [Total Purchase Rank]
FROM Sales.SalesOrderHeader
WHERE DATEPART(year, OrderDate) = 2007
GROUP BY CustomerID, TerritoryID;



--3-3

SELECT T.ProductID, T.Name, T.OrderDate, T.totalQty FROM (
	SELECT 
	    sd.ProductID, p.Name, sh.OrderDate, SUM(OrderQty) totalQty,
		RANK() OVER (PARTITION BY sh.OrderDate ORDER BY SUM(OrderQty) DESC) dailyrank
	FROM Sales.SalesOrderHeader AS sh
	INNER JOIN Sales.SalesOrderDetail AS sd 
	ON sh.SalesOrderID = sd.SalesOrderID
	INNER JOIN Production.Product AS p 
	ON sd.ProductID = p.ProductID
	GROUP BY sd.ProductID, sh.OrderDate, p.Name
) AS T
WHERE T.dailyrank = 1
ORDER BY T.OrderDate;



--3-4

SELECT sh.TerritoryID, st.Name, SUM(sh.TotalDue) AS TerrytoryTotal
FROM Sales.SalesOrderHeader AS sh
INNER JOIN Sales.SalesTerritory AS st 
ON sh.TerritoryID = st.TerritoryID
GROUP BY sh.TerritoryID, st.Name
ORDER BY TerrytoryTotal DESC;



--3-5
SELECT * FROM (
	SELECT 
		DENSE_RANK() OVER (ORDER BY sp.Bonus DESC) bonusrank,
		p.LastName, p.FirstName, sp.Bonus, sp.Bonus/(SUM(sp.Bonus) OVER()) as Percentage
	FROM Sales.SalesPerson AS sp 
	INNER JOIN Person.Person AS p 
	ON p.BusinessEntityID = sp.BusinessEntityID
	GROUP BY p.LastName, p.FirstName, sp.Bonus
) AS T
WHERE T.bonusrank = 1
ORDER BY T.Percentage;
