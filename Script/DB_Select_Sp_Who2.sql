DROP TABLE IF EXISTS #sp_who2_results;
CREATE TABLE #sp_who2_results
(
    SPID INT,
    [Status] VARCHAR(15),
    [LOGIN] VARCHAR(200),
    HostName VARCHAR(200),
    BlkBy VARCHAR(10),
    DBName VARCHAR(30),
    Command VARCHAR(200),
    CPUTime BIGINT,
    DiskIO BIGINT,
    LastBatch VARCHAR(20),
    ProgramName VARCHAR(150),
    SPID_1 INT,
    REQUESTID INT
)

INSERT INTO #sp_who2_results EXEC sp_who2

--查詢正在執行的SPID及其相關資訊
SELECT
	s.SPID,
	s.[Status],
	s.[LOGIN],
	s.HostName,
	s.BlkBy,
	s.DBName,
	s.Command,
	CAST(s.CPUTime / 1000.0 AS NUMERIC(10,3)) AS [CPUTime/sec],
	s.DiskIO,
	FORMAT(GETDATE(),'yyyy/') + s.LastBatch + '.000' AS LastBatch,
	OBJECT_NAME(sqltext.objectid) AS Proc_Name,
	sqltext.text
FROM #sp_who2_results s
JOIN master..sysprocesses ps ON s.SPID = ps.SPID
OUTER APPLY sys.dm_exec_sql_text(ps.sql_handle) sqltext
WHERE 1 = 1
AND S.SPID > 50
--AND s.LOGIN = 'egame_user'
AND S.SPID <> @@SPID
AND S.Status NOT IN ('sleeping','BACKGROUND')

--刪除重複的SPID，保留最新的紀錄
;WITH SS
AS
(
SELECT
	SPID,Status,ROW_NUMBER() OVER (PARTITION BY Spid ORDER BY LOGIN DESC,BlkBy DESC) R
FROM #sp_who2_results
)
DELETE
FROM SS
WHERE R > 1
OR SPID <= 50
OR Status = 'BACKGROUND'

--查詢被鎖定的SPID及其鎖定鏈
;WITH tree_who2
AS
(
	SELECT
		CAST(SPID AS NVARCHAR(MAX)) AS name,
		SPID,
		0 AS depth,
		CAST(SPID AS NVARCHAR(MAX)) AS location
	FROM #sp_who2_results AS tree
	WHERE BlkBy = '  .'
	AND SPID > 50
	AND EXISTS (SELECT 1 FROM #sp_who2_results F WHERE f.BlkBy = CAST(tree.SPID AS VARCHAR))

	UNION ALL

	SELECT
		CAST(CONCAT(SPACE(root_who2.depth * 5),'|__',CAST(sub_who2.SPID AS VARCHAR(100))) AS NVARCHAR(MAX)),
		sub_who2.SPID,
		root_who2.depth + 1,
		CAST(CONCAT (root_who2.location,'.',sub_who2.SPID) AS NVARCHAR(MAX)) AS location
	FROM #sp_who2_results AS sub_who2
	INNER JOIN tree_who2 AS root_who2 ON sub_who2.BlkBy = CAST(root_who2.SPID AS VARCHAR)
)
SELECT
	 B.name
	,B.SPID
	,S.*
	,ib.event_info
	,sqltext.text
	,location
FROM tree_who2 AS b JOIN #sp_who2_results s ON b.SPID = s.SPID
JOIN master..sysprocesses ps ON s.SPID = ps.SPID
OUTER APPLY sys.dm_exec_input_buffer(s.SPID,NULL) AS ib
OUTER APPLY sys.dm_exec_sql_text(ps.sql_handle) sqltext
ORDER BY location
OPTION (MAXRECURSION 0)

-- 查詢正在執行且持續時間大於兩分鐘的交易
SELECT
	s.session_id,
	DB_NAME(dt.database_id) AS database_name,
	s.login_name,
	s.host_name,
	s.program_name,
	at.name AS transaction_name,
	at.transaction_begin_time,
	r.status,
	r.command,
	txt.text AS sql_text
FROM sys.dm_tran_active_transactions at
JOIN sys.dm_tran_session_transactions st ON at.transaction_id = st.transaction_id
JOIN sys.dm_exec_sessions s ON st.session_id = s.session_id
LEFT JOIN sys.dm_exec_requests r ON s.session_id = r.session_id
LEFT JOIN sys.dm_tran_database_transactions dt ON at.transaction_id = dt.transaction_id
OUTER APPLY sys.dm_exec_sql_text(r.sql_handle) txt
WHERE at.transaction_begin_time < DATEADD(MINUTE,-2,GETDATE())
ORDER BY 1,3,4