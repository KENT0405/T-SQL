DROP TABLE IF EXISTS #TB
CREATE TABLE #TB
(
	DBname VARCHAR(100),
	TBname VARCHAR(100),
	row_count BIGINT,
	reserved_size VARCHAR(100),
	data_size VARCHAR(100),
	index_size VARCHAR(100),
	unused_size VARCHAR(100)
)

DROP TABLE IF EXISTS #DB
SELECT ROW_NUMBER() OVER (ORDER BY name) AS id,name 
INTO #DB
FROM sys.databases
WHERE database_id > 4
--AND name NOT IN ('idc_repl','distribution')

DECLARE
	@DB VARCHAR(100),
	@id INT = 1,
	@SQL NVARCHAR(MAX)

WHILE(1 = 1)
BEGIN
	SELECT @DB = name
	FROM #DB
	WHERE id = @id
	--PRINT(@DB)
	IF @@ROWCOUNT = 0
		BREAK;
	
	SET @SQL = @DB + N'
	..sp_MsForEachTable ''
	INSERT INTO #TB(TBname,row_count,reserved_size,data_size,index_size,unused_size) 
	EXEC sp_spaceused [?]''
	'
	EXEC(@SQL)
		--PRINT @SQL
	SET @SQL = N'
	UPDATE #TB 
	SET DBname = ''' + @DB + ''' 
	WHERE DBname IS NULL
	'
	EXEC(@SQL)
		--PRINT @SQL
	SET @id += 1
END

SELECT
	DBname, 
	TBname,
	row_count,
	CAST(ROUND(CONVERT(DECIMAL(18,3),REPLACE(reserved_size,' KB',''))/1024,3) AS DECIMAL(18,3)) AS reserved_size_MB,
	CAST(ROUND(CONVERT(DECIMAL(18,3),REPLACE(data_size,' KB',''))/1024,3) AS DECIMAL(18,3)) AS data_size_MB,
	CAST(ROUND(CONVERT(DECIMAL(18,3),REPLACE(index_size,' KB',''))/1024,3) AS DECIMAL(18,3)) AS index_size_MB,
	CAST(ROUND(CONVERT(DECIMAL(18,3),REPLACE(unused_size,' KB',''))/1024,3) AS DECIMAL(18,3)) AS unused_size_MB
FROM #TB
ORDER BY 1,2