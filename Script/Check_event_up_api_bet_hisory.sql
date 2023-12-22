DECLARE
	@BeginDate	DATETIME = '2023-12-21',
	@EndDate	DATETIME = '2023-12-22',
	@timepart	INT	= 60, --minute
	@SQL		NVARCHAR(MAX) = '',
	@merchant	NVARCHAR(MAX) = '',
	@timestamp	DATE,
	@time		DATETIME

DROP TABLE IF EXISTS #t, #TT, #temp, #temp_merchant;

--Create table #TT for time range
;WITH CTE
AS
(
    SELECT @BeginDate AS BeginDate
    UNION ALL
    SELECT DATEADD(MINUTE, @timepart, BeginDate)
    FROM CTE
    WHERE BeginDate < @EndDate + 1
)
SELECT
	CAST(BeginDate AS DATE) AS BeginDate,
	FORMAT(BeginDate, 'yyyy-MM-dd HH:mm:ss') AS upper,
	CAST(FORMAT(DATEADD(mi,@timepart,BeginDate), 'yyyy-MM-dd HH:mm:ss') AS DATETIME) AS lower
INTO #TT
FROM CTE
OPTION (maxrecursion 0)

--Get all event for time range
SELECT
	ROW_NUMBER() OVER(ORDER BY CAST(DATEADD(HOUR,8,n.value('(@timestamp)[1]', 'DATETIME2')) AS DATE)) AS ID,
	CAST(DATEADD(HOUR,8,n.value('(@timestamp)[1]', 'DATETIME2')) AS DATE) AS [timestamp],
	CAST(FORMAT(DATEADD(HOUR,8,n.value('(@timestamp)[1]', 'DATETIME2')), 'yyyy-MM-dd HH:mm:00') AS DATETIME) AS [time],
	n.value('(data[@name="statement"]/value)[1]', 'NVARCHAR(MAX)') AS statement
INTO #temp
FROM (
	SELECT CAST(event_data AS XML) AS event_data
	FROM sys.fn_xe_file_target_read_file('D:\Events\T-SQL*.xel', null, null, null)) ed
CROSS APPLY ed.event_data.nodes('event') AS q(n)
WHERE CAST(DATEADD(HOUR,8,n.value('(@timestamp)[1]', 'DATETIME2')) AS DATE) BETWEEN @BeginDate AND @EndDate
AND n.value('(data[@name="statement"]/value)[1]', 'NVARCHAR(MAX)') LIKE '%[up_api_bet_history]%'

SELECT
	[timestamp],
	[time],
	value AS merchant,
	statement,
	CAST('1' AS INT) AS cnt
INTO #t
FROM
(
	SELECT ROW_NUMBER() OVER(PARTITION BY ID ORDER BY ID) row_id, *
	FROM #temp
	CROSS APPLY STRING_SPLIT(REPLACE(SUBSTRING(statement, CHARINDEX('OUTPUT', statement) + LEN('OUTPUT') + 2, LEN(statement) - (CHARINDEX('OUTPUT', statement) + LEN('OUTPUT'))),'''',''), ',')
	WHERE statement NOT LIKE '%INSERT INTO%'
	AND statement NOT LIKE '%exec sp_executesql N''SELECT%'
	AND statement NOT LIKE '%UPDATE%'
) a
WHERE row_id = 1
AND value NOT LIKE '%-%'

SELECT @merchant += ',' + QUOTENAME(merchant)
FROM
(
	SELECT DISTINCT merchant
	FROM #t
) a
ORDER BY merchant DESC

--Pivot Range
SET @SQL = '
SELECT *
FROM
(
	SELECT
		upper,
		merchant,
		cnt
	FROM #TT CROSS APPLY #t
	WHERE BeginDate = [timestamp]
	AND [time] >= upper
	AND [time] < lower
) AS S
PIVOT (
	SUM(cnt)
	FOR merchant IN (' + STUFF(@merchant,1,1,'') + ')
) P
'

--PRINT @SQL

EXEC (@SQL)