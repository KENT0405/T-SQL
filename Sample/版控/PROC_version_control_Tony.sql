;WITH CTE
AS
(
	SELECT upvt.*
	FROM [maindb].[dbo].[TB_schema_bak]
	UNPIVOT
	(
		obj FOR def IN ([definition],[version_1],[version_2])	
	) AS upvt 
)
,CTE_2
AS
	(
	SELECT 
		db_name,
		obj_name,
		type_desc,
		modify_date,
		log_date,
		status,
		obj AS [definition],
		CASE r 
		WHEN 1 THEN 'definition'
		WHEN 2 THEN 'version_1'
		WHEN 3 THEN 'version_2'
		END AS new_def,
		r
	FROM 
	(
		SELECT *,ROW_NUMBER() OVER (PARTITION BY obj_name ORDER BY [status] DESC, modify_date DESC) AS R
		FROM CTE
	) AS n
	WHERE r < 4
)
SELECT 
	db_name,
	obj_name,
	type_desc,
	MAX(modify_date) AS modify_date,
	MAX(log_date) AS log_date,
	MAX(status) AS status,
	MAX([1]) AS definition, 
	MAX([2]) AS version_1,
	MAX([3]) AS version_2
FROM CTE_2
PIVOT
(
	MAX(definition)
	FOR r IN ([1],[2],[3])
) AS PVT
GROUP BY 
	db_name,
	obj_name,
	type_desc