DECLARE @SQL NVARCHAR(MAX),
		@SQL_PK NVARCHAR(MAX),
		@date_range VARCHAR(100),
		@date_range_PK VARCHAR(100),
		@status INT,
		@ID VARCHAR(10),
		@i INT = 1

DECLARE @T TABLE
(
	id INT NOT NULL,
	table_name VARCHAR(50) NULL,
	save_start_date DATETIME NULL,
	save_end_date DATETIME NULL,
	copy_date DATETIME NULL,
	copy_records_count INT NULL,
	delete_date DATETIME NULL,
	del_records_count INT NULL,
	status VARCHAR(50) NULL,
	log_date DATE NULL,
	str VARCHAR(MAX)
)

WHILE(1 = 1)
BEGIN
	;WITH CTE
	AS
	(
	SELECT ROW_NUMBER() OVER(ORDER BY log_date ASC) AS Num,*
	FROM dbo.sys_data_copy_log WITH(NOLOCK)
	WHERE status < 0
	)
	SELECT  @ID = CTE.id,
			@status = CTE.status,
			@date_range = 'save_date >= ''' + FORMAT(CTE.save_start_date,'yyyy-MM-dd HH:mm:ss.000') + ''' AND save_date < ''' + FORMAT(CTE.save_end_date,'yyyy-MM-dd HH:mm:ss.000') + '''' ,
			@date_range_PK =  'A.save_date >= ''' + FORMAT(CTE.save_start_date,'yyyy-MM-dd HH:mm:ss.000') + ''' AND A.save_date < ''' + FORMAT(CTE.save_end_date,'yyyy-MM-dd HH:mm:ss.000') + ''''
	FROM CTE
	WHERE CTE.Num = @i

	SET @SQL = N'
	DECLARE @copy_records_count VARCHAR(30) = '''',
			@del_records_count VARCHAR(30) = ''''' +
	CASE WHEN @status = -1 THEN N'
	----------------------------------------------------------------------------------------
	INSERT INTO ticket_all
	SELECT *
	FROM ticket_switch WITH (NOLOCK)
	WHERE ' + @date_range + '

	SET @copy_records_count = @@ROWCOUNT

	UPDATE sys_data_copy_log
	SET copy_records_count = @copy_records_count, status = 1
	WHERE id = ' + @ID
	ELSE '' END + N'
	----------------------------------------------------------------------------------------
	DELETE
	FROM ticket_switch
	WHERE ' + @date_range + '

	SET @del_records_count = @@ROWCOUNT

	UPDATE sys_data_copy_log
	SET del_records_count = @del_records_count,
		delete_date = GETDATE(),
		status = CASE WHEN @del_records_count = @copy_records_count THEN 2 ELSE 3 END
	WHERE id = ' + @ID + '
	----------------------------------------------------------------------------------------
	SELECT * FROM sys_data_copy_log WITH(NOLOCK) WHERE id = ' + @ID + '
	'

	INSERT INTO @T
	SELECT *,@SQL
	FROM sys_data_copy_log WITH(NOLOCK)
	WHERE status < 0 AND id = @ID

	IF 	(SELECT COUNT(*) FROM dbo.sys_data_copy_log WHERE status < 0 ) = @i OR
		(SELECT COUNT(*) FROM dbo.sys_data_copy_log WHERE status < 0 ) = 0
		BREAK;

	SET @i += 1
END

SET @SQL_PK = N'
SELECT COUNT(*)
FROM ticket_switch AS A WITH(NOLOCK)
JOIN ticket_all AS B WITH(NOLOCK)
ON A.ticket_id = B.ticket_id
AND A.ticket_date = B.ticket_date
WHERE ' + @date_range_PK + '
'

SELECT *, @SQL_PK AS Search_PK
FROM @T
