SELECT TOP 50
    DB_NAME(st.dbid) AS DBName,
    st.text AS query_text,
    qs.execution_count,
    qs.total_worker_time / 1000 AS total_cpu_ms,
    (qs.total_worker_time / qs.execution_count) / 1000 AS avg_cpu_ms,
    qs.total_logical_reads,
    (qs.total_logical_reads / qs.execution_count) AS avg_logical_reads,
    cp.size_in_bytes / 1024 AS plan_size_kb,
    (qs.execution_count * cp.size_in_bytes) / 1024 / 1024 AS total_cache_waste_mb,
    CASE
        WHEN qs.execution_count = 1 AND cp.size_in_bytes > 50000
            THEN '單次大查詢（浪費 Plan Cache）'

        WHEN qs.execution_count > 1000 AND qs.total_worker_time / qs.execution_count < 5
            THEN '高頻小查詢（設計問題）'

        WHEN qs.total_logical_reads / qs.execution_count > 100000
            THEN 'IO 殺手'

        WHEN qs.total_worker_time > qs.total_elapsed_time
            THEN '平行 CPU 壓力'

        ELSE '一般 Ad-hoc'
    END AS problem_type,
	CASE
        WHEN text LIKE '%=%[0-9]%' THEN 'YES（高度可參數化）'
        WHEN text LIKE '%IN (%' THEN '可能'
        ELSE '低'
    END AS parameterizable
FROM sys.dm_exec_cached_plans cp
JOIN sys.dm_exec_query_stats qs ON cp.plan_handle = qs.plan_handle
CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) st
WHERE cp.objtype = 'Adhoc'
ORDER BY total_cache_waste_mb DESC

--大致彙總一下"可參數化"的查詢
;WITH CTE
AS
(
	SELECT
		DB_NAME(st.dbid) AS DBName,
		LEFT(st.text,100) AS query_text,
		qs.execution_count,
		(qs.execution_count * cp.size_in_bytes) / 1024 / 1024 AS total_cache_waste_mb
	FROM sys.dm_exec_cached_plans cp
	JOIN sys.dm_exec_query_stats qs ON cp.plan_handle = qs.plan_handle
	CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) st
	WHERE cp.objtype = 'Adhoc'
)
SELECT
	DBName,
	query_text,
	SUM(execution_count) AS Total_execution_count,
	SUM(total_cache_waste_mb) AS Total_cache_waste_mb
FROM CTE
GROUP BY
	DBName,
	query_text
HAVING SUM(total_cache_waste_mb) > 1024
ORDER BY Total_cache_waste_mb DESC