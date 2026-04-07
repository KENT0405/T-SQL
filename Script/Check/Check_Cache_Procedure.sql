SELECT TOP 20
    DB_NAME(st.dbid) AS DBName,
    OBJECT_NAME(st.objectid, st.dbid) AS ProcName, --NULL is means Ad-hoc query or dynamic SQL
    SUBSTRING(st.text,
        (qs.statement_start_offset/2)+1,
        ((CASE qs.statement_end_offset
            WHEN -1 THEN DATALENGTH(st.text)
            ELSE qs.statement_end_offset END
        - qs.statement_start_offset)/2) + 1
    ) AS query_text,
    qs.execution_count,
    --qs.total_worker_time / 1000 AS total_cpu_ms,
    (qs.total_worker_time / qs.execution_count) / 1000 AS avg_cpu_ms,
    --qs.total_logical_reads,
    --qs.total_physical_reads,
    (qs.total_logical_reads / qs.execution_count) AS avg_logical_reads,
    --qs.total_elapsed_time / 1000 AS total_elapsed_ms,
    CASE
        WHEN qs.total_logical_reads / qs.execution_count > 100000 THEN 'IO/Scan'
        WHEN qs.total_physical_reads > 0 THEN 'Disk IO'
        WHEN qs.total_worker_time > qs.total_elapsed_time THEN 'Parallel'
        ELSE 'OK'
    END AS hint
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
ORDER BY qs.total_worker_time DESC;