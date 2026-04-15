/* 先Create Table Type才能Restore
USE master
GO

IF TYPE_ID('FILELIST_ONLY') IS NOT NULL
BEGIN DROP TYPE FILELIST_ONLY END
GO

IF TYPE_ID('HEADER_ONLY') IS NOT NULL
BEGIN DROP TYPE HEADER_ONLY END
GO

CREATE TYPE FILELIST_ONLY AS TABLE
(
	[LogicalName]			NVARCHAR(128),
	[PhysicalName]			NVARCHAR(260),
	[Type]					CHAR(1),
	[FileGroupName]			NVARCHAR(128),
	[Size]					NUMERIC(20,0),
	[MaxSize]				NUMERIC(20,0),
	[FileID]				BIGINT,
	[CreateLSN]				NUMERIC(25,0),
	[DropLSN]				NUMERIC(25,0),
	[UniqueID]				UNIQUEIDENTIFIER,
	[ReadOnlyLSN]			NUMERIC(25,0),
	[ReadWriteLSN]			NUMERIC(25,0),
	[BackupSizeInBytes]		BIGINT,
	[SourceBlockSize]		INT,
	[FileGroupID]			INT,
	[LogGroupGUID]			UNIQUEIDENTIFIER,
	[DifferentialBaseLSN]	NUMERIC(25,0),
	[DifferentialBaseGUID]	UNIQUEIDENTIFIER,
	[IsReadOnly]			BIT,
	[IsPresent]				BIT,
	[TDEThumbprint]			VARBINARY(32),
	[SnapshotUrl]			NVARCHAR(360)
)
GO

CREATE TYPE HEADER_ONLY AS TABLE
(
	BackupName				NVARCHAR(128),
	BackupDescription		NVARCHAR(255),
	BackupType				SMALLINT,
	ExpirationDate			DATETIME,
	Compressed				BIT,
	Position				SMALLINT,
	DeviceType				TINYINT,
	UserName				NVARCHAR(128),
	ServerName				NVARCHAR(128),
	DatabaseName			NVARCHAR(128),
	DatabaseVersion			INT,
	DatabaseCreationDate	DATETIME,
	BackupSize				NUMERIC(20, 0),
	FirstLSN				NUMERIC(25, 0),
	LastLSN					NUMERIC(25, 0),
	CheckpointLSN			NUMERIC(25, 0),
	DatabaseBackupLSN		NUMERIC(25, 0),
	BackupStartDate			DATETIME,
	BackupFinishDate		DATETIME,
	SortOrder				SMALLINT,
	[CodePage]				SMALLINT,
	UnicodeLocaleId			INT,
	UnicodeComparisonStyle	INT,
	CompatibilityLevel		TINYINT,
	SoftwareVendorId		INT,
	SoftwareVersionMajor	INT,
	SoftwareVersionMinor	INT,
	SoftwareVersionBuild	INT,
	MachineName				NVARCHAR(128),
	Flags					INT,
	BindingId				UNIQUEIDENTIFIER,
	RecoveryForkId			UNIQUEIDENTIFIER,
	Collation				NVARCHAR(128),
	FamilyGUID				UNIQUEIDENTIFIER,
	HasBulkLoggedData		BIT,
	IsSnapshot				BIT,
	IsReadOnly				BIT,
	IsSingleUser			BIT,
	HasBackupChecksums		BIT,
	IsDamaged				BIT,
	BeginsLogChain			BIT,
	HasIncompleteMetaData	BIT,
	IsForceOffline			BIT,
	IsCopyOnly				BIT,
	FirstRecoveryForkID		UNIQUEIDENTIFIER,
	ForkPointLSN			NUMERIC(25, 0),
	RecoveryModel			NVARCHAR(60),
	DifferentialBaseLSN		NUMERIC(25, 0),
	DifferentialBaseGUID	UNIQUEIDENTIFIER,
	BackupTypeDescription	NVARCHAR(60),
	BackupSetGUID			UNIQUEIDENTIFIER,
	CompressedBackupSize	BIGINT,
	Containment				TINYINT,
	KeyAlgorithm			NVARCHAR(32),
	EncryptorThumbprint		VARBINARY(20),
	EncryptorType			NVARCHAR(32)
	,LastValidRestoreTime	DATETIME
	,TimeZone				INT
	,CompressionAlgorithm	NVARCHAR(20)
)
GO
*/


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
	@I			INT = 1,
	@IsExecute	BIT = 1 --0:列印 1:列印 + 執行

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

SET @SQL += ', NOUNLOAD, STATS = 5, MAXTRANSFERSIZE = 4194304, BUFFERCOUNT = 8, RECOVERY'

--建立DB資料夾(command shell)
SET @CmdShell = 'IF NOT EXIST "' + @DBPath + '\' + @DBName + '" mkdir "' + @DBPath + '\' + @DBName + '"'

PRINT @CmdShell;
PRINT @SQL;

IF @IsExecute = 1
BEGIN
	--shell mkdir
	EXEC xp_cmdshell @CmdShell, NO_OUTPUT

	--RESTORE
	EXECUTE sp_executesql @SQL,N'@DiskPath	NVARCHAR(100)',@DiskPath;
END

SET @I += 1

END