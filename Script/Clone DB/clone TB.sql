DECLARE
	@SQL NVARCHAR(MAX) = '',
	@SQL_TB NVARCHAR(MAX) = '',
	@TB_name VARCHAR(30) = '',
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
		CASE WHEN isc.is_nullable = 'NO' THEN ' NOT NULL,' ELSE ' NULL,' END + '
		'
	FROM information_schema.columns isc
	JOIN sys.tables tb ON isc.table_name = tb.name
	JOIN sys.all_columns col ON tb.object_id = col.object_id AND isc.column_name = col.name
	WHERE tb.name = @TB_name

	SELECT @SQL += '
	CREATE TABLE [dbo].[' + @TB_name + '](
		' + @SQL_TB

	SET @ID += 1
END

SELECT @SQL