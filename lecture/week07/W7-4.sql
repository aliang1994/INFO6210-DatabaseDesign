
-- W7-4 How to remove duplicates from a table;

USE LIANG_WENQING_TEST;


CREATE TABLE NameList (Name VARCHAR(50));


INSERT NameList (Name)
VALUES ('Peter'),
('Mary'),
('Josh'),
('Peter'),
('Amanda');

SELECT * FROM NameList;


-- Option 1
-- Use ROW_NUMBER() with PARTITION BY
DELETE dupes
FROM 
(SELECT ROW_NUMBER()
OVER (PARTITION BY Name ORDER BY Name) rownum
FROM NameList) dupes
WHERE dupes.rownum > 1;

-- Validate duplicates have been removed
SELECT Name FROM NameList ORDER BY Name;


-- Option 2
-- Use SELECT DISTINCT INTO a new table

-- Put the duplicate back first
INSERT NameList (Name)
VALUES ('Peter');

SELECT DISTINCT Name
INTO NewTable
FROM NameList;

-- Validate duplicates have been removed
SELECT Name FROM NewTable ORDER BY Name;



-- Do some housekeeping
DROP TABLE NameList;
DROP TABLE NewTable;