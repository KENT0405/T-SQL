SELECT 
    t.NAME AS TableName,
    p.rows AS RowCounts,
    CAST(ROUND(((SUM(a.total_pages) * 8) / 1024.00 / 1024.00), 2) AS NUMERIC(36, 2)) AS TotalSpaceGB,
    CAST(ROUND(((SUM(a.used_pages) * 8) / 1024.00 / 1024.00), 2) AS NUMERIC(36, 2)) AS UsedSpaceGB, 
    CAST(ROUND(((SUM(a.total_pages) - SUM(a.used_pages)) * 8) / 1024.00 / 1024.00, 2) AS NUMERIC(36, 2)) AS UnusedSpaceGB
	,d.name
FROM 
    sys.tables t
INNER JOIN      
    sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN 
    sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN 
    sys.allocation_units a ON p.partition_id = a.container_id
INNER JOIN 
	sys.data_spaces d ON a.data_space_id = d.data_space_id
WHERE 1 = 1
	AND i.index_id < 2		-- 0 heap, 1 cluster , 2 non-cluster
	AND t.is_ms_shipped = 0
    AND i.OBJECT_ID > 255 
	AND p.rows > 0
	--AND t.NAME like '%daily_tran%'	
GROUP BY 
    t.Name, p.Rows, d.name
ORDER BY 
    p.Rows DESC, t.Name, d.name DESC
	
	
/*
SELECT 
    t.NAME AS TableName,
    SUM(p.rows) AS RowCounts,
	'TRUNCATE TABLE ' + t.name AS sqlstr
FROM 
    sys.tables t
INNER JOIN      
    sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN 
    sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN 
    sys.allocation_units a ON p.partition_id = a.container_id
INNER JOIN 
	sys.data_spaces d ON a.data_space_id = d.data_space_id
WHERE 1= 1
	AND i.index_id < 2		-- 0 heap, 1 cluster , 2 non-cluster
	AND t.is_ms_shipped = 0
    AND i.OBJECT_ID > 255 
	AND p.rows > 0
	--AND t.NAME like '%daily_tran%'	
GROUP BY 
    t.Name
ORDER BY 
	2 DESC


;WITH A
AS
(
	SELECT sOBJ.name AS [TableName],SUM(sPTN.Rows) AS [RowCount]
	FROM sys.objects AS sOBJ
	INNER JOIN sys.partitions AS sPTN
	ON sOBJ.object_id = sPTN.object_id
	WHERE sOBJ.type = 'U'
	AND sOBJ.is_ms_shipped = 0x0
	AND index_id < 2 -- 0:Heap, 1:Clustered
	GROUP BY sOBJ.name
)
,B
AS
(
	SELECT sOBJ.name AS [TableName],SUM(sPTN.Rows) AS [RowCount]
	FROM [IC-DB].[ic_egame_data].sys.objects AS sOBJ
	INNER JOIN [IC-DB].[ic_egame_data].sys.partitions AS sPTN
	ON sOBJ.object_id = sPTN.object_id
	WHERE sOBJ.type = 'U'
	AND sOBJ.is_ms_shipped = 0x0
	AND index_id < 2 -- 0:Heap, 1:Clustered
	GROUP BY sOBJ.name
)
SELECT A.TableName,A.[RowCount] AS ticket_db_rows,B.[RowCount] AS main_db_rows
FROM A JOIN B
ON A.TableName = B.TableName
ORDER BY 1
*/