SELECT
	tb.name				AS TableName,
	c.name				AS ColumnsName,
	t.name 				AS ColumnType,
	c.max_length		AS ColumnsLength, --length = -1 is (max)
	CASE c.is_nullable
		WHEN 1 THEN 'NULL'
		ELSE 'NOT NULL '
	END					AS [IsNull],
	c.is_identity,
	c.collation_name
FROM sys.all_columns AS c
JOIN sys.types AS t
ON c.system_type_id = t.system_type_id
JOIN (SELECT NAME, OBJECT_ID FROM sys.tables) AS tb
ON tb.object_id = c.object_id
WHERE t.NAME != 'sysname'
--AND tb.NAME = 'ticket'
--AND t.name = 'nvarchar'


/*----------------------ALL COLUMNS IMFORMATION----------------------*/

SELECT
	tb.NAME AS TableName,
	t.NAME 	AS ColumnType,
	c.*
FROM sys.all_columns AS c
JOIN sys.types AS t
ON c.system_type_id = t.system_type_id
JOIN (SELECT NAME, OBJECT_ID FROM sys.tables) AS tb
ON tb.object_id = c.object_id
WHERE t.NAME != 'sysname'
--AND tb.NAME = 'ticket'
--AND t.name = 'nvarchar'