
CREATE OR ALTER PROC PROC_GetCurrArray
	@curr_month VARCHAR(20)
AS
BEGIN
	DECLARE @curr_desc VARCHAR(200) = ''

	SELECT @curr_desc += ',' + curr_id
	FROM sys_currency_log_new
	WHERE curr_month = @curr_month

	SET @curr_desc = STUFF(@curr_desc,1,1,'')

	SELECT @curr_desc
END
GO


CREATE OR ALTER FUNCTION fn_GetCurrArray
(
	@curr_month VARCHAR(20)
)
RETURNS VARCHAR(200) --RETURNS 是函數返回值的數據類型
AS
BEGIN
	DECLARE @curr_desc VARCHAR(200) = ''

	SELECT @curr_desc += ',' + curr_id
	FROM sys_currency_log_new
	WHERE curr_month = @curr_month

	SET @curr_desc = STUFF(@curr_desc,1,1,'')

	RETURN @curr_desc --RETURN 是用於返回具體的值/值變量
END
GO


DECLARE @TABLE TABLE 
(
	curr_month VARCHAR(10)
)

INSERT INTO @TABLE (curr_month)
SELECT DISTINCT curr_month 
FROM sys_currency_log_new

SELECT T.curr_month,dbo.fn_GetCurrArray(T.curr_month)
FROM @TABLE T
GO