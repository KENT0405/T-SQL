/*
CREATE TABLE [dbo].[TB_schema_bak](
	[db_name] [nvarchar](128) NULL,
	[obj_name] [nvarchar](128) NULL,
	[definition] [nvarchar](max) NULL,
	[type_desc] [nvarchar](60) NULL,
	[modify_date] [datetime] NOT NULL,
	[log_date] [datetime] NOT NULL,
	[status] [int] NULL,
	[version_1] [nvarchar](max) NULL,
	[version_2] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[TB_schema_bak] ADD  CONSTRAINT [status]  DEFAULT ((1)) FOR [status]
GO
*/

CREATE OR ALTER PROC PROC_version_control
AS
BEGIN
	SET NOCOUNT, ARITHABORT ON;

	DECLARE
		@db_name		NVARCHAR(128) = '',
		@obj_name		NVARCHAR(128) = '',
		@definition		NVARCHAR(MAX) = '',
		@modify_date	DATETIME,
		@log_date		DATETIME,
		@status			INT,
		@sn				INT = 1

	DROP TABLE IF EXISTS #temp, #temp_tb;

	SELECT
		DB_NAME() AS db_name,
		OBJECT_NAME(m.object_id) AS obj_name,
		m.definition,
		o.type_desc,
		o.modify_date,
		GETDATE() AS log_date
	INTO #temp
	FROM sys.sql_modules m
	JOIN sys.objects o
	ON m.object_id = o.object_id

	MERGE INTO TB_schema_bak AS T
	USING #temp AS S
	ON T.[db_name] = S.[db_name]
	AND T.obj_name = S.obj_name
	AND T.[definition] = S.[definition]

	WHEN MATCHED THEN
	UPDATE SET
		--如果是0 -> 1 才需要更新log_date
		T.[status] = CASE WHEN T.status = 0 THEN 1 ELSE T.status END,

		--如果內容一樣，modify_date卻有更動，就更新
		T.modify_date = S.modify_date,

		--比對是否在線(status)
		T.log_date = CASE WHEN T.status = 0 THEN GETDATE() ELSE T.log_date END

	WHEN NOT MATCHED BY SOURCE THEN
	UPDATE SET
		T.[status] = 0,
		T.log_date = GETDATE()

	WHEN NOT MATCHED BY TARGET THEN
	INSERT
	(
		db_name,
		obj_name,
		definition,
		type_desc,
		modify_date,
		log_date
	)
	VALUES
	(
		S.db_name,
		S.obj_name,
		S.definition,
		S.type_desc,
		S.modify_date,
		S.log_date
	);

	--比對(definition有更動)
	;WITH CTE
	AS
	(
		SELECT ROW_NUMBER() OVER(PARTITION BY obj_name ORDER BY modify_date) AS ID, *
		FROM TB_schema_bak
	)
	SELECT ROW_NUMBER() OVER(ORDER BY obj_name) AS sn, *
	INTO #temp_tb
	FROM CTE
	WHERE ID > 1

	WHILE(1 = 1)
	BEGIN
		SELECT
			@db_name = [db_name],
			@obj_name = obj_name,
			@definition = [definition],
			@modify_date = modify_date,
			@log_date = log_date,
			@status = [status]
		FROM #temp_tb
		WHERE sn = @sn

		IF @@ROWCOUNT = 0
			BREAK;

		DELETE FROM TB_schema_bak
		WHERE [db_name] = @db_name
		AND obj_name = @obj_name
		AND [definition] = @definition
		AND modify_date = @modify_date
		AND log_date = @log_date

		UPDATE TB_schema_bak
		SET version_1 = [definition],
		version_2 = version_1,
		[definition] = @definition,
		modify_date = @modify_date,
		log_date = @log_date,
		[status] = @status
		WHERE [db_name] = @db_name
		AND obj_name = @obj_name

		SET @sn += 1
	END

	SET NOCOUNT, ARITHABORT OFF;
END