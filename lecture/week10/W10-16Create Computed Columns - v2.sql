
/* How to Create Computed Colimns */
USE LIANG_WENQING_TEST;
-- Example 1

-- Create a demo table with a computed column

CREATE TABLE dbo.ProductDemo
(
    ProductID INT IDENTITY (1,1) NOT NULL
  , QtyAvailable SMALLINT
  , UnitPrice MONEY
  , InventoryValue AS QtyAvailable * UnitPrice
);

-- Insert some data into the table

INSERT INTO dbo.ProductDemo (QtyAvailable, UnitPrice)
VALUES (25, 2.00), (10, 1.5);

-- See what the computed column looks like

SELECT ProductID, QtyAvailable, UnitPrice, InventoryValue
FROM dbo.ProductDemo;

-- Clean up what we just created

DROP TABLE dbo.ProductDemo;

-- Example 2

-- Create a function

CREATE FUNCTION fn_CalcPurchase_v2(@CustID INT)
RETURNS MONEY
AS
   BEGIN
      DECLARE @total MONEY =
         (SELECT SUM(SubTotal)
          FROM Sales.SalesOrderHeader
          WHERE CustomerID =@CustID);
      SET @total = ISNULL(@total, 0);
      RETURN @total;
END

-- Add a computed column to the Sales.Customer

ALTER TABLE Sales.Customer
ADD TotalPurchase AS (dbo.fn_calcPurchase_v2(CustomerID));

-- See what the computed column looks like

SELECT TOP 10 *
FROM AdventureWorks2008R2.Sales.Customer
WHERE TotalPurchase > 0
ORDER BY TotalPurchase DESC;

-- Clean up what we just created

-- Must drop the computed column before dropping the function

ALTER TABLE Sales.Customer DROP COLUMN TotalPurchase;

DROP FUNCTION dbo.fn_CalcPurchase_v2;
