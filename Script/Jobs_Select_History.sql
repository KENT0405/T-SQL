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
ORDER BY CTE.Rundate DESC