/*----------------------------------------------------------------

		Staging上線 (DB單) "ticket db 前置作業"

  ----------------------------------------------------------------

	1.DEV backup後，直接複製到本機並上傳owncloud
	2.從staging的GATE機下載下來後複製到staging OS環境
	3.建立db資料夾後 RESTORE DATABASE

*/----------------------------------------------------------------


USE ticket_data_xxx
GO

IF (DB_NAME() <> 'master')
BEGIN

--4.DB owner改成db_user
DECLARE @SQL_Alter_Owner NVARCHAR(MAX) = N''
SET @SQL_Alter_Owner = 'ALTER AUTHORIZATION ON DATABASE::[' + DB_NAME() + '] TO [DB_user]'
EXEC sys.sp_executesql @SQL_Alter_Owner

--5.刪除原本dev在使用的所有user(rd_user、IC_QA、qa_user、qard_user、read_ac)
DECLARE @SQL_Drop_AllUser NVARCHAR(MAX) = N''
SELECT @SQL_Drop_AllUser += N'DROP USER ' + QUOTENAME(name) + N';' + CHAR(13)
FROM sys.database_principals
WHERE principal_id > 4
    AND type IN ('S', 'U', 'G', 'E', 'X')
    AND name NOT IN
    (
        'dbo',
        'guest',
        'INFORMATION_SCHEMA',
        'sys'
    )
    AND name <> USER_NAME()

PRINT '請確認是否刪除正確 :' + CHAR(13) + @SQL_Drop_AllUser
EXEC sys.sp_executesql @SQL_Drop_AllUser

--6.GRANT USER(tkt_ac=2, rd_user=1)
DROP USER IF EXISTS [rd_user];
CREATE USER [rd_user] FOR LOGIN [rd_user];
ALTER ROLE [db_datareader] ADD MEMBER [rd_user];
GRANT VIEW DEFINITION TO [rd_user]

DROP USER IF EXISTS [tkt_ac];
CREATE USER [tkt_ac] FOR LOGIN [tkt_ac];
ALTER ROLE [db_datareader] ADD MEMBER [tkt_ac];
ALTER ROLE [db_datawriter] ADD MEMBER [tkt_ac];
GRANT VIEW DEFINITION,EXECUTE TO [tkt_ac];


--7.確認partition view時間區間正確


--8.idc_repl重建要看error_message的view
EXEC idc_repl.dbo.PROC_CreateAllErrorView

END