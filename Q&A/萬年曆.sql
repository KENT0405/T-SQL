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

-----------------------------------------------------------
----------------------�]�w��w����-------------------------
-----------------------------------------------------------
DECLARE @special_day TABLE
(
	special_day DATE,
	is_weekday CHAR(1) --1 or 0
)

INSERT INTO @special_day (special_day,is_weekday) VALUES 
('2025-01-01',1),
('2025-01-27',1),
('2025-01-28',1),
('2025-01-29',1),
('2025-01-30',1),
('2025-01-31',1),
('2025-02-08',0),
('2025-02-28',1),
('2025-04-03',1),
('2025-04-04',1),
('2025-05-30',1),
('2025-10-06',1),
('2025-10-10',1)
-----------------------------------------------------------
-----------------------------------------------------------
-----------------------------------------------------------


DECLARE @BEGINDATE DATETIME = '2025-01-01'
       ,@ENDDATE DATETIME = '2025-12-31'

SET DATEFIRST 1

;WITH CTE AS
(
	SELECT [DATE] = @BEGINDATE
	UNION ALL
	SELECT [DATE] + 1 
	FROM CTE 
	WHERE [DATE] < @ENDDATE
),CTE_DATE
AS
(
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
      ,(CASE WHEN DATEPART(WEEKDAY, [DATE]) IN (6,7) THEN 'v' ELSE '' END) AS [����] 
FROM CTE 
)
SELECT
	[���],[�~],[��],[��],[�P��],
	CASE WHEN is_weekday IS NULL THEN a.���� ELSE IIF(b.is_weekday = 1,'v','') END AS [����]
FROM CTE_DATE a
LEFT JOIN @special_day b
ON a.��� = b.special_day
OPTION (MAXRECURSION 0)
GO

---------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------��k 2 ��� ---------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------

DECLARE @BEGINDATE DATETIME = '2024-12-01'
       ,@ENDDATE DATETIME = '2025-12-31'

SET DATEFIRST 7

;WITH CTE AS
(
	SELECT [DATE] = @BEGINDATE
	UNION ALL
	SELECT [DATE] + 1 
	FROM CTE
	WHERE [DATE] < @ENDDATE
),result
AS
(
	SELECT
		CONVERT(VARCHAR(10),[DATE],120) AS DATE,
		DATEPART (YEAR,[DATE]) AS YEAR,
		DATEPART (MONTH,[DATE]) AS MONTH,
		DATEPART (DAY,[DATE]) AS DAY,
		CASE WHEN CAST(DATEPART(WEEKDAY, [DATE]) -1 % 7 AS CHAR(2)) = 0 THEN 7 ELSE CAST(DATEPART(WEEKDAY, [DATE]) -1 % 7 AS CHAR(2)) END AS WEEKDAY,
		DATEPART(WEEK, [DATE]) AS N_WEEK
	FROM CTE
)
SELECT
	YEAR AS '�~',
	MONTH AS '��',
	CASE WHEN CAST(MAX([7]) AS CHAR(2)) IS NULL THEN '' ELSE CAST(MAX([7]) AS CHAR(2)) END AS '�P����',
	CASE WHEN CAST(MAX([1]) AS CHAR(2)) IS NULL THEN '' ELSE CAST(MAX([1]) AS CHAR(2)) END AS '�P���@',
	CASE WHEN CAST(MAX([2]) AS CHAR(2)) IS NULL THEN '' ELSE CAST(MAX([2]) AS CHAR(2)) END AS '�P���G',
	CASE WHEN CAST(MAX([3]) AS CHAR(2)) IS NULL THEN '' ELSE CAST(MAX([3]) AS CHAR(2)) END AS '�P���T',
	CASE WHEN CAST(MAX([4]) AS CHAR(2)) IS NULL THEN '' ELSE CAST(MAX([4]) AS CHAR(2)) END AS '�P���|',
	CASE WHEN CAST(MAX([5]) AS CHAR(2)) IS NULL THEN '' ELSE CAST(MAX([5]) AS CHAR(2)) END AS '�P����',
	CASE WHEN CAST(MAX([6]) AS CHAR(2)) IS NULL THEN '' ELSE CAST(MAX([6]) AS CHAR(2)) END AS '�P����'
	--,N_WEEK AS 'N��§��'
FROM result
PIVOT
(
	MAX(DAY)
	FOR WEEKDAY IN ([1],[2],[3],[4],[5],[6],[7])
) AS pvt
GROUP BY
	YEAR,
	MONTH,
	N_WEEK
OPTION (MAXRECURSION 0)
GO