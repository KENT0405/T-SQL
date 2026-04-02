SELECT
    B.name AS Table_name,
    C.name AS Index_name,
    A.user_seeks,
    A.user_scans,
    A.user_updates,
	SUM(D.rows) AS [rowcount]
FROM
    sys.dm_db_index_usage_stats AS A
    INNER JOIN sys.objects	    AS B ON A.OBJECT_ID = B.OBJECT_ID
    INNER JOIN sys.indexes		AS C ON C.index_id = A.index_id AND A.OBJECT_ID = C.OBJECT_ID
	INNER JOIN sys.partitions	AS D ON C.object_id = D.object_id AND C.index_id = D.index_id
WHERE 1 = 1
AND C.is_primary_key = 0 --This line excludes primary key constarint
AND C.is_unique = 0 --This line excludes unique key constarint
AND A.user_updates <> 0 -- This line excludes indexes SQL Server hasn¡¦t done any work with
AND A.user_lookups = 0
AND A.user_seeks = 0
AND A.user_scans = 0
GROUP BY 
	B.name,
    C.name,
    A.user_seeks,
    A.user_scans,
    A.user_updates
ORDER BY 
	A.user_updates DESC
	
