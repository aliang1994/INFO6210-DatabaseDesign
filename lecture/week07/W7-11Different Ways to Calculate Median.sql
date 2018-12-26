
/* Different ways to calculate MEAN */

-- Use SELECT TOP 50 PERCENT
USE AdventureWorks2008R2;

WITH temp1 AS
   (SELECT
      ((SELECT MAX(bonus) FROM
          (SELECT TOP 50 PERCENT bonus FROM Sales.SalesPerson ORDER BY bonus) AS BottomHalf)
       +
       (SELECT MIN(bonus) FROM
          (SELECT TOP 50 PERCENT bonus FROM Sales.SalesPerson ORDER BY bonus DESC) AS TopHalf)
      ) / 2 AS Median),
temp2 AS
   (SELECT MIN(bonus) AS Minimum, MAX(bonus) AS Maximum, ROUND(AVG(Bonus), 2) AS Average
    FROM Sales.SalesPerson)
SELECT 'Bonus' AS ' ', Maximum, Minimum, Average, Median
FROM temp1
CROSS JOIN temp2;


-- Use ROW_NUMBER()

WITH temp1 AS
   (SELECT AVG(bonus) AS Median
    FROM
      (SELECT Bonus,
              ROW_NUMBER() OVER (
                 ORDER BY bonus ASC, BusinessEntityID ASC) AS RowAsc,
              ROW_NUMBER() OVER (
                 ORDER BY bonus DESC, BusinessEntityID DESC) AS RowDesc
       FROM Sales.SalesPerson sp) x
       WHERE RowAsc IN (RowDesc, RowDesc - 1, RowDesc + 1)),
temp2 AS
   (SELECT MIN(bonus) AS Minimum, MAX(bonus) AS Maximum, ROUND(AVG(Bonus), 2) AS Average
    FROM Sales.SalesPerson)
SELECT 'Bonus' AS ' ', Maximum, Minimum, Average, Median
FROM temp1
CROSS JOIN temp2;


-- Use PERCENTILE_CONT(0.5)

SELECT 'Bonus' AS ' ',
       MAX(Bonus) AS Maximum,
       MIN(Bonus) AS Minimum,
       ROUND(AVG(Bonus), 2) AS Average,
       (SELECT DISTINCT PERCENTILE_CONT(0.5) 
        WITHIN GROUP (ORDER BY Bonus)OVER () 
        From Sales.SalesPerson) AS Median
FROM Sales.SalesPerson;

