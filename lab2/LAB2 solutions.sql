--1.
select ProductID, Name, cast(SellStartDate as date) SsaleStartingDate
from Production.Product
where SellStartDate > '1-1-2005' and Color = 'red'
order by SellStartDate;

--2.
select count(ProductID) TotalCount
from Production.Product
where DaysToManufacture = 2
and Color = 'black';

--3.
select ProductID, Name, ListPrice
from Production.Product
where ListPrice > (select AVG(ListPrice) from Production.Product)+10
order by ListPrice desc;

--4.
select sd.ProductID, p.Name, sum(sd.OrderQty) TotalSoldQuantity
from Production.Product p
join Sales.SalesOrderDetail sd
on p.ProductID = sd.ProductID
where p.Color = 'red'
group by sd.ProductID, p.Name
having sum(sd.OrderQty) > 2000
order by sum(sd.OrderQty) desc;

--5.
(select CustomerID
from Sales.SalesOrderHeader oh
join Sales.SalesOrderDetail od
on oh.SalesOrderID = od.SalesOrderID
where od.ProductID = 710
INTERSECT
select CustomerID
from Sales.SalesOrderHeader oh
join Sales.SalesOrderDetail od
on oh.SalesOrderID = od.SalesOrderID
where od.ProductID = 715)
EXCEPT
select CustomerID
from Sales.SalesOrderHeader oh
join Sales.SalesOrderDetail od
on oh.SalesOrderID = od.SalesOrderID
where od.ProductID = 716
order by CustomerID;

--OR

select soh.CustomerID
from Sales.SalesOrderDetail sod
join Sales.SalesOrderHeader soh 
on sod.SalesOrderID = soh.SalesOrderID
where sod.ProductID in (710, 715)
and soh.SalesOrderID not in (
	select SalesOrderID
	from Sales.SalesOrderDetail
	where ProductID in (716))
group by soh.CustomerID
HAVING count( distinct sod.ProductID ) = 2
order by soh.CustomerID;

--6.
select sh.CustomerID, p.LastName, p.FirstName,
round(max(sh.TotalDue), 2) HighestOrderValue,
round(min(sh.TotalDue), 2) LowestOrderValue
from Sales.SalesOrderHeader sh
join Sales.Customer c
on sh.CustomerID = c.CustomerID
join Person.Person p
on c.PersonID = p.BusinessEntityID
group by sh.CustomerID, p.LastName, p.FirstName
order by sh.CustomerID;

