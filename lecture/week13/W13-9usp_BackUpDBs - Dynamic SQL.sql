
CREATE PROC [dbo].[usp_BackUpDBs]
AS
BEGIN

DECLARE @name VARCHAR(100) -- database name  
DECLARE @path VARCHAR(256) -- path for backup files  
DECLARE @fileName VARCHAR(256) -- filename for backup  
DECLARE @fileDate VARCHAR(20) -- used for file name 

SET @path = 'E:\SQL01\'  

SELECT @fileDate = CONVERT(VARCHAR(20),GETDATE(),112) 

DECLARE db_cursor CURSOR FOR  
SELECT name 
FROM MASTER.sys.databases 
WHERE name NOT IN ('tempdb') and
      state_desc = 'ONLINE'

OPEN db_cursor   
FETCH NEXT FROM db_cursor INTO @name   

WHILE @@FETCH_STATUS = 0   
BEGIN   
       SET @fileName = @path + @name + '_' + @fileDate + '.BAK'  
	   -- BACKUP DATABASE @name TO DISK = @fileName WITH COMPRESSION, INIT, FORMAT
       print 'BACKUP DATABASE '+ @name + ' TO DISK = ' + @fileName +' WITH COMPRESSION, INIT, FORMAT'
       FETCH NEXT FROM db_cursor INTO @name   
END   

CLOSE db_cursor   
DEALLOCATE db_cursor 

END
