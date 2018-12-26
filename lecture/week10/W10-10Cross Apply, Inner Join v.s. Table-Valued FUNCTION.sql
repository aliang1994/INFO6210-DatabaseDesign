
/* Close look at CROSS APPLY and Table-Vauled Functions*/

USE Northwind;

-----------------------------------------------------------------------------------------------------
-- Create and use a table-valued function
----------------------------------------------------------------------------------------------------

CREATE FUNCTION dbo.ufnOrdersForCustomer(@custID NVARCHAR(5))
--  Schema of table to be returned from function.
RETURNS @orderList TABLE 
	(CustomerID NVARCHAR(5), OrderID INT, OrderDate DATETIME, ItemCount INT)
AS
--  Script to insert data into table before it is returned.
BEGIN
  INSERT INTO @orderList (CustomerID, OrderID, OrderDate, ItemCount)
   (SELECT 
   		CustomerID, OrderID, OrderDate,
   		(SELECT COUNT(*) FROM [Order Details] OD WHERE OD.OrderID = O.OrderID)
    FROM Orders O
    WHERE O.CustomerID = @custID)
  RETURN
END;


-- USE customer ids "ALFKI" and "ANATR" to test out the function.
SELECT * FROM dbo.ufnOrdersForCustomer('alfki');
SELECT * FROM dbo.ufnOrdersForCustomer('anatr');

DROP FUNCTION dbo.ufnOrdersForCustomer;







-- INNER JOIN DOES NOT WORK WITH TABLE-VALUED FUNCTIONS WITH CORRELATION
SELECT
	C.CustomerID, C.CompanyName, OFC.OrderID, OFC.OrderDate, OFC.ItemCount
FROM Customers C
INNER JOIN dbo.ufnOrdersForCustomer(C.CustomerID) OFC
ON C.CustomerID = OFC.CustomerID;

-- CROSS APPLY DOES WORK WITH TABLE-VALUED FUNCTIONS WITH CORRELATION
SELECT
	C.CustomerID, C.CompanyName, OFC.OrderID, OFC.OrderDate, OFC.ItemCount
FROM Customers C 
CROSS APPLY dbo.ufnOrdersForCustomer(C.CustomerID) OFC;







-- INNER JOIN WORKS WITH TABLE-VALUED FUNCTIONS WITHOUT CORRELATION
SELECT
	C.CustomerID, C.CompanyName, OFC.OrderID, OFC.OrderDate, OFC.ItemCount
FROM Customers C
INNER JOIN dbo.ufnOrdersForCustomer('alfki') OFC
ON C.CustomerID = OFC.CustomerID;

-- CROSS APPLY DOES NOT WORK WITH TABLE-VALUED FUNCTIONS WITHOUT CORRELATION
SELECT
	C.CustomerID, C.CompanyName, OFC.OrderID, OFC.OrderDate, OFC.ItemCount
FROM Customers C 
CROSS APPLY dbo.ufnOrdersForCustomer('alfki') OFC;









-----------------------------------------------------------------------------------------------------
-- Create and use a table-valued function.
----------------------------------------------------------------------------------------------------

CREATE FUNCTION [dbo].ufnCreateTableVAR(@ListofIds nvarchar(max))
RETURNS @rtn TABLE (IntegerValue int)
AS
BEGIN
    WHILE(CHARINDEX(',', @ListofIds) > 0)
        BEGIN
            INSERT INTO @rtn
                SELECT LTRIM(RTRIM(SUBSTRING(@ListofIds, 1, CHARINDEX(',', @ListofIds) - 1)));
            SET @ListofIds = SUBSTRING(@ListofIds, CHARINDEX(',', @ListofIds) + LEN(','), LEN(@ListofIds));
        END;
    INSERT INTO @Rtn SELECT LTRIM(RTRIM(@ListofIds));
    RETURN;
END;



-- Test out the function
SELECT * FROM dbo.ufnCreateTableVAR('12100,14000,20000,38000,44220');



-- INNER JOIN WORKS WITH TABLE-VALUED FUNCTIONS WITHOUT CORRELATION
SELECT CustomerID, SalesOrderID, OrderDate
FROM AdventureWorks2012.Sales.SalesOrderHeader S
INNER JOIN dbo.ufnCreateTableVAR ('12100,14000,20000,38000,44220') C
ON C.IntegerValue = S.CustomerID
ORDER BY CustomerID DESC, OrderDate DESC, SalesOrderID DESC;



-- CROSS APPLY DOES NOT WORK WITH TABLE-VALUED FUNCTIONS WITHOUT CORRELATION
SELECT CustomerID, SalesOrderID, OrderDate
FROM AdventureWorks2012.Sales.SalesOrderHeader S
CROSS APPLY dbo.ufnCreateTableVAR ('12100,14000,20000,38000,44220') C
ORDER BY CustomerID DESC, OrderDate DESC, SalesOrderID DESC;
