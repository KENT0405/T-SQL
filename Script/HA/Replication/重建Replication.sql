SET NOCOUNT ON;

DECLARE
	@SQL_distribution		NVARCHAR(MAX) = '',
	@SQL_publication		NVARCHAR(MAX) = '',
	@SQL_articles			NVARCHAR(MAX) = '',
	@SQL_partition_columns	NVARCHAR(MAX) = '',
	@DBname					VARCHAR(100) = '',
	@TBname					VARCHAR(100) = '',
	@pubname				VARCHAR(100) = '',
	@filter_clause			VARCHAR(100) = '',
	@artid					VARCHAR(100) = '',
	@sn						INT = 1,	--run DB level
	@pubid					INT = 1		--run pubid level

SELECT @SQL_distribution = '
	/****** Begin: Script to be run at Publisher ******/

	-- Adding Distributor
	USE [master]
	exec sp_adddistributor @distributor = N''' + [data_source] + ''', @password = N''''
	exec sp_addsubscriber @subscriber = N''' + [data_source] + ''', @type = 0, @description = N''''
	GO

	/****** End: Script to be run at Publisher ******/

	/****** Begin: Script to be run at Distributor ******/

	-- Adding the agent profiles
	-- Updating the agent profile defaults
	exec sp_MSupdate_agenttype_default @profile_id = 1
	exec sp_MSupdate_agenttype_default @profile_id = 2
	exec sp_MSupdate_agenttype_default @profile_id = 4
	exec sp_MSupdate_agenttype_default @profile_id = 6
	exec sp_MSupdate_agenttype_default @profile_id = 11
	GO

	/****** End: Script to be run at Distributor ******/
'
FROM sys.servers
WHERE is_distributor = 1

DROP TABLE IF EXISTS #DBtemp, #TBpub;

--將所有DB放進暫存表裡
SELECT
	ROW_NUMBER() OVER(ORDER BY [name]) AS sn,
	[name] AS DBname
INTO #DBtemp
FROM sys.databases
WHERE is_published = 1

WHILE(1 = 1)
BEGIN
	SELECT @DBname = DBname
	FROM #DBtemp
	WHERE sn = @sn

	IF (@@ROWCOUNT = 0)
	BEGIN
		SET @SQL_distribution += '
	/****** End: Script to be run at Publisher ******/'
		BREAK;
	END

	SET @SQL_distribution +=
	CASE @sn WHEN 1 THEN '
	/****** Begin: Script to be run at Publisher ******/
	' ELSE '' END + '
	-- Enabling the replication database "' + @DBname + '"
	USE [master]
	exec sp_replicationdboption @dbname = N''' + @DBname + ''', @optname = N''publish'', @value = N''true''
	exec [' + @DBname + '].sys.sp_addlogreader_agent @job_login = null, @job_password = null, @publisher_security_mode = 1
	exec [' + @DBname + '].sys.sp_addqreader_agent @job_login = null, @job_password = null, @frompublisher = 1
	GO
	'

	SET @sn += 1
END
SET @sn = 1

---------------------------------Pub_result_table----------------------------------------
CREATE TABLE #TBpub
(
	DBname				VARCHAR(100),
	PubName				VARCHAR(100),
	Add_distribution	NVARCHAR(MAX),
	Add_publication		NVARCHAR(MAX),
	Add_articles		NVARCHAR(MAX)
)
------------------------------------------------------------------------------------------

--DB Level
WHILE(1 = 1)
BEGIN
	SELECT @DBname = DBname
	FROM #DBtemp
	WHERE sn = @sn

	IF (@@ROWCOUNT = 0)
		BREAK;

	DROP TABLE IF EXISTS ##syslogins, ##all_objects, ##all_columns, ##syspublications, ##sysarticles, ##_sysarticles, ##sysarticlecolumns;

	--將資料insert進全域表，方便整理使用
	EXEC
	('
		USE ['+ @DBname +'];

		SELECT * INTO ##syslogins			FROM sys.syslogins
		SELECT * INTO ##all_objects			FROM sys.all_objects
		SELECT * INTO ##all_columns			FROM sys.all_columns
		SELECT * INTO ##syspublications		FROM syspublications
		SELECT * INTO ##_sysarticles		FROM sysarticles
		SELECT * INTO ##sysarticlecolumns	FROM sysarticlecolumns

		SELECT [creation_script],[del_cmd],[description],[dest_table],[filter],[filter_clause],[ins_cmd],[name],[objid],[pubid],[pre_creation_cmd],art.[status],[sync_objid],[type],[upd_cmd],[schema_option],[dest_owner],[dest_db],[sync_type],[subscription_type],[update_mode],[srvname]
		INTO ##sysarticles
		FROM sysarticles AS art
		JOIN syssubscriptions AS sub
		ON art.artid = sub.artid
		WHERE sub.srvid = 2

		ALTER TABLE ##sysarticles ALTER COLUMN filter INT NULL
		ALTER TABLE ##sysarticles ALTER COLUMN pre_creation_cmd TINYINT NULL
		ALTER TABLE ##sysarticles ALTER COLUMN sync_objid INT NULL

		INSERT INTO ##sysarticles
		SELECT [creation_script],NULL,[description],[dest_object],NULL,NULL,NULL,[name],[objid],[pubid],[pre_creation_cmd],sch.[status],NULL,[type],NULL,[schema_option],[dest_owner],[dest_db],[sync_type],[subscription_type],[update_mode],[srvname]
		FROM dbo.sysschemaarticles AS sch
		JOIN dbo.syssubscriptions AS sub
		ON sch.artid = sub.artid
		WHERE sub.srvid = 2
	')

	--DB -> TB Level
	WHILE(1 = 1)
	BEGIN
		SELECT @pubname = [name]
		FROM ##syspublications
		WHERE pubid = @pubid

		IF (@@ROWCOUNT = 0 AND (SELECT MAX(pubid) FROM ##syspublications) <= @pubid)
			BREAK;

		SELECT @SQL_publication = N'
/******************************************************************************************************************************************************/
		-- Adding the transactional publication "' + @pubname + '"
		USE [' + @DBname + ']
		GO
		EXEC sp_addpublication
			@publication = N''' + @pubname  + ''',
			@description = N''Transactional publication of database ''''' + @DBname + ''''' from Publisher ''''' + @@SERVERNAME + '''''.'',
			@sync_method = N''Concurrent'',
			@retention = 0,
			@allow_push = N''' + CASE WHEN allow_push = 1 THEN 'true' ELSE 'false' END + ''',
			@allow_pull = N''' + CASE WHEN allow_pull = 1 THEN 'true' ELSE 'false' END + ''',
			@allow_anonymous = N''' + CASE WHEN allow_anonymous = 1 THEN 'true' ELSE 'false' END + ''',
			@enabled_for_internet = N''' + CASE WHEN enabled_for_internet = 1 THEN 'true' ELSE 'false' END + ''',
			@snapshot_in_defaultfolder = N''' + CASE WHEN snapshot_in_defaultfolder = 1 THEN 'true' ELSE 'false' END + ''',
			@compress_snapshot = N''' + CASE WHEN compress_snapshot = 1 THEN 'true' ELSE 'false' END + ''',
			@ftp_port = 21,
			@ftp_login = N''anonymous'',
			@allow_subscription_copy = N''' + CASE WHEN allow_subscription_copy = 1 THEN 'true' ELSE 'false' END + ''',
			@add_to_active_directory = N''false'',
			@repl_freq = N''continuous'',
			@status = N''active'',
			@independent_agent = N''' + CASE WHEN independent_agent = 1 THEN 'true' ELSE 'false' END + ''',
			@immediate_sync = N''' + CASE WHEN immediate_sync = 1 THEN 'true' ELSE 'false' END + ''',
			@allow_sync_tran = N''' + CASE WHEN allow_sync_tran = 1 THEN 'true' ELSE 'false' END + ''',
			@autogen_sync_procs = N''' + CASE WHEN autogen_sync_procs = 1 THEN 'true' ELSE 'false' END + ''',
			@allow_queued_tran = N''' + CASE WHEN allow_queued_tran = 1 THEN 'true' ELSE 'false' END + ''',
			@allow_dts = N''' + CASE WHEN allow_dts = 1 THEN 'true' ELSE 'false' END + ''',
			@replicate_ddl = 1,
			@allow_initialize_from_backup = N''' + CASE WHEN allow_initialize_from_backup = 1 THEN 'true' ELSE 'false' END + ''',
			@enabled_for_p2p = N''false'',
			@enabled_for_het_sub = N''false''
		GO

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

		--Adding User'
		FROM ##syspublications
		WHERE pubid = @pubid

		--Logins Level
		SELECT @SQL_publication += N'
		EXEC sp_grant_publication_access @publication = N''' + @pubname + ''', @login = N''' + [name] + ''''
		FROM ##syslogins
		WHERE sysadmin = 1

		SET @SQL_publication += '
		GO'

		--Articles Level
		DROP TABLE IF EXISTS #articles;
		SELECT
			ROW_NUMBER() OVER (ORDER BY pubid) AS ID,
			*
		INTO #articles
		FROM ##sysarticles
		WHERE pubid = @pubid

		SELECT
			@filter_clause = filter_clause,
			@TBname = dest_table
		FROM #articles
		WHERE ID = 1

		IF (@@ROWCOUNT = 0)
			BREAK;

		--查出partition columns的Table有哪些
		SELECT @artid = CTE.artid
		FROM
		(
			--找出複寫TABLE的欄位數量
			SELECT artid,COUNT(colid) AS count
			FROM ##sysarticlecolumns
			GROUP BY artid
		) AS CTE
		JOIN ##_sysarticles AS art --找出對應的TABLE名稱
		ON CTE.artid = art.artid
		JOIN
		(
			--找出真實TABLE的欄位數量
			SELECT obj.name,COUNT(col.name) AS count
			FROM ##all_columns AS col
			JOIN ##all_objects AS obj
			ON col.object_id = obj.object_id
			WHERE type = 'U'
			GROUP BY obj.name
		)AS cnt
		ON art.dest_table = cnt.name
		WHERE CTE.count <> cnt.count --找出有選取欄位的TABLE
		AND art.dest_table = @TBname --縮小範圍直接對應TABLE

		IF (@@ROWCOUNT <> 0) --確認table是否有配對到
		BEGIN
			DROP TABLE IF EXISTS ##partition_columns;

			EXEC --找出partition columns
			('
				;WITH CTE1
				AS
				(
					SELECT ROW_NUMBER() OVER(ORDER BY obj.name) AS ID, col.name
					FROM ' + @DBname + '.sys.objects AS obj
					JOIN ' + @DBname + '.sys.all_columns AS col
					ON obj.object_id = col.object_id
					WHERE obj.name = ''' + @TBname + '''
				)
				SELECT ROW_NUMBER() OVER(ORDER BY scol.colid) AS [rank], CTE1.name
				INTO ##partition_columns
				FROM [idc_data].[dbo].[sysarticlecolumns] AS scol JOIN CTE1
				ON scol.colid = CTE1.ID
				WHERE scol.artid = ' + @artid + '
			')

			SET @SQL_partition_columns += '
		-- Adding the article''s partition column(s)'

			SELECT @SQL_partition_columns +='
		EXEC sp_articlecolumn
			@publication = N''' + @TBname + ''',
			@article = N''' + @TBname + ''',
			@column = N''' + [name] + ''',
			@operation = N''add'',
			@force_invalidate_snapshot = 1,
			@force_reinit_subscription = 1'
			FROM ##partition_columns

			SET @SQL_partition_columns += '
		GO
				'
		END --IF

		SELECT @SQL_articles +='

		-- Adding the transactional articles
		EXEC sp_addarticle
			@publication = N''' + @pubname + ''',
			@article = N''' + @TBname + ''',
			@source_owner = N''' + dest_owner + ''',
			@source_object = N''' + @TBname + ''',
			@type = N''' + CASE WHEN [type] = 1 THEN 'logbased' ELSE 'proc schema only' END + ''',
			@description = N''' + CASE WHEN [description] IS NULL THEN '' ELSE [description] END + ''',
			@creation_script = N''' + CASE WHEN  creation_script IS NULL THEN '' ELSE creation_script END + ''',
			@pre_creation_cmd = N'''+ CASE pre_creation_cmd WHEN 0 THEN 'NONE' WHEN 1 THEN 'DROP' WHEN 2 THEN 'DELETE' ELSE 'TRUNCATE' END + ''',
			@schema_option = ' + CONVERT(VARCHAR(50),schema_option,1)+ ','
			+ CASE WHEN ins_cmd IS NULL THEN '' ELSE '
			@identityrangemanagementoption = N''manual'',' END + '
			@destination_table = N''' + @TBname + ''',
			@destination_owner = N''' + dest_owner + ''',
			@status = ' + CASE WHEN [status] = 17 THEN '16' ELSE '24,' END
			+ CASE WHEN @SQL_partition_columns = '' THEN CASE WHEN ins_cmd IS NULL THEN '' ELSE '
			@vertical_partition = N''false'',' END ELSE '
			@vertical_partition = N''true'',' END
			+ CASE WHEN ins_cmd IS NULL THEN '' ELSE '
			@ins_cmd = N''' + ins_cmd + ''',' END
			+ CASE WHEN del_cmd IS NULL THEN '' ELSE '
			@del_cmd = N''' + del_cmd + ''',' END
			+ CASE WHEN upd_cmd IS NULL THEN '' ELSE '
			@upd_cmd = N''' + upd_cmd + '''' END
			+ CASE WHEN @filter_clause IS NULL THEN '' ELSE '
			,@filter_clause = N''' + @filter_clause + '''' END + '
		GO
		' + @SQL_partition_columns
		FROM #articles
		WHERE ID = 1

		--只要有filter就會有這個 Articles
		IF(@filter_clause <> '')
		BEGIN
			DROP TABLE IF EXISTS ##FILTER_NAME;
			EXEC
			('
				USE [' + @DBname + '];
				SELECT OBJECT_NAME(referencing_id) AS filter_name
				INTO ##FILTER_NAME
				FROM sys.sql_expression_dependencies AS sed
				INNER JOIN sys.objects AS o ON sed.referencing_id = o.object_id
				WHERE o.type_desc = ''REPLICATION_FILTER_PROCEDURE''
				AND referenced_entity_name = ''' + @TBname + '''
			')

			SELECT @SQL_articles += '
		-- Adding the article filter
		EXEC sp_articlefilter
			@publication = N''' + @pubname + ''',
			@article = N''' + @TBname + ''',
			@filter_name = N''' + filter_name + ''',
			@filter_clause = N''' + CASE WHEN @filter_clause IS NULL THEN '' ELSE @filter_clause END + ''',
			@force_invalidate_snapshot = 1,
			@force_reinit_subscription = 1
		GO
		'
			FROM ##FILTER_NAME
		END

		--只要有partition或是filter就會有這個 Articles
		IF(@SQL_partition_columns <> '' OR @filter_clause <> '')
		BEGIN
			DROP TABLE IF EXISTS ##SYNC_NAME;
			EXEC
			('
				USE [' + @DBname + '];
				SELECT OBJECT_NAME(referencing_id) AS sync_name
				INTO ##SYNC_NAME
				FROM sys.sql_expression_dependencies AS sed
				INNER JOIN sys.objects AS o ON sed.referencing_id = o.object_id
				WHERE OBJECT_NAME(referencing_id) LIKE ''SYNC%''
				AND o.type_desc = ''VIEW''
				AND referenced_entity_name = ''' + @TBname + '''
			')

			SELECT @SQL_articles += '
		-- Adding the article synchronization object
		EXEC sp_articleview
			@publication = N''' + @pubname + ''',
			@article = N''' + @TBname + ''',
			@view_name = N''' + sync_name + ''',
			@filter_clause = N''' + CASE WHEN @filter_clause IS NULL THEN '' ELSE @filter_clause END + ''',
			@force_invalidate_snapshot = 1,
			@force_reinit_subscription = 1
		GO
		'
			FROM ##SYNC_NAME

		END

		--Adding the transactional subscription
		SELECT @SQL_articles += '
		-- Adding the transactional subscriptions
		EXEC sp_addsubscription
			@publication = N''' + @pubname + ''',
			@subscriber = N''' + srvname + ''',
			@destination_db = N''' + dest_db + ''',
			@subscription_type = N''' + CASE WHEN subscription_type = 1 THEN 'PULL' ELSE 'PUSH' END + ''',
			@sync_type = N''' + CASE WHEN sync_type = 1 THEN 'Automatic' ELSE 'None' END + ''',
			@article = N''all'',
			@update_mode = N''' + CASE WHEN update_mode = 0 THEN 'read only' ELSE 'immediate-updating' END + ''',
			@subscriber_type = 0
		GO
		'
		FROM ##sysarticles
		WHERE dest_table = @TBname

		IF((SELECT [name] FROM ##syspublications WHERE pubid = @pubid) <> '')
		BEGIN
			INSERT INTO #TBpub VALUES(@DBname,@pubname,@SQL_distribution,@SQL_publication+@SQL_user_login,@SQL_articles)
		END

		SET @pubid += 1

		--return
		SET @filter_clause = ''
		SET @SQL_articles = ''
		SET @SQL_partition_columns = ''
	END

	SET @sn += 1

	--return
	SET @pubid = 1
END

SELECT * FROM #TBpub

SET NOCOUNT OFF;