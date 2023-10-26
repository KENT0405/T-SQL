USE msdb

SELECT
    jobs.name AS JobName,
    steps.step_id AS StepID,
    steps.step_name AS StepName,
    steps.subsystem AS Subsystem,
    steps.command AS Command
FROM sysjobs AS jobs
INNER JOIN sysjobsteps AS steps ON jobs.job_id = steps.job_id
ORDER BY JobName, StepID
