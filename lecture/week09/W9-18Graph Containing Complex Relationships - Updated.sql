
/* Graph containing complex relationships
   The code works with SQL Server 2017 and beyond */

/* Use local SQL Server 2017
   or
   SQL Server 2017 class server at:
   is-swang01.ischool.uw.edu,1435
*/

CREATE DATABASE GraphMtM;
GO

-- Create a NODE table

USE GraphMtM;

CREATE TABLE [dbo].[Employee](
	[EmployeeID] [int] NOT NULL,
	[LastName] [nvarchar](20) NOT NULL,
	[FirstName] [nvarchar](10) NOT NULL,
	[Department] [varchar](20) NULL
) AS NODE;

GO
INSERT [dbo].[Employee] ([EmployeeID], [LastName], [FirstName], [Department]) VALUES (1, N'Davolio', N'Nancy', N'IT')
GO
INSERT [dbo].[Employee] ([EmployeeID], [LastName], [FirstName], [Department]) VALUES (2, N'Fuller', N'Andrew', NULL)
GO
INSERT [dbo].[Employee] ([EmployeeID], [LastName], [FirstName], [Department]) VALUES (3, N'Leverling', N'Janet', N'IT')
GO
INSERT [dbo].[Employee] ([EmployeeID], [LastName], [FirstName], [Department]) VALUES (4, N'Peacock', N'Margaret', N'IT')
GO
INSERT [dbo].[Employee] ([EmployeeID], [LastName], [FirstName], [Department]) VALUES (5, N'Buchanan', N'Steven', N'Finance')
GO
INSERT [dbo].[Employee] ([EmployeeID], [LastName], [FirstName], [Department]) VALUES (6, N'Suyama', N'Michael', N'Finance')
GO
INSERT [dbo].[Employee] ([EmployeeID], [LastName], [FirstName], [Department]) VALUES (7, N'King', N'Robert', N'Finance')
GO
INSERT [dbo].[Employee] ([EmployeeID], [LastName], [FirstName], [Department]) VALUES (8, N'Callahan', N'Laura', N'IT')
GO
INSERT [dbo].[Employee] ([EmployeeID], [LastName], [FirstName], [Department]) VALUES (9, N'Dodsworth', N'Anne', N'IT')
GO
INSERT [dbo].[Employee] ([EmployeeID], [LastName], [FirstName], [Department]) VALUES (10, N'Robinson', N'Peter', N'IT')
GO
INSERT [dbo].[Employee] ([EmployeeID], [LastName], [FirstName], [Department]) VALUES (11, N'Smith', N'Mary', N'IT')
GO
INSERT [dbo].[Employee] ([EmployeeID], [LastName], [FirstName], [Department]) VALUES (12, N'Chang', N'Leslie', N'Finance')
GO
INSERT [dbo].[Employee] ([EmployeeID], [LastName], [FirstName], [Department]) VALUES (13, N'Morales', N'Conney', N'Finance')
GO
INSERT [dbo].[Employee] ([EmployeeID], [LastName], [FirstName], [Department]) VALUES (14, N'Ng', N'Jordan', N'Finance')
GO
INSERT [dbo].[Employee] ([EmployeeID], [LastName], [FirstName], [Department]) VALUES (15, N'Black', N'Lela', N'IT')
GO
INSERT [dbo].[Employee] ([EmployeeID], [LastName], [FirstName], [Department]) VALUES (16, N'Lee', N'Josh', N'Finance')
GO
INSERT [dbo].[Employee] ([EmployeeID], [LastName], [FirstName], [Department]) VALUES (17, N'Spencer', N'Monica', N'Finance')
GO
INSERT [dbo].[Employee] ([EmployeeID], [LastName], [FirstName], [Department]) VALUES (19, N'Smith', N'JoAnna', N'Finance')
GO
INSERT [dbo].[Employee] ([EmployeeID], [LastName], [FirstName], [Department]) VALUES (20, N'White', N'Peter', N'Finance')
GO
INSERT [dbo].[Employee] ([EmployeeID], [LastName], [FirstName], [Department]) VALUES (21, N'Thompson', N'Connie', N'IT')
GO
INSERT [dbo].[Employee] ([EmployeeID], [LastName], [FirstName], [Department]) VALUES (22, N'Norman', N'Alyssa', N'Finance')
GO

-- Create an EDGE table for storing relationships

CREATE TABLE dbo.WorkFor AS EDGE;
GO

INSERT INTO dbo.WorkFor 
VALUES(
(SELECT $node_id FROM [dbo].[Employee] WHERE [EmployeeID] = 3),
(SELECT $node_id FROM [dbo].[Employee] WHERE [EmployeeID] = 2));

INSERT INTO dbo.WorkFor 
VALUES(
(SELECT $node_id FROM [dbo].[Employee] WHERE [EmployeeID] = 5),
(SELECT $node_id FROM [dbo].[Employee] WHERE [EmployeeID] = 2));

INSERT INTO dbo.WorkFor 
VALUES(
(SELECT $node_id FROM [dbo].[Employee] WHERE [EmployeeID] = 7),
(SELECT $node_id FROM [dbo].[Employee] WHERE [EmployeeID] = 5));

INSERT INTO dbo.WorkFor
VALUES(
(SELECT $node_id FROM [dbo].[Employee] WHERE [EmployeeID] = 7),
(SELECT $node_id FROM [dbo].[Employee] WHERE [EmployeeID] = 2));

INSERT INTO dbo.WorkFor
VALUES(
(SELECT $node_id FROM [dbo].[Employee] WHERE [EmployeeID] = 7),
(SELECT $node_id FROM [dbo].[Employee] WHERE [EmployeeID] = 3));

INSERT INTO dbo.WorkFor
VALUES(
(SELECT $node_id FROM [dbo].[Employee] WHERE [EmployeeID] = 12),
(SELECT $node_id FROM [dbo].[Employee] WHERE [EmployeeID] = 7));

INSERT INTO dbo.WorkFor
VALUES(
(SELECT $node_id FROM [dbo].[Employee] WHERE [EmployeeID] = 14),
(SELECT $node_id FROM [dbo].[Employee] WHERE [EmployeeID] = 7));

INSERT INTO dbo.WorkFor
VALUES(
(SELECT $node_id FROM [dbo].[Employee] WHERE [EmployeeID] = 15),
(SELECT $node_id FROM [dbo].[Employee] WHERE [EmployeeID] = 7));

INSERT INTO dbo.WorkFor
VALUES(
(SELECT $node_id FROM [dbo].[Employee] WHERE [EmployeeID] = 21),
(SELECT $node_id FROM [dbo].[Employee] WHERE [EmployeeID] = 15));

INSERT INTO dbo.WorkFor
VALUES(
(SELECT $node_id FROM [dbo].[Employee] WHERE [EmployeeID] = 15),
(SELECT $node_id FROM [dbo].[Employee] WHERE [EmployeeID] = 2));

-- Retrieve employees who work for 2 directly

SELECT E1.EmployeeID AS TeamMembers, E1.FirstName, E1.LastName, E1.Department
FROM Employee E1, WorkFor, Employee E2
WHERE MATCH(E1-(WorkFor)->E2)
AND E2.EmployeeID = 2;

-- Retrieve Employee 7's direct supervisors

SELECT E1.EmployeeID AS TeamLeads, E1.FirstName, E1.LastName, E1.Department
FROM Employee E1, WorkFor, Employee E2
WHERE MATCH(E1<-(WorkFor)-E2)
AND E2.EmployeeID = 7;

-- Retrieve employees who work for 7 directly

SELECT E1.EmployeeID AS TeamMembers, E1.FirstName, E1.LastName, E1.Department
FROM Employee E1, WorkFor, Employee E2
WHERE MATCH(E1-(WorkFor)->E2)
AND E2.EmployeeID = 7;


-- Retrieve employees who work for 2 indirectly

SELECT E1.EmployeeID AS TeamMembers, E1.FirstName, E1.LastName, E1.Department
FROM Employee E1, WorkFor W1, Employee E2, WorkFor W2, Employee E3
WHERE MATCH(E1-(W1)->E2-(W2)->E3)
AND E3.EmployeeID = 2;



-- USE Master;
-- DROP DATABASE GraphMtM;

