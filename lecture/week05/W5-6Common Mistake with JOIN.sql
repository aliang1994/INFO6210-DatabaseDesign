
/* Question: Retrieve customers who have never purchased Product 716 */ 

-- Use JOIN to get customers who have never purchased Product 716
select distinct sh.CustomerID
from Sales.SalesOrderHeader sh
join Sales.SalesOrderDetail sd
     on sh.SalesOrderID = sd.SalesOrderID
where sd.ProductID <> 716
order by sh.CustomerID;

-- Validate result
select distinct sh.CustomerID
from Sales.SalesOrderHeader sh
join Sales.SalesOrderDetail sd
on sh.SalesOrderID = sd.SalesOrderID
where sd.ProductID = 716
order by sh.CustomerID;

select distinct sd.ProductID
from Sales.SalesOrderHeader sh
join Sales.SalesOrderDetail sd
on sh.SalesOrderID = sd.SalesOrderID
where sh.CustomerID =11144
order by sd.ProductID;

-- Use EXCEPT to get correct data
select distinct CustomerID 
   from Sales.SalesOrderHeader
EXCEPT
select distinct CustomerID
   from Sales.SalesOrderHeader sh
   join Sales.SalesOrderDetail sd
        on sh.SalesOrderID = sd.SalesOrderID
   where sd.ProductID = 716;

-- USE NOT IN
select distinct CustomerID
from Sales.SalesOrderHeader
where CustomerID not in
   (select distinct CustomerID
    from Sales.SalesOrderHeader sh
    join Sales.SalesOrderDetail sd
    on sh.SalesOrderID = sd.SalesOrderID
    where sd.ProductID = 716)
    order by CustomerID;
