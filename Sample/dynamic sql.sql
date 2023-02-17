DECLARE
	 @curr_id VARCHAR(10) = 'IDR'
	,@curr_month VARCHAR(20) = '2022-05'

SELECT *
FROM [dbo].sys_currency_log WITH (NOLOCK)
WHERE id > 10
	AND (curr_id = @curr_id OR @curr_id = '')
	AND (curr_month = @curr_month OR @curr_month = '')
GO

----------------------------------------------------------------------------

DECLARE
	 @curr_id VARCHAR(10) = 'IDR'
	,@curr_month VARCHAR(20) = '2022-05'
	,@SQL NVARCHAR(MAX)
	,@SQL_condition NVARCHAR(MAX) = ''

IF @curr_id <> ''
	SET @SQL_condition += ' AND curr_id = @curr_id'

IF @curr_month <> ''
	SET @SQL_condition += ' AND curr_month = @curr_month'

SET @SQL = N'
	SELECT *
	FROM [sg_egame_ticket].[dbo].sys_currency_log WITH (NOLOCK)
	WHERE id > 10' + @SQL_condition

--PRINT @SQL

EXEC sp_executesql @SQL,
	N'
	@curr_id VARCHAR(10),
	@curr_month VARCHAR(20)
	',
	@curr_id,
	@curr_month