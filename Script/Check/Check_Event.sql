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
	AND a.name IN ('T-SQL Trace') --(T-SQL Trace / Lock Trace / Rd-Tool Trace)
)
SELECT @SQL += '
SELECT
	''' + EventName + ''' AS EventName,
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
		CAST(event_data AS XML).value(''(event/data[@name="statement"]/value)[1]'', ''NVARCHAR(MAX)'') AS SQL_Text'
		WHEN 'Rd-Tool Trace' THEN '
		CAST(event_data AS XML).value(''(event/action[@name="username"]/value)[1]'', ''NVARCHAR(100)'') AS UserName,
		CAST(event_data AS XML).value(''(event/data[@name="duration"]/value)[1]'', ''NVARCHAR(MAX)'') AS duration,
		CAST(event_data AS XML).value(''(event/data[@name="batch_text"]/value)[1]'', ''NVARCHAR(MAX)'') AS batch_text'
	END + '
FROM sys.fn_xe_file_target_read_file(''' + FilePath + ''', null, null, null)
WHERE DATEADD(HOUR,8,CAST(event_data AS XML).value(''(event/@timestamp)[1]'', ''DATETIME'')) >= GETDATE() - 7
' + CASE WHEN EventName = 'Rd-Tool Trace'
		THEN 'AND CAST(event_data AS XML).value(''(event/action[@name="username"]/value)[1]'', ''NVARCHAR(100)'') <> ''rd_user'''
	ELSE '' END + '
ORDER BY DATEADD(HOUR,8,CAST(event_data AS XML).value(''(event/@timestamp)[1]'', ''DATETIME'')) DESC
'
FROM CTE

--SELECT @SQL
EXEC (@SQL)