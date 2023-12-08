SELECT
	 OBJECT_NAME(p.object_id) AS TableName
	,p.partition_number AS PartitionNumber
	,prv_left.value AS LowerBoundary
	,prv_right.value AS UpperBoundary
	,ps.name AS PartitionScheme
	,pf.name AS PartitionFunction
	,fg.name AS FileGroupName
	,p.row_count
	,c.name AS partition_column
	,CASE WHEN data_compression = 0 THEN 'NONE' WHEN data_compression = 1 THEN 'ROWS' WHEN data_compression = 2 THEN 'PAGE' END AS compression
	--,'ALTER TABLE ' + OBJECT_NAME(p.object_id) + ' REBUILD PARTITION = ' + CAST(p.partition_number AS VARCHAR(5)) + ' WITH (DATA_COMPRESSION = ROW);' AS compression_str
	--,'ALTER TABLE ' + OBJECT_NAME(p.object_id) + ' SWITCH PARTITION ' + CAST(p.partition_number AS VARCHAR(3)) + ' TO ' + OBJECT_NAME(p.object_id) + '_switch PARTITION ' + CAST(p.partition_number AS VARCHAR(3)) AS swith_str
	--,'ALTER PARTITION FUNCTION ' + QUOTENAME(pf.name,'') + '() MERGE RANGE (''' + FORMAT(CAST(prv_left.value AS DATETIME),'yyyy-MM-dd 00:00:00.000') + ''')' AS merge_str
	--,'ALTER PARTITION SCHEME [' + ps.name + '] NEXT USED [' + fg.name + ']; ALTER PARTITION FUNCTION ' + QUOTENAME(pf.name,'') + '() SPLIT RANGE (''' + FORMAT(CAST(prv_left.value AS DATETIME),'yyyy-MM-dd 00:00:00.000') + ''')' AS split_str
	--,'TRUNCATE TABLE ' + OBJECT_NAME(p.object_id) + ' WITH (PARTITIONS (' + CAST(p.partition_number AS VARCHAR(3)) + '))' AS truncate_str
	--INTO ##TEMP
FROM sys.dm_db_partition_stats p
INNER JOIN sys.indexes i ON i.object_id = p.object_id AND i.index_id = p.index_id
INNER JOIN sys.index_columns ic ON (ic.partition_ordinal > 0) AND (ic.index_id=i.index_id AND ic.object_id=CAST(i.object_id AS int))
INNER JOIN sys.columns c ON c.object_id = ic.object_id and c.column_id = ic.column_id
INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id
INNER JOIN sys.partition_functions pf ON ps.function_id = pf.function_id
INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND  dds.destination_id = p.partition_number
INNER JOIN sys.filegroups fg ON fg.data_space_id = dds.data_space_id
INNER JOIN sys.partitions pt ON pt.object_id = p.object_id AND pt.partition_id = p.partition_id AND pt.partition_number = p.partition_number
LEFT JOIN sys.partition_range_values prv_right ON prv_right.function_id = ps.function_id AND prv_right.boundary_id = p.partition_number
LEFT JOIN sys.partition_range_values prv_left ON prv_left.function_id = ps.function_id AND prv_left.boundary_id = p.partition_number - 1
WHERE 1 = 1
AND p.index_id < 2 --( 0:堆積 / 1:叢集索引 / >1:非叢集索引 )
--AND ps.name IN ('Psh_owt','Psh_tck')
--AND p.row_count > 0
--AND p.partition_number < 22
--AND fg.name = 'FG_LOG_202107'
--AND prv_left.value BETWEEN CAST(GETDATE()-2 AS DATETIME) AND CAST(GETDATE()-1 AS DATETIME)
--AND data_compression = 0
--AND OBJECT_NAME(p.object_id) IN ('one_wallet_transfer_all','one_wallet_transfer')
ORDER BY 1,2
GO

/*

SELECT f.name,MAX(v.value) max_value
FROM sys.partition_functions f JOIN sys.partition_range_values v
ON f.function_id = v.function_id
GROUP BY f.name

*/