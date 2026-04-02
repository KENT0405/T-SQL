DECLARE @SQL NVARCHAR(MAX),
		@SQL_PK NVARCHAR(MAX),
		@date_range VARCHAR(100),
		@date_range_PK VARCHAR(100),
		@save_start_date DATETIME,
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
			@save_start_date = CTE.save_start_date,
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
	INSERT INTO one_wallet_transfer_all
	SELECT *
	FROM one_wallet_transfer_copyfail WITH (NOLOCK)
	WHERE is_success > 0
	AND ' + @date_range + '
	
	SET @copy_records_count = @@ROWCOUNT

	UPDATE sys_data_copy_log 
	SET copy_records_count = @copy_records_count, status = 1
	WHERE id = ' + @ID 
	ELSE '' END +

	CASE WHEN @save_start_date < FORMAT(GETDATE(),'yyyy-MM-dd 06:00:00') OR @status = -2 THEN N'
	----------------------------------------------------------------------------------------
	DELETE
	FROM one_wallet_transfer_copyfail
	WHERE is_success > 0
	AND ' + @date_range + '

	SET @del_records_count = @@ROWCOUNT

	UPDATE sys_data_copy_log 
	SET del_records_count = @del_records_count,
		delete_date = GETDATE(),
		status = CASE WHEN @del_records_count = @copy_records_count THEN 2 ELSE 3 END
	WHERE id = ' + @ID + ''
	ELSE '' END +
	'
	----------------------------------------------------------------------------------------
	SELECT * FROM sys_data_copy_log WITH(NOLOCK) WHERE id = ' + @ID + '
	'

	INSERT INTO @T
	SELECT *,@SQL
	FROM sys_data_copy_log WITH(NOLOCK)
	WHERE status < 0 AND id = @ID

	IF (SELECT COUNT(*) FROM dbo.sys_data_copy_log WHERE status < 0 ) = @i 
		OR (SELECT COUNT(*) FROM dbo.sys_data_copy_log WHERE status < 0 ) = 0
		BREAK;

	SET @i += 1
END

SET @SQL_PK = N'
SELECT COUNT(*)
FROM one_wallet_transfer AS A WITH(NOLOCK) 
JOIN one_wallet_transfer_all AS B WITH(NOLOCK)
ON A.id = B.id 
AND A.save_date = B.save_date
WHERE ' + @date_range_PK + '
'

SELECT *, @SQL_PK AS Search_PK 
FROM @T
