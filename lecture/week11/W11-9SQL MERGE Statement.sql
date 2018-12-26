/*      Use the MERGE statement in conjunction with the INSERT, UPDATE, 
        and DELETE statements to synch data between two tables. */


---------------------------------------------------------------------------
/*   Use the MERGE statement to synch data in one table with
     data in another table. */
---------------------------------------------------------------------------
USE Northwind;

-- Create a duplicate of Products table to use in demo
--	that only includes the even rows.
SELECT ProductID, ProductName, UnitPrice, QuantityPerUnit
INTO MyProducts
FROM Products
WHERE ProductID % 2 = 0;

SELECT * 
FROM MyProducts
ORDER BY ProductID;

-- Disabling the IDENTITY attribute on ProductID field so rows can
--	be inserted with the original ProductID.
SET IDENTITY_INSERT MyProducts ON;

-- Merge MyProducts with Products table. MyProducts will be updated from
--		 information in Products table.
-- NOTE: Multiple WHEN clauses. They will be examined in the order listed
--		 and the first one that meets the criteria specified will be the
--		 block that is executed.

MERGE MyProducts mp
USING 
		(SELECT ProductID, ProductName, UnitPrice, QuantityPerUnit FROM Products) Prod
ON mp.ProductID = Prod.ProductID
WHEN MATCHED AND mp.UnitPrice > 20 THEN
		DELETE
WHEN MATCHED THEN
		UPDATE SET UnitPrice = Prod.UnitPrice + 1.5
WHEN NOT MATCHED THEN
		INSERT (ProductID, ProductName, UnitPrice, QuantityPerUnit)
		VALUES (Prod.ProductID, Prod.ProductName, Prod.UnitPrice, Prod.QuantityPerUnit);

-- Verify results of Merge statement in MyProducts.
SELECT * 
FROM MyProducts
ORDER BY ProductID;

-- Remove the demo table.
DROP TABLE MyProducts;

