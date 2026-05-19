;WITH CTE
AS
(
	SELECT
		qs.creation_time,
		qs.execution_count,
		qs.total_worker_time / qs.execution_count AS avg_cpu_time, -- 平均 CPU 時間
		qs.total_elapsed_time / qs.execution_count AS avg_elapsed_time, -- 平均執行時間
		qs.total_logical_reads / qs.execution_count AS avg_logical_reads, -- 平均邏輯讀取次數
		qs.total_logical_writes / qs.execution_count AS avg_logical_writes, -- 平均邏輯寫入次數
		qs.total_physical_reads / qs.execution_count AS avg_physical_reads, -- 平均物理讀取次數
		qs.total_clr_time / qs.execution_count AS avg_clr_time, -- 平均 CLR 時間
		qs.execution_count AS exec_count, -- 執行次數
		SUBSTRING(st.text, (qs.statement_start_offset/2) + 1,
			((CASE statement_end_offset
				WHEN -1 THEN DATALENGTH(st.text)
				ELSE qs.statement_end_offset END
				- qs.statement_start_offset)/2) + 1) AS query_text
	FROM sys.dm_exec_query_stats AS qs
	CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
)
SELECT *
FROM CTE
--WHERE query_text LIKE '%delete%'
ORDER BY creation_time DESC;
