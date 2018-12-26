--Info 6210 Lab 2
--Wenqing Liang

--2-1
Select ProductID, Name, CAST(SellStartDate as DATE) [Sell Date]
From Production.Product 
Where Color='Red' And SellStartDate > '2005-01-01'
Order by SellStartDate;


--2-2
Select Count(ProductID)[Total - Black 2 Manufacture Days]
From Production.Product
Where DaysToManufacture = 2 And Color = 'Black'
Group By DaysToManufacture;


--2-3
Select ProductID, Name, ListPrice
From Production.Product 
Where ListPrice> (Select AVG(ListPrice) [Aver Price] From Production.Product) +10
Order by ListPrice desc;


--2-4
Select P.ProductID, P.Name, COUNT(SS.SalesOrderID)[Total Sold]
From Production.Product P
Inner Join Sales.SalesOrderDetail SS
On P.ProductID = SS.ProductID
Where P.Color='Red'
Group By P.ProductID, P.Name
Having COUNT(SS.SalesOrderID)>2000
Order By [Total Sold] desc;


--2-5
(Select Distinct SH.CustomerID
From Sales.SalesOrderHeader SH
Inner Join Sales.SalesOrderDetail SD
On SH.SalesOrderID = SD.SalesOrderID
Where SD.ProductID=710)
INTERSECT
 (Select Distinct SH.CustomerID
From Sales.SalesOrderHeader SH
Inner Join Sales.SalesOrderDetail SD
On SH.SalesOrderID = SD.SalesOrderID
Where SD.ProductID=715)
EXCEPT
(Select Distinct SH.CustomerID
From Sales.SalesOrderHeader SH
Inner Join Sales.SalesOrderDetail SD
On SH.SalesOrderID = SD.SalesOrderID
Where SD.ProductID=716)
Order By SH.CustomerID;


--2-6
Select SC.CustomerID, P.FirstName, P.LastName, MIN(SH.TotalDue)[Min Order Value], MAX(SH.TotalDue)[Max Order Value]
From Sales.Customer SC
Inner Join Sales.SalesOrderHeader SH
On SC.CustomerID=SH.CustomerID
Inner Join Person.Person P
On SC.PersonID = P.BusinessEntityID
Group By SC.CustomerID, P.LastName, P.FirstName
Order By SC.CustomerID;

 