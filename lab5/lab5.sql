--WENQING LIANG 001873144
--INFO 6210 LAB 5 





--Question 1

/* the query itself*/
USE AdventureWorks2008R2;

GO 

SELECT SUM(sh.TotalDue) TerritorySale, sh.TerritoryID, st.Name 
FROM Sales.SalesOrderHeader sh
INNER JOIN Sales.SalesTerritory st 
ON sh.TerritoryID = st.TerritoryID
WHERE YEAR(sh.OrderDate) = 2007 AND MONTH(sh.OrderDate) = 6
GROUP BY sh.TerritoryID, st.Name 
ORDER BY st.Name;


/* table-valued function */
USE LIANG_WENQING_TEST;

GO

CREATE FUNCTION TerritorySale
(@orderyear smallint, @ordermonth smallint)
RETURNS TABLE
AS
RETURN 
	(SELECT SUM(sh.TotalDue) TerritorySale, sh.TerritoryID, st.Name 
	 FROM AdventureWorks2008R2.Sales.SalesOrderHeader sh
	 INNER JOIN AdventureWorks2008R2.Sales.SalesTerritory st 
	 ON sh.TerritoryID = st.TerritoryID
	 WHERE YEAR(sh.OrderDate) = @orderyear AND MONTH(sh.OrderDate) = @ordermonth
	 GROUP BY sh.TerritoryID, st.Name 
	);

GO

SELECT * FROM TerritorySale(2007,6);


DROP FUNCTION TerritorySale;







--Question 2
USE LIANG_WENQING_TEST;

CREATE SCHEMA LAB5;

GO 

CREATE TABLE LAB5.DateRange
   (DateID INT IDENTITY,
	DateValue DATE,
	DayOfWeek SMALLINT,
	Week SMALLINT,
	Month SMALLINT,
	Quarter SMALLINT,
	Year SMALLINT);


-- create procedure
CREATE PROCEDURE DateRangeProc
	@startdate DATE, @numdays INT
AS
BEGIN
	DECLARE @counter int = 0;
	DECLARE @tempdate DATE = @startdate;
	WHILE (@counter<@numdays)
	BEGIN
		INSERT INTO LAB5.DateRange VALUES (@tempdate, DATEPART(weekday, @tempdate), DATEPART(week, @tempdate), 
		DATEPART(month, @tempdate), DATEPART(quarter, @tempdate), DATEPART(year, @tempdate));
		SET @counter += 1;
		SET @tempdate = DATEADD(day,@counter, @startdate);
	END
END


-- Declare variables 
DECLARE @inputdate DATE; 
DECLARE @inputrange INT;
SET @inputdate = '2018-10-31';
SET @inputrange = 16;
EXEC DateRangeProc @inputdate, @inputrange;

-- result
SELECT * FROM LAB5.DateRange;


-- clean up
DROP PROC DateRangeProc;
GO
TRUNCATE TABLE LAB5.DateRange;






--Question 3
USE LIANG_WENQING_TEST;

CREATE TABLE LAB5.Customer
(CustomerID VARCHAR(20) PRIMARY KEY,
CustomerLName VARCHAR(30),
CustomerFName VARCHAR(30),
CustomerStatus VARCHAR(10));

CREATE TABLE LAB5.SaleOrder
(OrderID INT IDENTITY PRIMARY KEY,
CustomerID VARCHAR(20) REFERENCES LAB5.Customer(CustomerID),
OrderDate DATE,
OrderAmountBeforeTax INT);

CREATE TABLE LAB5.SaleOrderDetail
(OrderID INT REFERENCES LAB5.SaleOrder(OrderID),
ProductID INT,
Quantity INT,
UnitPrice INT,
PRIMARY KEY (OrderID, ProductID));


CREATE TRIGGER totalsale
ON LAB5.SaleOrderDetail
AFTER INSERT 
AS
BEGIN
	UPDATE so
	SET so.OrderAmountBeforeTax = sd.Quantity * sd.UnitPrice
	FROM LAB5.SaleOrder so  
	INNER JOIN LAB5.SalesOrderDetail sd ON so.OrderID = sd.OrderID;
END;



DROP TRIGGER totalsale;






--Question 4
/* Use the content of an AdventureWorks database. Write a query that returns the following columns. 
1) Customer ID 
2) Customer’s first name 
3) Customer’s last name 
4) Total of orders made by each customer 
5) Total of unique products ever purchased by each customer 
Sort the returned data by the customer ID. */

USE AdventureWorks2008R2;

GO 

SELECT sh.CustomerID, pp.FirstName, pp.LastName, COUNT(sh.SalesOrderID) numorders, T2.numproducts
FROM Sales.SalesOrderHeader sh
INNER JOIN Sales.Customer sc 
ON sc.CustomerID = sh.CustomerID
INNER JOIN Person.Person pp
ON sc.PersonID = pp.BusinessEntityID
CROSS APPLY (
	SELECT T.CustomerID, T.numproducts 
	FROM (SELECT sh.CustomerID, COUNT(sd.ProductID) numproducts
			FROM Sales.SalesOrderHeader sh
			INNER JOIN Sales.SalesOrderDetail sd
			ON sh.SalesOrderID = sd.SalesOrderID
			GROUP BY sh.CustomerID) AS T
	WHERE T.CustomerID = sh.CustomerID) AS T2
GROUP BY sh.CustomerID, pp.FirstName, pp.LastName, T2.numproducts
ORDER BY sh.CustomerID;




