--1.
SELECT CustomerID, ROUND(SUM(TotalDue), 2) [Total Purchase],
COUNT(SalesOrderid) [Total # of Orders],
	CASE
		 WHEN COUNT(SalesOrderid) = 1
			THEN 'One Time'
		 WHEN COUNT(SalesOrderid) > 5
			THEN 'Loyal'
		 ELSE 'Regular'
	END AS [Order Frequency]
FROM Sales.SalesOrderHeader
WHERE DATEPART(year, OrderDate) = 2007
GROUP BY CustomerID;

--2.
SELECT 
RANK() OVER (PARTITION BY TerritoryID ORDER BY ROUND(SUM(TotalDue), 2) DESC) AS [Rank]
	, CustomerID, TerritoryID, ROUND(SUM(TotalDue), 2) [Total Purchase]
	, COUNT(SalesOrderid) [Total # of Orders]
FROM Sales.SalesOrderHeader
WHERE DATEPART(year, OrderDate) = 2007
GROUP BY CustomerID, TerritoryID

--3.
select * from
(select CAST(a.OrderDate as DATE) AS OrderDate,
b.ProductID, c.Name, sum(b.OrderQty) as total,
RANK() OVER
(PARTITION BY a.OrderDate ORDER BY sum(b.OrderQty) DESC)
AS Rank
from [Sales].[SalesOrderHeader] a
join [Sales].[SalesOrderDetail] b
on a.SalesOrderID = b.SalesOrderID
join [Production].[Product] c
on c.ProductID = b.ProductID
group by a.OrderDate, b.ProductID, c.Name
) temp
where rank = 1
order by OrderDate;

--4.
select t.TerritoryID, t.Name,
round(sum(TotalDue), 2) TotalSale
from sales.Customer c
join sales.SalesTerritory t
on c.TerritoryID = t.TerritoryID
join Sales.SalesOrderHeader s
on s.CustomerID = c.CustomerID
group by t.TerritoryID, t.Name
order by sum(TotalDue) desc;

--5.
with temp as
(select max(bonus) HighestBonus, max(bonus)/sum(bonus)*100 Percentage
from Sales.SalesPerson)
select p.LastName, p.FirstName, t.HighestBonus, t.Percentage
from Person.Person p
join Sales.SalesPerson sp
on p.BusinessEntityID = sp.BusinessEntityID
cross join temp t
where bonus = t.HighestBonus;