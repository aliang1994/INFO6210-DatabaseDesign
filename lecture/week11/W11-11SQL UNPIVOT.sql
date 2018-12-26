
/* SQL UNPIVOT */
USE LIANG_WENQING_TEST;
-- Create demo table
CREATE TABLE dbo.CustomerPhone
(CustomerID INT,
 Phone1 varchar(20),
 Phone2 varchar(20),
 Phone3 varchar(20));

-- Insert some demo data
INSERT INTO CustomerPhone
VALUES
(1, 4252223535, 2061237878, NULL),
(2, 4255554343, 4256142000, 4257776565),
(3, 2057575, NULL, NULL);

-- See what we have in demo table
SELECT * FROM CustomerPhone;

-- Use SQL UNPIVOT to produce a better (normalized) report
SELECT CustomerID, Phone
FROM (
  SELECT CustomerID, Phone1, Phone2, Phone3 
  FROM dbo.CustomerPhone
) AS original
UNPIVOT 
(Phone FOR Phones IN (Phone1, Phone2, Phone3)
  /* Create a new row for every value found in the columns 
     Phone1, Phone2, and Phone3 */
) AS unp;

-- Do housekeeping
DROP TABLE dbo.CustomerPhone;
