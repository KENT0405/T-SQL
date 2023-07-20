DECLARE
	 @source VARCHAR(50) = 'sys_currency_log'		--輸入源頭表
	,@target VARCHAR(50) = 'sys_currency_log_test'	--輸入想同步的表
	,@SQL	 NVARCHAR(MAX) = ''

SET @SQL = 
CASE WHEN (SELECT COUNT(*) FROM sys.tables WHERE [name] = '' + @target + '') = 0 
THEN--如果"沒有"這張表
'
	SELECT *
	INTO ' + @target + '
	FROM ' + @source + '
'
ELSE--如果"有"這張表
'
	TRUNCATE TABLE ' + @target + ';

	INSERT INTO ' + @target + '
	SELECT *
	FROM ' + @source + '
'
END

PRINT @SQL

EXEC sp_executesql @SQL



--SET IDENTITY_INSERT [ [ database_name . ] schema_name . ] table_name { ON | OFF }  