DECLARE @SQL NVARCHAR(MAX) = ''

SELECT @SQL += '
SELECT ''' + name + ''' AS DB,*
FROM ' + name + '.sys.tables
WHERE is_ms_shipped = 0
UNION
'
FROM sys.databases
WHERE database_id > 4
AND name LIKE 'source%'
AND name <> 'source_jobs'

SET @SQL = LEFT(@SQL, LEN(@SQL) - 8)

--SELECT @SQL
EXEC (@SQL)