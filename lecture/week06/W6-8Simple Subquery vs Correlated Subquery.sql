
-- Simple Subquery vs Correlated Subquery

-- Set the database context

USE Northwind;

-- Simple Subquery
-- Simple subquery doesn't use values from the outer query.
-- Simple subquery is executed only once.
-- Simple subquery is not driven by the outer Query.

SELECT * 
FROM Products
WHERE ProductID = (SELECT MAX(ProductID) FROM Products);


-- Correlated Subquery
-- Correlated subquery is executed based on the value provided by the Outer query.
-- Correlated subquery is executed for each row processed by the outer query.
-- Correlated subquery is driven by the outer Query.

SELECT C.CompanyName, C.City, C.Country, 
	   (SELECT Count(SupplierID) FROM Suppliers S WHERE S.Country = C.Country) AS [Total Suppliers]
FROM Customers C

