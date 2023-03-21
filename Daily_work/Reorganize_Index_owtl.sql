------------------------------------------------------------
------------------------每日重組index(main)------------------
------------------------------------------------------------

DECLARE @Yesterday			DATE = GETDATE() - 1,
		@PartitionNumber	INT

SET @PartitionNumber = $Partition.[Pfn_datetime_owt](@Yesterday)

ALTER INDEX [PK_one_wallet_transfer_all] ON dbo.one_wallet_transfer_all REORGANIZE PARTITION = @PartitionNumber WITH ( LOB_COMPACTION = ON );
ALTER INDEX [idx_date_merchant] ON dbo.one_wallet_transfer_all REORGANIZE PARTITION = @PartitionNumber WITH ( LOB_COMPACTION = ON );

UPDATE STATISTICS one_wallet_transfer_all

;WITH A
AS
(
	SELECT  LOWER(T.name) AS table_name
		   ,I.name AS index_name
		   ,I.type_desc AS index_type
		   ,ISNULL(F.name,S.name) AS file_group
		   ,P.rows
		   ,I.is_unique
		   ,I.is_primary_key
		   ,P.partition_number
		   ,'ALTER INDEX [' + I.name + '] ON ' + SCHEMA_NAME(t.schema_id) + '.' + OBJECT_NAME(T.object_id) + ' REBUILD PARTITION = ' +
		   CASE WHEN S.name IS NULL THEN 'ALL' ELSE CAST(P.partition_number AS VARCHAR) END + ' WITH (SORT_IN_TEMPDB = ON,ONLINE=ON);' AS rebuildstr
		   ,'ALTER INDEX [' + I.name + '] ON ' + SCHEMA_NAME(t.schema_id) + '.' + OBJECT_NAME(T.object_id) + ' REORGANIZE PARTITION = ' +
		   CASE WHEN S.name IS NULL THEN 'ALL' ELSE CAST(P.partition_number AS VARCHAR) END + ' WITH ( LOB_COMPACTION = ON );' reorganizestr
		   ,'UPDATE STATISTICS ' + OBJECT_NAME(T.object_id) AS updatestatstr
		   ,STATS_DATE(T.object_id,I.index_id) stats_time
		   ,O.create_date
		   ,p.object_id
		   ,p.index_id
	FROM sys.tables T JOIN sys.indexes I
	ON T.object_id = I.object_id
					  JOIN sys.partitions P
	ON I.object_id = P.object_id
	AND I.index_id = P.index_id
					  JOIN sys.objects O
	ON I.object_id = O.object_id
					  LEFT JOIN sys.filegroups F
	ON i.data_space_id = F.data_space_id
					  LEFT JOIN sys.partition_schemes S
	ON i.data_space_id = S.data_space_id
	WHERE 1 = 1
	AND T.name = 'one_wallet_transfer_all'
	AND p.partition_number = @PartitionNumber
	AND p.rows > 100
	AND i.name IS NOT NULL
)
SELECT table_name
	   ,index_name
	   ,index_type
	   ,file_group
	   ,rows
	   ,D.avg_fragmentation_in_percent
	   ,stats_time
	   ,create_date
	   ,is_unique
	   ,is_primary_key
	   ,A.partition_number
	   ,rebuildstr
	   ,reorganizestr
	   ,updatestatstr
FROM A CROSS APPLY sys.dm_db_index_physical_stats(DB_ID(), A.object_id , A.index_id , A.partition_number , NULL) D
ORDER BY 1 DESC