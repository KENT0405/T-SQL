DECLARE
	@tracefile NVARCHAR(256) = N'D:\ProfilerTrace\test',
	@EventCategoryName NVARCHAR(MAX) = 'Stored Procedures / TSQL', --(Stored Procedures / TSQL)
	@EventClassName NVARCHAR(MAX) = 'RPC:Completed', --(RPC:Completed / RPC:Starting / SP:StmtCompleted / SP:StmtStarting / SQL:BatchCompleted / SQL:BatchStarting)
	@Filter_Parameters NVARCHAR(100) = 'TextData,OR,LIKE,%PROC_tranlist_get%', --ex:(TextData,OR,LIKE,%PROC_tranlist_get% / LoginName,AND,=,gino)

	--Delete File (Close : 1)
	@Delete_File BIT = 0

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE
	@FileExists INT,
	@SQL NVARCHAR(MAX) = '',
	@File NVARCHAR(256) = @tracefile + '.trc'

EXEC master.dbo.xp_fileexist @File, @FileExists OUTPUT

IF (@FileExists = 1 AND @Delete_File = 0)
BEGIN
	SELECT
		ServerName,
		DatabaseName,
		HostName,
		ApplicationName,
		LoginName,
		SPID,
		Duration,
		StartTime,
		EndTime,
		Reads,
		Writes,
		CPU,
		TextData
	FROM fn_trace_gettable(@File,DEFAULT)
END
ELSE IF (@FileExists = 0 AND @Delete_File = 0)
BEGIN
	DECLARE
		@TraceID INT,
		@maxfilesize BIGINT = 1024

	-- Set the trace file
	EXEC sp_trace_create
		@TraceID OUTPUT,
		@options = 2,
		@tracefile = @tracefile,
		@maxfilesize = @maxfilesize,
		@stoptime = NULL,
		@filecount = 2

	-- Set the events all columns
	SELECT @SQL += 'EXEC sp_trace_setevent ' + CAST(@TraceID AS VARCHAR(100)) + ', ' + CAST(te.trace_event_id AS VARCHAR(100)) + ', ' + CAST(teb.trace_column_id AS VARCHAR(100)) + ', 1' + CHAR(10)
	FROM sys.trace_categories AS tc
	JOIN sys.trace_events AS te ON te.category_id = tc.category_id
	JOIN sys.trace_event_bindings AS teb ON teb.trace_event_id = te.trace_event_id
	JOIN sys.trace_columns AS tcol ON tcol.trace_column_id = teb.trace_column_id
	WHERE tc.name IN (SELECT value FROM STRING_SPLIT(REPLACE(@EventCategoryName,' / ','/'), '/'))
	AND te.name IN (SELECT value FROM STRING_SPLIT(REPLACE(@EventClassName,' / ','/'), '/'))

	EXEC (@SQL)

	-- Set the Filters
	DECLARE
		@FilterText NVARCHAR(MAX),
		@ColumnName NVARCHAR(100),
		@LogicalName NVARCHAR(100),
		@ComparisonName NVARCHAR(100),
		@FilterValue NVARCHAR(100),
		@columnid INT,
		@logical_operator INT,
		@comparison_operator INT,
		@SQL_Filter NVARCHAR(MAX) = ''

	DECLARE @Filters TABLE
	(
		ID INT IDENTITY(1,1),
		FilterText NVARCHAR(MAX)
	)

	INSERT INTO @Filters
	SELECT '["' + REPLACE(LTRIM(RTRIM(value)), ',', '","') + '"]'
	FROM STRING_SPLIT(@Filter_Parameters, '/')

	DECLARE cur CURSOR FOR
	SELECT FilterText
	FROM @Filters

	OPEN cur

	FETCH NEXT FROM cur INTO @FilterText

	WHILE @@FETCH_STATUS = 0
	BEGIN

		SELECT
			@ColumnName = JSON_VALUE(@FilterText, '$[0]'),
			@LogicalName = JSON_VALUE(@FilterText, '$[1]'),
			@ComparisonName = JSON_VALUE(@FilterText, '$[2]'),
			@FilterValue = JSON_VALUE(@FilterText, '$[3]')

		SET @columnid =
		CASE @ColumnName
			WHEN 'TextData' THEN 1
			WHEN 'HostName' THEN 8
			WHEN 'ApplicationName' THEN 10
			WHEN 'LoginName' THEN 11
			WHEN 'Duration' THEN 13
			WHEN 'ServerName' THEN 26
			WHEN 'DatabaseName' THEN 35
		END

		SET @logical_operator =
		CASE @LogicalName
			WHEN 'AND' THEN 0
			WHEN 'OR' THEN 1
		END

		SET @comparison_operator =
		CASE @ComparisonName
			WHEN '=' THEN 0
			WHEN '<>' THEN 1
			WHEN '>' THEN 2
			WHEN '<' THEN 3
			WHEN '>=' THEN 4
			WHEN '<=' THEN 5
			WHEN 'LIKE' THEN 6
			WHEN 'NOT LIKE' THEN 7
		END

		SET @SQL_Filter += 'EXEC sp_trace_setfilter ' + CAST(@TraceID AS VARCHAR(100)) + ',
		' + CAST(@columnid AS VARCHAR) + ',
		' + CAST(@logical_operator AS VARCHAR) + ',
		' + CAST(@comparison_operator AS VARCHAR) + ',
		N''' + @FilterValue + ''';' + CHAR(10)

		FETCH NEXT FROM cur INTO @FilterText
	END

	CLOSE cur
	DEALLOCATE cur

	EXEC (@SQL_Filter)

	-- Set the trace status to start
	exec sp_trace_setstatus @TraceID, 1

	PRINT @TraceID
END

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

IF (@FileExists = 1 AND @Delete_File = 1)
BEGIN
	SELECT @SQL += 'EXEC sp_trace_setstatus ' + CAST(t.id AS VARCHAR(10))+ ', 0;' + CHAR(10) + 'EXEC sp_trace_setstatus ' + CAST(t.id AS VARCHAR(10))+ ', 2;'
    FROM sys.traces t
    LEFT JOIN sys.dm_exec_sessions s ON s.program_name LIKE '%Profiler%'
    WHERE is_default <> 1

	IF(@SQL <> '')
		EXEC (@SQL)

	SET @File = 'DEL ' + @File

	--EXEC sp_configure 'show advanced options', 1; RECONFIGURE;
	--EXEC sp_configure 'xp_cmdshell', 1; RECONFIGURE;

	EXEC xp_cmdshell @File
END