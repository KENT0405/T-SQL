WITH    autostats(object_id, stats_id, name, column_id)
AS (
SELECT  sys.stats.object_id ,
        sys.stats.stats_id ,
        sys.stats.name ,
        sys.stats_columns.column_id
FROM    sys.stats
        INNER JOIN sys.stats_columns ON sys.stats.object_id = sys.stats_columns.object_id
                                        AND sys.stats.stats_id = sys.stats_columns.stats_id
WHERE   sys.stats.auto_created = 1
        AND sys.stats_columns.stats_column_id = 1
)
SELECT  OBJECT_NAME(sys.stats.object_id) AS [Table] ,
		sys.columns.name AS [Column] ,
		sys.stats.name AS [Overlapped] ,
		autostats.name AS [Overlapping] ,
		'DROP STATISTICS [' + OBJECT_SCHEMA_NAME(sys.stats.object_id) + '].[' + OBJECT_NAME(sys.stats.object_id) + '].[' + autostats.name + ']'
FROM    sys.stats
		INNER JOIN sys.stats_columns ON sys.stats.object_id = sys.stats_columns.object_id
										AND sys.stats.stats_id = sys.stats_columns.stats_id
		INNER JOIN autostats ON sys.stats_columns.object_id = autostats.object_id
								AND sys.stats_columns.column_id = autostats.column_id
		INNER JOIN sys.columns ON sys.stats.object_id = sys.columns.object_id
									AND sys.stats_columns.column_id = sys.columns.column_id
WHERE   sys.stats.auto_created = 0
		AND sys.stats_columns.stats_column_id = 1
		AND sys.stats_columns.stats_id != autostats.stats_id
		AND OBJECTPROPERTY(sys.stats.object_id, 'IsMsShipped') = 0;

/*　查看單一Table的統計值
DECLARE @TableName = ''
SELECT
	s.name AS 'Statistics'
	,so.name AS TableName
	,COL_NAME(scol.object_id, scol.column_id) AS 'Column'
	,s.auto_created
	,s.user_created
	,sp.last_updated
	,sp.rows AS RowsInTableWhenUpdated
	,sp.rows_sampled
	,sp.modification_counter
FROM sys.stats s (NOLOCK)
JOIN sys.objects so
	ON s.object_id = so.object_id
JOIN sys.stats_columns AS scol (NOLOCK)
	ON s.stats_id = scol.stats_id
		AND s.object_id = scol.object_id
JOIN sys.tables AS tab (NOLOCK)
	ON tab.object_id = s.object_id
CROSS APPLY [sys].[dm_db_stats_properties](so.object_id, s.stats_id) [sp]
WHERE 
   so.name = @TableName
--s.name like '_WA%'
--and stats_column_id = 1
ORDER BY so.name, s.name
*/