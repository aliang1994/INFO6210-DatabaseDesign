
USE AdventureWorks2008R2;

-- Create query result in the Element Centric XML format

SELECT FirstName, MiddleName, LastName
FROM Person.Person AS Person
FOR XML AUTO, ROOT('FullName'), Elements;

-- Create query result in the Attribute Centric XML format

SELECT FirstName, MiddleName, LastName
FROM Person.Person AS Person
FOR XML AUTO, ROOT('FullName');