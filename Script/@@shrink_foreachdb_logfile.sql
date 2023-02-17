DECLARE @LogSpace TABLE 
  (
      DBName VARCHAR(500) , 
      LogSize FLOAT , 
      LogSpaceUsed FLOAT , 
      [Status] INT
  )

DECLARE @Logfile TABLE 
  (
      DBName VARCHAR(500) , 
      logfile_name VARCHAR(500), 
      [type] VARCHAR(10)
  )

INSERT INTO @Logfile EXECUTE sys.sp_MSforeachdb 'USE [?]; 
EXEC (''
SELECT  DB_NAME() AS DBname,
		name AS logfile_name,
		type_desc
FROM sys.database_files
'')'
INSERT INTO @LogSpace EXECUTE('DBCC SQLPERF(''LOGSPACE'')')

--EXECUTE DBCC SQLPERF('LOGSPACE')
SELECT 
	L.DBName ,
	ROUND(L.LogSize,2) AS N'Log_Currently_Space(MB)' ,
	ROUND((L.LogSize * LogSpaceUsed / 100),2) AS N'Log_Space_Used(MB)',
	ROUND((100 - L.LogSpaceUsed),2) AS N'Log_Available_Space(%)',
	N'USE ' + L.DBName + '; DBCC SHRINKFILE (N''' + A.logfile_name + ''', 8) WITH NO_INFOMSGS;' AS shrink_log_str
FROM @LogSpace AS L 
	JOIN sys.databases AS S ON L.DBName = S.Name
	JOIN @Logfile AS A ON L.DBName = A.DBNAME
WHERE 1 = 1
AND S.database_id > 4 -- < 5 is sysdb 
AND CHARINDEX('report',S.Name) = 0
AND A.[type] = 'LOG'
--AND ROUND((100 - L.LogSpaceUsed),2) > 90

