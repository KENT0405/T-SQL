DECLARE @TABLE TABLE (I INT IDENTITY(1,1),dbname VARCHAR(30))

INSERT INTO @TABLE
SELECT [name]
FROM sys.databases
WHERE [name] NOT IN ('master','model','msdb','tempdb','distribution')
--AND [name] = ''

DECLARE
	@I INT = 1,
	@dbname VARCHAR(30),
	@SQL NVARCHAR(300),
	@bakpath VARCHAR(100) = 'D:\BAK'

WHILE (1=1)
BEGIN
	SELECT @dbname = dbname
	FROM @TABLE
	WHERE I = @I

	IF @@ROWCOUNT = 0
		BREAK;

	SET @SQL = N'
	BACKUP DATABASE [' + @dbname + '] TO  DISK = N''' + @bakpath + '\' + @dbname + '.bak'' WITH NOFORMAT, NOINIT,
	NAME = N''' + @dbname + '-Full Database Backup'', SKIP, NOREWIND, NOUNLOAD, COMPRESSION,  STATS = 10,
	MAXTRANSFERSIZE = 4194304, BUFFERCOUNT = 12;
	'

	EXECUTE (@SQL)

	SET @I += 1
END