SELECT 
	DB_NAME(st.dbid) AS DBName,
    OBJECT_SCHEMA_NAME(objectid,st.dbid) AS SchemaName,
    OBJECT_NAME(objectid,st.dbid) AS StoredProcedure,
    MAX(cp.usecounts) AS execution_count,
    SUM(qs.total_physical_reads + qs.total_logical_reads + qs.total_logical_writes) AS total_IO,
    SUM(qs.total_physical_reads + qs.total_logical_reads + qs.total_logical_writes) / (MAX(cp.usecounts)) AS avg_total_IO,
    SUM(qs.total_physical_reads) AS total_physical_reads,
    SUM(qs.total_physical_reads) / (max(cp.usecounts) * 1.0) AS avg_physical_read,
    SUM(qs.total_logical_reads) AS total_logical_reads,
    SUM(qs.total_logical_reads) / (max(cp.usecounts) * 1.0) AS avg_logical_read,
    SUM(qs.total_logical_writes) AS total_logical_writes,
    SUM(qs.total_logical_writes) / (max(cp.usecounts) * 1.0) AS avg_logical_writes
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.plan_handle) AS st
JOIN sys.dm_exec_cached_plans cp ON qs.plan_handle = cp.plan_handle
WHERE DB_NAME(st.dbid) IS NOT NULL 
AND cp.objtype = 'proc'
AND DB_NAME(st.dbid) <> 'msdb'
AND OBJECT_NAME(st.objectid,dbid) NOT LIKE 'FN_%'
GROUP BY 
	DB_NAME(st.dbid),
	OBJECT_SCHEMA_NAME(objectid,st.dbid), 
	OBJECT_NAME(objectid,st.dbid)
ORDER BY MAX(cp.usecounts) DESC
