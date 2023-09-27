CREATE TABLE PROC_TEST
(
	sn int IDENTITY(1,1),
	test VARCHAR(20)
)
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------


CREATE OR ALTER PROC [dbo].[proc_test3] --1、2、3、4
	@test INT
AS
BEGIN

	BEGIN TRAN
		BEGIN TRY

			INSERT INTO PROC_TEST VALUES(@test)

			COMMIT
		END TRY
	BEGIN CATCH

		ROLLBACK
		EXEC dbo.up_sys_error_log

	END CATCH

END
GO
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

BEGIN TRAN
BEGIN TRY

	EXEC [dbo].[proc_test1] 'abc'
	EXEC [dbo].[proc_test2] 'ABC'
	EXEC [dbo].[proc_test3] 'abc'
	EXEC [dbo].[proc_test4] 'abc'

	COMMIT
END TRY
BEGIN CATCH

	ROLLBACK
	EXEC dbo.up_sys_error_log

END CATCH

GO

SELECT *
FROM dbo.sys_jobs_errormessage

TRUNCATE TABLE dbo.sys_jobs_errormessage
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------


--EXEC [dbo].[proc_test1] 'abc'

SELECT * FROM PROC_TEST

TRUNCATE TABLE PROC_TEST

--SELECT * FROM sys.messages WHERE message_id = 8114