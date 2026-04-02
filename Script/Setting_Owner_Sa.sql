SELECT 'ALTER AUTHORIZATION ON DATABASE::[' + name + '] TO [Db_user]' AS sqlstring
FROM master.sys.databases
WHERE database_id > 4 AND name <> 'distribution'
UNION ALL
SELECT 'EXEC msdb.dbo.sp_update_job @job_id=N''' + CONVERT(VARCHAR(100),job_id) + ''', @owner_login_name=N''Db_user''' AS sqlstring
FROM msdb.dbo.sysjobs
GO


-- ALTER AUTHORIZATION ON ENDPOINT::Hadr_endpoint TO Db_user;
-- GO
-- ALTER AUTHORIZATION ON AVAILABILITY GROUP::DEV_PMT_AG TO Db_user;
-- GO

-- ALTER AUTHORIZATION ON AVAILABILITY GROUP::DEV_BO_AG TO Db_user;
-- GO