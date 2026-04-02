--重新設定"伺服器"定序 :

-->先將instance上的DB全部卸載
-->備好所有重建jobs跟login的腳本
-->打開SQL安裝的setup
-->將 cmd 切換到 setup的檔案位址:
/Setup.exe /QUIET /ACTION=REBUILDDATABASE /INSTANCENAME=MSSQLSERVER /SQLSYSADMINACCOUNTS=.\Administrator /SAPWD=1qaz@WSX3edc /SQLCOLLATION=Chinese_PRC_CI_AS

---------------------------------------------------------------------------------------
--重新設定"資料庫"定序 :
USE [master]
GO

-- 設定為單一使用者
ALTER DATABASE [db_name] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO

-- 變更資料庫定序
ALTER DATABASE [db_name] COLLATE Chinese_PRC_CI_AS
GO

-- 恢復成為多人使用
ALTER DATABASE [db_name] SET MULTI_USER;
GO
---------------------------------------------------------------------------------------

--重新設定"欄位"定序 :
USE [db_name]
GO

ALTER TABLE [table_name] ALTER COLUMN F1 varchar(10) COLLATE Chinese_PRC_CI_AS;
GO

ALTER TABLE [table_name] ALTER COLUMN F2 char(10) COLLATE Chinese_PRC_CI_AS;
GO