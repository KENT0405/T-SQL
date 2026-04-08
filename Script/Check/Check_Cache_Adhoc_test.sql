SELECT TOP 10
    DB_NAME(st.dbid) AS DBName,
    cp.objtype,
    CASE WHEN cp.objtype = 'Adhoc'
		THEN LEFT(st.text, 100)
        ELSE RIGHT(st.text, LEN(st.text) - qs.statement_start_offset/2)
    END AS sub_query_text,
    COUNT(*) AS Plan_Count,
    SUM(qs.execution_count) AS Total_execution_count,
    SUM(cp.size_in_bytes/ 1024) / 1024 AS Total_plan_size_mb
FROM sys.dm_exec_cached_plans cp
JOIN sys.dm_exec_query_stats qs ON cp.plan_handle = qs.plan_handle
CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) st
CROSS APPLY sys.dm_exec_plan_attributes(cp.plan_handle) pa
WHERE cp.objtype IN ('Adhoc','Prepared')
AND DB_NAME(st.dbid) NOT IN ('master','msdb')
GROUP BY
    DB_NAME(st.dbid),
    cp.objtype,
    CASE WHEN cp.objtype = 'Adhoc'
		THEN LEFT(st.text, 100)
        ELSE RIGHT(st.text, LEN(st.text) - qs.statement_start_offset/2)
    END
ORDER BY Total_plan_size_mb DESC


SELECT plan_handle, refcounts, usecounts, size_in_bytes, cacheobjtype, objtype
FROM sys.dm_exec_cached_plans;
GO
SELECT attribute, [value], is_cache_key
FROM sys.dm_exec_plan_attributes(0x05000600A869AF6FC0FE49A07D01000001000000000000000000000000000000000000000000000000000000);
GO

SELECT *
FROM sys.dm_exec_cached_plans cp
JOIN sys.dm_exec_query_stats qs ON cp.plan_handle = qs.plan_handle
CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) st
CROSS APPLY sys.dm_exec_plan_attributes(cp.plan_handle) pa
JOIN sys.objects o ON o.object_id = pa.