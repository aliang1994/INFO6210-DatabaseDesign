-- Encrypt Table Columns


USE LIANG_WENQING_TEST;



-- Create New DB
CREATE DATABASE DemoEncrypt;
GO
USE DemoEncrypt;

-- Create a table to hold results
CREATE TABLE TempNames(
	BusinessEntityID int PRIMARY KEY,
	FirstName nvarchar(50),
	MiddleName nvarchar(50),
	LastName nvarchar(50),
	EncFirstName varbinary(200),
	EncMiddleName varbinary(200),
	EncLastName varbinary(200)
);

Select * From TempNames;



-- Encrytion
-- Create DMK
CREATE MASTER KEY ENCRYPTION 
BY PASSWORD = 'Test_P@sswOrd';

-- Create certificate to protect symmetric key
CREATE CERTIFICATE TestCertificate
WITH SUBJECT = 'Liang_wenqing Test Certificate',
EXPIRY_DATE = '2026-10-31';

-- Create symmetric key to encrypt data
CREATE SYMMETRIC KEY TestSymmetricKey
WITH ALGORITHM = AES_128
ENCRYPTION BY CERTIFICATE TestCertificate;

-- Open symmetric key
OPEN SYMMETRIC KEY TestSymmetricKey
DECRYPTION BY CERTIFICATE TestCertificate;





/* Populate temp table with 100 encrypted names from the Person.Person table */

INSERT
INTO TempNames(
	BusinessEntityID,
	EncFirstName,
	EncMiddleName,
	EncLastName
)
SELECT TOP(100) 
	BusinessEntityID,
	EncryptByKey(Key_GUID(N'TestSymmetricKey'), FirstName),
	EncryptByKey(Key_GUID(N'TestSymmetricKey'), MiddleName),
	EncryptByKey(Key_GUID(N'TestSymmetricKey'), LastName)
FROM AdventureWorks2012.Person.Person
ORDER BY BusinessEntityID;

/*
 * You may have seen Transact-SQL code that passes strings around using an N prefix. 
 * This denotes that the subsequent string is in Unicode (the N actually stands for National language character set).
 * Which means that you are passing an NCHAR, NVARCHAR or NTEXT value, as opposed to CHAR, VARCHAR or TEXT.
 */



-- Update the temp table with decrypted names
UPDATE TempNames
SET FirstName = DecryptByKey(EncFirstName),
	MiddleName = DecryptByKey(EncMiddleName),
	LastName = DecryptByKey(EncLastName);

-- Show the results
SELECT * FROM TempNames;


-- Close the symmetric key
CLOSE SYMMETRIC KEY TestSymmetricKey;






-- Database Clean Up
-- Drop the symmetric key
DROP SYMMETRIC KEY TestSymmetricKey;

-- Drop the certificate
DROP CERTIFICATE Liang_wenqing TestCertificate;

--Drop the DMK
DROP MASTER KEY;

USE Master;

--Drop Database
DROP DATABASE DemoEncrypt;

