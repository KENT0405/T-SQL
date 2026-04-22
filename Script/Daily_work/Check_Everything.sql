SET NOCOUNT ON;

DECLARE @ReportType INT = 2 --2047

DROP TABLE IF EXISTS #ReportType;
SELECT
    POWER(CAST(2 AS BIGINT),number) AS id,
    CASE POWER(CAST(2 AS BIGINT),number)
        WHEN 1    THEN 'Job fail record'
        WHEN 2    THEN 'Error message'
        WHEN 4    THEN 'Tsql & DeadLock Trace'
        WHEN 8    THEN 'Unclosed Profiler'
        WHEN 16   THEN 'Space Usage'
        WHEN 32   THEN 'RecordSpCached Top IO'
        WHEN 64   THEN 'Long Running Job'
        WHEN 128  THEN 'Non-Compliance Connection'
        WHEN 256  THEN 'Connection Fulled Loaded'
        WHEN 512  THEN 'Recently Modify Obejct'
        WHEN 1024 THEN 'Partition Check'
    END AS ReportType
INTO #ReportType
FROM master..spt_values
WHERE type = 'P'
AND number BETWEEN 0 AND 10
AND POWER(CAST(2 AS BIGINT),number) & @ReportType <> 0


--Job fail record
IF EXISTS (SELECT 1 FROM #ReportType WHERE id = 1)
BEGIN
    ;WITH CTE
    AS
    (
        SELECT
            b.name AS job_name,
            a.step_name,
            [Message],
            command,
            CASE run_date WHEN 0 THEN NULL ELSE
                CONVERT(DATETIME, STUFF(STUFF(CAST(run_date AS NCHAR(8)), 7, 0, '-'), 5, 0, '-') + N' ' +
                STUFF(STUFF(SUBSTRING(CAST(1000000 + run_time AS NCHAR(7)), 2, 6), 5, 0, ':'), 3, 0, ':'), 120) END AS Rundate,
            run_duration,
            CASE run_status
                WHEN 0 THEN N'fail'
                WHEN 1 THEN N'success'
                WHEN 3 THEN N'cancel'
                WHEN 4 THEN N'continue'
                WHEN 5 THEN N'unknow'
            END AS result,
            CAST(STUFF(STUFF(CAST(run_date AS NCHAR(8)), 7, 0, '-'), 5, 0, '-') AS DATE) AS date
        FROM msdb..sysjobhistory a
        JOIN msdb..sysjobs_view b ON a.job_id = b.job_id
        JOIN msdb..sysjobsteps c ON a.job_id = c.job_id
        WHERE a.step_id > 0
    )
    SELECT * FROM CTE
    WHERE 1 = 1
    AND CTE.Rundate >= DATEADD(DD,-2,GETDATE())
    AND result <> 'success'
    AND step_name NOT IN ('Check Replica - Secondary','Check Replica - Primary')
    AND DB_NAME() NOT IN ('ref_data','finance_data')
    ORDER BY CTE.Rundate DESC
END

--Error message
IF EXISTS (SELECT 1 FROM #ReportType WHERE id = 2)
BEGIN
	DECLARE @SQL_Error_message NVARCHAR(MAX) = ''

	;WITH CTE
	AS
	(
		SELECT
			o.name  AS table_name,
			c.name  AS col_name,
			ROW_NUMBER() OVER (ORDER BY o.name, c.column_id) AS rn
		FROM sys.objects o
		JOIN sys.columns c ON o.object_id = c.object_id
		WHERE o.type IN ('U', 'V')
		AND o.name IN ('sys_jobs_errormessage', 'TB_JobsErrorMessage_Main')
	)
	SELECT @SQL_Error_message = '
	SELECT ''' + (SELECT TOP 1 table_name FROM CTE) + ''' AS TABLENAME, ' +
	STUFF((
		SELECT ', ' + IIF(col_name = 'sn','CAST(' + col_name + ' AS BIGINT)',col_name) + ' AS ' + REPLACE(IIF(col_name = 'Id','SN',UPPER(col_name)),'_','')
		FROM CTE
		WHERE rn <= 8
		FOR XML PATH('')),1,1,'') +
	', ' + COALESCE((SELECT col_name FROM CTE WHERE rn = 9), '''''') + ' AS ERRORDATABASE,
	''USE [' + IIF(DB_NAME() <> 'idc_repl',DB_NAME(), ''' + ERRORDATABASE + ''') + ']; DELETE ' + (SELECT TOP 1 table_name FROM CTE) + ' WHERE sn = '' + CAST(' + IIF(DB_NAME() IN ('af_data','ref_data'),'id','sn') + ' AS VARCHAR) AS delete_str
	FROM ' + (SELECT TOP 1 table_name FROM CTE) + ' WITH(NOLOCK)
    WHERE @@SERVERNAME NOT IN (''IC-BO-DB-02'',''IC-DBPMT-002'') '

	--PRINT @SQL_Error_message
	EXEC sp_executesql  @SQL_Error_message
END

--Tsql & DeadLock Trace
IF EXISTS (SELECT 1 FROM #ReportType WHERE id = 4)
BEGIN
    DECLARE @SQL_Trace NVARCHAR(MAX) = ''

    ;WITH CTE
    AS
    (
        SELECT
            a.name AS EventName,
            CAST(b.target_data AS XML).value('(/EventFileTarget/File/@name)[1]', 'NVARCHAR(MAX)') AS FilePath
        FROM sys.dm_xe_sessions a
        JOIN sys.dm_xe_session_targets b ON a.address = b.event_session_address
        WHERE a.session_source = 'server'
        AND a.name IN ('T-SQL Trace','Lock Trace')
        AND DB_NAME() NOT IN ('ref_data','finance_data')
    )
    SELECT @SQL_Trace += '
    SELECT
        ''' + EventName + ''' AS EventName,
        SUM(CASE WHEN EventTime >= FORMAT(GETDATE(),''yyyy-MM-dd 00:00:00.000'') THEN 1 ELSE 0 END) AS [Today (CNT)],
        SUM(CASE WHEN EventTime >= GETDATE() - 1 THEN 1 ELSE 0 END) AS [last_24hour (CNT)],
        COUNT(EventTime) / 7 AS [last_7day (AVG)]
    FROM
    (
        SELECT DATEADD(HOUR,8,CAST(event_data AS XML).value(''(event/@timestamp)[1]'', ''DATETIME'')) AS EventTime
        FROM sys.fn_xe_file_target_read_file(''' + FilePath + ''', null, null, null)
        WHERE DATEADD(HOUR,8,CAST(event_data AS XML).value(''(event/@timestamp)[1]'', ''DATETIME'')) >= GETDATE() - 7
    ) a
    UNION ALL
    '
    FROM CTE

    IF @SQL_Trace = ''
    BEGIN
        SELECT
            CAST(NULL AS NVARCHAR(100)) AS EventName,
            CAST(NULL AS INT) AS [Today (CNT)],
            CAST(NULL AS INT) AS [last_24hour (CNT)],
            CAST(NULL AS INT) AS [last_7day (AVG)]
        WHERE 1 = 0
    END
    ELSE
        SET @SQL_Trace = LEFT(@SQL_Trace, LEN(@SQL_Trace) - 11)

    EXEC (@SQL_Trace)
END

--Unclosed Profiler
IF EXISTS (SELECT 1 FROM #ReportType WHERE id = 8)
BEGIN
    SELECT 'Unclosed Profiler'
END

--Space Usage
IF EXISTS (SELECT 1 FROM #ReportType WHERE id = 16)
BEGIN
   DECLARE @SQL_shrink NVARCHAR(MAX) = ''

    DROP TABLE IF EXISTS #temp_shink;
    CREATE TABLE #temp_shink
    (
        [DB_Name] VARCHAR(30),
        [FileGroup] VARCHAR(30),
        [Name] VARCHAR(30),
        [File_path] VARCHAR(100),
        [Currently_Space(MB)] INT,
        [Space_Used(MB)] INT,
        [Available_Space(MB)] INT,
        Rate DECIMAL(5,2),
        shrinkstr VARCHAR(100),
        shrinkstr_loop VARCHAR(1000)
    )

    SELECT @SQL_shrink += '
    USE [' + name + '];

    ;WITH shink
    AS
    (
        SELECT
            ISNULL(b.groupname,'''') AS [FileGroup],
            Name,
            [Filename] AS [File_path],
            CONVERT (DECIMAL(15,0),ROUND(a.Size/128.000,2)) [Currently_Space(MB)],
            CONVERT (DECIMAL(15,0),ROUND(FILEPROPERTY(a.Name,''SpaceUsed'')/128.000,2)) AS [Space_Used(MB)],
            CONVERT (DECIMAL(15,0),ROUND((a.Size-FILEPROPERTY(a.Name,''SpaceUsed''))/128.000,2)) AS [Available_Space(MB)]
        FROM sysfiles a
        LEFT JOIN sysfilegroups b
        ON a.groupid = b.groupid
    )
    INSERT INTO #temp_shink
    SELECT
        ''' + name + ''' AS DB_Name,
        *
        ,CONVERT(DECIMAL(5,2),[Space_Used(MB)] / [Currently_Space(MB)]) AS Rate
        ,''USE ' + name + ';  DBCC SHRINKFILE (N'''''' + Name + '''''' , 8) WITH NO_INFOMSGS;'' AS shrinkstr
        ,''
		USE ' + name + ';
        SET NOCOUNT ON;
        DECLARE @I INT = '' + CAST([Currently_Space(MB)] AS VARCHAR) + '' --目前檔案size

        WHILE (@I > '' + CAST([Space_Used(MB)] + 100 AS VARCHAR) + '') --目標size
        BEGIN

        DBCC SHRINKFILE (N'''''' + name + '''''' , @I) WITH NO_INFOMSGS

        SET @I -= 100

        END
        '' AS shrinkstr_loop
    FROM shink
    WHERE [Currently_Space(MB)] > 10240 --10GB
    AND (CONVERT(DECIMAL(5,2),[Space_Used(MB)] / [Currently_Space(MB)]) < 0.7 AND [FileGroup] <> '''' ) --NDF/MDF
    OR ([Currently_Space(MB)] > 10240 AND [FileGroup] = '''')--LDF
    '
    FROM sys.databases
    WHERE database_id > 4

    EXEC (@SQL_shrink)

    SELECT *
    FROM #temp_shink
	WHERE 1 = 1
	AND FileGroup <> '' --ldf
	AND DB_Name NOT LIKE 'source%'
	AND DB_Name NOT LIKE 'ticket%'

    ;WITH T1
    AS
    (
        SELECT DISTINCT
        REPLACE(vs.volume_mount_point,':\','') AS Drive_Name ,
        CAST(vs.total_bytes / 1024.0 / 1024 / 1024 AS NUMERIC(18,2)) AS Total_Space_GB ,
        CAST(vs.available_bytes / 1024.0 / 1024 / 1024 AS NUMERIC(18,2)) AS Free_Space_GB
        FROM  sys.master_files AS f
        CROSS APPLY sys.dm_os_volume_stats(f.database_id, f.file_id) AS vs
    )
    SELECT
    Drive_Name,
    Total_Space_GB,
    Total_Space_GB-Free_Space_GB AS Used_Space_GB,
    Free_Space_GB,
    CAST(Free_Space_GB*100/Total_Space_GB AS NUMERIC(18,2)) AS Free_Space_Percent
    FROM T1
    WHERE CAST(Free_Space_GB*100/Total_Space_GB AS NUMERIC(18,2)) <= 30
	AND DB_NAME() NOT IN ('ref_data','finance_data')
END

--RecordSpCached Top IO
IF EXISTS (SELECT 1 FROM #ReportType WHERE id = 32)
BEGIN
    ;WITH CTE
    AS
    (
        SELECT TOP 10 *
        FROM [master]..[RecordSpCached]
        WHERE 1 = 1
        AND [Procedure] <> 'PROC_updatestats'
        AND [Procedure] NOT LIKE '%backup%'
        AND DB_NAME() NOT IN ('ref_data','finance_data')
        ORDER BY [AVG_IO (MB)] DESC
    )
    SELECT *
    FROM CTE
    WHERE Last_Exec_Date >= CAST(GETDATE() - 1 AS DATE)
END

--Long Running Job
IF EXISTS (SELECT 1 FROM #ReportType WHERE id = 64)
BEGIN
    SELECT 'Long Running Job'
END

--Non-Compliance Connection
IF EXISTS (SELECT 1 FROM #ReportType WHERE id = 128)
BEGIN
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
        AND a.name IN ('Rd-Tool Trace')
    )
    SELECT @SQL += '
    SELECT
        ''' + EventName + ''' AS EventName,
        DATEADD(HOUR,8,CAST(event_data AS XML).value(''(event/@timestamp)[1]'', ''DATETIME'')) AS EventTime,
        CAST(event_data AS XML).value(''(event/action[@name="username"]/value)[1]'', ''NVARCHAR(100)'') AS UserName,
        CAST(event_data AS XML).value(''(event/data[@name="duration"]/value)[1]'', ''NVARCHAR(MAX)'') AS duration,
        CAST(event_data AS XML).value(''(event/data[@name="batch_text"]/value)[1]'', ''NVARCHAR(MAX)'') AS batch_text
    FROM sys.fn_xe_file_target_read_file(''' + FilePath + ''', null, null, null)
    WHERE DATEADD(HOUR,8,CAST(event_data AS XML).value(''(event/@timestamp)[1]'', ''DATETIME'')) >= GETDATE() - 7
    AND CAST(event_data AS XML).value(''(event/action[@name="username"]/value)[1]'', ''NVARCHAR(100)'') <> ''rd_user''
    ORDER BY DATEADD(HOUR,8,CAST(event_data AS XML).value(''(event/@timestamp)[1]'', ''DATETIME'')) DESC
    '
    FROM CTE

    --SELECT @SQL
    EXEC (@SQL)
END

--Connection Fulled Loaded
IF EXISTS (SELECT 1 FROM #ReportType WHERE id = 256)
BEGIN
    SELECT TOP 10
        [log_time],
        COUNT([log_time]) AS Connect_Count
    FROM [master].[dbo].[TB_Conn_FulledLoaded_Log]
    GROUP BY [log_time]
    ORDER BY [log_time] DESC
END

--Recently Modify Obejct
IF EXISTS (SELECT 1 FROM #ReportType WHERE id = 512)
BEGIN
    SELECT 'Recently Modify Obejct'
END

--Partition Check
IF EXISTS (SELECT 1 FROM #ReportType WHERE id = 1024)
BEGIN
    DECLARE @SQL_Check_Partition NVARCHAR(MAX) = ''

    DROP TABLE IF EXISTS #Temp_Check_Partition
    CREATE TABLE #Temp_Check_Partition
    (
        DBname VARCHAR(100),
        TableName VARCHAR(100),
        PartitionNumber INT,
		PartitionScheme VARCHAR(100),
		PartitionFunction VARCHAR(100),
        LowerBoundary DATETIME,
        UpperBoundary DATETIME
    )

    SELECT @SQL_Check_Partition += N'
    INSERT INTO #Temp_Check_Partition
    SELECT
        ''' + name + ''',
        OBJECT_NAME(p.object_id,' + CAST(database_id AS VARCHAR(10)) + ') AS TableName,
        p.partition_number AS PartitionNumber,
		ps.name AS PartitionScheme,
		pf.name AS PartitionFunction,
        CAST(prv_left.value AS DATETIME) AS LowerBoundary,
        CAST(prv_right.value AS DATETIME) AS UpperBoundary
    FROM ' + name + '.sys.dm_db_partition_stats p
    INNER JOIN ' + name + '.sys.indexes i ON i.object_id = p.object_id AND i.index_id = p.index_id
    INNER JOIN ' + name + '.sys.partition_schemes ps ON ps.data_space_id = i.data_space_id
	INNER JOIN ' + name + '.sys.partition_functions pf ON ps.function_id = pf.function_id
    LEFT JOIN ' + name + '.sys.partition_range_values prv_right ON prv_right.function_id = ps.function_id AND prv_right.boundary_id = p.partition_number
    LEFT JOIN ' + name + '.sys.partition_range_values prv_left ON prv_left.function_id = ps.function_id AND prv_left.boundary_id = p.partition_number - 1
    WHERE p.index_id < 2 --( 0:堆積 / 1:叢集索引 / >1:非叢集索引 )
    '
    FROM sys.databases
    WHERE database_id > 4
    AND DB_NAME() NOT IN ('ref_data','finance_data')

    --SELECT @SQL_Check_Partition
    EXEC (@SQL_Check_Partition)

	;WITH CTE
	AS
	(
		SELECT
			DBname,
			TableName,
			CASE WHEN COUNT(*) = COUNT(CASE WHEN DAY(LowerBoundary) = 1 THEN 1 END) THEN 'Monthly' ELSE 'Daily' END AS PartitionType
		FROM #Temp_Check_Partition
		WHERE LowerBoundary IS NOT NULL
		GROUP BY DBname,TableName
	)
    SELECT DISTINCT
		a.DBname,
		a.PartitionScheme,
		a.PartitionFunction,
		a.LowerBoundary,
		a.UpperBoundary,
		c.PartitionType,
		IIF(a.UpperBoundary IS NULL,'Invalid max boundary','Non-continuous range') AS Result
    FROM #Temp_Check_Partition AS a
	JOIN CTE AS c ON a.DBname = c.DBname AND a.TableName = c.TableName
    WHERE
	UpperBoundary <>
	CASE c.PartitionType
		WHEN 'Monthly' THEN DATEADD(MONTH,1,LowerBoundary)
		WHEN 'Daily' THEN DATEADD(DAY,1,LowerBoundary)
	END --Non-continuous range
    OR (a.LowerBoundary < DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1) AND c.PartitionType = 'Monthly' AND a.UpperBoundary IS NULL) --Invalid max boundary
	OR (a.LowerBoundary < EOMONTH(GETDATE()) AND c.PartitionType = 'Daily' AND a.UpperBoundary IS NULL AND a.LowerBoundary <> DATEADD(DAY, 6, DATEADD(WEEK, DATEDIFF(WEEK, 0, GETDATE()) + 1, 0))) --Invalid max boundary
    AND a.LowerBoundary > '1900-12-31 00:00:00.000' --column type is number
    ORDER BY 1,2,3
END