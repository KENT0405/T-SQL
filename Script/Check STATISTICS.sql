SELECT
	OBJECT_NAME(s.object_id) AS table_name,
	COL_NAME(scol.object_id, scol.column_id) AS column_name,
	MIN(STATS_DATE(s.object_id,s.stats_id)) AS stats_time,
	AVG(sp.rows_sampled) AS [sample_rowcount],	--取樣樣本數
	MAX(sp.modification_counter) AS modify_count,	--統計值更新後，資料修改次數
	MAX(hist.step_number) AS step_count		--欄位取樣分組
FROM sys.tables t
JOIN sys.stats AS s ON s.object_id = t.object_id
JOIN sys.stats_columns AS scol ON s.stats_id = scol.stats_id AND s.object_id = scol.object_id AND scol.stats_column_id = 1
CROSS APPLY sys.dm_db_stats_properties(t.object_id, s.stats_id) AS sp
CROSS APPLY sys.dm_db_stats_histogram(s.object_id, s.stats_id) AS hist
WHERE 1 = 1
--AND OBJECT_NAME(s.object_id) = 'mem_info'
GROUP BY s.object_id,scol.object_id, scol.column_id
ORDER BY 1,2 ASC