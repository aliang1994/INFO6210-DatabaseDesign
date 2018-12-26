
-- Get the order with the highest total due amount for each customer

declare @x xml;

set @x = (SELECT c.CustomerID CustID, p.FirstName PF, p.LastName PL, o.SalesOrderID OID, o.TotalDue TD
FROM sales.Customer c
INNER JOIN sales.SalesOrderHeader o
ON c.CustomerID = o.CustomerID
INNER JOIN Person.Person p
ON c.PersonID = p.BusinessEntityID
ORDER BY c.CustomerID, o.TotalDue desc
FOR XML AUTO, ROOT('CustomerOrder'), ELEMENTS);

SELECT 
    b.value('CustID[1]', 'int') as CustomerID,
	b.value('(./p/PF)[1]', 'Varchar(50)') as FirstName,
	b.value('(./p/PL)[1]', 'Varchar(50)') as LastName,
	b.value('(./p/o/OID)[1]', 'int') as OrderID,
	b.value('(./p/o/TD)[1]', 'decimal(10,2)') as Amount
FROM @x.nodes('/CustomerOrder/c') as a(b);


-- Get the top 3 orders with the highest total due amounts for each customer

declare @x xml;

set @x = (SELECT c.CustomerID CustID, p.FirstName PF, p.LastName PL, o.SalesOrderID OID, o.TotalDue TD
FROM sales.Customer c
INNER JOIN sales.SalesOrderHeader o
ON c.CustomerID = o.CustomerID
INNER JOIN Person.Person p
ON c.PersonID = p.BusinessEntityID
ORDER BY c.CustomerID, o.TotalDue desc
FOR XML AUTO, ROOT('CustomerOrder'), ELEMENTS);

SELECT 
    b.value('CustID[1]', 'int') as CustomerID,
	b.value('(./p/PF)[1]', 'Varchar(50)') as FirstName,
	b.value('(./p/PL)[1]', 'Varchar(50)') as LastName,
	ISNULL(b.value('(./p/o/OID/text())[1]', 'VARCHAR(10)'), '') + '  '+
	ISNULL(b.value('(./p/o/OID/text())[2]', 'VARCHAR(10)'), '') + '  '+
	ISNULL(b.value('(./p/o/OID/text())[3]', 'VARCHAR(10)'), '') as TopOrders
FROM @x.nodes('/CustomerOrder/c') as a(b);


-- Get the top 3 orders with the highest total due amounts for each customer

WITH Temp AS
   (select CustomerID, SalesOrderID,
    rank() over (partition by CustomerID order by TotalDue desc) as TopOrders
    from [Sales].[SalesOrderHeader]
	where customerid > 20000
    group by CustomerID, SalesOrderID, TotalDue) 
select distinct t2.CustomerID,
STUFF((SELECT  ', '+RTRIM(CAST(SalesOrderID as char))  
       FROM temp t1
       WHERE t1.CustomerID = t2.CustomerID and TopOrders <=3
       FOR XML PATH('')) , 1, 2, '') AS Top5Orders
from temp t2;

