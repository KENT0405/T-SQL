DECLARE
	@BeginDate	DATETIME = '2023-10-01',
	@EndDate	DATETIME = '2023-10-04',
	@timepart	INT	= 360, --minute
	@SQL		NVARCHAR(MAX) = '',
	@DateRange	NVARCHAR(MAX) = '',
	@timestamp	DATE,
	@time		DATETIME,
	@i			INT = 1

DROP TABLE IF EXISTS #t,#TT;

--Create table #TT for every 5 minute
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
	CAST(FORMAT(DATEADD(mi,@timepart,BeginDate), 'yyyy-MM-dd HH:mm:ss') AS DATETIME) AS lower,
	NULL AS cnt
INTO #TT
FROM CTE
OPTION (maxrecursion 0)

--Get all event for every 5 minute
SELECT
	ROW_NUMBER() OVER(ORDER BY CAST(DATEADD(HOUR,8,n.value('(@timestamp)[1]', 'DATETIME2')) AS DATE)) AS ID,
	CAST(DATEADD(HOUR,8,n.value('(@timestamp)[1]', 'DATETIME2')) AS DATE) AS [timestamp],
	CAST(FORMAT(DATEADD(HOUR,8,n.value('(@timestamp)[1]', 'DATETIME2')), 'yyyy-MM-dd HH:mm:00') AS DATETIME) AS [time]
INTO #t
FROM (
	SELECT CAST(event_data AS XML) AS event_data
	FROM sys.fn_xe_file_target_read_file('D:\Events\T-SQL*.xel', null, null, null)) ed
CROSS APPLY ed.event_data.nodes('event') AS q(n)
WHERE CAST(DATEADD(HOUR,8,n.value('(@timestamp)[1]', 'DATETIME2')) AS DATE) BETWEEN @BeginDate AND @EndDate

--Update summary cnt
WHILE(1 = 1)
BEGIN
	SELECT
		@timestamp = timestamp,
		@time = time
	FROM #t
	WHERE ID = @i

	IF @@ROWCOUNT = 0
		BREAK;

	UPDATE #TT
	SET cnt = CASE WHEN cnt IS NULL THEN 1 ELSE cnt + 1 END
	WHERE BeginDate = @timestamp
	AND @time >= upper
	AND @time < lower

	SET @i += 1
END

--Get @DateRange : BeginDate to EndDate
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

--Pivot Range
SET @SQL = '
SELECT *
FROM
(
	SELECT
		BeginDate,
		CAST(upper AS TIME(0)) AS upper,
		cnt
	FROM #TT
) AS S
PIVOT (
	SUM(cnt)
	FOR BeginDate IN (' + STUFF(@DateRange,1,1,'') + ')
) P
'

--PRINT @SQL

EXEC (@SQL)