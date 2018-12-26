--------------------------------------------------------------------------
/* SELF JOIN */
--------------------------------------------------------------------------

USE Northwind;

-- Update Employees table to set up deeper levels of supervisors.

-- See what we have before making the changes.

SELECT 
		EmployeeID
		, FirstName
		, LastName
		, Title
		, ReportsTo
FROM Employees;

-- Make the changes.

UPDATE Employees
SET ReportsTo = 3
WHERE EmployeeID IN (1, 4);

UPDATE Employees
SET ReportsTo = 4
WHERE EmployeeID IN (8, 9);

-- See what we have after making the changes.

SELECT 
		EmployeeID
		, FirstName
		, LastName
		, Title
		, ReportsTo
FROM Employees;

-- Create a self join to show the name of each person's immediate manager.

-- We'll use different aliases for the same table, Employees, in SELF JOIN.

SELECT
	  Emp.EmployeeID AS EmpID
	  ,Emp.LastName AS EmpName
	  ,Emp.ReportsTo
FROM Employees Emp;

SELECT
	  Mgr.EmployeeID AS MgrID
	  ,Mgr.LastName AS MgrName
FROM Employees Mgr;

-- Perform SELF JOIN.
-- Exclude top manager from list.

SELECT
	  Emp.Employeeid AS EmpID
	  ,Emp.LastName AS EmpName
	  ,Emp.ReportsTo
	  ,Mgr.EmployeeID AS MgrID
	  ,Mgr.LastName AS MgrName
FROM Employees Emp 
INNER JOIN Employees Mgr
	ON Emp.ReportsTo = Mgr.EmployeeID;

-- Include top manager in list.

SELECT
	  Emp.Employeeid AS EmpID
	  ,Emp.LastName AS EmpName
	  ,Emp.ReportsTo
	  ,Mgr.EmployeeID AS MgrID
	  ,Mgr.LastName AS MgrName
FROM Employees Emp 
LEFT OUTER JOIN Employees Mgr
	ON Emp.ReportsTo  = Mgr.EmployeeID;
	
