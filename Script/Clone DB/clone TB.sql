DROP TABLE IF EXISTS #TABLE;
CREATE TABLE #TABLE
(
	TB_name VARCHAR(100),
	create_table NVARCHAR(MAX),
	create_index NVARCHAR(MAX)
)

DECLARE
	@SQL NVARCHAR(MAX) = '',
	@SQL_TB NVARCHAR(MAX) = '',
	@SQL_CS NVARCHAR(MAX) = '',
	@SQL_IDX NVARCHAR(MAX) = '',
	@SQL_DF NVARCHAR(MAX) = '',
	@TB_name VARCHAR(100) = '',
	@TB_schema VARCHAR(100) = '',
	@ID INT = 1

WHILE(1 = 1)
BEGIN
	;WITH CTE
	AS
	(
		SELECT ROW_NUMBER() OVER(ORDER BY [name]) AS ID,[name]
		FROM sys.tables
	)
	SELECT
		@TB_name = [name],
		@TB_schema = (SELECT TABLE_SCHEMA FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = CTE.name)
	FROM CTE
	WHERE ID = @ID
	ORDER BY name

	IF @@ROWCOUNT = 0
		BREAK;

	-- TABLE COLUMN
	SELECT
		@SQL_TB += QUOTENAME(isc.column_name) + ' ' + QUOTENAME(isc.data_type) +
		CASE isc.data_type
			WHEN 'numeric' THEN '(' + CAST(isc.numeric_precision AS VARCHAR(3)) + ',' + CAST(isc.numeric_scale AS VARCHAR(3)) + ')'
			WHEN 'decimal' THEN '(' + CAST(isc.numeric_precision AS VARCHAR(3)) + ',' + CAST(isc.numeric_scale AS VARCHAR(3)) + ')'
			WHEN 'char'	   THEN '(' + CAST(isc.character_maximum_length AS VARCHAR(5)) + ')'
			WHEN 'nchar'   THEN '(' + CAST(isc.character_maximum_length AS VARCHAR(5)) + ')'
			WHEN 'time'    THEN '(' + CAST(isc.datetime_precision AS VARCHAR(2)) + ')'
			WHEN 'datetime2' THEN '(' + CAST(isc.datetime_precision AS VARCHAR(2)) + ')'
			WHEN 'varchar' THEN CASE isc.character_maximum_length WHEN -1 THEN '(MAX)' ELSE '(' + CAST(isc.character_maximum_length AS VARCHAR(5)) + ')' END
			WHEN 'nvarchar' THEN CASE isc.character_maximum_length WHEN -1 THEN '(MAX)' ELSE '(' + CAST(isc.character_maximum_length AS VARCHAR(5)) + ')' END
			WHEN 'varbinary' THEN CASE isc.character_maximum_length WHEN -1 THEN '(MAX)' ELSE '(' + CAST(isc.character_maximum_length AS VARCHAR(5)) + ')' END
		ELSE '' END +
		CASE WHEN col.is_identity = 1 THEN ' IDENTITY(' + CAST(IDENT_SEED(@TB_name) AS VARCHAR(5)) + ',' + CAST(IDENT_INCR(@TB_name) AS VARCHAR(5)) + ')' ELSE '' END +
		CASE WHEN isc.is_nullable = 'NO' THEN ' NOT NULL,' ELSE ' NULL,' END + '
		'
	FROM information_schema.columns isc
	JOIN sys.tables tb ON isc.table_name = tb.name
	JOIN sys.all_columns col ON tb.object_id = col.object_id AND isc.column_name = col.name
	WHERE tb.name = @TB_name

	-- CONSTRAINT INDEX
	IF EXISTS(SELECT 1 FROM sys.indexes WHERE OBJECT_NAME(object_id) = @TB_name AND (is_primary_key = 1 OR is_unique_constraint = 1))
	BEGIN
		SELECT @SQL_CS += ',
		CONSTRAINT ' + QUOTENAME(i.name) + CASE WHEN i.is_primary_key = 1 THEN ' PRIMARY KEY ' ELSE ' UNIQUE ' END + i.type_desc + '
		(
			' +
			STUFF((
				SELECT ',' + QUOTENAME(c.name) + CASE WHEN ic.is_descending_key = 0 THEN ' ASC' ELSE ' DESC' END
				FROM sys.index_columns ic
				JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
				WHERE ic.object_id = i.object_id
				AND ic.index_id = i.index_id
				FOR XML PATH('')
			), 1, 1, '') + '
		) WITH (PAD_INDEX = ' + CASE WHEN i.is_padded = 0 THEN 'OFF' ELSE 'ON' END +
		', IGNORE_DUP_KEY = ' + CASE WHEN i.ignore_dup_key = 0 THEN 'OFF' ELSE 'ON' END +
		', ALLOW_ROW_LOCKS = ' + CASE WHEN i.allow_row_locks = 0 THEN 'OFF' ELSE 'ON' END +
		', ALLOW_PAGE_LOCKS = ' + CASE WHEN i.allow_page_locks = 0 THEN 'OFF' ELSE 'ON' END +
		', FILLFACTOR = ' + CASE WHEN i.fill_factor = 0 THEN '100' ELSE CAST(i.fill_factor AS NVARCHAR(3)) END +
		', DATA_COMPRESSION = ' + CASE p.data_compression WHEN 0 THEN 'NONE' WHEN 1 THEN 'ROW' ELSE 'PAGE' END + ') ON [PRIMARY]'
		FROM sys.indexes i
		JOIN sys.partitions p ON p.object_id = i.object_id AND p.index_id = i.index_id
		WHERE OBJECT_NAME(i.object_id) = @TB_name
		AND (i.is_primary_key = 1 OR is_unique_constraint = 1)
	END

	--INDEX
	SELECT @SQL_IDX += '
	/******   ' + i.name + '   ******/
	CREATE ' + CASE WHEN i.is_unique = 1 THEN 'UNIQUE ' ELSE '' END + i.type_desc + ' INDEX ' + QUOTENAME(i.name) + ' ON ' + QUOTENAME(@TB_schema) + '.' + QUOTENAME(@TB_name) + '
	(
		' +
		STUFF((
			SELECT ',' + QUOTENAME(c.name) + CASE WHEN ic.is_descending_key = 0 THEN ' ASC' ELSE ' DESC' END
			FROM sys.index_columns ic
			JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
			WHERE ic.object_id = i.object_id
			AND ic.index_id = i.index_id
			AND ic.is_included_column <> 1
			FOR XML PATH('')
		), 1, 1, '') + '
	)' + CASE  --INCLUDE COLUMNS
			WHEN EXISTS
			(
				SELECT 1
				FROM sys.index_columns ic
				JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
				WHERE ic.object_id = i.object_id
				AND ic.index_id = i.index_id
				AND ic.is_included_column = 1
			) THEN '
	INCLUDE (' +
			STUFF((
				SELECT ',' + QUOTENAME(c.name)
				FROM sys.index_columns ic
				JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
				WHERE ic.object_id = i.object_id
				AND ic.index_id = i.index_id
				AND ic.is_included_column = 1
				FOR XML PATH('')
			), 1, 1, '') + ')'
			ELSE ''
		END
	+ CASE WHEN i.has_filter = 1 THEN 'WHERE ' + i.filter_definition ELSE '' END + '
	WITH (PAD_INDEX = ' + CASE WHEN i.is_padded = 0 THEN 'OFF' ELSE 'ON' END + ', SORT_IN_TEMPDB = OFF' +
	', IGNORE_DUP_KEY = ' + CASE WHEN i.ignore_dup_key = 0 THEN 'OFF' ELSE 'ON' END + ', DROP_EXISTING = OFF, ONLINE = OFF' +
	', ALLOW_ROW_LOCKS = ' + CASE WHEN i.allow_row_locks = 0 THEN 'OFF' ELSE 'ON' END +
	', ALLOW_PAGE_LOCKS = ' + CASE WHEN i.allow_page_locks = 0 THEN 'OFF' ELSE 'ON' END +
	', FILLFACTOR = ' + CASE WHEN i.fill_factor = 0 THEN '100' ELSE CAST(i.fill_factor AS NVARCHAR(3)) END +
	', DATA_COMPRESSION = ' + CASE p.data_compression WHEN 0 THEN 'NONE' WHEN 1 THEN 'ROW' ELSE 'PAGE' END + ') ON [PRIMARY]
	GO
	'
	FROM sys.indexes i
	JOIN sys.partitions p ON p.object_id = i.object_id AND p.index_id = i.index_id
	WHERE OBJECT_NAME(i.object_id) = @TB_name
	AND i.is_primary_key <> 1
	AND is_unique_constraint <> 1

	--COLUMN DEFAULT VALUES
	IF EXISTS(SELECT 1 FROM sys.all_columns WHERE default_object_id <> 0 AND OBJECT_NAME(object_id) = @TB_name)
	BEGIN
		SELECT @SQL_DF += '
	ALTER TABLE [dbo].' + QUOTENAME(@TB_name) + ' ADD DEFAULT ' + dc.definition + ' FOR ' + QUOTENAME(c.name) + '
	GO'
		FROM sys.default_constraints dc
		JOIN sys.columns c ON dc.parent_object_id = c.object_id AND dc.parent_column_id = c.column_id
		WHERE OBJECT_NAME(c.object_id) = @TB_name
	END

	--SQL RESULT
	SET @SQL = '
	CREATE TABLE ' + QUOTENAME(@TB_schema) + '.' + QUOTENAME(@TB_name) + '
	(
		' + STUFF(@SQL_TB,LEN(@SQL_TB) - 4,LEN(@SQL_TB) - 4,'') + @SQL_CS + '
	) ON [PRIMARY]
	GO
	' + @SQL_DF + '
	----------------------------------------------------------------------------------------------------------
	'

	INSERT INTO #TABLE VALUES(@TB_name,@SQL,@SQL_IDX)

	SET @SQL_TB = ''
	SET @SQL_CS = ''
	SET @SQL_IDX = ''
	SET @SQL_DF = ''
	SET @SQL = ''
	SET @ID += 1
END

SELECT * FROM #TABLE
WHERE 1 = 1
AND TB_name = 'Create_Code_Table'
ORDER BY TB_name