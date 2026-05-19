/*

重建columnstore index (與分散率無關，依照delete_rows判斷是否重建)
判別delete_rows與實際分割區的占比，若delete_rows占比20%，那就可以執行分割區重建了，以換取更高效的查詢

*/
SELECT
    t.name AS table_name,
    i.name AS index_name,
    p.partition_number,
    SUM(d.total_rows) AS total_rows,
    SUM(d.deleted_rows) AS deleted_rows,
	CAST(SUM(d.deleted_rows) AS DECIMAL(10,2)) / CAST(SUM(d.total_rows) AS DECIMAL(10,2)) * 100 AS percent_tage,
	SUM(CAST(c.size_in_bytes / 1024.0 / 1024.0 AS DECIMAL(10,2))) AS size_MB,
	'ALTER INDEX ' +  i.name + ' ON ' +  t.name + ' REBUILD PARTITION = ' + CAST(p.partition_number AS VARCHAR(3)) + ' WITH (ONLINE = ON);' AS Rebuild_Index,
    'UPDATE STATISTICS ' + t.name AS update_statistics
FROM sys.dm_db_column_store_row_group_physical_stats d
INNER JOIN sys.indexes i ON i.index_id = d.index_id AND i.object_id = d.object_id
INNER JOIN sys.tables t ON t.object_id = i.object_id
INNER JOIN sys.partitions p ON p.partition_number = d.partition_number AND p.index_id = i.index_id AND p.object_id = t.object_id
INNER JOIN sys.column_store_row_groups c ON c.partition_number = p.partition_number AND c.object_id = i.object_id AND d.row_group_id = c.row_group_id
WHERE t.name = '請輸入表名稱'
GROUP BY t.name, i.name, p.partition_number

/*

重組columnstore index (與分散率無關)

影響查詢效能因素:
1.判斷row_groups的多寡來決定是否重組
2.判斷每個rows_groups的total_rows是否都有放滿(最佳 1,048,576)
4.確認state_desc是否是COMPRESSED
3.確認trim_reason_desc是否是NO_TRIM(最佳)、REORG(已完成重組)

*/
SELECT
    t.name AS table_name,
    i.name AS index_name,
    p.partition_number,
    d.row_group_id,
    d.total_rows,
    d.deleted_rows,
	CAST(c.size_in_bytes / 1024.0 / 1024.0 AS DECIMAL(10,2))  AS size_MB,
    d.state_desc,
    d.trim_reason_desc,
	'ALTER INDEX ' +  i.name + ' ON ' +  t.name + ' REORGANIZE PARTITION = ' + CAST(p.partition_number AS VARCHAR(3)) + ' WITH (COMPRESS_ALL_ROW_GROUPS = ON);' AS Reorganize_Index,
	'UPDATE STATISTICS ' + t.name AS update_statistics
FROM sys.dm_db_column_store_row_group_physical_stats d
INNER JOIN sys.indexes i ON i.index_id = d.index_id AND i.object_id = d.object_id
INNER JOIN sys.tables t ON t.object_id = i.object_id
INNER JOIN sys.partitions p ON p.partition_number = d.partition_number AND p.index_id = i.index_id AND p.object_id = t.object_id
INNER JOIN sys.column_store_row_groups c ON c.partition_number = p.partition_number AND c.object_id = i.object_id AND d.row_group_id = c.row_group_id
WHERE 1 = 1
AND t.name = '請輸入表名稱'
--AND p.partition_number = 14
--AND (d.state_desc <> 'COMPRESSED' OR d.deleted_rows > 0)
ORDER BY i.index_id, d.row_group_id
