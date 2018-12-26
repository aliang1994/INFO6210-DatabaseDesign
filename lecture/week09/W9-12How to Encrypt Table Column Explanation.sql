-- Encrypt Table Columns
-- Demo different data types
USE LIANG_WENQING_TEST;


-- Create New DB
CREATE DATABASE DemoEncrypt;

USE DemoEncrypt;

-- Create DMK
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'Test_P@sswOrd';

-- Create certificate to protect symmetric key
CREATE CERTIFICATE TestCertificate
WITH SUBJECT = 'AdventureWorks Test Certificate',
EXPIRY_DATE = '2026-10-31';

-- Create symmetric key to encrypt data
CREATE SYMMETRIC KEY TestSymmetricKey
WITH ALGORITHM = AES_128
ENCRYPTION BY CERTIFICATE TestCertificate;

-- Open symmetric key
OPEN SYMMETRIC KEY TestSymmetricKey
DECRYPTION BY CERTIFICATE TestCertificate;

-- Create a demo table
-- Use VARBINARY as the data type for the encrypted column
create table RegisteredUser
(
	UserName VARCHAR(100),
	EncryptedPassword VARBINARY(250)
);

SELECT * FROM RegisteredUser;
-- Put a row in the table
-- Use CONVERT to convert the plain data to VARBINARY
INSERT
INTO RegisteredUser(
	UserName,
	EncryptedPassword 
)
VALUES
('User 1' , EncryptByKey(Key_GUID(N'TestSymmetricKey'), convert(varbinary, 'PassTS1')));



-- Put another row in the table
-- Don't convert the plain data
-- SQL Server will do implicit conversion
INSERT
INTO RegisteredUser(
	UserName,
	EncryptedPassword 
)
VALUES
('User 2' , EncryptByKey(Key_GUID(N'TestSymmetricKey'), 'PassTS2'));




-- See what we have in the table
select * from RegisteredUser;

-- Use DecryptByKey to decrypt the encrypted data and see what we have in the table
select username, DecryptByKey(EncryptedPassword) dec_key
from RegisteredUser;




-- Use DecryptByKey to decrypt the encrypted data and see what we have in the table
-- DecryptByKey returns VARBINARY with a maximum size of 8,000 bytes
-- Also use CONVERT to convert the decrypted data to VARCHAR so that we can see the plain passwords
select username, convert(varchar, DecryptByKey(EncryptedPassword))
from RegisteredUser;

-- Do housekeeping
drop table RegisteredUser;














-- Recreate the demo table
-- Use VARCHAR as the data type for the encrypted column
create table RegisteredUser
(
	UserName VARCHAR(100),
	EncryptedPassword VARCHAR(250)
);

-- Put a row in the table
-- Use CONVERT to convert the plain data to VARBINARY
INSERT
INTO RegisteredUser
(
	UserName,
	EncryptedPassword 
)
VALUES
('User 1' , EncryptByKey(Key_GUID(N'TestSymmetricKey'), convert(varbinary, 'PassTS1')));

select * from RegisteredUser;

-- Put another row in the table
-- Don't convert the plain data
-- SQL Server will do implicit conversion
-- EncryptByKey returns VARBINARY with a maximum size of 8,000 bytes
INSERT
INTO RegisteredUser
(
	UserName,
	EncryptedPassword 
)
VALUES
('User 2' , EncryptByKey(Key_GUID(N'TestSymmetricKey'), 'PassTS2'));

-- See what we have in the table
select * from RegisteredUser;

-- Use DecryptByKey to decrypt the encrypted data and see what we have in the table
select username, DecryptByKey(EncryptedPassword)
from RegisteredUser;

-- Use DecryptByKey to decrypt the encrypted data and see what we have in the table
-- DecryptByKey returns VARBINARY with a maximum size of 8,000 bytes
-- Also use CONVERT to convert the decrypted data to VARCHAR so that we can see the plain passwords
select username, convert(varchar, DecryptByKey(EncryptedPassword))
from RegisteredUser;

-- Do housekeeping
drop table RegisteredUser;

-- Close the symmetric key
CLOSE SYMMETRIC KEY TestSymmetricKey;

-- Drop the symmetric key
DROP SYMMETRIC KEY TestSymmetricKey;

-- Drop the certificate
DROP CERTIFICATE TestCertificate;

--Drop the DMK
DROP MASTER KEY;

USE Master;

--Drop Database
DROP DATABASE DemoEncrypt;

