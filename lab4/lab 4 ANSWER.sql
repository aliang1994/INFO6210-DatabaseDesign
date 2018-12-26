--B
SELECT DISTINCT sh.CustomerID,
COALESCE(STUFF((SELECT distinct ', '+RTRIM(CAST(SalesPersonID as char))  
       FROM Sales.SalesOrderHeader
       WHERE CustomerID = sh.CustomerID
       FOR XML PATH('')) , 1, 2, ''), '') AS SalesPersonID
FROM Sales.SalesOrderHeader sh
ORDER BY sh.CustomerID DESC;

--C
IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL
DROP TABLE #TempTable;

WITH Parts(AssemblyID, ComponentID, PerAssemblyQty, EndDate, ComponentLevel) AS
(
    -- Top-level compoments
	SELECT b.ProductAssemblyID, b.ComponentID, b.PerAssemblyQty,
        b.EndDate, 0 AS ComponentLevel
    FROM Production.BillOfMaterials AS b
    WHERE b.ProductAssemblyID = 992
          AND b.EndDate IS NULL

    UNION ALL

	-- All other sub-compoments
    SELECT bom.ProductAssemblyID, bom.ComponentID, p.PerAssemblyQty,
        bom.EndDate, ComponentLevel + 1
    FROM Production.BillOfMaterials AS bom 
        INNER JOIN Parts AS p
        ON bom.ProductAssemblyID = p.ComponentID
        AND bom.EndDate IS NULL
)
SELECT AssemblyID, ComponentID, Name, ListPrice, PerAssemblyQty, 
       ListPrice * PerAssemblyQty SubTotal, ComponentLevel

into #TempTable

FROM Parts AS p
    INNER JOIN Production.Product AS pr
    ON p.ComponentID = pr.ProductID
ORDER BY ComponentLevel, AssemblyID, ComponentID;

SELECT CAST((
(SELECT SUM(SubTotal)
FROM #TempTable
WHERE ComponentLevel = 0 AND
      ComponentID NOT IN (SELECT AssemblyID FROM #TempTable WHERE ComponentLevel = 1))
+
(SELECT SUM(SubTotal)
FROM #TempTable
WHERE ComponentLevel = 1)) AS DECIMAL(8,2)) AS TotalCost;