---------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------��k 1 ------------------------------------------------------------------
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

SELECT  set_date AS ���,
		set_year AS �~,
		set_month AS ��,
		set_day AS ��,
		set_weekday AS �P��,
		the_first_few_weeks AS �ĴX��§��,
		week_of_the_month AS �C��ĴX��§��
FROM #T

---------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------��k 2 ------------------------------------------------------------------
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
SELECT  CONVERT(VARCHAR(10),[DATE],120) AS [���]
       ,DATEPART (YEAR,[DATE]) AS [�~]
	   ,DATEPART (MONTH,[DATE]) AS [��]
	   ,DATEPART (DAY,[DATE]) AS [��]
	   ,(CASE DATEPART(WEEKDAY, [DATE]) 
		WHEN 1 THEN '�P���@' 
		WHEN 2 THEN '�P���G' 
		WHEN 3 THEN '�P���T' 
		WHEN 4 THEN '�P���|' 
		WHEN 5 THEN '�P����' 
		WHEN 6 THEN '�P����' 
		WHEN 7 THEN '�P����' END) AS [�P��] 
      ,(CASE DATEPART(WEEKDAY, [DATE]) 
		WHEN 1 THEN '' 
		WHEN 2 THEN '' 
		WHEN 3 THEN '' 
		WHEN 4 THEN '' 
		WHEN 5 THEN '' 
		WHEN 6 THEN 'O' 
		WHEN 7 THEN 'O' END) AS [����] 
      ,(CASE WHEN DATEPART(WEEKDAY, [DATE]) IN (6,7) THEN 'v' ELSE '' END) AS [����] 
  FROM CTE
OPTION (MAXRECURSION 0)
GO