CREATE OR ALTER PROC proc_bak_full 
	@bak_path VARCHAR(100)
AS

DECLARE 
	@date_time VARCHAR(30) = FORMAT(GETDATE(),'yyyyMMddhhmm'),
	@DB_NAME NVARCHAR(30) = DB_NAME(),
	@SQL NVARCHAR(MAX)

IF @bak_path <> '' 
	SET @SQL = N'BACKUP DATABASE ['+ @DB_NAME + '] TO  DISK = N'''+ @bak_path + '\' + @DB_NAME  + @date_time + '.bak''
				 WITH NOFORMAT, NOINIT,  NAME = N''備份'', SKIP, NOREWIND, NOUNLOAD,  STATS = 10'

EXEC sp_executesql @SQL
GO

-------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR ALTER PROC proc_bak_diff 
	@bak_path VARCHAR(100)
AS

DECLARE 
	@date_time VARCHAR(30) = FORMAT(GETDATE(),'yyyyMMddhhmm'),
	@DB_NAME NVARCHAR(30) = DB_NAME(),
	@SQL NVARCHAR(MAX)

IF @bak_path <> '' 
	SET @SQL = N'BACKUP DATABASE ['+ @DB_NAME + '] TO  DISK = N'''+ @bak_path + '\' + @DB_NAME + @date_time + 'diff.bak''
				 WITH DIFFERENTIAL, NOFORMAT, NOINIT,  NAME = N''備份'', SKIP, NOREWIND, NOUNLOAD,  STATS = 10'

EXEC sp_executesql @SQL
GO

-------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR ALTER PROC proc_bak_log
	@bak_path VARCHAR(100)
AS

DECLARE 
	@date_time VARCHAR(30) = FORMAT(GETDATE(),'yyyyMMddhhmm'),
	@DB_NAME NVARCHAR(30) = DB_NAME(),
	@SQL NVARCHAR(MAX)

IF @bak_path <> '' 
	SET @SQL = N'BACKUP LOG ['+ @DB_NAME + '] TO  DISK = N'''+ @bak_path + '\' + @DB_NAME + @date_time + 'log.bak''
				WITH NOFORMAT, NOINIT,  NAME = N''備份'', SKIP, NOREWIND, NOUNLOAD,  STATS = 10'
				 
PRINT @SQL
--EXEC sp_executesql @SQL
GO

-------------------------------------------------------------------------------------------------------------------------------------------
EXEC proc_bak_full 'D:\BAK'
EXEC proc_bak_diff 'D:\BAK'
EXEC proc_bak_log 'D:\BAK'
