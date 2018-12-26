--INFO 6250 Quiz1
--Wenqing Liang 001873144
--Set "NUID Second Last Digit 4 or 5"



--Question 1
/*
 * We need to make sure that the relationship between CheckOut-Customer, CheckOut-Item is non-identifying, 
 * which means that a CheckOut can be made without Customer or without Item.
 */

--Question 2: See PDF file attached


USE AdventureWorks2008R2;

--Question 3

Select Distinct T.SalesPersonID, T.FirstName, T.LastName, T.EmailAddress,  T.OrderDateOnly
From (
	SELECT sh.SalesPersonID, p.FirstName, p.LastName, e.EmailAddress, CAST(sh.OrderDate as DATE) OrderDateOnly, 
	RANK() OVER (ORDER BY CAST(sh.OrderDate as DATE) DESC) daterank
	FROM Sales.SalesOrderHeader sh
	INNER JOIN Person.Person p 
	ON sh.SalesPersonID = p.BusinessEntityID
	INNER JOIN Person.EmailAddress e 
	ON p.BusinessEntityID = e.BusinessEntityID
	) as T 
WHERE T.daterank=1
ORDER BY T.SalesPersonID;


--Question 4

SELECT DISTINCT sh.CustomerID, sd.ProductID, p.Color
FROM Sales.SalesOrderHeader sh
INNER JOIN Sales.SalesOrderDetail sd 
ON sh.SalesOrderID = sd.SalesOrderID
INNER JOIN Production.Product p 
ON P.ProductID = sd.ProductID
WHERE p.Color = 'Red' ;


--Question 5
SELECT T2.Color AS MostPopularColor, T2.sumColorQty, T2.OrderMonth
FROM (
	SELECT T.Color, SUM(T.totalQty) sumColorQty, MONTH(T.OrderDate) OrderMonth,
	RANK() OVER (PARTITION BY MONTH(T.OrderDate) ORDER BY SUM(T.totalQty) DESC) colorrank
	FROM (
		SELECT 
		    sd.ProductID, p.Color, sh.OrderDate, SUM(OrderQty) totalQty
		FROM Sales.SalesOrderHeader AS sh
		INNER JOIN Sales.SalesOrderDetail AS sd 
		ON sh.SalesOrderID = sd.SalesOrderID
		INNER JOIN Production.Product AS p 
		ON sd.ProductID = p.ProductID
		WHERE DATEPART(YEAR, sh.OrderDate) = 2006
		GROUP BY sd.ProductID, sh.OrderDate, p.Color
	) AS T
	GROUP BY T.Color, MONTH(T.OrderDate) 
) AS T2
WHERE T2.colorrank = 1
ORDER BY T2.OrderMonth;