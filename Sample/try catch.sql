CREATE OR ALTER PROC proc_inserttest
AS
BEGIN

BEGIN TRY
	INSERT INTO [acct_role] VALUES (9,'MemApp','2022-01-01')
END TRY
BEGIN CATCH
	EXEC dbo.up_sys_error_log
END CATCH

END
GO

EXEC proc_inserttest


SELECT *
FROM dbo.sys_jobs_errormessage