
USE Northwind;

/*
CTE Exercise 2
  Retrieve the same results as CTE Exericse 1 using two CTEs:
  1.  One CTE is the SELECT statement below.
  2.  Second CTE is the CTE used in CTE Exercise 1 (choose one of them in the solution).
  3.  Join the CTEs in a SELECT statement and return the same information
	  as the solution for CTE Exercise 1.
*/

SELECT ProductID
	  ,ProductName
	  ,CategoryID
	  ,UnitPrice
FROM Products;
----------------------------------------------------------------------------------

-- Solution using multiple CTEs.
WITH 
	Cat AS
	   (SELECT C.CategoryID
			   ,C.CategoryName
			   ,AVG(P.unitprice) AS CatAvgPrice
		FROM categories C 
		INNER JOIN products P
				ON C.categoryID = P.categoryid
		GROUP BY C.CategoryID, C.CategoryName),

	Prod AS 
		(SELECT ProductID, ProductName, UnitPrice, CategoryID 
		 FROM Products)
SELECT Prod.productid
	  ,Prod.productname
	  ,Prod.categoryid
	  ,Prod.unitprice
	  ,Cat.CategoryName
	  ,Cat.CatAvgPrice
	  ,(Prod.unitprice - Cat.CatAvgPrice) AS CatPriceDiff
FROM Prod 
INNER JOIN Cat
	 ON Prod.CategoryID = Cat.CategoryID;
	
