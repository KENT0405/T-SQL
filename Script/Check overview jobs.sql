-- jobs with a daily schedule
SELECT
	sysjobs.[name] AS job_name,
	CASE WHEN sysjobs.[enabled] = 1 THEN 'Enabled' ELSE 'Disabled' END AS [enabled],
	CASE
		WHEN freq_subday_type = 2 
			THEN 'every ' + CAST (freq_interval AS VARCHAR(3)) + ' day(s)' + '_every ' + CAST(freq_subday_interval AS VARCHAR(7)) + ' sec'
		WHEN freq_subday_type = 4 
			THEN 'every ' + CAST (freq_interval AS VARCHAR(3)) + ' day(s)' + '_every ' + CAST(freq_subday_interval AS VARCHAR(7)) + ' min'
		WHEN freq_subday_type = 8 
			THEN 'every ' + CAST (freq_interval AS VARCHAR(3)) + ' day(s)' + '_every ' + CAST(freq_subday_interval AS VARCHAR(7)) + ' hours'
		ELSE     'every ' + CAST (freq_interval AS VARCHAR(3)) + ' day(s)' 
	END AS frequency,
	CASE
		WHEN freq_subday_type = 2 
			THEN STUFF(STUFF(RIGHT(REPLICATE('0', 6) + CAST(active_start_time AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')
		WHEN freq_subday_type = 4 
			THEN STUFF(STUFF(RIGHT(REPLICATE('0', 6) + CAST(active_start_time AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')
		WHEN freq_subday_type = 8 
			THEN STUFF(STUFF(RIGHT(REPLICATE('0', 6) + CAST(active_start_time AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')
		ELSE	 STUFF(STUFF(RIGHT(REPLICATE('0', 6) + CAST(active_start_time AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')
	END AS starting_time
FROM msdb.dbo.sysjobs
INNER JOIN msdb.dbo.sysjobschedules	 ON sysjobs.job_id = sysjobschedules.job_id
INNER JOIN msdb.dbo.sysschedules	 ON sysjobschedules.schedule_id = sysschedules.schedule_id
WHERE freq_type = 4

UNION

-- jobs with a weekly schedule
SELECT
	sysjobs.[name] AS job_name,
	CASE WHEN sysjobs.[enabled] = 1 THEN 'Enabled' ELSE 'Disabled' END AS [enabled],
	CASE WHEN freq_type = 8 THEN 'every week on ' END +
	REPLACE
	(
	 CASE WHEN freq_interval&1 = 1	 THEN 'Sunday, '	ELSE '' END +
	 CASE WHEN freq_interval&2 = 2	 THEN 'Monday, '	ELSE '' END +
	 CASE WHEN freq_interval&4 = 4	 THEN 'Tuesday, '	ELSE '' END +
	 CASE WHEN freq_interval&8 = 8	 THEN 'Wednesday, ' ELSE '' END +
	 CASE WHEN freq_interval&16 = 16 THEN 'Thursday, '	ELSE '' END +
	 CASE WHEN freq_interval&32 = 32 THEN 'Friday, '	ELSE '' END +
	 CASE WHEN freq_interval&64 = 64 THEN 'Saturday, '	ELSE '' END ,', ',''
	) +
	CASE
		WHEN freq_subday_type = 2 
			THEN ' every ' + CAST(freq_subday_interval AS VARCHAR(7)) + ' sec'
		WHEN freq_subday_type = 4 
			THEN ' every ' + CAST(freq_subday_interval AS VARCHAR(7)) + ' min'
		WHEN freq_subday_type = 8 
			THEN ' every ' + CAST(freq_subday_interval AS VARCHAR(7)) + ' hours'
		ELSE '' 
	END AS [Days],
	CASE
		WHEN freq_subday_type = 2 
			THEN STUFF(STUFF(RIGHT(REPLICATE('0', 6) +  CAST(active_start_time AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':') 
		WHEN freq_subday_type = 4 
			THEN STUFF(STUFF(RIGHT(REPLICATE('0', 6) +  CAST(active_start_time AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')
		WHEN freq_subday_type = 8 
			THEN STUFF(STUFF(RIGHT(REPLICATE('0', 6) +  CAST(active_start_time AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')
		ELSE	 STUFF(STUFF(RIGHT(REPLICATE('0', 6) +  CAST(active_start_time AS VARCHAR(6)), 6), 3, 0, ':'), 6, 0, ':')
	END AS TIME
FROM msdb.dbo.sysjobs
INNER JOIN msdb.dbo.sysjobschedules	 ON sysjobs.job_id = sysjobschedules.job_id
INNER JOIN msdb.dbo.sysschedules	 ON sysjobschedules.schedule_id = sysschedules.schedule_id
WHERE freq_type = 8
ORDER BY job_name ASC