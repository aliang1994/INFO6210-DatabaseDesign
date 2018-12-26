--W7-5 Lab3 Exercise b


USE AdventureWorks2008R2;


--Exercise 1

/*
SELECT ProductID, Name, ListPrice FROM Production.Product.
Use the CASE function to display "Expensive" if ListPrice > 3000
"Medium" if ListPrice > 1000
"Low" if ListPrice <= 1000.
ORDER the results DESC BY ListPrice.
*/

SELECT ProductID, Name, ListPrice,
	CASE 
		WHEN ListPrice > 3000 THEN 'Expensive'
		WHEN ListPrice <= 1000 THEN 'Low'
		ELSE 'Medium'
	END AS PriceLevel
FROM Production.Product
ORDER BY ListPrice DESC;
	




--Exercise 2

/*
SELECT SalesOrderID, CustomerID, TotalDue
FROM Sales.SalesOrderHeader
WHERE TotalDue > 10000
and RANK them with gaps in the desc order of TotalDue
*/

SELECT SalesOrderID, CustomerID, TotalDue, RANK() OVER (ORDER BY TotalDue DESC) as Rank
FROM Sales.SalesOrderHeader
WHERE TotalDue > 10000;





--Exercise 3

/*
SELECT SalesOrderID, CustomerID, TotalDue
FROM Sales.SalesOrderHeader
WHERE TotalDue > 10000
and RANK them with gaps in the desc order of TotalDue
also PARTITION BY CustomerID
*/


SELECT SalesOrderID, CustomerID, TotalDue, RANK() OVER (PARTITION BY CustomerID ORDER BY TotalDue DESC) as Rank
FROM Sales.SalesOrderHeader
WHERE TotalDue > 10000;




--Exercise 4

/*
SELECT SalesOrderID, CustomerID, TotalDue
FROM Sales.SalesOrderHeader
WHERE TotalDue > 10000
and RANK them with gaps in the desc order of TotalDue
also PARTITION BY CustomerID
Display only the highest total due amount for each customer.
Hints: For this exercise, we need to create a derived table
using a subquery. Then SELECT FROM the derived table.
*/

SELECT * FROM 
	(SELECT SalesOrderID, CustomerID, TotalDue, RANK() OVER (PARTITION BY CustomerID ORDER BY TotalDue DESC) as Rank
	FROM Sales.SalesOrderHeader
	WHERE TotalDue > 10000 ) AS T
WHERE T.Rank = 1;




--Exercise 5

/* List the product id, product name, and order date of each
product sold in 2008.
Tables needed: Production.Product
Sales.SalesOrderDetail
Sales.SalesOrderHeader
*/


SELECT p.ProductID, p.Name, sh.OrderDate 
FROM Production.Product p 
INNER JOIN Sales.SalesOrderDetail sd
ON p.ProductID = sd.ProductID
INNER JOIN Sales.SalesOrderHeader sh
ON sd.SalesOrderID = sh.SalesOrderID
WHERE DATEPART(YEAR, sh.OrderDate) = 2008;





--Exercise 6
/* What is the name and average rating for the product with ProductID = 937? */

SELECT pp.ProductID, pp.Name, avg(pr.Rating) averRating
FROM Production.Product pp
INNER JOIN Production.ProductReview pr 
ON pp.ProductID = pr.ProductID
WHERE pp.ProductID = 937
GROUP BY pp.ProductID, pp.Name




--Exercise 7
/* Use the SubTotal value in SalesOrderHeader to calculate total value. 
 What is the total value of products sold to an address in 'Seattle'? */

select ad.city, sum(SubTotal) as total_value
from Sales.SalesOrderHeader soh
join Person.Address ad on soh.ShipToAddressID = ad.AddressID
where ad.city = 'Seattle'
group by ad.city;

