
/* SQL UPDATE Command */

-- UPDATE a single column with a literal value

UPDATE Person.vStateProvinceCountryRegion
SET CountryRegionName = 'United States'
WHERE CountryRegionName = 'United States of America';


-- UPDATE a single column with a formula

UPDATE Production.Product
SET ListPrice = ListPrice * 2;


-- UPDATE multiple columns of a table

UPDATE Sales.SalesPerson
SET Bonus = 6000, CommissionPct = .05, SalesQuota = NULL;


-- UPDATE a table using data from another table

UPDATE Sales.SalesPerson
SET SalesYTD = SalesYTD + so.SubTotal
	FROM Sales.SalesPerson AS sp
	JOIN Sales.SalesOrderHeader AS so
	ON sp.BusinessEntityID = so.SalesPersonID
AND so.OrderDate = (SELECT MAX(OrderDate)
					FROM Sales.SalesOrderHeader
                    WHERE SalesPersonID = sp.BusinessEntityID);
