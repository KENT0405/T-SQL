---------------------------------------------
---------- JOB overview command -------------
---------------------------------------------
SELECT
    jobs.name AS JobName,
    steps.step_id AS StepID,
    steps.step_name AS StepName,
    steps.subsystem AS Subsystem,
    steps.command AS Command
FROM msdb..sysjobs AS jobs
INNER JOIN msdb..sysjobsteps AS steps ON jobs.job_id = steps.job_id
--WHERE command LIKE '%Procedure_Name%'
ORDER BY JobName, StepID


---------------------------------------------
------ JOB 裡面的所有 procedure (新版) -------
---------------------------------------------
;WITH CTE AS
(
    SELECT DISTINCT
        LTRIM(RTRIM(s.value)) AS Segment
    FROM msdb.dbo.sysjobs AS jobs
    INNER JOIN msdb.dbo.sysjobsteps AS steps ON jobs.job_id = steps.job_id
    CROSS APPLY STRING_SPLIT
	(
		REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(steps.command,
						CHAR(9), ' '),  -- 替換 TAB
                        CHAR(10), ' '), -- 替換 Enter
                        CHAR(13), ' '), -- 替換 Enter
                        '[', ''),       -- 移除方括號
                        ']', ''),       -- 移除方括號
                        ';', ' '),      -- 移除分號
                        ' '             -- 最後拆分空格
    ) AS s
    WHERE LTRIM(RTRIM(s.value)) <> '' -- 過濾空值
)
SELECT DISTINCT p.name
FROM sys.procedures p
JOIN CTE ps ON p.name = ps.Segment
ORDER BY p.name;


---------------------------------------------
------ JOB 裡面的所有 procedure (舊版) -------
---------------------------------------------
;WITH CTE
AS
(
	SELECT s.value AS Segment
	FROM msdb.dbo.sysjobs AS jobs
	INNER JOIN msdb.dbo.sysjobsteps AS steps ON jobs.job_id = steps.job_id
	CROSS APPLY STRING_SPLIT(steps.command, ' ') AS s
),CTE2
AS
(
	SELECT s.value AS Segment
	FROM CTE CROSS APPLY STRING_SPLIT(Segment, '''') AS s
),CTE3
AS
(
	SELECT s.value AS Segment
	FROM CTE2 CROSS APPLY STRING_SPLIT(Segment, '.') AS s
),CTE4
AS
(
	SELECT s.value AS Segment
	FROM CTE3 CROSS APPLY STRING_SPLIT(Segment, '[') AS s
),CTE5
AS
(
	SELECT s.value AS Segment
	FROM CTE4 CROSS APPLY STRING_SPLIT(Segment, ']') AS s
),CTE6
AS
(
	SELECT s.value AS Segment
	FROM CTE5 CROSS APPLY STRING_SPLIT(Segment, ';') AS s
),CTE7
AS
(
	SELECT s.value AS Segment
	FROM CTE6 CROSS APPLY STRING_SPLIT(Segment, CHAR(9)) AS s --CHAR(9) = 'TAB鍵'
),CTE8
AS
(
	SELECT s.value AS Segment
	FROM CTE7 CROSS APPLY STRING_SPLIT(Segment, CHAR(10)) AS s --CHAR(10) = 'Enter鍵'
),CTE9
AS
(
	SELECT s.value AS Segment
	FROM CTE8 CROSS APPLY STRING_SPLIT(Segment, CHAR(13)) AS s --CHAR(13) = 'Enter鍵'
)
SELECT DISTINCT name
FROM sys.procedures p
JOIN CTE9 c ON p.name = c.Segment
ORDER BY name