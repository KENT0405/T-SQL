DROP TABLE IF EXISTS #OS_Job_List, #OsJob_Freq, #OsJob_Keepday;
CREATE TABLE #OS_Job_List
(
	output VARCHAR(4000)
)

INSERT INTO #OS_Job_List
EXEC xp_cmdshell 'schtasks /query /tn "\delbak" /fo LIST /v'

IF(@@SERVERNAME LIKE '%PMT%')
BEGIN
	INSERT INTO #OS_Job_List
	EXEC xp_cmdshell 'type "E:\OS_Jobs\delbakfile.bat"'
END
ELSE
BEGIN
	INSERT INTO #OS_Job_List
	EXEC xp_cmdshell 'type "D:\OS_Jobs\delbakfile.bat"'
END

--OsJob_Freq
SELECT
    MAX(IIF(output LIKE '%Days%', LTRIM(REPLACE(output,'Days:','')),''))
	+ ' at ' +
    MAX(IIF(output LIKE '%Start Time%', LTRIM(REPLACE(output,'Start Time:','')),''))
AS OsJob_Freq
INTO #OsJob_Freq
FROM #OS_Job_List

--OsJob_Keepday
;WITH CTE
AS
(
SELECT
	output,
	CASE
		WHEN value LIKE '%p "D:\BAK\%' THEN UPPER(REPLACE(REPLACE(value,'p "D:\BAK\',''),'"',''))
		WHEN value LIKE '%p "E:\BAK\%' THEN UPPER(REPLACE(REPLACE(value,'p "E:\BAK\',''),'"',''))
		WHEN value LIKE '%.bak%' THEN '_' + REPLACE(REPLACE(REPLACE(value,'"',''),'.bak',''),'m ','')
		WHEN value LIKE '%d -%' THEN ': ' + REPLACE(value,'d -','') + 'day'
	END path_value
FROM #OS_Job_List
CROSS APPLY STRING_SPLIT(output, '/')
WHERE value LIKE '%d -%'
OR value LIKE '%p "D:\BAK\%'
OR value LIKE '%p "E:\BAK\%'
OR value LIKE '%.bak%'
), CTE2
AS
(
SELECT
    STUFF((
        SELECT path_value
        FROM CTE b
        WHERE a.output = b.output
        FOR XML PATH(''), TYPE
    ).value('.', 'varchar(max)')
    ,1,0,'') AS Result
FROM CTE a
GROUP BY output
)
SELECT TOP 1 STUFF((SELECT ' || ' + Result FROM CTE2 FOR XML PATH('')),1,4,'') AS OsJob_Keepday
INTO #OsJob_Keepday
FROM CTE2

--SQLServer_backup_job_list
;WITH backup_job
AS
(
SELECT
	sysjobs.[name] AS job_name,
	REPLACE(RIGHT(sysjobs.[name], 4),'_','') AS backup_type,
	CASE freq_type
		WHEN 1 THEN 'Run only one times'
		WHEN 4 THEN
			CASE
				WHEN freq_subday_type = 2 THEN 'every ' + CAST (freq_interval AS VARCHAR(3)) + ' day(s)' + '_every ' + CAST(freq_subday_interval AS VARCHAR(7)) + ' sec'
				WHEN freq_subday_type = 4 THEN 'every ' + CAST (freq_interval AS VARCHAR(3)) + ' day(s)' + '_every ' + CAST(freq_subday_interval AS VARCHAR(7)) + ' min'
				WHEN freq_subday_type = 8 THEN 'every ' + CAST (freq_interval AS VARCHAR(3)) + ' day(s)' + '_every ' + CAST(freq_subday_interval AS VARCHAR(7)) + ' hours'
				ELSE 'every ' + CAST (freq_interval AS VARCHAR(3)) + ' day(s)'
			END
		WHEN 64 THEN 'When SQL Server Agent Start'
		WHEN 128 THEN 'Execute when the computer is idle'
		ELSE
			CASE freq_type
				WHEN 8 THEN 'every ' + CAST(freq_recurrence_factor AS VARCHAR(7))  + ' week(s) on ' +
					LEFT
					(
						CASE WHEN freq_interval&1 = 1	 THEN 'Sunday, '	ELSE '' END +
						CASE WHEN freq_interval&2 = 2	 THEN 'Monday, '	ELSE '' END +
						CASE WHEN freq_interval&4 = 4	 THEN 'Tuesday, '	ELSE '' END +
						CASE WHEN freq_interval&8 = 8	 THEN 'Wednesday, ' ELSE '' END +
						CASE WHEN freq_interval&16 = 16	 THEN 'Thursday, '	ELSE '' END +
						CASE WHEN freq_interval&32 = 32	 THEN 'Friday, '	ELSE '' END +
						CASE WHEN freq_interval&64 = 64	 THEN 'Saturday, '	ELSE '' END,
						LEN(
						CASE WHEN freq_interval&1 = 1	 THEN 'Sunday, '	ELSE '' END +
						CASE WHEN freq_interval&2 = 2	 THEN 'Monday, '	ELSE '' END +
						CASE WHEN freq_interval&4 = 4	 THEN 'Tuesday, '	ELSE '' END +
						CASE WHEN freq_interval&8 = 8	 THEN 'Wednesday, ' ELSE '' END +
						CASE WHEN freq_interval&16 = 16	 THEN 'Thursday, '	ELSE '' END +
						CASE WHEN freq_interval&32 = 32	 THEN 'Friday, '	ELSE '' END +
						CASE WHEN freq_interval&64 = 64	 THEN 'Saturday, '	ELSE '' END)-1
					)
				WHEN 16 THEN 'every ' + CAST(freq_recurrence_factor AS VARCHAR(7)) + ' month(s) on ' + CAST(freq_interval AS VARCHAR(3))
				WHEN 32 THEN
					CASE WHEN CAST(freq_recurrence_factor AS VARCHAR(7)) = 1 THEN ' Monthly '
						ELSE 'every ' + CAST(freq_recurrence_factor AS VARCHAR(7)) + ' month(s) on ' END +
					CASE
						WHEN freq_relative_interval = 1	 THEN 'First '
						WHEN freq_relative_interval = 2	 THEN 'Second '
						WHEN freq_relative_interval = 4	 THEN 'Third '
						WHEN freq_relative_interval = 8	 THEN 'Fourth '
						WHEN freq_relative_interval = 16 THEN 'Last '
					END +
					LEFT
					(
						CASE WHEN freq_interval = 1	 THEN 'Sunday, '		ELSE '' END +
						CASE WHEN freq_interval = 2	 THEN 'Monday, '		ELSE '' END +
						CASE WHEN freq_interval = 3	 THEN 'Tuesday, '		ELSE '' END +
						CASE WHEN freq_interval = 4	 THEN 'Wednesday, '		ELSE '' END +
						CASE WHEN freq_interval = 5	 THEN 'Thursday, '		ELSE '' END +
						CASE WHEN freq_interval = 6	 THEN 'Friday, '		ELSE '' END +
						CASE WHEN freq_interval = 7	 THEN 'Saturday, '		ELSE '' END +
						CASE WHEN freq_interval = 8	 THEN 'Day of Month, '	ELSE '' END +
						CASE WHEN freq_interval = 9	 THEN 'Weekday, '		ELSE '' END +
						CASE WHEN freq_interval = 10 THEN 'Weekend day, '	ELSE '' END,
						LEN(
						CASE WHEN freq_interval = 1	 THEN 'Sunday, '		ELSE '' END +
						CASE WHEN freq_interval = 2	 THEN 'Monday, '		ELSE '' END +
						CASE WHEN freq_interval = 3	 THEN 'Tuesday, '		ELSE '' END +
						CASE WHEN freq_interval = 4	 THEN 'Wednesday, '		ELSE '' END +
						CASE WHEN freq_interval = 5	 THEN 'Thursday, '		ELSE '' END +
						CASE WHEN freq_interval = 6	 THEN 'Friday, '		ELSE '' END +
						CASE WHEN freq_interval = 7	 THEN 'Saturday, '		ELSE '' END +
						CASE WHEN freq_interval = 8	 THEN 'Day of Month, '	ELSE '' END +
						CASE WHEN freq_interval = 9	 THEN 'Weekday, '		ELSE '' END +
						CASE WHEN freq_interval = 10 THEN 'Weekend day, '	ELSE '' END)-1
					)
			END +
			CASE
				WHEN freq_subday_type = 2 THEN ' every ' + CAST(freq_subday_interval AS VARCHAR(7)) + ' sec'
				WHEN freq_subday_type = 4 THEN ' every ' + CAST(freq_subday_interval AS VARCHAR(7)) + ' min'
				WHEN freq_subday_type = 8 THEN ' every ' + CAST(freq_subday_interval AS VARCHAR(7)) + ' hours'
				ELSE ''
			END
	END AS frequency,
	CASE WHEN freq_type IN(1,64,128) THEN 'NULL' ELSE
		CASE
			WHEN freq_subday_type = 2 THEN STUFF(STUFF(RIGHT(REPLICATE('0', 6) +  CAST(active_start_time AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')
			WHEN freq_subday_type = 4 THEN STUFF(STUFF(RIGHT(REPLICATE('0', 6) +  CAST(active_start_time AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')
			WHEN freq_subday_type = 8 THEN STUFF(STUFF(RIGHT(REPLICATE('0', 6) +  CAST(active_start_time AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')
			ELSE STUFF(STUFF(RIGHT(REPLICATE('0', 6) +  CAST(active_start_time AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')
		END
	END AS starting_time,
    sysjobsteps.step_name AS StepName,
	sysjobsteps.database_name AS DB,
    sysjobsteps.command AS Command
FROM msdb.dbo.sysjobs
INNER JOIN msdb.dbo.sysjobschedules	 ON sysjobs.job_id = sysjobschedules.job_id
INNER JOIN msdb.dbo.sysschedules	 ON sysjobschedules.schedule_id = sysschedules.schedule_id
INNER JOIN msdb.dbo.sysjobactivity	 ON sysjobactivity.job_id = sysjobs.job_id
INNER JOIN msdb.dbo.sysjobsteps		 ON sysjobs.job_id = sysjobsteps.job_id
WHERE session_id = (SELECT MAX(session_id) FROM msdb.dbo.sysjobactivity)
AND sysjobs.[name] LIKE '%backup%'
), CTE
AS
(
SELECT
	CASE
    WHEN EXISTS (
        SELECT 1
        FROM backup_job x
        WHERE x.job_name = t.job_name
        AND (
            (
                x.StepName = 'Check Replica - Primary'
                AND master.dbo.fn_hadr_is_primary_replica(
                        SUBSTRING(
                            x.command,
                            CHARINDEX('(''', x.command) + 2,
                            CHARINDEX(''')', x.command) - CHARINDEX('(''', x.command) - 2
                        )
                    ) <> 1
            )
            OR
            (
                x.StepName = 'Check Replica - Secondary'
                AND master.dbo.fn_hadr_is_primary_replica(
                        SUBSTRING(
                            x.command,
                            CHARINDEX('(''', x.command) + 2,
                            CHARINDEX(''')', x.command) - CHARINDEX('(''', x.command) - 2
                        )
                    ) <> 0
            )
            )
    )
    THEN NULL
	ELSE t.StepName
	END AS step_name,
	IIF(DB = 'master', LTRIM(RTRIM(
    CASE
        WHEN LEFT(StepName, 1) = '('
                AND CHARINDEX(')', StepName) > 0
                AND CHARINDEX(':', StepName) > CHARINDEX(')', StepName)
        THEN SUBSTRING(
                StepName,
                CHARINDEX(')', StepName) + 1,
                CHARINDEX(':', StepName) - CHARINDEX(')', StepName) - 1
                )
        WHEN CHARINDEX('(', StepName) > 0
        THEN LEFT(
                StepName,
                CHARINDEX('(', StepName) - 1
                )
        WHEN CHARINDEX(':', StepName) > 0
        THEN LEFT(
                StepName,
                CHARINDEX(':', StepName) - 1
                )
        ELSE StepName
    END
	)),DB) AS DBName,
	backup_type,
	CASE
		WHEN Command LIKE '%IF (DAY(GETDATE()) = %BEGIN%'
		THEN 'every 1 month(s) on ' +
        LTRIM(RTRIM(SUBSTRING(
            Command,
            CHARINDEX('=', Command) + 1,
            CHARINDEX(')', Command, CHARINDEX('=', Command)) - CHARINDEX('=', Command) - 1
        )))
		ELSE frequency
	END + ' at ' + starting_time AS frequency
FROM backup_job t
)
SELECT *
FROM
(
	SELECT
		DBName,
		backup_type,
		frequency
	FROM CTE
	WHERE step_name LIKE '%back%'
) s
PIVOT
(
    MAX(frequency)
    FOR backup_type IN ([full], [diff], [log])
) AS pt
CROSS APPLY #OsJob_Freq
CROSS APPLY #OsJob_Keepday