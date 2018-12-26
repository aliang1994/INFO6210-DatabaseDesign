
-- StringToValues Function Return A Table Variable
USE LIANG_WENQING_TEST;
 


CREATE FUNCTION [dbo].StringToValues(@ListofIds nvarchar(max))
RETURNS @rtn TABLE (IntegerValue int)
AS
BEGIN
    WHILE(CHARINDEX(',', @ListofIds) > 0)
        BEGIN
            INSERT INTO @Rtn SELECT LTRIM(RTRIM(SUBSTRING(@ListofIds, 1, CHARINDEX(',', @ListofIds) - 1)));
            SET @ListofIds = SUBSTRING(@ListofIds, CHARINDEX(',', @ListofIds) + LEN(','), LEN(@ListofIds));
        END;
    INSERT INTO @Rtn SELECT LTRIM(RTRIM(@ListofIds));
    RETURN;
END;

-- Test the function

SELECT * FROM dbo.StringToValues('12100,14000,20000,38000,44220');

-- Housekeeping

DROP FUNCTION dbo.StringToValues;

/* NOTE: SQL INDEX STARTS FROM 1 INSTEAD OF 0 !!!!!!!!!
 * 
 * 
 * CHARINDEX ( expressionToFind , expressionToSearch, start_location [optional] ):   
 * This function searches for one character expression inside a second character expression, 
 * returning the starting position of the first expression if found.
 * 
 * 
 * SUBSTRING ( expression, start, length ):
 * Returns part of a character, binary, text, or image expression in SQL Server.
 * 
 * 
 * LEN ( string_expression ): 
 * Returns the number of characters of the specified string expression, excluding trailing blanks.
 * 
 * 
 */
