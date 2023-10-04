DECLARE
	@BeginDate	DATETIME = '2023-09-10',
	@EndDate	DATETIME = '2023-09-12',
	@SQL		NVARCHAR(MAX) = '',
	@DateRange	NVARCHAR(MAX) = ''

DROP TABLE IF EXISTS #t,#s,#temp;

SELECT
	CAST(DATEADD(HOUR,8,n.value('(@timestamp)[1]', 'DATETIME2')) AS DATE) AS [timestamp],
    FORMAT(DATEADD(HOUR,8,n.value('(@timestamp)[1]', 'DATETIME2')), 'HH:00:00') AS [time]
INTO #t
FROM (
	SELECT CAST(event_data AS XML) AS event_data
	FROM sys.fn_xe_file_target_read_file('D:\Events\T-SQL*.xel', null, null, null)) ed
CROSS APPLY ed.event_data.nodes('event') AS q(n)
ORDER BY n.value('(@timestamp)[1]', 'DATETIME2') DESC

;WITH CTE_DateRange
AS
(
    SELECT @BeginDate AS BeginDate
    UNION ALL
    SELECT DATEADD(DAY, 1, BeginDate)
    FROM CTE_DateRange
    WHERE BeginDate < @EndDate
)
SELECT @DateRange += ',' + QUOTENAME(BeginDate) 
FROM CTE_DateRange

SELECT 
	timestamp,
	time,
	COUNT(time) AS cnt 
INTO #temp
FROM #t
WHERE [timestamp] BETWEEN @BeginDate AND @EndDate
GROUP BY timestamp,time

;WITH CTE 
AS
(
    SELECT @BeginDate AS BeginDate
    UNION ALL
    SELECT DATEADD(HOUR, 1, BeginDate)
    FROM CTE
    WHERE BeginDate < @EndDate + 1
)
SELECT 
	CAST(BeginDate AS DATE) AS BD,
	FORMAT(BeginDate, 'HH:mm:ss') AS time
INTO #s
FROM CTE
OPTION (maxrecursion 0)

SET @SQL = '
SELECT *
FROM 
(
	SELECT s.*, t.cnt
	FROM #s s LEFT JOIN #temp t
	ON s.BD = t.timestamp
	AND s.time = t.time
) AS S
PIVOT (
	SUM(cnt)
	FOR BD IN (' + STUFF(@DateRange,1,1,'') + ')
) P

UNION ALL

SELECT ''Total'',*
FROM 
(
	SELECT timestamp, time
	FROM #t
) AS S
PIVOT (
	COUNT(time)
	FOR timestamp IN (' + STUFF(@DateRange,1,1,'') + ')
) P
'

--PRINT @SQL

EXEC (@SQL)