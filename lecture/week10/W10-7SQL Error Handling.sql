
-- SQL Programming Error Handling
-- TRY and CATCH

-- Put the code you want to monitor in the TRY block
-- Put your error handling code in the CATCH block
USE AdventureWorks2012;

BEGIN TRY
   CREATE TABLE DemoTable(
       FirstColumn int PRIMARY KEY
   );
END TRY

BEGIN CATCH  
    DECLARE @ErrorNo	int,
            @Severity   tinyint,
            @State      smallint,
            @LineNo     int,
            @Message    nvarchar(4000);
    SELECT 
        @ErrorNo = ERROR_NUMBER(),
        @Severity = ERROR_SEVERITY(),
        @State = ERROR_STATE(),
        @LineNo = ERROR_LINE (),
        @Message = ERROR_MESSAGE();

    IF @ErrorNo = 2714 -- Object exists error, we knew this could happen
        PRINT 'WARNING: Table already exists';
    ELSE -- Unexpected error; report it
        RAISERROR(@Message, 16, 1 );
END CATCH

-- Additional Info
-- http://msdn.microsoft.com/en-us/library/ms178592.aspx
-- http://technet.microsoft.com/en-us/library/aa937483(v=sql.80).aspx
-- http://www.codeproject.com/Articles/38991/A-Closer-Look-Inside-RAISERROR-SQLServer


