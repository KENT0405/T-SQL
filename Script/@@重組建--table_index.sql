;WITH A
AS
(
	SELECT  LOWER(T.name) AS table_name
		   ,I.name AS index_name
		   ,I.type_desc AS index_type
		   ,ISNULL(F.name,S.name) AS file_group
		   ,P.rows
		   ,I.is_unique
		   ,I.is_primary_key
		   ,P.partition_number
		   ,'ALTER INDEX [' + I.name + '] ON ' + SCHEMA_NAME(t.schema_id) + '.' + OBJECT_NAME(T.object_id) + ' REBUILD PARTITION = ' +
		   CASE WHEN S.name IS NULL THEN 'ALL' ELSE CAST(P.partition_number AS VARCHAR) END + ' WITH (SORT_IN_TEMPDB = ON,ONLINE=ON);' AS rebuildstr
		   ,'ALTER INDEX [' + I.name + '] ON ' + SCHEMA_NAME(t.schema_id) + '.' + OBJECT_NAME(T.object_id) + ' REORGANIZE PARTITION = ' +
		   CASE WHEN S.name IS NULL THEN 'ALL' ELSE CAST(P.partition_number AS VARCHAR) END + ' WITH ( LOB_COMPACTION = ON );' reorganizestr
		   ,'UPDATE STATISTICS ' + OBJECT_NAME(T.object_id) AS updatestatstr
		   ,STATS_DATE(T.object_id,I.index_id) stats_time
		   ,O.create_date
		   ,p.object_id
		   ,p.index_id
	FROM sys.tables T JOIN sys.indexes I
	ON T.object_id = I.object_id
					  JOIN sys.partitions P
	ON I.object_id = P.object_id
	AND I.index_id = P.index_id
					  JOIN sys.objects O
	ON I.object_id = O.object_id
					  LEFT JOIN sys.filegroups F
	ON i.data_space_id = F.data_space_id
					  LEFT JOIN sys.partition_schemes S
	ON i.data_space_id = S.data_space_id
	WHERE 1 = 1

	--AND T.name = 'mem_info'
	--AND p.partition_number = 470
	--AND T.name LIKE '%daily_tran%'
	AND p.rows > 100
	AND i.name IS NOT NULL
)
SELECT table_name
	   ,index_name
	   ,index_type
	   ,file_group
	   ,rows
	   ,D.avg_fragmentation_in_percent
	   ,stats_time
	   ,create_date
	   ,is_unique
	   ,is_primary_key
	   ,A.partition_number
	   ,rebuildstr
	   ,reorganizestr
	   ,updatestatstr
FROM A CROSS APPLY sys.dm_db_index_physical_stats(DB_ID(), A.object_id , A.index_id , A.partition_number , NULL) D
WHERE 1 = 1
AND avg_fragmentation_in_percent> 10.0
--AND rows <= 10000000
AND file_group = 'PRIMARY'
--AND stats_time <= CAST(GETDATE()-7 AS DATE)
--AND stats_time IS NULL
--AND index_type <> 'CLUSTERED COLUMNSTORE'
ORDER BY 1 DESC
--ORDER BY avg_fragmentation_in_percent DESC

/*
SELECT
	t.name,
	i.name,
	'EXEC sp_rename ''dbo.' + t.name + '.' + i.name + ''',''PK_' + t.name + ''',''INDEX'''
FROM sys.tables t join sys.indexes i
on t.object_id = i.object_id
WHERE i.type_desc = 'CLUSTERED'
ORDER BY 1
*/

/* 查PK
SELECT Col.Column_Name from
    INFORMATION_SCHEMA.TABLE_CONSTRAINTS Tab,
    INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE Col
WHERE
    Col.Constraint_Name = Tab.Constraint_Name
    AND Col.Table_Name = Tab.Table_Name
    AND Constraint_Type = 'PRIMARY KEY'
*/