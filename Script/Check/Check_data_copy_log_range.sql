DECLARE
	 @Begin_date DATE = '2024-11-01'
	,@End_date DATE = '2024-11-12'
	,@DateString VARCHAR(200) = ''
	,@SQL NVARCHAR(MAX) = ''


;WITH D
AS
(
	SELECT @Begin_date AS bd
	UNION ALL
	SELECT DATEADD(DAY,1,D.bd)
	FROM D
	WHERE bd < @End_date
)
SELECT @DateString += ',' +  QUOTENAME(CAST(D.bd AS VARCHAR(10)),'')
FROM D
OPTION (MAXRECURSION 0)

SET @DateString = STUFF(@DateString,1,1,'')

SET @SQL = N'
;WITH S
AS
(
	SELECT
		CAST(save_start_date AS TIME(0)) AS save_start_date,
		CAST(save_end_date AS TIME(0)) AS save_end_date,
		log_date,
		copy_records_count
	FROM sys_data_copy_log
	WHERE log_date BETWEEN @Begin_date AND @End_date
)
SELECT *
FROM S
PIVOT
(
	MAX(copy_records_count)
	FOR log_date IN (' + @DateString + ')
) AS pvt
ORDER BY 1,2
'

EXEC sp_executesql
@SQL,N'
@Begin_date DATE,
@End_date DATE',
@Begin_date,
@End_date