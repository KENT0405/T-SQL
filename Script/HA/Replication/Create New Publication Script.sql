-----------------------------------------Create New Publication Script----------------------------------------------
DECLARE-------------------------------------------------------------------------------------------------------------

	@db_name	VARCHAR(30) = 'eucy_egame_jackpot_data'	,	--輸入想要複寫的DB
	@pub_name	VARCHAR(30) = 'test'					,	--輸入publication的名稱

------------------------------------------------以下為"二擇一"------------------------------------------------------

	@tb_name	VARCHAR(30) = ''						,	--輸入想要複寫的表
	@proc_name	VARCHAR(30) = 'up_log_currency'			,	--輸入想要複寫的procedure(ex:'up_log_currency' or '-' : all)

--------------------------------------------以下為"可填" / "可不填"-------------------------------------------------

	@column		VARCHAR(30)	= 'role_id,merchant_code'	,	--輸入想要複寫的欄位(ex: id,ticket_date)
	@filter		VARCHAR(100) = 'role_id = 9'			,	--輸入Where條件(ex: user_id = ''belle'')

--------------------------------------------------------------------------------------------------------------------

	@insert		INT	= 1									,	--(open = 1 \ close = 2)
	@delete		INT	= 1									,	--(open = 1 \ close = 2)
	@update		INT	= 1									,	--(open = 1 \ close = 2)

--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------

	@SQL		NVARCHAR(MAX) = '',
	@SQL_rep_tb	NVARCHAR(MAX) = '',
	@SQL_proc	NVARCHAR(MAX) = '',
	@SQL_col	NVARCHAR(MAX) = '',
	@SQL_synob	NVARCHAR(MAX) = '',
	@SQL_filter	NVARCHAR(MAX) = '',
	@sn			INT = 1

IF (@proc_name <> '')
BEGIN
	SET @tb_name = ''
END

DECLARE @TB_or_proc TABLE
(
	sn INT IDENTITY(1,1),
	col VARCHAR(30)
)

--新增procedure複寫的格式
IF (@tb_name = '' AND @proc_name <> '')
BEGIN
	IF (@proc_name = '-') --如果為 '-' 則列出所有的procedure
	BEGIN
		INSERT INTO @TB_or_proc
		SELECT [name] FROM sys.procedures ORDER BY [name]
	END
	ELSE
	BEGIN	--否則只有 insert 列出來的項目進去
		INSERT INTO @TB_or_proc
		SELECT * FROM STRING_SPLIT(@proc_name,',')
	END

	WHILE(1 = 1)
	BEGIN
		SELECT @proc_name = col
		FROM @TB_or_proc
		WHERE sn = @sn

		IF @@ROWCOUNT = 0
			BREAK;

		SET @SQL_proc += '
		-- Adding the articles procedure(s)
		exec sp_addarticle
			@publication = N''' + @pub_name + ''',
			@article = N''' + @proc_name + ''',
			@source_owner = N''dbo'',
			@source_object = N''' + @proc_name + ''',
			@type = N''proc schema only'',
			@description = null,
			@creation_script = null,
			@pre_creation_cmd = N''drop'',
			@schema_option = 0x0000000008000001,
			@destination_table = N''' + @proc_name + ''',
			@destination_owner = N''dbo''
		'

		SET @sn += 1
	END
END

--新增table複寫的格式
IF (@tb_name <> '' AND @proc_name = '')
BEGIN
	INSERT INTO @TB_or_proc
	SELECT * FROM STRING_SPLIT(@column,',')

	SET @SQL_rep_tb = '
	EXEC sp_addarticle
		@publication = N''' + @pub_name + ''',
		@article = N''' + @tb_name + ''',
		@source_owner = N''dbo'',
		@source_object = N''' + @tb_name + ''',
		@type = N''logbased'',
		@description = null,
		@creation_script = null,
		@pre_creation_cmd = N''drop'',
		@schema_option = 0x000000000803509F,
		@identityrangemanagementoption = N''manual'',
		@destination_table = N''' + @tb_name + ''',
		@destination_owner = N''dbo'',
		@vertical_partition = N''false'',
		@ins_cmd = N''' + CASE @insert WHEN 1 THEN 'CALL sp_MSins_dbo' + @tb_name ELSE 'NONE' END + ''',
		@del_cmd = N''' + CASE @delete WHEN 1 THEN 'CALL sp_MSdel_dbo' + @tb_name ELSE 'NONE' END + ''',
		@upd_cmd = N''' + CASE @update WHEN 1 THEN 'SCALL sp_MSupd_dbo' + @tb_name  ELSE 'NONE' END + '''
		' + CASE WHEN @filter <> '' THEN ',@filter_clause = N''' + @filter + '''' ELSE '' END + '
	'
END

--新增table column的格式
IF (@column <> '' AND @proc_name = '')
BEGIN
	WHILE(1 = 1)
	BEGIN
		SELECT @column = col
		FROM @TB_or_proc
		WHERE sn = @sn

		IF @@ROWCOUNT = 0
			BREAK;

		SET @SQL_col += '
		-- Adding the articles partition column(s)
		exec sp_articlecolumn
			@publication = N''test'',
			@article = N''' + @tb_name + ''',
			@column = N''' + @column + ''',
			@operation = N''add'',
			@force_invalidate_snapshot = 1,
			@force_reinit_subscription = 1
		'

		SET @sn += 1
	END
END

--新增table filter的格式
IF (@filter <> '' AND @proc_name = '')
BEGIN
	SET @SQL_filter = '
	-- Adding the article filter
	EXEC sp_articlefilter
		@publication = N''' + @pub_name + ''',
		@article = N''' + @tb_name + ''',
		@filter_name = N''FLTR_' + @tb_name + ''',
		@filter_clause = N''' + @filter + ''',
		@force_invalidate_snapshot = 1,
		@force_reinit_subscription = 1
	'
END

--新增synchronization object的格式
IF ((@filter <> '' OR @column <> '') AND @proc_name = '')
BEGIN
	SET @SQL_synob = '
	-- Adding the article synchronization object
	EXEC sp_articleview
		@publication = N''' + @pub_name + ''',
		@article = N''' + @tb_name + ''',
		@view_name = N''SYNC_' + @tb_name + ''',
		@filter_clause = ' + CASE WHEN @filter <> '' THEN 'N''' + @filter + '''' ELSE 'null' END + ',
		@force_invalidate_snapshot = 1,
		@force_reinit_subscription = 1
	'
END

SET @SQL = '
/* Create New Publication Script */

-- Enabling the replication database
USE master
EXEC sp_replicationdboption
	@dbname = N''' + @db_name + ''',
	@optname = N''publish'',
	@value = N''true''

-- Adding the transactional publication
USE ' + @db_name + '
EXEC sp_addpublication
	@publication = N''' + @pub_name + ''',
    @description = N''Transactional publication of database ''''' + @db_name + ''''' from Publisher ''''' + @@SERVERNAME + '''''.'',
    @sync_method = N''concurrent'',
    @retention = 0,
    @allow_push = N''true'',
    @allow_pull = N''true'',
    @allow_anonymous = N''' + CASE WHEN @proc_name = '' THEN 'true' ELSE 'false' END + ''',
    @enabled_for_internet = N''false'',
    @snapshot_in_defaultfolder = N''true'',
    @compress_snapshot = N''false'',
    @ftp_port = 21,
    @ftp_login = N''anonymous'',
    @allow_subscription_copy = N''false'',
    @add_to_active_directory = N''false'',
    @repl_freq = N''continuous'',
    @status = N''active'',
    @independent_agent = N''true'',
    @immediate_sync = N''' + CASE WHEN @proc_name = '' THEN 'true' ELSE 'false' END + ''',
    @allow_sync_tran = N''false'',
    @autogen_sync_procs = N''false'',
    @allow_queued_tran = N''false'',
    @allow_dts = N''false'',
    @replicate_ddl = 1,
    @allow_initialize_from_backup = N''false'',
    @enabled_for_p2p = N''false'',
    @enabled_for_het_sub = N''false''

EXEC sp_addpublication_snapshot
	@publication = N''' + @pub_name + ''',
	@frequency_type = 1,
	@frequency_interval = 0,
	@frequency_relative_interval = 0,
	@frequency_recurrence_factor = 0,
	@frequency_subday = 0,
	@frequency_subday_interval = 0,
	@active_start_time_of_day = 0,
	@active_end_time_of_day = 235959,
	@active_start_date = 0,
	@active_end_date = 0,
	@job_login = null,
	@job_password = null,
	@publisher_security_mode = 1

	' + @SQL_proc	+ '
	' + @SQL_rep_tb + '
	' +	@SQL_col	+ '
	' + @SQL_filter + '
	' + @SQL_synob  + '
'

PRINT (@SQL)

EXEC(@SQL)