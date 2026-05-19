--Step 1 新增"資料庫檔案"資料夾

--Step 2 Restore DB
USE [master]

DECLARE 
	 @DB_name		VARCHAR(30)  = 'fs_egame_data'
	,@BakFile_full	VARCHAR(100) = ''
	,@BakFile_diff	VARCHAR(100) = ''
	,@BakFile_log1	VARCHAR(100) = ''
	,@BakFile_log2	VARCHAR(100) = ''
	,@BakFile_log3	VARCHAR(100) = ''
	,@BakFile_log4	VARCHAR(100) = ''
	,@replace		VARCHAR(1) = 'N' --要不要覆蓋( Y / N )	
	,@SQL			NVARCHAR(MAX) = ''

------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------
--Full_backup
IF(@BakFile_full <> '')
BEGIN
	SET @SQL = N'
	RESTORE DATABASE [' + @DB_name + ']
	FROM DISK = N''D:\BAK\full\' + @BakFile_full + '.bak''
	WITH FILE = 1, ' 
	+ CASE WHEN @BakFile_diff <> '' THEN 'NORECOVERY,' 
		   WHEN @BakFile_log1 <> '' THEN 'NORECOVERY,' ELSE '' END + ' NOUNLOAD,' 
	+ CASE WHEN @replace = 'Y' THEN 'REPLACE,' ELSE '' END + ' STATS = 5
	--,MAXTRANSFERSIZE = 4194304 , BUFFERCOUNT = 48'
END

--Diff_backup
IF(@BakFile_diff <> '')
BEGIN
	SET @SQL += N'
	RESTORE DATABASE [' + @DB_name + '] 
	FROM DISK = N''D:\BAK\diff\' + @BakFile_diff + '.bak''
	WITH FILE = 1, ' 
	+ CASE WHEN @BakFile_log1 <> '' THEN 'NORECOVERY,' ELSE '' END + ' NOUNLOAD, STATS = 5'
END

--Log_backup
IF(@BakFile_log1 <> '')
BEGIN
	SET @SQL += N'
	RESTORE LOG [' + @DB_name + '] 
	FROM DISK = N''D:\BAK\log\' + @BakFile_log1 + '.bak''
	WITH FILE = 1, '
	+ CASE WHEN @BakFile_log2 <> '' THEN 'NORECOVERY,' ELSE '' END + ' NOUNLOAD, STATS = 5'
END

IF(@BakFile_log2 <> '')
BEGIN
	SET @SQL += N'
	RESTORE LOG [' + @DB_name + '] 
	FROM DISK = N''D:\BAK\log\' + @BakFile_log2 + '.bak''
	WITH FILE = 1, '
	+ CASE WHEN @BakFile_log3 <> '' THEN 'NORECOVERY,' ELSE '' END + ' NOUNLOAD, STATS = 5'
END

IF(@BakFile_log3 <> '')
BEGIN
	SET @SQL += N'
	RESTORE LOG [' + @DB_name + '] 
	FROM DISK = N''D:\BAK\log\' + @BakFile_log3 + '.bak''
	WITH FILE = 1, '
	+ CASE WHEN @BakFile_log4 <> '' THEN 'NORECOVERY,' ELSE '' END + ' NOUNLOAD, STATS = 5'
END

IF(@BakFile_log4 <> '')
BEGIN
	SET @SQL += N'
	RESTORE LOG [' + @DB_name + '] 
	FROM DISK = N''D:\BAK\log\' + @BakFile_log4 + '.bak''
	WITH FILE = 1, NOUNLOAD, STATS = 5'
END

PRINT @SQL

--EXEC sp_executesql @SQL
GO


