
-----------------   QUIZ 2       NUID Last Digit 3 or 4   -----------------

-- Your Name: WENQING LIANG
-- Your NUID: 001873144

------------------------- Question 1 (2 points) ----------------

/* Rewrite the following query to present the same data in a horizontal format
   using the SQL PIVOT command. Your report should have the format listed below.
   
TerritoryID		2008-3-1	2008-3-2	2008-3-3	2008-3-4	2008-3-5
	1				34			7			9			8			12
	2				12			0			0			0			0
	3				13			0			0			0			0
	4				46			14			10			10			13
	5				15			0			0			0			0    
*/

USE AdventureWorks2008R2;

SELECT TerritoryID, CAST(OrderDate AS DATE) [Order Date], COUNT(CustomerID) AS [Customer Count]
FROM Sales.SalesOrderHeader
WHERE OrderDate BETWEEN '3-1-2008' AND '3-5-2008'
GROUP BY TerritoryID, OrderDate
ORDER BY TerritoryID, OrderDate;


--pivot table


SELECT TerritoryID, [2008-3-1], [2008-3-2], [2008-3-3], [2008-3-4], [2008-3-5]
FROM 
(SELECT TerritoryID, CAST(OrderDate AS DATE) [Order Date], CustomerID FROM Sales.SalesOrderHeader) SourceTable
PIVOT(
  COUNT (CustomerID) FOR [Order Date] IN ([2008-3-1], [2008-3-2], [2008-3-3], [2008-3-4], [2008-3-5])
) AS PivotTable;








------------------------- Question 2 (3 points) ----------------------

/* Write a query to retrieve the top five customers of each territory.
   Use the sum of TotalDue in SalesOrderHeader to determine the total purchase amounts.
   The top 5 customers have the five highest total purchase amounts. Your solution
   should retrieve a tie if there is any. The report should have the following format.
   Sort the report by TerritoryID.

TerritoryID	Top5Customers
	1		Harui Roger, Camacho Lindsey, Bready Richard, Ferrier Fran�ois, Vanderkamp Margaret
	2		DeGrasse Kirk, Lum Richard, Hirota Nancy, Duerr Bernard, Browning Dave
	3		Hendricks Valerie, Kirilov Anton, Kennedy Mitch, Abercrombie Kim, Huntsman Phyllis
	4		Vessa Robert, Cereghino Stacey, Dockter Blaine, Liu Kevin, Arthur John
	5		Dixon Andrew, Allen Phyllis, Cantoni Joseph, Hendergart James, Dennis Helen   
*/

USE AdventureWorks2008R2;

WITH temp AS
   (SELECT DISTINCT
	    sh.TerritoryID, 
	    pp.FirstName,
	    pp.LastName,
	    SUM(sh.TotalDue) AS TotalSum,
	    RANK() OVER (PARTITION BY sh.TerritoryID ORDER BY SUM(sh.TotalDue) DESC ) AS OrderRank
	FROM Sales.SalesOrderHeader sh
	INNER JOIN Sales.Customer sc ON sh.CustomerID = sc.CustomerID
	INNER JOIN Person.Person pp ON sc.PersonID = pp.BusinessEntityID
	GROUP BY sh.TerritoryID, pp.FirstName, pp.LastName) 
	
SELECT DISTINCT 
	t2.TerritoryID, 
	STUFF(
		(SELECT  ', '+RTRIM(CAST(LastName as char)) +' '+ RTRIM(CAST(FirstName as char))   
		FROM temp t1 
		WHERE t1.TerritoryID = t2.TerritoryID 
		AND t1.OrderRank< 6
		FOR XML PATH('')) , 1, 2, '') AS listCustomers
FROM temp t2
ORDER BY TerritoryID;




------------------------- Question 3 (2 points) ----------------------

/* Use the function below and Person.Person to create a report.
   Include the SalespersonID, LastName, FirstName, SalesOrderID, OrderDate and TotalDue
   columns in the report. Don't modify the function.
   Sort he report by SalespersonID. */

-- Get a salesperson's orders
create function dbo.ufGetSalespersonOrders
(@spid int)
returns table
as return
select SalespersonID, SalesOrderID, OrderDate, TotalDue
from Sales.SalesOrderHeader
where SalespersonID=@spid;


SELECT DISTINCT
    sh.SalesPersonID, 
    pp.FirstName,
    pp.LastName,
    ufo.SalesOrderID,
    ufo.OrderDate,
    ufo.TotalDue
FROM Sales.SalesOrderHeader sh
INNER JOIN Sales.SalesPerson sp ON sh.SalesPersonID = sp.BusinessEntityID
INNER JOIN Person.Person pp ON sp.BusinessEntityID = pp.BusinessEntityID
CROSS APPLY dbo.ufGetSalespersonOrders(sh.SalesPersonID) ufo
ORDER BY sh.SalesPersonID;





/* Given five tables as defined below for Questions 4 and 5 */
USE LIANG_WENQING_TEST;

CREATE SCHEMA quiz2;

CREATE TABLE quiz2.Department
 (DepartmentID INT PRIMARY KEY,
  Name VARCHAR(50));

CREATE TABLE quiz2.Employee
(EmployeeID INT PRIMARY KEY,
 LastName VARCHAR(50),
 FirsName VARCHAR(50),
 Salary DECIMAL(10,2),
 DepartmentID INT REFERENCES Department(DepartmentID),
 TerminateDate DATE);

CREATE TABLE quiz2.Project
(ProjectID INT PRIMARY KEY,
 Name VARCHAR(50));

CREATE TABLE quiz2.Assignment
(EmployeeID INT REFERENCES Employee(EmployeeID),
 ProjectID INT REFERENCES Project(ProjectID),
 StartDate DATE,
 EndDate DATE
 PRIMARY KEY (EmployeeID, ProjectID, StartDate));

CREATE TABLE quiz2.SalaryAudit
(LogID INT IDENTITY,
 EmployeeID INT,
 OldSalary DECIMAL(10,2),
 NewSalary DECIMAL(10,2),
 ChangedBy VARCHAR(50) DEFAULT original_login(),
 ChangeTime DATETIME DEFAULT GETDATE());


------------------------- Question 4 (4 points) ----------------------

/* There is a business rule that the company can not have have more than 10 active projects at the same time 
   and an active project team average size can not be greater than 50 empoyees. 
   An active project is a project which has at least one employee working on it. 
   Write a SINGLE table-level constraint to implement the rule. */



--int 0 = success, 1 = fail

CREATE FUNCTION quiz2.CheckProject (@pid int)
RETURNS smallint
AS
BEGIN
	DECLARE @checkresult smallint=0;
  
   	DECLARE @Countproject int = 0;
  	SELECT @Countproject = COUNT(DISTINCT ProjectID) FROM quiz2.Project;
  	IF @Countproject > 10
   		SET @checkresult = 1;
   	ELSE
   		DECLARE @Countemployee int = 0;
   		SELECT @Countemployee = COUNT(a.EmployeeID) FROM quiz2.Project p INNER JOIN quiz2.Assignment a on p.ProjectID=a.ProjectID
   		WHERE p.ProjectID = @pid;
		IF @Countemployee > 50 OR @Countemployee < 1
			SET @checkresult = 1; 
   RETURN @checkresult;
END;


ALTER TABLE quiz2.Project ADD CONSTRAINT validProject CHECK (quiz2.CheckProject(ProjectID) = 0);




------------------------- Question 5 (4 points) ----------------------

/* There is a business rule a salary adjustment cannot be greater than 10%.
   Also, any allowed adjustment must be logged in the SalaryAudit table.
   Please write a trigger to implement the rule. 
   Assume only one update takes place at a time. */

CREATE TRIGGER trig_Salary
ON quiz2.Employee
FOR UPDATE
AS 
BEGIN
	DECLARE @change float = 0.0;
	INSERT INTO quiz2.SalaryAudit (EmployeeID, OldSalary, NewSalary, ChangedBy)
       SELECT 
       		i.EmployeeID, 
            e.Salary,
            i.Salary,
            (i.Salary-e.Salary)/e.Salary
       FROM Inserted i
       INNER JOIN quiz2.Employee e ON i.EmployeeID = e.EmployeeID;
    SELECT @change = (i.Salary-e.Salary)/e.Salary FROM Inserted i INNER JOIN quiz2.Employee e ON i.EmployeeID = e.EmployeeID;
    IF @change > 0.1
	    BEGIN
		    ROLLBACK TRAN;
		    RAISERROR ('salary adjustment cannot be greater than 10%', 16, 1);
	    END;
END;






