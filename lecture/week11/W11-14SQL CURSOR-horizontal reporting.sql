
USE AdventureWorks2012;

--horizontal reporting using XML PATH
SELECT DISTINCT SalesOrderID,
STUFF((SELECT  ', '+RTRIM(CAST(ProductID as char))  
       FROM Sales.SalesOrderDetail d1
       WHERE d1.SalesOrderID = d2.SalesOrderID
       ORDER BY ProductID
       FOR XML PATH('')) , 1, 2, '') AS Products
FROM Sales.SalesOrderDetail d2
ORDER BY SalesOrderID;

--horizontal reporting using CURSOR


DECLARE @list varchar(1000) = '';
DECLARE @ordid int;
DECLARE @EmailAdd varchar(50);
DECLARE @subj varchar(20);

CREATE TABLE #temp
(OrderID int,
 Email varchar(50),
 Products varchar(1000));

DECLARE ord_cursor CURSOR FOR  
     SELECT SalesOrderID, EmailAddress
     FROM Sales.SalesOrderHeader soh
	 JOIN Sales.Customer c
	 ON soh.CustomerID = c.CustomerID
	 JOIN Person.EmailAddress e
	 ON c.PersonID = e.BusinessEntityID
     ORDER BY SalesOrderID;

OPEN ord_cursor;
FETCH NEXT FROM ord_cursor INTO @ordid, @EmailAdd;  

WHILE @@FETCH_STATUS = 0   
BEGIN   
   SET @list  = '';

   SELECT @list = @list + ' ' + RTRIM(CAST(ProductID as char)) + ',' 
   FROM Sales.SalesOrderDetail 
   WHERE SalesOrderID = @ordid
   ORDER BY ProductID;

   SELECT @list = LTRIM(LEFT(@list, LEN(@list) -1));

   INSERT INTO #temp
   VALUES (@ordid, @EmailAdd, @list);

   --SET @subj = 'Products contained in ' + CAST(@ordid AS char);  
   --EXEC msdb.dbo.sp_send_dbmail  
   -- @profile_name = 'simon',  -- ex07 Exchange Server
   -- @recipients = @EmailAdd,  
   -- @body = @list,  
   -- @subject = @subj;  

   FETCH NEXT FROM ord_cursor INTO @ordid, @EmailAdd;   
END   

CLOSE ord_cursor;   
DEALLOCATE ord_cursor; 

SELECT * FROM #temp;
DROP TABLE #temp;


