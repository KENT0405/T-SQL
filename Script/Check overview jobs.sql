SELECT
	sysjobs.[name] AS job_name,
	CASE WHEN sysjobs.[enabled] = 1 THEN 'Enabled' ELSE 'Disabled' END AS [enabled],
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
	CASE WHEN freq_type IN(1,64,128) THEN 'NULL' ELSE
		CASE
			WHEN freq_subday_type = 2 THEN STUFF(STUFF(RIGHT(REPLICATE('0', 6) + CAST(active_end_time AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')
			WHEN freq_subday_type = 4 THEN STUFF(STUFF(RIGHT(REPLICATE('0', 6) + CAST(active_end_time AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')
			WHEN freq_subday_type = 8 THEN STUFF(STUFF(RIGHT(REPLICATE('0', 6) + CAST(active_end_time AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')
			ELSE STUFF(STUFF(RIGHT(REPLICATE('0', 6) + CAST(active_end_time AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')
		END
	END AS ending_time,
	sysjobactivity.last_executed_step_date AS last_run_date,
	CASE
		WHEN sysjobservers.last_run_outcome = 0 THEN 'fail' 
		WHEN sysjobservers.last_run_outcome = 1 THEN 'OK' 
		WHEN sysjobservers.last_run_outcome = 2 THEN 'retry' 
		WHEN sysjobservers.last_run_outcome = 3 THEN 'cancel' 
		WHEN sysjobservers.last_run_outcome = 4 THEN 'running' 
		ELSE 'unknown' END AS result,
	sysjobservers.last_run_duration AS duration,
	sysjobactivity.next_scheduled_run_date AS next_run_date,
	CASE 
		WHEN freq_type = 1 THEN 'NULL' 
		ELSE CASE
		WHEN freq_type = 64 THEN 'NULL'
		ELSE CASE
		WHEN freq_type = 128 THEN 'NULL'
		ELSE CASE
		WHEN STUFF(CAST(active_end_date AS VARCHAR(10)),5,10,'') = '9999' THEN 'No end date'
		ELSE STUFF(STUFF(CAST(active_end_date AS VARCHAR(10)),5,0,'-'),8,0,'-') END END END
	END AS end_date,
	sysjobs.date_modified
FROM msdb.dbo.sysjobs
INNER JOIN msdb.dbo.sysjobschedules	 ON sysjobs.job_id = sysjobschedules.job_id
INNER JOIN msdb.dbo.sysschedules	 ON sysjobschedules.schedule_id = sysschedules.schedule_id
INNER JOIN msdb.dbo.sysjobactivity	 ON sysjobactivity.job_id = sysjobs.job_id
INNER JOIN msdb.dbo.sysjobservers 	 ON sysjobservers.job_id = sysjobs.job_id
WHERE session_id = (SELECT MAX(session_id) FROM msdb.dbo.sysjobactivity)
ORDER BY sysjobs.[name] ASC