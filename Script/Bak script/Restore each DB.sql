USE [master] 
GO
/*
EXEC sp_configure 'show advanced options',1;
RECONFIGURE;

EXEC sp_configure 'xp_cmdshell',1;
RECONFIGURE;

EXEC sp_configure 'show advanced options',0;
RECONFIGURE;
GO
*/

SET NOCOUNT ON;

--取得目錄下檔案
DECLARE 
	@BakPath	NVARCHAR(500) = 'D:\BAK', --來源資料夾
	@BakName	VARCHAR(100),
	@DBPath		NVARCHAR(500) = 'D:\DB', --目的資料夾
	@DBName		VARCHAR(100),
	@DiskPath	NVARCHAR(100),
	@CmdShell	NVARCHAR(100),
	@SQL		NVARCHAR(MAX),
	@I			INT = 1

DECLARE
	@HEADERONLY		HEADER_ONLY,
	@FILELIST_ONLY	FILELIST_ONLY

DECLARE @tblgetfileList TABLE
(
	id INT IDENTITY(1,1),
	[subdirectory] nvarchar(500),
	[depth] int,
	[file] int
)

INSERT INTO @tblgetfileList
EXEC xp_DirTree @BakPath,1,1

WHILE (1=1)
BEGIN

DELETE FROM @HEADERONLY
DELETE FROM @FILELIST_ONLY

SELECT @BakName = [subdirectory] 
FROM @tblgetfileList 
WHERE [file] = 1
AND id = @I

IF @@ROWCOUNT <> 1
	BREAK;

SET @DiskPath = @BakPath + '\' + @BakName

--從bak檔資訊(HEADERONLY)取得DB名稱(@DBName)
SET @SQL = 'RESTORE HEADERONLY FROM DISK = ' + QUOTENAME(@DiskPath,'''')

INSERT INTO @HEADERONLY
EXECUTE (@SQL)

SELECT @DBName = DatabaseName 
FROM @HEADERONLY

SET @SQL = 'RESTORE FILELISTONLY FROM DISK = ' + QUOTENAME(@DiskPath,'''')
INSERT INTO @FILELIST_ONLY 
EXECUTE (@SQL)

SET @SQL = 'RESTORE DATABASE [' + @DBName + '] FROM DISK = @DiskPath WITH FILE = 1'

--設定logical name & mdf(ldf)的新路徑
;WITH CTE
AS
(
	SELECT 
		LogicalName,
		@DBPath + '\' + @DBName + '\' + RIGHT(PhysicalName, CHARINDEX('\', REVERSE(PhysicalName))-1) AS NewDBPhysicalName
	FROM @FILELIST_ONLY
)
SELECT 
	@SQL += ', MOVE N' + QUOTENAME(LogicalName,'''') + ' TO N' + QUOTENAME(NewDBPhysicalName,'''')
FROM CTE

SET @SQL += ', NOUNLOAD, STATS = 5'

--建立DB資料夾(command shell)
SET @CmdShell = 'IF NOT EXIST "' + @DBPath + '\' + @DBName + '" mkdir "' + @DBPath + '\' + @DBName + '"'
EXEC xp_cmdshell @CmdShell

--RESTORE
EXECUTE sp_executesql @SQL,N'@DiskPath	NVARCHAR(100)',@DiskPath

SET @I += 1

END