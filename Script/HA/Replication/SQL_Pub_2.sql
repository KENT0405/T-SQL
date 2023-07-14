DECLARE
	@SQL_publication		NVARCHAR(MAX) = '',
	@SQL_snapshot			NVARCHAR(MAX) = '',
	@SQL_user_login			NVARCHAR(MAX) = '',
	@SQL_articles			NVARCHAR(MAX) = '',
	@DBname					VARCHAR(100) = '-',
	@TBname					VARCHAR(100) = '',
	@pubname				VARCHAR(100) = '',
	@user_sysadmin			VARCHAR(100) = '',
	@articles_source_owner	VARCHAR(20) = '',
	@articles_description	VARCHAR(MAX) = '',
	@articles_craete_script	VARCHAR(MAX) = '',
	@articles_schema_option BINARY(8),
	@articles_del_cmd		VARCHAR(100) = '',
	@articles_ins_cmd		VARCHAR(100) = '',
	@articles_upd_cmd		VARCHAR(100) = '',
	@partition_columns		VARCHAR(100) = '',
	@view_name				VARCHAR(100) = '',
	@filter_clause			VARCHAR(100) = '',
	@filter					INT,
	@artid					INT,
	@sn						INT = 1,
	@id						INT = 1,
	@pubid					INT = 1,
	@article_id				INT = 1,
	@rank					INT = 1		--partition columns

DROP TABLE IF EXISTS #DBtemp, #TBpub;

CREATE TABLE #TBpub
(
	lI							VARCHAR(2),
	DBname						VARCHAR(100),
	PubName						VARCHAR(100),
	ll							VARCHAR(2),
	Addpublication				NVARCHAR(MAX),
	Addpublication_snapshot		NVARCHAR(MAX),
	Adduser						NVARCHAR(MAX),
	Addarticles					NVARCHAR(MAX)
)

CREATE TABLE #DBtemp
(
	sn INT IDENTITY(1,1),
	DBname VARCHAR(100)
)

--如果 @DBname = '-' 查出全部, 否則列出各項
IF (@DBname = '-')
BEGIN
	INSERT INTO #DBtemp
	SELECT [name]
	FROM sys.databases
	WHERE is_published = 1
END
ELSE
BEGIN
	INSERT INTO #DBtemp
	SELECT * FROM string_split(@DBname,',')
END

--DB Level
WHILE(1 = 1)
BEGIN
	SELECT @DBname = DBname
	FROM #DBtemp
	WHERE sn = @sn

	IF (@@ROWCOUNT = 0)
		BREAK;

	DROP TABLE IF EXISTS ##syspublications, ##sysarticles, ##_sysarticles,##sysarticlecolumns;

	--將資料insert進全域表，方便整理使用
	EXEC ('SELECT * INTO ##syspublications FROM '+ @DBname +'.dbo.syspublications')
	EXEC ('
	SELECT [creation_script],[del_cmd],[description],[dest_table],[filter],[filter_clause],[ins_cmd],[name],[objid],[pubid],[pre_creation_cmd],[status],[sync_objid],[type],[upd_cmd],[schema_option],[dest_owner]
	INTO ##sysarticles
	FROM '+ @DBname +'.dbo.sysarticles

	ALTER TABLE ##sysarticles ALTER COLUMN filter INT NULL
	ALTER TABLE ##sysarticles ALTER COLUMN pre_creation_cmd TINYINT NULL
	ALTER TABLE ##sysarticles ALTER COLUMN sync_objid INT NULL

	INSERT INTO ##sysarticles
	SELECT [creation_script],NULL,[description],[dest_object],NULL,NULL,NULL,[name],[objid],[pubid],[pre_creation_cmd],[status],NULL,[type],NULL,[schema_option],[dest_owner]
	FROM '+ @DBname +'.dbo.sysschemaarticles')
	EXEC('SELECT * INTO ##_sysarticles FROM '+ @DBname +'.dbo.sysarticles')
	EXEC('SELECT * INTO ##sysarticlecolumns FROM '+ @DBname +'.dbo.sysarticlecolumns')

	--DB -> TB Level
	WHILE(1 = 1)
	BEGIN

	SELECT @pubname = [name]
	FROM ##syspublications
	WHERE pubid = @pubid

	IF (@@ROWCOUNT = 0)
		BREAK;

	SET @SQL_publication = N'
	/******************************************************************************************************************************************************/
	-- Adding the transactional publication "' + @pubname + '"
	USE [' + @DBname + ']
	GO
	EXEC sp_addpublication
		@publication = N''' + @pubname  + ''',
		@description = N''Transactional publication of database ''''' + @DBname + ''''' from Publisher ''''' + @@SERVERNAME + '''''.'',
		@sync_method = N''Concurrent'',
		@retention = 0,
		@allow_push = N''' + CASE WHEN (SELECT allow_push FROM ##syspublications WHERE pubid = @pubid) = 1 THEN 'true' ELSE 'false' END + ''',
		@allow_pull = N''' + CASE WHEN (SELECT allow_pull FROM ##syspublications WHERE pubid = @pubid) = 1 THEN 'true' ELSE 'false' END + ''',
		@allow_anonymous = N''' + CASE WHEN (SELECT allow_anonymous FROM ##syspublications WHERE pubid = @pubid) = 1 THEN 'true' ELSE 'false' END + ''',
		@enabled_for_internet = N''' + CASE WHEN (SELECT enabled_for_internet FROM ##syspublications WHERE pubid = @pubid) = 1 THEN 'true' ELSE 'false' END + ''',
		@snapshot_in_defaultfolder = N''' + CASE WHEN (SELECT snapshot_in_defaultfolder FROM ##syspublications WHERE pubid = @pubid) = 1 THEN 'true' ELSE 'false' END + ''',
		@compress_snapshot = N''' + CASE WHEN (SELECT compress_snapshot FROM ##syspublications WHERE pubid = @pubid) = 1 THEN 'true' ELSE 'false' END + ''',
		@ftp_port = 21,
		@ftp_login = N''anonymous'',
		@allow_subscription_copy = N''' + CASE WHEN (SELECT allow_subscription_copy FROM ##syspublications WHERE pubid = @pubid) = 1 THEN 'true' ELSE 'false' END + ''',
		@add_to_active_directory = N''false'',
		@repl_freq = N''continuous'',
		@status = N''active'',
		@independent_agent = N''' + CASE WHEN (SELECT independent_agent FROM ##syspublications WHERE pubid = @pubid) = 1 THEN 'true' ELSE 'false' END + ''',
		@immediate_sync = N''' + CASE WHEN (SELECT immediate_sync FROM ##syspublications WHERE pubid = @pubid) = 1 THEN 'true' ELSE 'false' END + ''',
		@allow_sync_tran = N''' + CASE WHEN (SELECT allow_sync_tran FROM ##syspublications WHERE pubid = @pubid) = 1 THEN 'true' ELSE 'false' END + ''',
		@autogen_sync_procs = N''' + CASE WHEN (SELECT autogen_sync_procs FROM ##syspublications WHERE pubid = @pubid) = 1 THEN 'true' ELSE 'false' END + ''',
		@allow_queued_tran = N''' + CASE WHEN (SELECT allow_queued_tran FROM ##syspublications WHERE pubid = @pubid) = 1 THEN 'true' ELSE 'false' END + ''',
		@allow_dts = N''' + CASE WHEN (SELECT allow_dts FROM ##syspublications WHERE pubid = @pubid) = 1 THEN 'true' ELSE 'false' END + ''',
		@replicate_ddl = 1,
		@allow_initialize_from_backup = N''' + CASE WHEN (SELECT allow_initialize_from_backup FROM ##syspublications WHERE pubid = @pubid) = 1 THEN 'true' ELSE 'false' END + ''',
		@enabled_for_p2p = N''false'',
		@enabled_for_het_sub = N''false''
	GO
	'

	SET @SQL_snapshot = N'
	EXEC sp_addpublication_snapshot
		@publication = N''' + @pubname  + ''',
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
		@job_login = NULL,
		@job_password = NULL,
		@publisher_security_mode = 1
	GO
	'

	--DB -> TB -> Logins Level
	WHILE(1 = 1)
	BEGIN

	;WITH CTE
	AS
	(
		SELECT
			ROW_NUMBER() OVER (ORDER BY [name]) AS ID,
			[name]
		FROM sys.syslogins
		WHERE sysadmin = 1
	)
	SELECT @user_sysadmin = [name]
	FROM CTE
	WHERE ID = @id

	IF (@@ROWCOUNT = 0)
		BREAK;

	SET @SQL_user_login +=
	CASE WHEN @id = 1 THEN '
	-- Adding User' ELSE '' END + N'
	EXEC sp_grant_publication_access @publication = N''' + @pubname + ''', @login = N''' + @user_sysadmin + ''''
	+ CASE WHEN (SELECT COUNT(1) FROM sys.syslogins WHERE sysadmin = 1) = @id THEN '
	GO' ELSE '' END + ''

	SET @id += 1

	END

	--DB -> TB -> Articles Level
	WHILE(1 = 1)
	BEGIN

	DROP TABLE IF EXISTS #articles;
	SELECT
		ROW_NUMBER() OVER (ORDER BY pubid) AS ID,
		*
	INTO #articles
	FROM ##sysarticles
	WHERE pubid = @pubid

	SELECT
		@articles_source_owner = dest_owner,
		@articles_description = [description],
		@articles_craete_script = creation_script,
		@articles_schema_option = schema_option,
		@filter_clause = filter_clause,
		@filter = [filter],
		@articles_del_cmd = del_cmd,
		@articles_ins_cmd = ins_cmd,
		@articles_upd_cmd = upd_cmd,
		@TBname = dest_table
	FROM #articles
	WHERE ID = @article_id

	IF @@ROWCOUNT = 0
		BREAK;

	SET @SQL_articles +=
	CASE WHEN @article_id = 1 THEN '

	-- Adding the transactional articles' ELSE '' END + N'
	EXEC sp_addarticle
		@publication = N''' + @pubname + ''',
		@article = N''' + @TBname + ''',
		@source_owner = N''' + @articles_source_owner + ''',
		@source_object = N''' + @TBname + ''',
		@type = N''' + CASE WHEN (SELECT [type] FROM #articles WHERE ID = @article_id) = 1 THEN 'logbased' ELSE 'proc schema only' END + ''',
		@description = N''' + @articles_description + ''',
		@creation_script = N''' + @articles_craete_script + ''',
		@pre_creation_cmd = N'''+ CASE (SELECT pre_creation_cmd FROM #articles WHERE ID = @article_id) WHEN 0 THEN 'NONE' WHEN 1 THEN 'DROP' WHEN 2 THEN 'DELETE' ELSE 'TRUNCATE' END + ''',
		@schema_option = ' + CONVERT(VARCHAR(50),@articles_schema_option,1)+ ','
		+ CASE WHEN @filter_clause IS NULL THEN '' ELSE '@identityrangemanagementoption = N''manual'',' END + '
		@destination_table = N''' + @TBname + ''',
		@destination_owner = N''' + @articles_source_owner + ''',
		@status = ' + CASE WHEN (SELECT [status] FROM #articles WHERE ID = @article_id) = 17 THEN '16' ELSE '24,' END + '
		'+ CASE WHEN @filter IS NULL THEN '' ELSE '@vertical_partition = N''true'',' END + '
		'+ CASE WHEN @articles_ins_cmd IS NULL THEN '' ELSE '@ins_cmd = N''' + @articles_ins_cmd + ''',' END + '
		'+ CASE WHEN @articles_del_cmd IS NULL THEN '' ELSE '@del_cmd = N''' + @articles_del_cmd + ''',' END + '
		'+ CASE WHEN @articles_upd_cmd IS NULL THEN '' ELSE '@upd_cmd = N''' + @articles_upd_cmd + '''' END + '
		'+ CASE WHEN @filter_clause IS NULL THEN '' ELSE ',@filter_clause = N''' + @filter_clause + '''' END + '
	GO
	'

	--查出partition columns的Table有哪些
	SELECT @artid = CTE.artid
	FROM
	(
		SELECT artid,COUNT(colid) AS count
		FROM ##sysarticlecolumns
		GROUP BY artid
	) AS CTE
	JOIN ##_sysarticles AS art
	ON CTE.artid = art.artid
	JOIN
	(
		SELECT obj.name,COUNT(col.name) AS count
		FROM sys.all_columns AS col
		JOIN sys.all_objects AS obj
		ON col.object_id = obj.object_id
		WHERE type = 'U'
		GROUP BY obj.name
	)AS cnt
	ON art.dest_table = cnt.name
	WHERE CTE.count <> cnt.count
	AND art.dest_table = @TBname

	IF (@@ROWCOUNT <> 0) --確認table是否有配對到
	BEGIN

	DROP TABLE IF EXISTS #partition_columns;

	;WITH CTE1 --找出partition columns
	AS
	(
		SELECT ROW_NUMBER() OVER(ORDER BY obj.name) AS ID, col.name
		FROM sys.objects AS obj
		JOIN sys.all_columns AS col
		ON obj.object_id = col.object_id
		WHERE obj.name = @TBname
	)
	SELECT ROW_NUMBER() OVER(ORDER BY scol.colid) AS [rank], CTE1.name
	INTO #partition_columns
	FROM [idc_data].[dbo].[sysarticlecolumns] AS scol JOIN CTE1
	ON scol.colid = CTE1.ID
	WHERE scol.artid = @artid

	WHILE(1 = 1)
	BEGIN

	SELECT @partition_columns = [name]
	FROM #partition_columns
	WHERE [rank] = @rank

	IF @@ROWCOUNT = 0
	BEGIN
		SET @SQL_articles += '
	GO'
		BREAK;
	END

	SET @SQL_articles +=
	CASE WHEN @rank = 1 THEN '
	-- Adding the article''s partition column(s)' ELSE '' END + '
	EXEC sp_articlecolumn @publication = N''' + @TBname + ''', @article = N''' + @TBname + ''', @column = N''' + @partition_columns + ''', @operation = N''add'', @force_invalidate_snapshot = 1, @force_reinit_subscription = 1'

	SET @rank += 1

	END --WHILE

	END --IF

	SELECT @view_name = [name]
	FROM sys.views
	WHERE [name] LIKE '%' + @TBname + '%'
	AND is_ms_shipped = 1

	IF(@@ROWCOUNT <> 0)
	BEGIN

	SET @SQL_articles += '

	-- Adding the article synchronization object
	EXEC sp_articleview
		@publication = N''' + @pubname + ''',
		@article = N''' + @TBname + ''',
		@view_name = N''' + @view_name + ''',
		@filter_clause = N''' + CASE WHEN @filter_clause IS NULL THEN '' ELSE @filter_clause END + ''',
		@force_invalidate_snapshot = 1,
		@force_reinit_subscription = 1
	GO
	'

	END

	SET @article_id += 1

	END	--WHILE

	INSERT INTO #TBpub VALUES('/*',@DBname,@TBname,'*/',@SQL_publication,@SQL_snapshot,@SQL_user_login,@SQL_articles)

	SET @pubid += 1
	SET @rank = 1
	SET @id = 1
	SET @article_id = 1
	SET @SQL_user_login = ''
	SET @SQL_articles = ''

	END

	SET @pubid = 1
	SET @sn += 1
END

SELECT * FROM #TBpub