
-- CustomerOrders Function Return Orders for Customers
USE LIANG_WENQING_TEST;

CREATE FUNCTION CustomerOrders
(@CustomerIDs varchar(max), @MaxOrderNumber int)
RETURNS TABLE
AS
RETURN
        SELECT TOP(@MaxOrderNumber)
		       CustomerID,
               SalesOrderID,
               OrderDate,
               PurchaseOrderNumber
        FROM AdventureWorks2012.Sales.SalesOrderHeader S

		JOIN dbo.StringToValues(@CustomerIDs) C
		ON C.IntegerValue = S.CustomerID
        ORDER BY CustomerID DESC, OrderDate DESC, SalesOrderID DESC;

		GO

-- Test the function

select * from dbo.CustomerOrders ('12100,14000,20000,28000,44220' , 15)

-- Housekeeping

DROP FUNCTION CustomerOrders;


