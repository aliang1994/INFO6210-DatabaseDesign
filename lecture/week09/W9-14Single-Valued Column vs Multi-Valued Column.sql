
/* Single-Valued Column vs Multi-Valued Column For Reporting */





/* 1. For one customer */

-- vertical list
USE AdventureWorks2012;

SELECT SalesOrderID, CustomerID
FROM Sales.SalesOrderHeader 
WHERE CustomerID = 14328
ORDER BY SalesOrderID;


-- horizontal list

DECLARE @list varchar(max) = '';

SELECT @list = @list + ' ' + RTRIM(CAST(SalesOrderID as char)) + ',' 
FROM Sales.SalesOrderHeader 
WHERE CustomerID = 14328
ORDER BY SalesOrderID;

SELECT LEFT(@list, LEN(@list)-1) AS Orders;

/*
 * left(character, integer):
 * Returns the left part of a character string with the specified number of characters.
 * 
 */






/* 2. For many customers */


-- vertical list

SELECT DISTINCT h.CustomerID, p.FirstName, p.LastName, h.SalesOrderID   
FROM Sales.SalesOrderHeader h
JOIN Sales.Customer c
ON h.CustomerID = c.CustomerID
JOIN Person.Person p
ON c.PersonID = p.BusinessEntityID
ORDER BY CustomerID, SalesOrderID;

-- horizontal list

SELECT DISTINCT h.CustomerID, p.FirstName, p.LastName,
STUFF((SELECT  ', '+RTRIM(CAST(SalesOrderID as char))  
       FROM Sales.SalesOrderHeader 
       WHERE CustomerID = c.customerid
       ORDER BY SalesOrderID
       FOR XML PATH('')) , 1, 2, '') AS Orders
FROM Sales.SalesOrderHeader h
JOIN Sales.Customer c
ON h.CustomerID = c.CustomerID
JOIN Person.Person p
ON c.PersonID = p.BusinessEntityID
ORDER BY CustomerID;


/*
 * STUFF (character, start , length , replaceWith_expression):
 * The STUFF function inserts a string into another string. 
 * It deletes a specified length of characters in the first string at the start position 
 * and then inserts the second string into the first string at the start position.
 * 
 * SELECT STUFF('abcdef', 2, 3, 'ijklmn');  --> aijklmnef   
 */





