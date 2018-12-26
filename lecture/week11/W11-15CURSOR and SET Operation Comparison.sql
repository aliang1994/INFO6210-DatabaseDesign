USE Northwind
GO

--Create demo tables

CREATE TABLE [dbo].[CustCopy1](
	[CustomerID] [nchar](5) NOT NULL PRIMARY KEY,
	[CompanyName] [nvarchar](40) NOT NULL,
	[ContactName] [nvarchar](30) NULL,
	[ContactTitle] [nvarchar](30) NULL,
	[Address] [nvarchar](60) NULL,
	[City] [nvarchar](15) NULL,
	[Region] [nvarchar](15) NULL,
	[PostalCode] [nvarchar](10) NULL,
	[Country] [nvarchar](15) NULL,
	[Phone] [nvarchar](24) NULL,
	[Fax] [nvarchar](24) NULL,
	LastOrder datetime NULL,
 )
 
 insert into CustCopy1
   select *,NULL as LastOrder
   from dbo.customers
   
 select *
 into dbo.CustCopy2
 from dbo.CustCopy1
      
--Declare customer cursor
DECLARE CustomerCur CURSOR
FORWARD_ONLY
KEYSET
FOR
  select customerid, lastorder
  from custcopy1;

--Declare holding vars
  declare @customerid nchar (5);
  declare @lastorder datetime;
  declare @orderdate datetime
 
--Get the most recent order date for each customer using CURSORs
 OPEN CustomerCur;
 FETCH NEXT FROM CustomerCur into @customerid, @lastorder
 
 while @@FETCH_STATUS = 0
 BEGIN
   DECLARE OrderCur CURSOR
   READ_ONLY FOR
     select orderdate
     from orders
     where customerID = @customerid;

   OPEN OrderCur
   FETCH NEXT FROM OrderCur into @orderdate
   --loop through a customer's orders
   while @@FETCH_STATUS = 0
   BEGIN
     if (@lastorder is null) or (@orderdate > @lastorder)
       set @lastorder = @orderdate
       FETCH NEXT FROM OrderCur into @orderdate
   END 
   CLOSE OrderCur
   DEALLOCATE OrderCur
   
   UPDATE CustCopy1
     set LastOrder = @lastorder
   WHERE CURRENT OF CustomerCur;
   
   FETCH NEXT FROM CustomerCur into @customerid, @lastorder
END
CLOSE CustomerCur
DEALLOCATE CustomerCur

--Get the most recent order date for each customer using SET Oriented Operation 
update CustCopy2
 set LastOrder = a.lastdate
from
  CustCopy2 c
  left outer join
  (select customerid, MAX(OrderDate) as lastdate
   from orders
   group by customerid) a
  on c.customerid=a.CustomerID

-- Housekeeping
drop table CustCopy1
drop table CustCopy2

