SELECT
    --QUOTENAME(SCHEMA_NAME(t.schema_id)) AS SchemaName,
    QUOTENAME(t.name) AS TableName,
    QUOTENAME(i.name) AS IndexName,
    STUFF((
        SELECT ',' + QUOTENAME(c.name) + CASE WHEN ic.is_descending_key = 1 THEN ' DESC' ELSE '' END AS [data()]
        FROM sys.index_columns AS ic
        INNER JOIN sys.columns AS c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
        WHERE ic.object_id = i.object_id AND ic.index_id = i.index_id AND ic.is_included_column = 0 AND key_ordinal > 0
        ORDER BY ic.key_ordinal
        FOR XML PATH('')
    ), 1, 1, '') AS KeyColumns,
    STUFF(REPLACE(REPLACE((
        SELECT QUOTENAME(c.name) AS [data()]
        FROM sys.index_columns AS ic
        INNER JOIN sys.columns AS c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
        WHERE ic.object_id = i.object_id AND ic.index_id = i.index_id AND ic.is_included_column = 1
        ORDER BY ic.index_column_id
        FOR XML PATH
    ), '<row>', ', '), '</row>', ''), 1, 2, '') AS IncludedColumns,
	i.type_desc,
    i.is_primary_key,
    i.is_unique,
    i.is_unique_constraint
FROM sys.tables AS t
INNER JOIN sys.indexes AS i ON t.object_id = i.object_id
WHERE t.is_ms_shipped = 0
AND i.type <> 0
--AND QUOTENAME(t.name) = '[ticket_all]'