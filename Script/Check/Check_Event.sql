DECLARE @SQL NVARCHAR(MAX) = ''

;WITH CTE
AS
(
	SELECT
		a.name AS EventName,
		CAST(b.target_data AS XML).value('(/EventFileTarget/File/@name)[1]', 'NVARCHAR(MAX)') AS FilePath
	FROM sys.dm_xe_sessions a
	JOIN sys.dm_xe_session_targets b ON a.address = b.event_session_address
	WHERE a.session_source = 'server'
	AND a.name IN ('Rd-Tool Trace') --(T-SQL Trace / Lock Trace / Rd-Tool Trace)
)
SELECT @SQL += '
SELECT
	''' + EventName + ''' AS EventName,
	CAST(event_data AS XML).value(''(event/@name)[1]'', ''NVARCHAR(100)'') AS name,
	DATEADD(HOUR,8,CAST(event_data AS XML).value(''(event/@timestamp)[1]'', ''DATETIME'')) AS EventTime,'
	+ CASE EventName
		WHEN 'Lock Trace' THEN '
		CAST(event_data AS XML) AS Event_XML'
		WHEN 'T-SQL Trace' THEN '
		CAST(event_data AS XML).value(''(event/action[@name="database_name"]/value)[1]'', ''NVARCHAR(100)'') AS DBName,
		CAST(event_data AS XML).value(''(event/data[@name="object_name"]/value)[1]'', ''NVARCHAR(MAX)'') AS ObjectName,
		CAST(event_data AS XML).value(''(event/data[@name="writes"]/value)[1]'', ''NVARCHAR(MAX)'') AS writes,
		CAST(event_data AS XML).value(''(event/data[@name="physical_reads"]/value)[1]'', ''NVARCHAR(MAX)'') AS physical_reads,
		CAST(event_data AS XML).value(''(event/data[@name="logical_reads"]/value)[1]'', ''NVARCHAR(MAX)'') AS logical_reads,
		CAST(event_data AS XML).value(''(event/data[@name="duration"]/value)[1]'', ''NVARCHAR(MAX)'') AS duration,
		CAST(event_data AS XML).value(''(event/data[@name="statement"]/value)[1]'', ''NVARCHAR(MAX)'') AS SQL_Text,
		CAST(event_data AS XML)'
		WHEN 'Rd-Tool Trace' THEN '
		CAST(event_data AS XML).value(''(event/action[@name="client_hostname"]/value)[1]'', ''NVARCHAR(100)'') AS client_hostname,
		CAST(event_data AS XML).value(''(event/action[@name="username"]/value)[1]'', ''NVARCHAR(100)'') AS UserName,
		CAST(event_data AS XML).value(''(event/data[@name="cpu_time"]/value)[1]'', ''NVARCHAR(MAX)'') AS cpu_time,
		CAST(event_data AS XML).value(''(event/data[@name="writes"]/value)[1]'', ''NVARCHAR(MAX)'') AS writes,
		CAST(event_data AS XML).value(''(event/data[@name="spills"]/value)[1]'', ''NVARCHAR(MAX)'') AS spills,
		CAST(event_data AS XML).value(''(event/data[@name="physical_reads"]/value)[1]'', ''NVARCHAR(MAX)'') AS physical_reads,
		CAST(event_data AS XML).value(''(event/data[@name="logical_reads"]/value)[1]'', ''NVARCHAR(MAX)'') AS logical_reads,
		CAST(event_data AS XML).value(''(event/data[@name="duration"]/value)[1]'', ''NVARCHAR(MAX)'') AS duration,
		CAST(event_data AS XML).value(''(event/data[@name="row_count"]/value)[1]'', ''NVARCHAR(MAX)'') AS row_count,
		CAST(event_data AS XML).value(''(event/data[@name="batch_text"]/value)[1]'', ''NVARCHAR(MAX)'') AS batch_text,
		CAST(event_data AS XML).value(''(event/data[@name="result"]/text)[1]'', ''NVARCHAR(MAX)'') AS result,
		CAST(event_data AS XML).value(''(event/action[@name="client_app_name"]/value)[1]'', ''NVARCHAR(100)'') AS client_app_name,
		CAST(event_data AS XML).value(''(event/action[@name="client_pid"]/value)[1]'', ''NVARCHAR(100)'') AS client_pid'
	END + '
FROM sys.fn_xe_file_target_read_file(''' + FilePath + ''', null, null, null)
WHERE DATEADD(HOUR,8,CAST(event_data AS XML).value(''(event/@timestamp)[1]'', ''DATETIME'')) >= GETDATE() - 7
ORDER BY DATEADD(HOUR,8,CAST(event_data AS XML).value(''(event/@timestamp)[1]'', ''DATETIME'')) DESC
'
FROM CTE

--SELECT @SQL
EXEC (@SQL)