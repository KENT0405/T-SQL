DROP TABLE IF EXISTS #Temp;

SELECT *
INTO #Temp
FROM (
    SELECT 1 AS id, 'a,b' AS val
    UNION ALL
    SELECT 1 AS id, 'b,c' AS val
    UNION ALL
    SELECT 2 AS id, 'aa,bb' AS val
    UNION ALL
    SELECT 2 AS id, 'bb,cc' AS val
) t;

--希望得到结果
 -- 1,  a,b,c
 -- 2,  aa,bb,cc

;WITH CTE
AS
(
	SELECT DISTINCT a.id,b.value AS val
	FROM #Temp a
	CROSS APPLY STRING_SPLIT(val,',') b
)
SELECT
	id,
	STUFF(
	(
        SELECT ',' + val
        FROM CTE a
        WHERE a.id = b.id
        FOR XML PATH('')
    ),1,1, '') AS val
FROM CTE b
GROUP BY id