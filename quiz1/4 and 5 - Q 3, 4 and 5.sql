

/* ------------  Question 3   --------------- */

select sh.SalesPersonID, p.LastName, p.FirstName, e.EmailAddress,
       cast(max(sh.OrderDate) as date) MostRecentOrderDate
from Sales.SalesOrderHeader sh
join Person.Person p
on sh.SalesPersonID = p.BusinessEntityID
left join Person.EmailAddress e
on p.BusinessEntityID = e.BusinessEntityID
group by sh.SalesPersonID, p.LastName, p.FirstName, e.EmailAddress
order by sh.SalesPersonID;


/* ------------  Question 4   --------------- */

SELECT DISTINCT sh.CustomerID
FROM Sales.SalesOrderHeader sh
JOIN Sales.SalesOrderDetail sd
ON sh.SalesOrderID = sd.SalesOrderID
JOIN Production.Product p
ON sd.ProductID = p.ProductID
GROUP BY CustomerID
HAVING COUNT(DISTINCT p.Color) = 1
 AND sh.CustomerID IN
 (SELECT DISTINCT CustomerID
  FROM Sales.SalesOrderHeader sh
  JOIN Sales.SalesOrderDetail sd
  ON sh.SalesOrderID = sd.SalesOrderID
  JOIN Production.Product p
  ON sd.ProductID = p.ProductID
  WHERE Color = 'red')
ORDER BY sh.CustomerID;


/* ------------  Question 5   --------------- */

WITH Temp
   AS
   (SELECT MONTH(o.OrderDate) AS Mon, p.Color, SUM(od.OrderQty) AS Total, 
   RANK ( ) OVER ( PARTITION BY MONTH(o.OrderDate) ORDER BY SUM(od.OrderQty) DESC)  AS Pop
   FROM Production.Product p
   JOIN Sales.SalesOrderDetail od
   ON p.ProductID = od.ProductID
   JOIN Sales.SalesOrderHeader o
   ON od.SalesOrderID = o.SalesOrderID
   WHERE p.Color IS NOT NULL and YEAR(o.OrderDate) = 2006
   GROUP BY MONTH(o.OrderDate), p.Color)
   SELECT * FROM Temp
   WHERE Pop = 1
   ORDER BY Mon;


