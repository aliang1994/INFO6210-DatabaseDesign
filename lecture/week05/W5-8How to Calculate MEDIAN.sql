
/* Calculate the highest, lowest, average, median and total bonus for salespeople */

/* Use MAX() for highest
       MIN() for lowest
	   AVG() for average
	    ?    for median
	   SUM() for total    */


WITH temp1 AS
(SELECT
   ((SELECT MAX(bonus) FROM
       (SELECT TOP 50 PERCENT bonus FROM Sales.SalesPerson ORDER BY bonus) AS BottomHalf)
    +
    (SELECT MIN(bonus) FROM
       (SELECT TOP 50 PERCENT bonus FROM Sales.SalesPerson ORDER BY bonus DESC) AS TopHalf)
   ) / 2 AS Median),
temp2 AS
(SELECT MIN(bonus) AS Minimum, MAX(bonus) AS Maximum, ROUND(AVG(bonus), 2) AS Average, SUM(bonus) AS Total
 FROM Sales.SalesPerson)
 
SELECT 'Bonus' AS ' ', Minimum, Maximum, Average, Median, Total
FROM temp1
CROSS JOIN temp2;


