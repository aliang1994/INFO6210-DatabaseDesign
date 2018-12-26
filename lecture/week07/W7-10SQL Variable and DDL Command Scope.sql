
-- Variable Scope

DECLARE @MyVarchar varchar(50);  --This DECLARE only lasts for this batch!

SELECT @MyVarchar = 'Hey, I''m home...';

PRINT 'Done with first Batch...';

GO

PRINT @MyVarchar;  --This generates an error since @MyVarchar
                   --isn't declared in this batch
PRINT 'Done with second Batch';

GO



DECLARE @MyVarchar varchar(50);  --This DECLARE only lasts for this batch!

SELECT @MyVarchar = 'Hey, I''m home...';

PRINT @MyVarchar;	


-- DDL Command Scope

CREATE DATABASE Test;

USE Test;



CREATE DATABASE Test;
GO

USE Test;


-- Housekeeping

Use Master;
DROP DATABASE Test;

