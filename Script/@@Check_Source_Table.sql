DROP TABLE IF EXISTS ##testTB;
DECLARE @SQL NVARCHAR(MAX) = ''

;WITH ExceptDB
AS
(
	SELECT *
	FROM (VALUES
	('AWS'),('INP'),('ISN'),('RYC'),('SXC'),('TXR'),('AES'),('BNS'),('BSS'),('EBC'),('EBS'),('MGC'),('MGS'),('NSS'),('OKN'),('PSS'), --Offline DB List
	('reget'),('source_jobs'),('all_source_data_tmp'),('distribution') --Except DB List
	) a(DBname)
)
SELECT @SQL += '
SELECT
	''' + name + ''' AS DB,
	t.name ,
	CAST(t.is_published AS VARCHAR(10)) AS is_repl,
	p.data_compression_desc AS CompressionType,
	COUNT(p.partition_number) AS PartitionNum
FROM ' + name + '.sys.tables t
JOIN ' + name + '.sys.indexes i ON t.object_id = i.object_id
JOIN ' + name + '.sys.partitions p ON t.object_id = p.object_id
WHERE is_ms_shipped = 0
AND i.index_id IN (0,1)
GROUP BY t.name, t.is_published, p.data_compression_desc
UNION ALL
'
FROM sys.databases d
WHERE database_id > 4
AND NOT EXISTS
(
    SELECT 1
    FROM ExceptDB e
    WHERE d.name LIKE '%' + e.DBname + '%'
)

SET @SQL = '
SELECT * INTO ##testTB
FROM (' + LEFT(@SQL, LEN(@SQL) - 11) + ') t'

--SELECT @SQL
EXEC (@SQL)

------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------

;WITH CTE
AS
(
	SELECT
		a.DB,
		a.name AS TB,
		IIF(d.name IS NULL AND a.DB NOT LIKE '%_all','x',IIF(a.DB <> d.DB,'','IsAllTable')) AS have_all_TB,
		IIF(a.is_repl = '0' AND a.DB LIKE '%_all','IsAllTable',IIF(a.is_repl = '0','x','')) AS is_repl,
		CASE
			WHEN a.DB LIKE '%_all' THEN IIF(a.name = c.tb_name_main,'','x')
			ELSE IIF(a.name = b.tb_name_main,'','x')
		END AS is_setting,
		IIF(a.CompressionType = 'PAGE','','x') AS is_page_compress,
		IIF(a.PartitionNum = 1,'x','') AS is_partitioned
	FROM ##testTB a
	LEFT JOIN [source_jobs].[dbo].[sys_jobs_setting] b ON a.DB = b.db_name AND a.name = b.tb_name_main
	LEFT JOIN [source_jobs].[dbo].[sys_jobs_setting_all] c ON a.DB = c.db_name AND a.name = c.tb_name_main
	LEFT JOIN (SELECT * FROM ##testTB WHERE DB LIKE '%_all') d ON a.DB + '_all' = d.DB AND a.name = d.name
	WHERE a.name NOT LIKE '%Seed%'
)
SELECT *
FROM CTE
WHERE is_repl = 'x'			--miss replication
OR is_setting = 'x'			--miss sys_jobs_setting(All)
OR is_page_compress = 'x'	--miss page compression
OR is_partitioned = 'x'		--miss partition