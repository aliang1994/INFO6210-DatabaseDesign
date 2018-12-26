
USE Northwind;

/*
CTE Exercise 1
  1. Use a CTE to gather the following information:
	* CategoryID
    * CategoryName
    * Average price of all Products in that category
	HINT: You will need to incorporate either a join or correlated
	      subquery in the CTE itself to get the info.
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

-- Solution using a join in the CTE.
WITH Cat AS
   (SELECT C.CategoryID, C.CategoryName, AVG(P.unitprice) AS CatAvgPrice
    FROM categories C 
    INNER JOIN products P ON C.categoryID = P.categoryid
    GROUP BY C.CategoryID, C.CategoryName)
SELECT
	  P.productid, P.productname, P.categoryid, P.unitprice, Cat.CategoryName, Cat.CatAvgPrice, (P.unitprice - Cat.CatAvgPrice) AS CatPriceDiff
FROM products P 
INNER JOIN Cat ON P.categoryid = Cat.categoryid;

-- Solution using a correlated subquery in the CTE.	
WITH Cat AS
   (SELECT CategoryID, CategoryName,
           (SELECT AVG(P.unitprice) FROM Products p WHERE p.CategoryID = C.CategoryID) AS CatAvgPrice
    FROM categories C)

SELECT
	  P.productid
	  ,P.productname
	  ,P.categoryid
	  ,P.unitprice
	  ,Cat.CategoryName
	  ,Cat.CatAvgPrice
	  ,(P.unitprice - Cat.CatAvgPrice) AS CatPriceDiff
FROM products P 
INNER JOIN Cat
      ON P.categoryid = Cat.categoryid;	
