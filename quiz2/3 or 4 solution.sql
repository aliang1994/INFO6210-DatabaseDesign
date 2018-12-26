
-----------------   3 or 4   ----------------------------

------------------------- Question 1 ----------------------

SELECT * --TerritoryID, '2008-3-1', '2008-3-2', '2008-3-3', '2008-3-4', '2008-3-5'
FROM (SELECT TerritoryID, OrderDate, CustomerID
      FROM Sales.SalesOrderHeader
      WHERE OrderDate BETWEEN '2008-3-1' AND '2008-3-5') AS S
PIVOT
     (COUNT(CustomerID) FOR OrderDate IN
	  ([2008-3-1], [2008-3-2], [2008-3-3], [2008-3-4], [2008-3-5]) )AS P




------------------------- Question 2 ----------------------

with temp as
(select sh.TerritoryID,  (p.LastName + ' ' + p.FirstName) as FullName,
	   rank() over (partition by sh.TerritoryID order by sum(sh.TotalDue) desc) Position
from Sales.SalesOrderHeader sh
join Sales.Customer c
on sh.CustomerID = c.CustomerID
join Person.Person p
on c.PersonID = p.BusinessEntityID
group by sh.TerritoryID, p.LastName, p.FirstName)

select distinct TerritoryID,

STUFF((SELECT  ', ' + FullName  
       FROM temp t1
       WHERE t1.TerritoryID = t2.TerritoryID and Position <=5
       FOR XML PATH('')) , 1, 2, '') AS Top5Customers

from temp t2
order by TerritoryID;




------------------------- Question 3 ----------------------

select SalespersonID, p.LastName, p.FirstName, o.SalesOrderID, o.OrderDate, o.TotalDue
from Person.Person p
cross apply dbo.ufGetSalespersonOrders (BusinessEntityID) o
order by o.SalespersonID;




------------------------- Question 4 ----------------------

create function ufCheckRule2
()
 returns smallint
 begin
    declare @flag smallint;
    if (select count(distinct ProjectID) from Assignment where enddate is null) > 10
	or cast(((select count(EmployeeID) from Assignment where enddate is null) / 
	   (select count(distinct ProjectID) from Assignment where enddate is null)) as decimal(3,2)) > 50
		
    set @flag = 1
    else set @flag = 0

	return @flag
 end

ALTER TABLE Assignment ADD CONSTRAINT AssignmentRule2 CHECK (dbo.ufCheckRule2() = 0);

ALTER TABLE dbo.Assignment drop CONSTRAINT AssignmentRule2




------------------------- Question 5 ----------------------

CREATE TRIGGER utrSalaryAudit ON Employee  
AFTER UPDATE
AS  
BEGIN
 
	IF UPDATE(Salary)
	begin

	   declare @perc decimal(3, 2)
	   select @perc = (i.salary - d.salary)/d.salary
	       FROM inserted AS i 
		   FULL JOIN deleted d
		   ON i.EmployeeID = d.EmployeeID;

	   IF @perc > 0.1

	       ROLLBACK Transaction

	   ELSE
	      INSERT INTO SalaryAudit (EmployeeID, OldSalary, NewSalary) 
		  (SELECT isnull(i.EmployeeID, d.EmployeeID), d.Salary, i.Salary
		   FROM inserted AS i 
		   FULL JOIN deleted d
		   ON i.EmployeeID = d.EmployeeID);	  
    end
END

drop TRIGGER utrSalaryAudit

