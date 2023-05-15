SELECT
	t.name AS table_name,
	i.name AS PK_name,
	'EXEC sp_rename ''' + i.name + ''', ''PK_' + t.name + ''';' AS PK_rename
FROM sys.tables AS t
JOIN sys.indexes AS i
ON t.object_id = i.object_id
WHERE i.name <> 'PK_' + t.name
AND index_id = 1