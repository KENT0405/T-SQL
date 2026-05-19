DECLARE @SQL NVARCHAR(MAX)

SET @SQL = N'
EXEC sp_dropserver ' + QUOTENAME(@@SERVERNAME,'''') + '

EXEC sp_addserver ' + QUOTENAME(HOST_NAME(),'''') + ',local
'

PRINT @SQL


--改完後要重啟SQL SERVER