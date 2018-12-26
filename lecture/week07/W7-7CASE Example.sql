
/* CASE Example */

DECLARE @month integer;
DECLARE @year integer;
DECLARE @DateTemp date;

SET @month = 2;
SET @year = 2016;
	
SET @DateTemp =	
	CASE when @month IN (4,6,9,11) then datefromparts (@year,@month,30)
		 when @month = 2 and @year%4 =0 then datefromparts (@year,@month,29)
		 when @month = 2 then datefromparts (@year,@month,28)
		 else datefromparts (@year,@month,31) 
	END;

SELECT @DateTemp;
