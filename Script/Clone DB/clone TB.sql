DROP TABLE IF EXISTS #TABLE;
CREATE TABLE #TABLE
(
	TB_name VARCHAR(100),
	create_script NVARCHAR(MAX)
)

DECLARE
	@SQL NVARCHAR(MAX) = '',
	@SQL_TB NVARCHAR(MAX) = '',
	@TB_name VARCHAR(100) = '',
	@ID INT = 1

WHILE(1 = 1)
BEGIN
	;WITH CTE
	AS
	(
		SELECT ROW_NUMBER() OVER(ORDER BY [name]) AS ID,[name]
		FROM sys.tables
	)
	SELECT @TB_name = [name]
	FROM CTE
	WHERE ID = @ID
	ORDER BY name

	IF @@ROWCOUNT = 0
		BREAK;

	SELECT
		@SQL_TB += QUOTENAME(isc.column_name) + ' ' + QUOTENAME(isc.data_type) +
		CASE isc.data_type
			WHEN 'numeric' THEN '(' + CAST(isc.numeric_precision AS VARCHAR(3)) + ',' + CAST(isc.numeric_scale AS VARCHAR(3)) + ')'
			WHEN 'decimal' THEN '(' + CAST(isc.numeric_precision AS VARCHAR(3)) + ',' + CAST(isc.numeric_scale AS VARCHAR(3)) + ')'
			WHEN 'varchar' THEN '(' + CAST(isc.character_maximum_length AS VARCHAR(10)) + ')'
		ELSE '' END +
		CASE WHEN col.is_identity = 1 THEN ' IDENTITY(' + CAST(IDENT_SEED(@TB_name) AS VARCHAR(5)) + ',' + CAST(IDENT_INCR(@TB_name) AS VARCHAR(5)) + ')' ELSE '' END +
		CASE WHEN isc.is_nullable = 'NO' THEN ' NOT NULL' ELSE ' NULL' END +
		CASE WHEN (SELECT COUNT(1) FROM sys.indexes WHERE OBJECT_NAME(object_id) = @TB_name AND is_primary_key = 1) = 1 THEN ',' ELSE '' END + '
		'
	FROM information_schema.columns isc
	JOIN sys.tables tb ON isc.table_name = tb.name
	JOIN sys.all_columns col ON tb.object_id = col.object_id AND isc.column_name = col.name
	WHERE tb.name = @TB_name

	SELECT @SQL = '
	CREATE TABLE [dbo].[' + @TB_name + '](
		' + @SQL_TB +
		CASE WHEN EXISTS(SELECT name FROM sys.indexes WHERE OBJECT_NAME(object_id) = @TB_name AND is_primary_key = 1)
		THEN 'CONSTRAINT [' + (SELECT name FROM sys.indexes WHERE OBJECT_NAME(object_id) = @TB_name AND is_primary_key = 1) + '] PRIMARY KEY CLUSTERED
		(
			' +
		STUFF((
			SELECT ',' + QUOTENAME(c.name) + CASE WHEN ic.is_descending_key = 0 THEN ' ASC' ELSE ' DESC' END
			FROM sys.indexes i
			JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
			JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
			WHERE i.is_primary_key = 1
			AND OBJECT_NAME(i.object_id) = @TB_name
			FOR XML PATH(''))
		,1,1,'') + '
		)WITH (PAD_INDEX = ' + CASE WHEN (SELECT is_padded FROM sys.indexes WHERE is_primary_key = 1 AND OBJECT_NAME(object_id) = @TB_name) = 0 THEN 'OFF, ' ELSE 'ON, ' END +
		'IGNORE_DUP_KEY = ' + CASE WHEN (SELECT ignore_dup_key FROM sys.indexes WHERE is_primary_key = 1 AND OBJECT_NAME(object_id) = @TB_name) = 0 THEN 'OFF, ' ELSE 'ON, ' END +
		'ALLOW_ROW_LOCKS = ' + CASE WHEN (SELECT allow_row_locks FROM sys.indexes WHERE is_primary_key = 1 AND OBJECT_NAME(object_id) = @TB_name) = 0 THEN 'OFF, ' ELSE 'ON, ' END +
		'ALLOW_PAGE_LOCKS = ' + CASE WHEN (SELECT allow_page_locks FROM sys.indexes WHERE is_primary_key = 1 AND OBJECT_NAME(object_id) = @TB_name) = 0 THEN 'OFF, ' ELSE 'ON, ' END +
		'FILLFACTOR = ' + CASE WHEN (SELECT fill_factor FROM sys.indexes WHERE is_primary_key = 1 AND OBJECT_NAME(object_id) = @TB_name) = 0 THEN '100' ELSE (SELECT CAST(fill_factor AS VARCHAR(3)) FROM sys.indexes WHERE is_primary_key = 1 AND OBJECT_NAME(object_id) = @TB_name) END + ') ON [PRIMARY] '
		ELSE ')' END + '
	)ON [PRIMARY]
	GO'

	INSERT INTO #TABLE VALUES(@TB_name,@SQL)

	SET @SQL_TB = ''
	SET @SQL = ''
	SET @ID += 1
END

SELECT * FROM #TABLE
WHERE 1 = 1
--AND TB_name = 'test'
ORDER BY TB_name