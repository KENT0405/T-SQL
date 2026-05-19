DROP TABLE IF EXISTS #sp_who2_results

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
);

INSERT INTO #sp_who2_results EXEC sp_who2;

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
	--,sqltext.text
	,location
FROM tree_who2 AS b JOIN #sp_who2_results s ON b.SPID = s.SPID
JOIN master..sysprocesses ps ON s.SPID = ps.SPID
OUTER APPLY sys.dm_exec_input_buffer(s.SPID,NULL) AS ib
--OUTER APPLY sys.dm_exec_sql_text(ps.sql_handle) sqltext
ORDER BY location
OPTION (MAXRECURSION 0)