--W4-6 Lab 2 Exercise
USE AdventureWorks2008R2;


--Exercise 1: Retrieve only the following columns from the Production.Product table: 
--Product ID, Name, Selling start date, Selling end date, Size, Weight
Select ProductID, Name, SellStartDate, SellEndDate, Size, Weight 
From Production.Product;


--Exercise 2: Select all info for all orders with no credit card id
Select * 
From Sales.SalesOrderHeader
Where CreditCardID is null;


--Exercise 3: Select all info for all products with size specified
Select *
From Production.Product
Where Size is not null;


--Exercise 4: Select all information for products that started selling
--between January 1, 2007 and December 31, 2007
Select *
From Production.Product
Where SellStartDate Between '2007-01-01' And '2007-12-31';


--Exercise 5: Select all info for all orders placed in June 2007 using date functions, 
--and include a column for an estimated delivery date that is 7 days after the order date
SELECT *, DATEADD(DAY, 7, OrderDate) AS [Est. Delivery Date]
FROM Sales.SalesOrderHeader
WHERE DATEPART(MONTH, OrderDate) = 6 and DATEPART(YEAR, OrderDate) = 2007;


--Exercise 6: Determine the date that is 30 days from today 
--and display only the date in mm/dd/yyyy format (4-digit year).
SELECT CONVERT(CHAR(20), DATEADD(DAY, 30, GETDATE()), 101)
AS [30 Days From Today];


--Exercise 7: Determine the number of orders, overall total due, average of total due, 
--amount of the smallest amount due, and amount of the largest amount due for all orders placed in May 2008. 
--Make sure all columns have a descriptive heading.
Select COUNT(*) AS [TOTAL ORDERS], SUM(TotalDue) AS [TOTAL DUE], AVG(TotalDue) AS [AVG DUE], MIN(TotalDue) AS [MIN DUE], MAX(TotalDue) [MAX DUE]
From Sales.SalesOrderHeader
Where DATEPART(MONTH, OrderDate) = 5 and DATEPART(YEAR, OrderDate) = 2008;


--Exercise 8: Retrieve the Customer ID, total number of orders and overall total due for the customers 
--who placed more than one order in 2007 and sort the result by the overall total due in the descending order.
Select CustomerID, Count(SalesOrderID) AS [Total Order], Sum(TotalDue) AS[Total Due]
From Sales.SalesOrderHeader
Where DATEPART(YEAR, OrderDate) = 2007
Group By CustomerID
Having Count(SalesOrderID)>1
Order By Sum(TotalDue) DESC;


--Exercise 9: Provide a unique list of the sales person ids who have sold the product id 777. 
--Sort the list by the sales person id.
Select Distinct O.SalesPersonID, D.ProductID
From Sales.SalesOrderHeader O
Inner Join Sales.SalesOrderDetail D
On O.SalesOrderID = D.SalesOrderID
Where ProductID = 777
Order By O.SalesPersonID;


--Exercise 10: List the product ID, name, list price, size of products 
--Under the ‘Bikes’ category (ProductCategoryID = 1) and subcategory ‘Mountain Bikes’.
Select P.ProductID, P.Name, P.ListPrice, P.Size, SP.Name
From Production.Product P
Join Production.ProductSubcategory SP
On P.ProductSubcategoryID = SP.ProductSubcategoryID
Where SP.ProductCategoryID = 1 AND SP.Name='Mountain Bikes';


--Exercise 11: List the SalesOrderID and currency name for each order.
select H.SalesOrderID, C.Name
from Sales.SalesOrderHeader H
join Sales.CurrencyRate CR on H.CurrencyRateID = CR.CurrencyRateID
join Sales.Currency C on CR.ToCurrencyCode = C.CurrencyCode;