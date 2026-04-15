CREATE OR ALTER PROC proc_bak_all
	@bak_path VARCHAR(100),
	@modal VARCHAR(5)
AS
BEGIN
	DECLARE 
		@date_time VARCHAR(30) = FORMAT(GETDATE(),'yyyyMMddhhmm'),
		@DB_NAME NVARCHAR(30) = DB_NAME(),
		@SQL NVARCHAR(MAX) = ''

	IF @bak_path <> '' AND @modal <> ''
		SET @SQL = N'BACKUP ' + CASE WHEN @modal = 'log' THEN 'LOG' ELSE 'DATABASE' END + '[' + @DB_NAME + '] TO DISK = N'''+ @bak_path + '\' + @DB_NAME + @date_time + @modal + '.bak''
		WITH ' + CASE WHEN @modal = 'diff' THEN 'DIFFERENTIAL,' ELSE '' END + 'NOFORMAT, NOINIT,  NAME = N''³Æ¥÷'', SKIP, NOREWIND, NOUNLOAD,  STATS = 10'

	EXEC sp_executesql @SQL

	--PRINT @SQL
END
GO

EXEC proc_bak_all 'D:\BAK','full'
EXEC proc_bak_all 'D:\BAK','diff'
EXEC proc_bak_all 'D:\BAK','log'
