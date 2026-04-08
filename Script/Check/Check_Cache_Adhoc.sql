DROP TABLE IF EXISTS #temp, #temp2;

SELECT
	DB_NAME(st.dbid) AS DBName,
	LEFT(st.text,100) AS sub_query_text,
	st.text AS query_text,
	qs.execution_count,
	qs.total_worker_time / 1000 AS total_cpu_ms,
	(qs.total_worker_time / qs.execution_count) / 1000 AS avg_cpu_ms,
	qs.total_logical_reads,
	(qs.total_logical_reads / qs.execution_count) AS avg_logical_reads,
	cp.size_in_bytes / 1024 AS plan_size_kb
INTO #temp
FROM sys.dm_exec_cached_plans cp
JOIN sys.dm_exec_query_stats qs ON cp.plan_handle = qs.plan_handle
CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) st
WHERE cp.objtype = 'Adhoc'
AND DB_NAME(st.dbid) NOT IN ('master','msdb')

;WITH CTE
AS
(
	SELECT
		DBName,
		sub_query_text,
		COUNT(sub_query_text) AS Plan_Count,
		SUM(IIF(execution_count = 1,1,0)) AS Plan_Only_one,
		SUM(execution_count) AS Total_execution_count,
		SUM(plan_size_kb) / 1024 AS Total_plan_size_mb
	FROM #temp
	GROUP BY
		DBName,
		sub_query_text
	HAVING SUM(plan_size_kb) / 1024 > 1
)
SELECT
	ROW_NUMBER() OVER(ORDER BY Total_plan_size_mb DESC) AS RankId,
	*
INTO #temp2
FROM CTE

SELECT *
FROM #temp2
WHERE RankId <= 10

;WITH CTE
AS
(
	SELECT
		RankId,
		a.DBName,
		query_text,
		execution_count,
		total_cpu_ms,
		avg_cpu_ms,
		total_logical_reads,
		avg_logical_reads,
		plan_size_kb,
		ROW_NUMBER() OVER (PARTITION BY RankId ORDER BY (SELECT NULL)) AS rn
	FROM #temp a
	JOIN #temp2 b ON a.sub_query_text = b.sub_query_text
)
SELECT
	RankId,
	DBName,
	query_text,
	execution_count,
	total_cpu_ms,
	avg_cpu_ms,
	total_logical_reads,
	avg_logical_reads,
	plan_size_kb
FROM CTE
WHERE rn <= 5;