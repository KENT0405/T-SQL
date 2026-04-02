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
	AND a.name IN ('T-SQL Trace','Lock Trace') --Search Event Session Name
)
SELECT @SQL += '
SELECT
	''' + EventName + ''' AS EventName,
	DATEADD(HOUR,8,CAST(event_data AS XML).value(''(event/@timestamp)[1]'', ''DATETIME'')) AS EventTime,'
	+ CASE WHEN EventName = 'Lock Trace' THEN '
	CAST(event_data AS XML) AS Event_XML' ELSE '' END
	+ CASE WHEN EventName = 'T-SQL Trace' THEN '
	CAST(event_data AS XML).value(''(event/action[@name="database_name"]/value)[1]'', ''NVARCHAR(100)'') AS DBName,
	CAST(event_data AS XML).value(''(event/data[@name="object_name"]/value)[1]'', ''NVARCHAR(MAX)'') AS ObjectName,
	CAST(event_data AS XML).value(''(event/data[@name="statement"]/value)[1]'', ''NVARCHAR(MAX)'') AS SQL_Text' ELSE '' END + '
FROM sys.fn_xe_file_target_read_file(''' + FilePath + ''', null, null, null)
WHERE DATEADD(HOUR,8,CAST(event_data AS XML).value(''(event/@timestamp)[1]'', ''DATETIME'')) >= GETDATE() - 7
'
FROM CTE

--SELECT @SQL
EXEC (@SQL)