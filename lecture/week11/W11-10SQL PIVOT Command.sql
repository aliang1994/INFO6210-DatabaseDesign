
/* PIVOT rotates a table-valued expression by turning the unique values 
   from one column in the expression into multiple columns in the output, 
   and performs aggregations where they are required on any remaining column values 
   that are wanted in the final output. */

USE AdventureWorks2008R2;


-- SQL statement to create the vertical format

SELECT DaysToManufacture, AVG(StandardCost) AS AverageCost 
FROM Production.Product
GROUP BY DaysToManufacture
ORDER BY DaysToManufacture;

-- Pivot table with one row and five columns

SELECT 'AverageCost' AS Cost_Sorted_By_Production_Days, 
[0], [1], [2], [3], [4]
FROM
(SELECT DaysToManufacture, StandardCost 
    FROM Production.Product) AS SourceTable
PIVOT
(AVG(StandardCost) FOR DaysToManufacture IN ([0], [1], [2], [3], [4])) AS PivotTable;

---------------------------------------------------------------------------------------
-- SQL statement to create the vertical format

SELECT EmployeeID, COUNT(PurchaseOrderID) AS [Order Count]
FROM Purchasing.PurchaseOrderHeader
WHERE EmployeeID IN (250, 251, 256, 257, 260)
GROUP BY EmployeeID
ORDER BY EmployeeID;

-- Pivot table with one row and six columns

SELECT 'Order Count' AS ' ', [250] AS Emp1, [251] AS Emp2, [256] AS Emp3, [257] AS Emp4, [260] AS Emp5
FROM 
(SELECT PurchaseOrderID, EmployeeID
FROM Purchasing.PurchaseOrderHeader) SourceTable
PIVOT
(COUNT (PurchaseOrderID) FOR EmployeeID IN ( [250], [251], [256], [257], [260] )) AS PivotTable;

---------------------------------------------------------------------------------------

-- SQL statement to create the vertical format

SELECT EmployeeID, VendorID, COUNT(PurchaseOrderID) AS [Order Count]
FROM Purchasing.PurchaseOrderHeader
WHERE EmployeeID IN (250, 251, 256, 257, 260)
GROUP BY EmployeeID, VendorID
ORDER BY EmployeeID, VendorID;

-- Pivot table with multiple rows and six columns

SELECT VendorID, [250] AS Emp1, [251] AS Emp2, [256] AS Emp3, [257] AS Emp4, [260] AS Emp5
FROM 
(SELECT PurchaseOrderID, EmployeeID, VendorID
FROM Purchasing.PurchaseOrderHeader) SourceTable
PIVOT
(COUNT (PurchaseOrderID) FOR EmployeeID IN ( [250], [251], [256], [257], [260] )) AS PivotTable
ORDER BY PivotTable.VendorID;

