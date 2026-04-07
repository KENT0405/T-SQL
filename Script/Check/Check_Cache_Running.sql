SELECT
    r.session_id,
    s.login_name,
    s.host_name,
    r.status,
    r.cpu_time,                -- CPU 使用時間（ms）
    r.logical_reads,           -- 邏輯讀（重點）
    r.reads,                   -- 實體讀
    r.writes,                  -- 寫入
    r.total_elapsed_time,      -- 執行時間
    SUBSTRING(t.text, r.statement_start_offset/2,
        (CASE WHEN r.statement_end_offset = -1
            THEN LEN(t.text)
			ELSE r.statement_end_offset
		END - r.statement_start_offset)/2
    ) AS running_sql
FROM sys.dm_exec_requests r
JOIN sys.dm_exec_sessions s ON r.session_id = s.session_id
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) t
WHERE r.session_id <> @@SPID
--AND login_name = 'api_ac'
ORDER BY r.cpu_time DESC;