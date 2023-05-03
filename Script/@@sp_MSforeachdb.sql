DECLARE @mysql VARCHAR(4000)
SET @mysql = N'use ?
SELECT
	OBJECT_NAME(object_Id) AS ''資料表名稱'',
	DB_NAME() AS ''資料庫名稱''
FROM sys.tables
WHERE DB_NAME() NOT IN (''master'', ''model'', ''msdb'', ''tempdb'')
'
EXEC sp_MSforeachdb @mysql