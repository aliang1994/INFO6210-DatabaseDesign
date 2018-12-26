
/* Import XML Data */

USE Northwind;

-- Creates an element-centric XML document.
SELECT c.CustomerID [CustID], CompanyName [Company], o.OrderID, o.OrderDate, o.CustomerID
FROM Customers c INNER JOIN Orders o
	ON c.CustomerID = o.CustomerID
ORDER BY c.CustomerID
FOR XML AUTO, ROOT('CustOrdRoot'), ELEMENTS;

-- Create a table for importing customer data.
IF EXISTS(SELECT name FROM sys.tables WHERE name = 'CustomersXML')
	DROP TABLE CustomersXML;
GO      
SELECT CustomerID, CompanyName
INTO CustomersXML
FROM Customers
WHERE 1=2;
GO

-- Read data into the CustomersXML table from the main element
--		(c) of an element-centric XML file .

-- All of the script below between the "***" lines has to be executed in
--		the same batch, as the declared variables only stay in
--		memory while the batch in which they are declared is
--		executing.

--*****************************************************************
-- Required to open XML file and get contents into memory.
DECLARE @XML xml;
SELECT @xml = x.a
FROM OPENROWSET(BULK 'C:\Backup\XML.xml', SINGLE_BLOB) AS x(a);
-- Required to prepare XML document for reading and to get a pointer
--		to access the prepared XML document in memory.
DECLARE @XMLDocPointer INT;
EXEC sp_xml_preparedocument @XMLDocPointer OUTPUT, @xml;
-- The OPENXML function reads the portions of the XML file as
--		indicated by the row pattern argument (Element named c) 
--		and the following WITH clause.
INSERT INTO CustomersXML
	(CustomerID, CompanyName)
SELECT CustID, Company
FROM OPENXML(@XMLDocPointer, '/CustOrdRoot/c', 2)	-- 2=element-centric
		WITH (CustID NCHAR(6),
			  Company NVARCHAR(40));
-- Always execute the following to clear the prepared document
--		from memory. This will run even if an error occurs above.
EXEC sp_xml_removedocument @XMLDocPointer;
--*******************************************************************

-- Data should now be available in the table.
SELECT * from CustomersXML;

-- Create a table for importing order data.
IF EXISTS(SELECT name FROM sys.tables WHERE name = 'OrdersXML')
	DROP TABLE OrdersXML;
GO      
CREATE TABLE OrdersXML
(
	OrderID INT,
	OrderDate DATETIME,
	CustomerID NCHAR(6)
);
GO

-- Read data into the OrdersXML table from the sub element
--		(o) of an element-centric XML file. 

-- All of the script below between the "***" lines has to be executed in
--		the same batch, as the declared variables only stay in
--		memory while the batch in which they are declared is
--		executing.

--*****************************************************************
-- Required to open XML file and get contents into memory.
DECLARE @XML xml;
SELECT @xml = x.a 
FROM OPENROWSET(BULK 'C:\Backup\XML.xml', SINGLE_BLOB) AS x(a);
-- Required to prepare XML document for reading and to get a pointer
--		to access the prepared XML document in memory.
DECLARE @XMLDocPointer INT;
EXEC sp_xml_preparedocument @XMLDocPointer OUTPUT, @xml;
-- The OPENXML function reads the portions of the XML file as
--		indicated by the row pattern argument (Sub Element named o) 
--		and the following WITH clause.
INSERT INTO OrdersXML
	(OrderID, OrderDate, CustomerID)
SELECT OrderID, OrderDate, CustomerID
FROM OPENXML(@XMLDocPointer, '//o', 2)

--FROM OPENXML(@XMLDocPointer, '/CustOrdRoot/c/o', 2)

		WITH (OrderID INT,
			  OrderDate DATETIME,
			  CustomerID NCHAR(6));
-- Always execute the following to clear the prepared document
--		from memory. This will run even if an error occurs above.
EXEC sp_xml_removedocument @XMLDocPointer;
--*******************************************************************

-- Data should now be available in the table.
SELECT * from OrdersXML;

-- Drop demo tables.
DROP TABLE CustomersXML;
DROP TABLE OrdersXML;

