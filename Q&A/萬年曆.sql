---------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------方法 1 ------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS #T

CREATE TABLE #T 
(
	set_date DATE,
	set_year INT,
	set_month INT,
	set_day INT,
	set_weekday NVARCHAR(30),
	the_first_few_weeks NVARCHAR(10),
	week_of_the_month NVARCHAR(10)
)

DECLARE
	@start_date DATE = '2022-01-01',
	@end_date DATE = '2022-09-28',
	@plus INT = 0


WHILE (1 = 1)
BEGIN	
	INSERT INTO #T
	SELECT  DATEADD(DAY,@plus,@start_date),
			YEAR(DATEADD(DAY,@plus,@start_date)),
			MONTH(DATEADD(DAY,@plus,@start_date)),
			DAY(DATEADD(DAY,@plus,@start_date)),
			DATENAME(DW,DATEADD(DAY,@plus,@start_date)),
			DATENAME(WW,DATEADD(DAY,@plus,@start_date)),
			CASE CAST(DATENAME(WW,DATEADD(DAY,@plus,@start_date)) AS INT) % 4
				 WHEN 0 THEN 4
				 ELSE CAST(DATENAME(WW,DATEADD(DAY,@plus,@start_date)) AS INT) % 4 END

				 --WHEN DATENAME(WW,DATEADD(DAY,@plus,@start_date)) < 5 THEN (SELECT DATENAME(WW,DATEADD(DAY,@plus,@start_date)))
				 --WHEN (SELECT CAST(DATENAME(WW,DATEADD(DAY,@plus,@start_date)) AS INT) % 4) = 0 THEN (SELECT 4)
				 --ELSE (SELECT CAST(DATENAME(WW,DATEADD(DAY,@plus,@start_date)) AS INT) % 4) END

	IF DATEADD(DAY,@plus,@start_date) = @end_date
		BREAK;
	SET @plus += 1
END

SELECT  set_date AS 日期,
		set_year AS 年,
		set_month AS 月,
		set_day AS 日,
		set_weekday AS 星期,
		the_first_few_weeks AS 第幾個禮拜,
		week_of_the_month AS 每月第幾個禮拜
FROM #T

---------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------方法 2 ------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

DECLARE @BEGINDATE DATETIME = '2022-09-20'
       ,@ENDDATE DATETIME = '2022-11-30'

SET DATEFIRST 1

;WITH CTE AS
(
	SELECT [DATE] = @BEGINDATE
	UNION ALL
	SELECT [DATE] + 1 
	FROM CTE 
	WHERE [DATE] < @ENDDATE
)
SELECT  CONVERT(VARCHAR(10),[DATE],120) AS [日期]
       ,DATEPART (YEAR,[DATE]) AS [年]
	   ,DATEPART (MONTH,[DATE]) AS [月]
	   ,DATEPART (DAY,[DATE]) AS [日]
	   ,(CASE DATEPART(WEEKDAY, [DATE]) 
		WHEN 1 THEN '星期一' 
		WHEN 2 THEN '星期二' 
		WHEN 3 THEN '星期三' 
		WHEN 4 THEN '星期四' 
		WHEN 5 THEN '星期五' 
		WHEN 6 THEN '星期六' 
		WHEN 7 THEN '星期日' END) AS [星期] 
      ,(CASE DATEPART(WEEKDAY, [DATE]) 
		WHEN 1 THEN '' 
		WHEN 2 THEN '' 
		WHEN 3 THEN '' 
		WHEN 4 THEN '' 
		WHEN 5 THEN '' 
		WHEN 6 THEN 'O' 
		WHEN 7 THEN 'O' END) AS [假日] 
      ,(CASE WHEN DATEPART(WEEKDAY, [DATE]) IN (6,7) THEN 'v' ELSE '' END) AS [假日] 
  FROM CTE
OPTION (MAXRECURSION 0)
GO