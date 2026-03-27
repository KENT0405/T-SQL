SET NOCOUNT ON;

DECLARE @ReportType INT = 2 --2047

DROP TABLE IF EXISTS #ReportType;
SELECT
    POWER(CAST(2 AS BIGINT),number) AS id,
    CASE POWER(CAST(2 AS BIGINT),number)
        WHEN 1    THEN 'Job fail record'
        WHEN 2    THEN 'Error message'
        WHEN 4    THEN 'Tsql & DeadLock Trace'
        WHEN 8    THEN 'Unclosed Profiler'
        WHEN 16   THEN 'Space Usage'
        WHEN 32   THEN 'RecordSpCached Top IO'
        WHEN 64   THEN 'Long Running Job'
        WHEN 128  THEN 'Non-Compliance Connection'
        WHEN 256  THEN 'Connection Fulled Loaded'
        WHEN 512  THEN 'Recently Modify Obejct'
        WHEN 1024 THEN 'Partition Check'
    END AS ReportType
INTO #ReportType
FROM master..spt_values
WHERE type = 'P'
AND number BETWEEN 0 AND 10
AND POWER(CAST(2 AS BIGINT),number) & @ReportType <> 0


--Job fail record
IF EXISTS (SELECT 1 FROM #ReportType WHERE id = 1)
BEGIN
    SELECT 'Job fail record'
END

--Error message
IF EXISTS (SELECT 1 FROM #ReportType WHERE id = 2)
BEGIN
	DECLARE @SQL NVARCHAR(MAX)

	;WITH CTE
	AS
	(
		SELECT
			o.name  AS table_name,
			c.name  AS col_name,
			ROW_NUMBER() OVER (ORDER BY o.name, c.column_id) AS rn
		FROM sys.objects o
		JOIN sys.columns c ON o.object_id = c.object_id
		WHERE o.type IN ('U', 'V')
		AND o.name IN ('sys_jobs_errormessage', 'TB_JobsErrorMessage_Main')
	)
	SELECT @SQL = '
	SELECT ' +
	STUFF((
		SELECT ', ' + IIF(col_name = 'sn','CAST(' + col_name + ' AS BIGINT)',col_name) + ' AS ' + REPLACE(IIF(col_name = 'Id','SN',UPPER(col_name)),'_','')
		FROM CTE
		WHERE rn <= 8
		FOR XML PATH('')),1,1,'') +
	', ' + COALESCE((SELECT col_name FROM CTE WHERE rn = 9), '''''') + ' AS ERRORDATABASE
	FROM ' + (SELECT TOP 1 table_name FROM CTE) + ' WITH(NOLOCK)'

	--PRINT @SQL
	EXEC sp_executesql  @SQL
END

--Tsql & DeadLock Trace
IF EXISTS (SELECT 1 FROM #ReportType WHERE id = 4)
BEGIN
    SELECT 'Tsql & DeadLock Trace'
END

--Unclosed Profiler
IF EXISTS (SELECT 1 FROM #ReportType WHERE id = 8)
BEGIN
    SELECT 'Unclosed Profiler'
END

--Space Usage
IF EXISTS (SELECT 1 FROM #ReportType WHERE id = 16)
BEGIN
    SELECT 'Space Usage'
END

--RecordSpCached Top IO
IF EXISTS (SELECT 1 FROM #ReportType WHERE id = 32)
BEGIN
    SELECT 'RecordSpCached Top IO'
END

--Long Running Job
IF EXISTS (SELECT 1 FROM #ReportType WHERE id = 64)
BEGIN
    SELECT 'Long Running Job'
END

--Non-Compliance Connection
IF EXISTS (SELECT 1 FROM #ReportType WHERE id = 128)
BEGIN
    SELECT 'Non-Compliance Connection'
END

--Connection Fulled Loaded
IF EXISTS (SELECT 1 FROM #ReportType WHERE id = 256)
BEGIN
    SELECT 'Connection Fulled Loaded'
END

--Recently Modify Obejct
IF EXISTS (SELECT 1 FROM #ReportType WHERE id = 512)
BEGIN
    SELECT 'Recently Modify Obejct'
END

--Partition Check
IF EXISTS (SELECT 1 FROM #ReportType WHERE id = 1024)
BEGIN
    SELECT 'Partition Check'
END