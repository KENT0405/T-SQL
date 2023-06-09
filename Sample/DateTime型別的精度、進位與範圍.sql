DECLARE @TB_DATETIME TABLE
(
	sn INT,
	val_datetime VARCHAR(23),	--datetime 文字
	val_datetime2 VARCHAR(30),	--datetime2 文字
	real_datetime DATETIME,		--datetime 實際存入時間
	real_datetime2 DATETIME2,	--datetime2 實際存入時間
	val_result VARCHAR(2)
)

DECLARE
	@DATETIME VARCHAR(23),
	@DATETIME2 VARCHAR(30),
	@RES VARCHAR(2),
	@I INT = 1

WHILE (@I <= 999)
BEGIN

	SET @DATETIME = '2023-06-08 00:00:00.' + RIGHT('000' + CAST(@I AS VARCHAR(3)),3)
	SET @DATETIME2 = '2023-06-08 00:00:00.' + RIGHT('000' + CAST(@I AS VARCHAR(3)),3) + '0000'

	SET @RES = IIF(CAST(@DATETIME AS DATETIME) <= CAST(@DATETIME2 AS DATETIME2),'=','<>')

	INSERT INTO @TB_DATETIME
	SELECT
		@I,
		@DATETIME,
		@DATETIME2,
		@DATETIME,
		@DATETIME2,
		@RES

	SET @I += 1
END

SELECT
	sn,
	val_datetime AS [datetime 文字],
	val_datetime2 AS [datetime2 文字],
	real_datetime AS [datetime 實際存入時間],
	val_result AS [datetime <= datetime2],
	real_datetime2 AS [datetime2 實際存入時間]
FROM @TB_DATETIME