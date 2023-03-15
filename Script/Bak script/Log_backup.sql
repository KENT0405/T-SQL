-------------------------------------------------------------
-------------------------log_backup--------------------------
-------------------------------------------------------------

DECLARE
	 @bak_path		VARCHAR(100) = 'D:\BAK\log'
	,@compression	VARCHAR(1) = 'Y' --要不要壓縮( Y / N )
	,@SQL			NVARCHAR(MAX)

IF (@bak_path <> '')
BEGIN
	SET @SQL = N'
	BACKUP LOG ['+ DB_NAME() + ']
	TO DISK = N'''+ @bak_path + '\' + DB_NAME() + FORMAT(GETDATE(),'yyyyMMddhhmm') + 'log.bak''
	WITH NOFORMAT, NOINIT,
	NAME = N''' + DB_NAME() + '-log_backup'',
	SKIP, NOREWIND, NOUNLOAD, ' +
	CASE WHEN @compression = 'Y' THEN 'COMPRESSION,' ELSE '' END +
	' STATS = 10
	--,MAXTRANSFERSIZE = 4194304 , BUFFERCOUNT = 48'
END

PRINT @SQL

--EXEC sp_executesql @SQL
GO