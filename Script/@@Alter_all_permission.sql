DECLARE @TABLE TABLE (I INT IDENTITY(1,1),dbname VARCHAR(30))

INSERT INTO @TABLE
SELECT [name]
FROM sys.databases
WHERE [name] NOT IN ('master','model','msdb','tempdb','distribution')
ORDER BY 1

DECLARE
	@I INT = 1,
	@dbname VARCHAR(30),
	@SQL NVARCHAR(500),
	@ac_name VARCHAR(30) = 'qa_user',
	@type TINYINT = 1

	/***
	type desc
	1 : db_datareader(readonly)
	2 : db_datareader,db_datawriter,view definition,execute
	3 : db_datareader,db_datawriter,db_ddladmin
	4 : db_owner
	5 : drop upser
	6 : backup
	****/

WHILE (1=1)
BEGIN
	SELECT @dbname = dbname
	FROM @TABLE
	WHERE I = @I

	IF @@ROWCOUNT = 0
		BREAK;

	SET @SQL = CASE @type

	WHEN 1 THEN N'
	USE [' + @dbname + '];
	DROP USER IF EXISTS [' + @ac_name + '];
	CREATE USER [' + @ac_name + '] FOR LOGIN [' + @ac_name + '];
	ALTER ROLE [db_datareader] ADD MEMBER [' + @ac_name + '];
	GRANT VIEW DEFINITION TO [' + @ac_name + '];'

	WHEN 2 THEN N'
	USE [' + @dbname + '];
	DROP USER IF EXISTS [' + @ac_name + '];
	CREATE USER [' + @ac_name + '] FOR LOGIN [' + @ac_name + '];
	ALTER ROLE [db_datareader] ADD MEMBER [' + @ac_name + '];
	ALTER ROLE [db_datawriter] ADD MEMBER [' + @ac_name + '];
	GRANT VIEW DEFINITION,EXECUTE TO ' + @ac_name + ''

	WHEN 3 THEN N'
	USE [' + @dbname + '];
	DROP USER IF EXISTS [' + @ac_name + '];
	CREATE USER [' + @ac_name + '] FOR LOGIN [' + @ac_name + '];
	ALTER ROLE [db_datareader] ADD MEMBER [' + @ac_name + '];
	ALTER ROLE [db_datawriter] ADD MEMBER [' + @ac_name + '];
	ALTER ROLE [db_ddladmin] ADD MEMBER [' + @ac_name + '];
	GRANT VIEW DEFINITION,EXECUTE TO [' + @ac_name + ']'

	WHEN 4 THEN N'
	USE [' + @dbname + '];
	DROP USER IF EXISTS [' + @ac_name + '];
	CREATE USER [' + @ac_name + '] FOR LOGIN [' + @ac_name + '];
	ALTER ROLE [db_owner] ADD MEMBER [' + @ac_name + ']'

	WHEN 5 THEN N'
	USE [' + @dbname + '];DROP USER IF EXISTS [' + @ac_name + '];'

	WHEN 6 THEN N'
	USE [' + @dbname + '];
	DROP USER IF EXISTS [' + @ac_name + '];
	CREATE USER [' + @ac_name + '] FOR LOGIN [' + @ac_name + '];
	ALTER ROLE [db_backupoperator] ADD MEMBER [' + @ac_name + '];'

	END

	--EXEC (@SQL)
	PRINT @SQL

	SET @I += 1
END
GO