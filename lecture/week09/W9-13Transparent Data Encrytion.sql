-- Implement TDE: Transparent Data Encryption



USE master;
-- Create the database master key

CREATE MASTER KEY
ENCRYPTION BY PASSWORD = 'Test_P@sswOrd';

-- Create the server certificate

CREATE CERTIFICATE ServerCert
WITH SUBJECT = 'Server Certificate for TDE',
EXPIRY_DATE = '2020-12-31';




-- Create the demo database

CREATE DATABASE DemoTDE;

-- Change the database context to DemoTDE

USE DemoTDE;

-- Create the TDE encryption key and protect it with the server certificate

CREATE DATABASE ENCRYPTION KEY
WITH ALGORITHM = AES_128
ENCRYPTION BY SERVER CERTIFICATE ServerCert;

GO

-- Enable TDE on the demo database

ALTER DATABASE DemoTDE
SET ENCRYPTION ON;

-- Clean up

USE Master;
DROP DATABASE DemoTDE;
DROP CERTIFICATE ServerCert;
DROP MASTER KEY;


