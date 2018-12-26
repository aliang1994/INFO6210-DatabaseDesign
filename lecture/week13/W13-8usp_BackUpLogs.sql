
CREATE PROC [dbo].[usp_BackUpLogs]
AS
BEGIN

   DECLARE @name VARCHAR(100) -- database name  

   DECLARE db_cursor CURSOR FOR  
     SELECT name
     FROM sys.databases
     WHERE recovery_model_desc = 'FULL'
	       and state_desc = 'ONLINE';

   OPEN db_cursor   
   FETCH NEXT FROM db_cursor INTO @name   

   WHILE @@FETCH_STATUS = 0   
   BEGIN   
       BACKUP LOG @name TO DISK = 'NUL:' ;
       FETCH NEXT FROM db_cursor INTO @name   
   END   

   CLOSE db_cursor   
   DEALLOCATE db_cursor 

END
