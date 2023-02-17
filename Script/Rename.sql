--STEP1
CREATE DATABASE [Manvendra]
 CONTAINMENT = NONE
 ON  PRIMARY
( NAME = N'Manvendra', FILENAME = N'D:\DB\RenameTest\Manvendra.mdf',SIZE = 5MB , MAXSIZE = UNLIMITED, FILEGROWTH = 10MB ),
( NAME = N'Manvendra_1', FILENAME = N'D:\DB\RenameTest\Manvendra_1.ndf',SIZE = 5MB , MAXSIZE = UNLIMITED, FILEGROWTH = 10MB ),
( NAME = N'Manvendra_2', FILENAME = N'D:\DB\RenameTest\Manvendra_2.ndf' ,SIZE = 5MB , MAXSIZE = UNLIMITED, FILEGROWTH = 10MB )
 LOG ON
( NAME = N'Manvendra_log', FILENAME = N'D:\DB\RenameTest\Manvendra_log.ldf',SIZE = 10MB , MAXSIZE = 1GB , FILEGROWTH = 10%)
GO

--STEP2
USE Manvendra
GO
SELECT file_id, name as [logical_file_name], physical_name
FROM sys.database_files
GO

--STEP3
USE [master];
GO
ALTER DATABASE Manvendra SET SINGLE_USER WITH ROLLBACK IMMEDIATE --Disconnect all existing session.
GO
ALTER DATABASE Manvendra SET OFFLINE --Change database in to OFFLINE mode.

SELECT name as [Database_Name], State_desc from sys.databases

--STEP4
--RENAME FILE

--STEP5
ALTER DATABASE Manvendra MODIFY FILE (Name='Manvendra', FILENAME='D:\DB\RenameTest\Manvendra_RE.mdf')
GO
ALTER DATABASE Manvendra MODIFY FILE (Name='Manvendra_1', FILENAME='D:\DB\RenameTest\Manvendra_1_RE.ndf')
GO
ALTER DATABASE Manvendra MODIFY FILE (Name='Manvendra_2', FILENAME='D:\DB\RenameTest\Manvendra_2_RE.ndf')
GO
ALTER DATABASE Manvendra MODIFY FILE (Name='Manvendra_log', FILENAME='D:\DB\RenameTest\Manvendra_log_RE.ldf')
GO

--STEP6
ALTER DATABASE Manvendra SET ONLINE
Go
ALTER DATABASE Manvendra SET MULTI_USER
Go

SELECT name as [Database_Name], State_desc from sys.databases

--STEP7
USE Manvendra
GO
SELECT file_id, name as [logical_file_name], physical_name
FROM sys.database_files


https://www.mssqltips.com/sqlservertip/4419/renaming-physical-database-file-names-for-a-sql-server-database/