USE Graph2;

Select * from dbo.OrgHierarchy;

WITH DirectReports AS (
		  -- Anchor member definition: level 0
		  SELECT
				ReportsTo, Department, EmployeeID, LastName, 0 AS [Level], CONVERT(NVARCHAR(20), NULL) AS MgrName
		  FROM OrgHierarchy e
		  WHERE ReportsTo IS NULL
		  
		  UNION ALL
		  
		   --Recursive member definition
		  SELECT
			   E.ReportsTo, E.Department, E.EmployeeID, E.LastName, [Level] + 1, 
			   (SELECT LastName FROM OrgHierarchy Emp WHERE Emp.EmployeeID = E.ReportsTo) AS MgrName
		  FROM OrgHierarchy E 
		  INNER JOIN DirectReports DR
		  ON E.ReportsTo = DR.EmployeeID
	 )
-- Statement that executes the CTE
SELECT EmployeeID AS EmpID, LastName AS EmpLName, Department, [Level], ReportsTo AS MgrID, MgrName AS MgrLName
FROM DirectReports
ORDER BY Department, [Level], LastName;