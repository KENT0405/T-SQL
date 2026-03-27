CREATE OR ALTER FUNCTION fntb_GetCurrArray
(
	@curr_month VARCHAR(20)
)
RETURNS TABLE
AS
RETURN
SELECT
	 curr_month
	,SUM(curr_rate_before) AS sum_curr_rate_before
	,SUM(real_curr_rate_after) AS sum_real_curr_rate_after
	,AVG(real_curr_rate_before) AS avg_real_curr_rate_before
	,AVG(real_curr_rate_after) AS avg_real_curr_rate_after
	,COUNT(*) AS total_cnt
FROM sys_currency_log WITH (NOLOCK)
WHERE curr_month = @curr_month
GROUP BY curr_month
GO

CREATE OR ALTER FUNCTION fntb_GetCurrArray_2
(
	@curr_month VARCHAR(20)
)
RETURNS @res TABLE
(
	curr_month VARCHAR(20),
	sum_curr_rate_before INT,
	sum_real_curr_rate_after INT,
	avg_real_curr_rate_before INT,
	avg_real_curr_rate_after INT,
	total_cnt INT
)
AS
BEGIN
	INSERT INTO @res
	SELECT
		curr_month
		,SUM(curr_rate_before) AS sum_curr_rate_before
		,SUM(real_curr_rate_after) AS sum_real_curr_rate_after
		,AVG(real_curr_rate_before) AS avg_real_curr_rate_before
		,AVG(real_curr_rate_after) AS avg_real_curr_rate_after
		,COUNT(*) AS total_cnt
	FROM sys_currency_log WITH (NOLOCK)
	WHERE curr_month = @curr_month
	GROUP BY curr_month

	RETURN
END
GO

DECLARE @TABLE TABLE
(
	curr_month VARCHAR(10)
)

INSERT INTO @TABLE (curr_month)
SELECT DISTINCT curr_month
FROM sys_currency_log_new

INSERT INTO @TABLE (curr_month) VALUES ('2022-09')

SELECT T.curr_month,F.avg_real_curr_rate_after,F.curr_month
FROM @TABLE T OUTER APPLY dbo.fntb_GetCurrArray(T.curr_month) AS f

GO

