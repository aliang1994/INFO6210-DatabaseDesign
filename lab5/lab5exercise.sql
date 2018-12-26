USE LIANG_WENQING_TEST;



--1. stored procedure
CREATE PROCEDURE MyFirstProcedure
	@InNumber INT,
	@OutNumber INT OUTPUT
AS
BEGIN
	IF @InNumber < 0
		SET @OutNumber = 0;
	ELSE
		BEGIN
			SET @OutNumber=@InNumber + 1;
		END
	PRINT @OutNumber;
END


--must execute together
------------------------------------------------------
-- Declare variables 
DECLARE @MyInput INT; 
DECLARE @MyOutput INT;

-- Initilize variable 
SET @MyInput = 3;

-- Execute the procedure 
EXEC MyFirstProcedure @MyInput, @MyOutput OUTPUT;

-- See result 
SELECT @MyOutput;
------------------------------------------------------



-- Drop the procedure 
DROP PROC MyFirstProcedure;





--2. try catch in stored procedure; must execute together
------------------------------------------------------
BEGIN TRY 
	BEGIN TRANSACTION;
	DELETE FROM AdventureWorks2008R2.Production.Product 
	WHERE ProductID = 980;
	-- If the delete operation succeeds, commit the transaction. 
	COMMIT TRANSACTION;
END TRY

BEGIN CATCH
	PRINT 'UNABLE TO DELETE PRODUCT!';
	-- Roll back any active or uncommittable transactions 
	IF XACT_STATE() <> 0 
	BEGIN 
		ROLLBACK TRANSACTION;
	END;
END CATCH;






-- 3. Functions
-- 1) scalar function
-- FUNCTION accepts Argument(s); FUNCTION uses the RETURN statement to return the value
CREATE FUNCTION whichContinent
(@Country nvarchar(15))
RETURNS varchar(30)
AS
BEGIN
	DECLARE @ReturnC varchar(30);

	SELECT @ReturnC = 
		CASE @Country
		when 'Argentina' then 'South America'
		when 'Belgium' then 'Europe'
		when 'Brazil' then 'South America'
		when 'Canada' then 'North America'
		when 'France' then 'Europe'
		ELSE 'Unknown'
	END;
	RETURN @returnC;
END
-- Execute the new function
SELECT dbo.whichContinent('Canada') [answer];



-- 2) table-valued function
-- Create new function
CREATE FUNCTION dbo.GetDateRange
(@StartDate date, @NumberOfDays int)
RETURNS @DateList TABLE (Position int, DateValue date)
AS 
BEGIN
	DECLARE @Counter int = 0;

	WHILE (@Counter < @NumberOfDays)
	BEGIN
		INSERT INTO @DateList VALUES(@Counter + 1, DATEADD(day,@Counter,@StartDate));
		SET @Counter += 1;
	END
	RETURN;
END

-- Execute the new function
SELECT * FROM dbo.GetDateRange('2009-12-31',16);





-- Create a table-valued function
CREATE FUNCTION GetLastOrdersForCustomer
(@CustomerID int, @NumberOfOrders int)
RETURNS TABLE
AS
RETURN 
	(SELECT TOP(@NumberOfOrders) SalesOrderID, OrderDate, PurchaseOrderNumber
	FROM AdventureWorks2008R2.Sales.SalesOrderHeader
	WHERE CustomerID = @CustomerID
	ORDER BY OrderDate DESC, SalesOrderID DESC
	);

-- Execute the new function
SELECT * FROM GetLastOrdersForCustomer(17288,1);






-- 4. while loop
DECLARE @counter INT;
SET @counter = 0;
WHILE @counter <> 5
	BEGIN
		SET @counter = @counter + 1;
		PRINT 'The counter : ' + CAST(@counter AS CHAR);
	END;
