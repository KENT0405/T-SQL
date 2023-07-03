DECLARE
	@SQL_dis	NVARCHAR(MAX) = '',
	@DBname		VARCHAR(100) = '-',
	@sn			INT = 1

SET @SQL_dis = '
	/****** Begin: Script to be run at Publisher ******/

	-- Adding Distributor
	USE [master]
	exec sp_adddistributor @distributor = N''IC-DIS-DB'', @password = N''''
	exec sp_addsubscriber @subscriber = N''IC-DIS-DB'', @type = 0, @description = N''''
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

DROP TABLE IF EXISTS #DBtemp;
CREATE TABLE #DBtemp
(
	sn INT IDENTITY(1,1),
	DBname VARCHAR(100)
)

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

WHILE(1 = 1)
BEGIN
	SELECT @DBname = DBname
	FROM #DBtemp
	WHERE sn = @sn

	IF (@@ROWCOUNT = 0)
	BEGIN
		SET @SQL_dis += '
	/****** End: Script to be run at Publisher ******/'
		BREAK;
	END

	SET @SQL_dis +=
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

SELECT @SQL_dis