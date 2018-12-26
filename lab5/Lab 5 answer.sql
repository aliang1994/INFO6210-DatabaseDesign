--5.1
CREATE FUNCTION dbo.ufGetTerritorySale
(@y SMALLINT, @m SMALLINT)
RETURNS TABLE
AS
RETURN
SELECT TOP 100 PERCENT t.TerritoryID, t.Name, 
      ROUND(SUM(sh.TotalDue), 2) TotalSale
FROM Sales.SalesOrderHeader sh
JOIN Sales.SalesTerritory t
ON sh.TerritoryID = t.TerritoryID
WHERE YEAR(sh.OrderDate) = @y and MONTH(sh.OrderDate) = @m
GROUP BY t.TerritoryID, t.Name
ORDER BY t.Name;


--5.2
CREATE PROC dbo.uspDate
@d DATE, @n INT
AS
BEGIN
  WHILE @n <>0
    BEGIN
      INSERT INTO dbo.DateRange (DateValue, DayOfWeek,
	         Week, Month, Quarter, Year)
      SELECT @d, DATEPART(dw, @d), DATEPART(wk, @d),
	         MONTH(@d), DATEPART(q, @d), YEAR(@d)
      SET @d = DATEADD(d, 1, @d);
      SET @n = @n -1;
    END
END


--5.3
CREATE TRIGGER UpdateOrderAmount
    ON SaleOrderDetail
    FOR INSERT, UPDATE, DELETE
AS
BEGIN
   SET NOCOUNT ON;
   UPDATE SaleOrder SET OrderAmountBeforeTax = 
          ISNULL(OrderAmountBeforeTax, 0) + (
          SELECT ISNULL(i.Quantity*i.UnitPrice, 0) -
		  ISNULL(d.Quantity*d.UnitPrice, 0) AS AmountAdjustment
   FROM Inserted i
   FULL JOIN Deleted d
   ON i.OrderID = d.OrderID
   WHERE SaleOrder.OrderID = ISNULL(i.OrderID, d.OrderID)
         AND ISNULL(i.Quantity*i.UnitPrice, 0) - 
		     ISNULL(d.Quantity*d.UnitPrice, 0) != 0);
END


--5.4
with temp1 as
(select CustomerID, count(SalesOrderID) TotalOrderCount
 from Sales.SalesOrderHeader
 group by CustomerID),

temp2 as
(select CustomerID, count(distinct sd.ProductID) TotalUniqueProducts
 from Sales.SalesOrderHeader sh
 join Sales.SalesOrderDetail sd
 on sh.SalesOrderID = sd.SalesOrderID
 group by CustomerID)

select c.CustomerID, p.FirstName, p.LastName, t1.TotalOrderCount, t2.TotalUniqueProducts
from Sales.Customer c
join Person.Person p
on c.PersonID = p.BusinessEntityID
join temp1 t1
on c.CustomerID = t1.CustomerID
join temp2 t2
on c.CustomerID = t2.CustomerID
order by c.CustomerID;
