CREATE OR ALTER PROCEDURE [dbo].[#PROC_MergePartition_OWT]
	@owt_keepday TINYINT  --30
AS
BEGIN
	SET NOCOUNT, ARITHABORT ON;

	DECLARE
		@SN		 INT = 1,
		@SN_FN   INT = 1,
		@SN_exec INT = 1,
		@SQL	 NVARCHAR(MAX)

	DROP TABLE IF EXISTS #exec_table, #temp;

	CREATE TABLE #exec_table
	(
		SN_exec  INT IDENTITY(1,1),
		SQL_exec NVARCHAR(MAX)
	)

-----------------MERGE_RANGE_OWT-----------------

	INSERT INTO #exec_table(SQL_exec)
	SELECT 'ALTER PARTITION FUNCTION ['+pf.NAME+']() MERGE RANGE(''' + FORMAT(CAST(prv_left.VALUE AS DATE),'yyyy-MM-dd 00:00:00.000') + ''')' AS MERGE_RANGE_SQL
	FROM sys.dm_db_partition_stats p
	JOIN sys.indexes i ON i.OBJECT_ID = p.OBJECT_ID AND i.index_id = p.index_id
	JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id
	JOIN sys.partition_functions pf ON ps.function_id = pf.function_id
	LEFT JOIN sys.partition_range_values prv_left ON prv_left.function_id = ps.function_id AND prv_left.boundary_id = p.partition_number - 1
	WHERE p.index_id < 2
	AND p.row_count = 0
	AND OBJECT_NAME(p.OBJECT_ID) = 'one_wallet_transfer_all'
	AND FORMAT(CAST(prv_left.VALUE AS DATE),'yyyy-MM-dd 00:00:00.000') < CAST((GETDATE() - @owt_keepday) AS DATE)

---------------------MOVEFILE---------------------

	SELECT
		fg.name AS FG_Name,
		sf.name AS FL_Name
	INTO #temp
	FROM sys.dm_db_partition_stats p
	JOIN sys.indexes i ON i.OBJECT_ID = p.OBJECT_ID AND i.index_id = p.index_id
	JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id
	JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number
	JOIN sys.filegroups fg ON fg.data_space_id = dds.data_space_id
	JOIN sys.sysfiles sf ON sf.groupid = fg.data_space_id
	LEFT JOIN sys.partition_range_values prv_left ON prv_left.function_id = ps.function_id AND prv_left.boundary_id = p.partition_number - 1
	WHERE p.index_id < 2
	AND p.row_count = 0
	AND OBJECT_NAME(p.OBJECT_ID) = 'one_wallet_transfer_all'
	AND FORMAT(CAST(prv_left.VALUE AS DATE),'yyyy-MM-dd 00:00:00.000') < CAST((GETDATE() - @owt_keepday) AS DATE)
	EXCEPT
	SELECT
		fg.name AS FG_Name,
		sf.name AS FL_Name
	FROM sys.dm_db_partition_stats p
	JOIN sys.indexes i ON i.OBJECT_ID = p.OBJECT_ID AND i.index_id = p.index_id
	JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id
	JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number
	JOIN sys.filegroups fg ON fg.data_space_id = dds.data_space_id
	JOIN sys.sysfiles sf ON sf.groupid = fg.data_space_id
	LEFT JOIN sys.partition_range_values prv_left ON prv_left.function_id = ps.function_id AND prv_left.boundary_id = p.partition_number - 1
	WHERE p.index_id < 2
	AND OBJECT_NAME(p.OBJECT_ID) = 'one_wallet_transfer_all'
	AND FORMAT(CAST(prv_left.VALUE AS DATE),'yyyy-MM-dd 00:00:00.000') BETWEEN GETDATE() - 28 AND GETDATE()

	INSERT INTO #exec_table(SQL_exec)
	SELECT DISTINCT
		'ALTER DATABASE '+ DB_NAME() +' REMOVE FILE '+ FL_Name +';
		 ALTER DATABASE '+ DB_NAME() +' REMOVE FILEGROUP '+ FG_Name +';'
	FROM #temp
	WHERE 1 = 1
	AND FL_Name <> 'spade_owt_base'
	AND FL_Name <> 'spade_tck_base'

--------------------exec_table--------------------

	WHILE(1 = 1)
	BEGIN
		SELECT @SQL = SQL_exec
		FROM #exec_table
		WHERE @SN_exec = SN_exec

		IF @@ROWCOUNT = 0
			BREAK;

		PRINT(@SQL)
		--EXEC(@SQL)

		SET @SN_exec += 1
	END

	SET NOCOUNT, ARITHABORT ON;
END