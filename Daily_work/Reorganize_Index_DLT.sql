DECLARE @Yesterday			DATE = GETDATE() - 1,
		@PartitionNumber_jp INT,
		@SQL_reorganizestr	NVARCHAR(MAX) = '',
		@SQL_updatestatstr	NVARCHAR(MAX) = '',
		@i					INT = 1

SET @PartitionNumber_jp = $Partition.[Pfn_datetime_dlt](@Yesterday)

DROP TABLE IF EXISTS #temp;

CREATE TABLE #temp
(
	sn INT IDENTITY(1,1),
	reorganizestr VARCHAR(200),
	updatestatstr VARCHAR(200)
)

;WITH A
AS
(
	SELECT  LOWER(T.name) AS table_name
		   ,P.partition_number
		   ,'ALTER INDEX [' + I.name + '] ON ' + SCHEMA_NAME(t.schema_id) + '.' + OBJECT_NAME(T.object_id) + ' REORGANIZE PARTITION = ' +
		   CASE WHEN S.name IS NULL THEN 'ALL' ELSE CAST(P.partition_number AS VARCHAR) END + ' WITH ( LOB_COMPACTION = ON );' reorganizestr
		   ,'UPDATE STATISTICS ' + OBJECT_NAME(T.object_id) AS updatestatstr
		   ,p.object_id
		   ,p.index_id
	FROM sys.tables T
	JOIN sys.indexes I					ON T.object_id = I.object_id
	JOIN sys.partitions P				ON I.object_id = P.object_id AND I.index_id = P.index_id
	LEFT JOIN sys.partition_schemes S	ON i.data_space_id = S.data_space_id
	WHERE p.partition_number = @PartitionNumber_jp
)
INSERT INTO #temp(reorganizestr,updatestatstr)
SELECT reorganizestr, updatestatstr
FROM A CROSS APPLY sys.dm_db_index_physical_stats(DB_ID(), A.object_id , A.index_id , A.partition_number , NULL) D
WHERE avg_fragmentation_in_percent > 10.0
ORDER BY 1 DESC

WHILE(1 = 1)
BEGIN
	SELECT
		@SQL_reorganizestr += reorganizestr + '
',
		@SQL_updatestatstr += updatestatstr + ';
'
	FROM #temp
	WHERE sn = @i

	IF(@@ROWCOUNT = 0)
		BREAK;

	SET @i += 1
END

EXEC(@SQL_reorganizestr)
EXEC(@SQL_updatestatstr)