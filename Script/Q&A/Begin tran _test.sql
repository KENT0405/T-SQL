DROP TABLE IF EXISTS PROC_TEST
CREATE TABLE PROC_TEST
(
	sn int PRIMARY KEY,
	test VARCHAR(20)
)
GO
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------


CREATE OR ALTER PROC [dbo].[proc_test4] --1、2、3、4
	@sn INT,
	@test VARCHAR(10)
AS
BEGIN
	BEGIN TRAN
		BEGIN TRY

			INSERT INTO PROC_TEST VALUES(@sn, @test)

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


CREATE OR ALTER PROC tt
AS
BEGIN
	DECLARE @i INT = 1

	WHILE(1=1)
	BEGIN
		BEGIN TRAN

		EXEC [dbo].[proc_test1] 1,'abc'

		EXEC [dbo].[proc_test2] 1,'sda' --error

		EXEC [dbo].[proc_test3] 2,'abc'

		EXEC [dbo].[proc_test4] 3,'asdasd'

		COMMIT

		IF (@i = 2)
			BREAK;

		SET @i += 1
	END
END

/*
SELECT *
FROM dbo.sys_jobs_errormessage

TRUNCATE TABLE dbo.sys_jobs_errormessage

SELECT * FROM PROC_TEST

TRUNCATE TABLE PROC_TEST
*/