Use AdventureWorks2008R2;

/* Get the customer id, custome name, sales orderid, saplesperson id, and salesperson name for all orders */

select sh.CustomerID, sh.SalesOrderID, sh.SalesPersonID,
       pc.FirstName as customerFirstName, pc.LastName as customerLastName, 
       ps.FirstName as SalesPersonFirstNme, ps.LastName as SalesPersonLastName
from Sales.SalesOrderHeader sh
join Sales.Customer c
     on sh.CustomerID = c.CustomerID
left join Person.Person pc
     on c.PersonID = pc.BusinessEntityID
left join Person.Person ps
     on sh.SalesPersonID = ps.BusinessEntityID
where sh.SalesPersonID is not null
order by sh.CustomerID, sh.SalesOrderID;


select distinct sh.CustomerID, pc.FirstName, pc.LastName, sh.SalesOrderID
from Sales.SalesOrderHeader sh
join Sales.Customer c
on sh.CustomerID = c.CustomerID
left join Person.Person pc
on c.PersonID = pc.BusinessEntityID
where sh.SalesPersonID is not null
order by sh.CustomerID, sh.SalesOrderID;



select distinct sh.CustomerID, sh.SalesOrderID, sh.SalesPersonID, ps.FirstName, ps.LastName
from Sales.SalesOrderHeader sh
left join Person.Person ps
on sh.SalesPersonID = ps.BusinessEntityID
where sh.SalesPersonID is not null
order by sh.CustomerID, sh.SalesOrderID;
 
select count(*) from Sales.SalesOrderHeader;
select count(1) from Sales.SalesOrderHeader;
