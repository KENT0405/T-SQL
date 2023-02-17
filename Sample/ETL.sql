DECLARE @SQL VARCHAR(8000) = 'copy D:\Demo\sample.xlsx D:\Demo\Data\sample_copy.xlsx',
		@SQL_rename VARCHAR(8000) = 'ren D:\Demo\Data\sample_copy.xlsx sample' + CAST(CAST(FORMAT(GETDATE(),'yyMMddhhmmss') AS BIGINT) AS VARCHAR(50)) + '.xlsx'
--copy
EXECUTE sp_configure 'show advanced options', 1;  
RECONFIGURE;  

EXECUTE sp_configure 'xp_cmdshell', 1;
RECONFIGURE;  

EXEC master..xp_cmdshell @SQL

--strat job ETL
USE msdb ; 
GO
EXEC dbo.sp_start_job N'ETL'
GO

--rename
EXEC master..xp_cmdshell @SQL_rename

EXECUTE sp_configure 'show advanced options', 0;  
RECONFIGURE;  

/*
bcp "SELECT * FROM [fs_egame_data].[dbo].[merchant_relation]" queryout D:\Demo\sample.csv -c -t, -T
copy D:\Demo\sample.csv D:\Demo\Data\xxxx.csv
*/
