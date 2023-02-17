-------------------------------------------------------------
-------------------------diff_backup-------------------------
-------------------------------------------------------------

DECLARE 
	 @bak_path		VARCHAR(100) = 'D:\BAK'
	,@compression	VARCHAR(1) = 'Y' --要不要壓縮( Y / N )
	,@SQL			NVARCHAR(MAX)

IF (@bak_path <> '')
BEGIN
	SET @SQL = N'
	BACKUP DATABASE ['+ DB_NAME() + '] 
	TO DISK = N'''+ @bak_path + '\' + DB_NAME() + FORMAT(GETDATE(),'yyyyMMddhhmm') + 'diff.bak''
	WITH DIFFERENTIAL, NOFORMAT, NOINIT, 
	NAME = N''' + DB_NAME() + '-diff_backup'',
	SKIP, NOREWIND, NOUNLOAD, ' + 
	CASE WHEN @compression = 'Y' THEN 'COMPRESSION,' ELSE '' END +  
	' STATS = 10'
END

PRINT @SQL

EXEC sp_executesql @SQL
GO