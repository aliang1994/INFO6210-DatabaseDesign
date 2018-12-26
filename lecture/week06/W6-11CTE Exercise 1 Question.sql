
USE Northwind;

/*
CTE Exercise 1
  1. Use a CTE to gather the following information:
	* CategoryID
    * CategoryName
    * Average price of all Products in that category
  2. Join the CTE with Products in the SELECT statement below to
		include the category name and average price in the SELECT
		statement.
  3. Add an additional expression in the SELECT statement to show
		the difference between the Product Price (UnitPrice) and the
        category average price.
*/

SELECT ProductID
	  ,ProductName
	  ,CategoryID
	  ,UnitPrice
FROM Products;
----------------------------------------------------------------------------------
WITH cte AS
(SELECT C.CategoryID, C.CategoryName, AVG(P.UnitPrice) aver 
FROM Categories C
INNER JOIN Products P ON P.CategoryID = C.CategoryID
GROUP BY C.CategoryID, C.CategoryName)

SELECT
	  P.productid, P.productname, P.categoryid, P.unitprice, cte.CategoryName, cte.aver, (P.unitprice - cte.aver) AS PriceDiff
FROM products P 
INNER JOIN cte ON P.categoryid = cte.categoryid;
