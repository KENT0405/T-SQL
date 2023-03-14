/*
* 20221013 yaming add viet new market pool
* 20230105 jd add currency 汇率
*/
CREATE OR ALTER PROCEDURE [dbo].[up_qq_thai_reportStockList]
	@BeginDate		DATETIME = '',
	@EndDate		DATETIME = '',
	@MerchantCode	VARCHAR(30) = '-',  --沒用到入參
	@IsAll			BIT = 0,
	@Group			BIT = 0,
	@Market			VARCHAR(10) = '',
	@CurrencyId		VARCHAR(10) = '',
	@BetNumber		VARCHAR(20) = '',
	@DrawId			VARCHAR(20) = '',
	@OrderBy		VARCHAR(50) = '',
	@GameCategory   INT = 0,
	@PageIndex		INT = 1,
	@PageSize		INT = 2,
	@RecordsCount	INT = 0 OUTPUT
AS
BEGIN
	SET NOCOUNT, ARITHABORT ON

	DECLARE
		@SQL			NVARCHAR(MAX) = '',
		@SQL_condition	NVARCHAR(MAX) = ''

	DROP TABLE IF EXISTS #T;
	DROP TABLE IF EXISTS #T1;

	IF(@CurrencyId <> '')
	BEGIN
		SET @SQL_condition += N' AND bt.currency_id = @CurrencyId '
	END

	IF(@IsAll <> 1 AND @MerchantCode <> '-')
	BEGIN
		SET @SQL_condition += N' AND ai.Merchant_Code = @MerchantCode '
	END

	IF(@Market <> '')
	BEGIN
		SET @SQL_condition += N' AND draw.market = @Market '
	END

	IF(@BetNumber <> '')
	BEGIN
		SET @SQL_condition += N' AND btd.bet_number = @BetNumber '
	END

	IF(@DrawId <> '')
	BEGIN
		SET @SQL_condition += N' AND draw.draw_number = @DrawId '
	END

	IF(@GameCategory <> 0)
	BEGIN
		SET @SQL_condition += N' AND draw_market.game_category = @GameCategory '
	END

	IF(@MerchantCode = '-')
	BEGIN
		SET @SQL_condition += N' and ai.Merchant_Code NOT IN (''TEST'', ''QQDEMO'') '
	END

	SET @SQL = N'
	SELECT
		btd.[bet_number],
		bt.currency_id,
		' + CASE WHEN @Group <> 1 THEN N' ai.merchant_code, ' ELSE N' '''' AS merchant_code, ' END + '
		btd.[pool_id] AS BetType,
		SUM(ISNULL(btd.bet_amount,0) * curr_rate_after) AS bet_amount
	INTO #T
	FROM qq_settled_bet_ticket_detail btd WITH(NOLOCK)
	INNER JOIN qq_settled_bet_ticket bt WITH(NOLOCK) ON btd.ticket_id = bt.ticket_id
	INNER JOIN
	(
		SELECT curr_id,curr_rate_after
		FROM sys_currency_log WITH(NOLOCK)
		WHERE curr_month = CONVERT(VARCHAR(7), GETDATE(), 120)
		AND curr_status = 1
	) scl ON scl.curr_id = bt.currency_id
	INNER JOIN acct_info ai WITH(NOLOCK) ON bt.acct_id = ai.acct_id
	INNER JOIN draw WITH(NOLOCK) ON draw.draw_id = bt.draw_id
	INNER JOIN draw_market AS draw_market WITH(NOLOCK) ON draw_market.market = draw.market
	LEFT JOIN merchant_relation m WITH(NOLOCK) ON ai.merchant_code = m.sub_merchant_code
	WHERE btd.bet_at BETWEEN @BeginDate AND @EndDate
	AND btd.is_cancel = 0
	AND m.merchant_code = @MerchantCode
	' + @SQL_condition + '
	GROUP BY
		btd.[bet_number],
		bt.currency_id,
		' + CASE WHEN @Group <> 1 THEN N' ai.merchant_code, ' ELSE '' END + '
		btd.[pool_id]

	INSERT INTO #T
	SELECT
		btd.[bet_number],
		bt.currency_id,
		' + CASE WHEN @Group <> 1 THEN N' ai.merchant_code, ' ELSE N' '''' AS merchant_code, ' END + '
		btd.[pool_id] AS BetType,
		SUM(ISNULL(btd.bet_amount,0) * curr_rate_after) AS bet_amount
	FROM qq_bet_ticket_detail btd WITH(NOLOCK)
	INNER JOIN qq_bet_ticket bt WITH(NOLOCK) ON btd.ticket_id = bt.ticket_id
	INNER JOIN
	(
		SELECT curr_id,curr_rate_after
		FROM sys_currency_log WITH(NOLOCK)
		WHERE curr_month = CONVERT(VARCHAR(7), GETDATE(), 120)
		AND curr_status = 1
	) scl ON scl.curr_id = bt.currency_id
	INNER JOIN acct_info ai WITH(NOLOCK) ON bt.acct_id = ai.acct_id
	INNER JOIN draw WITH(NOLOCK) ON draw.draw_id = bt.draw_id
	INNER JOIN draw_market AS draw_market WITH(NOLOCK) ON draw_market.market = draw.market
	LEFT JOIN merchant_relation m WITH(NOLOCK) ON ai.merchant_code = m.sub_merchant_code
	WHERE btd.bet_at BETWEEN @BeginDate AND @EndDate
	AND btd.is_cancel = 0
	AND draw.status <> ''F''
	AND m.merchant_code = @MerchantCode
	' + @SQL_condition + '
	GROUP BY
		btd.[bet_number],
		bt.currency_id,
		' + CASE WHEN @Group <> 1 THEN N' ai.merchant_code, ' ELSE '' END + '
		btd.[pool_id]

	SELETC *
	INTO #T1
	FROM #T
	PIVOT
	(
		sum(bet_amount)
		FOR BetType IN
		(
			[1ST-A1],[1ST-E2],[1ST-E3],[1ST-A3],[1ST-BSOE],[1ST-FSC],[1ST-REMTH],
			[2ND-E3],[3RD-E3],
			[4TH-A1],[4TH-E2],
			[DOWN-A1],[DOWN-E2],
			[UP-A1],[UP-A3],[UP-E2],[UP-E3]
			,[ROLL-2D],[ROLL-3D],[ROLL-4D],[ROLL-5D],[S3D-H3],[S3D-S],[S3D-H3S],[S2D-H2D],[S2D-LS]
			,[S-TS],[S-OS],[P-P2],[P-P3],[P-P4],[FP-FP4],[FP-FP8],[FP-FP10]
			,[BOTTOM-2D],[BOTTOM-3D],[TOP-2D],[TOP-3D],[TB-2D],[TB-3D],[ROLL7-2D],[ROLL7-3D]
			,[BB-2D],[BB-3D],[BB-4D],[DEPAN-2D],[TENGAH-2D],[BSOE-E1],
			[BSOE-E2],[COLOK-AN4],[COLOK-MA4],
			[COLOK-NA4],[COLOK-AS],[COLOK-KOP],[COLOK-KPL],[COLOK-EKR],[SI-DP],[SI-TG],[SI-BK]
		)
	) pivot_table

	SET @RecordsCount = @@ROWCOUNT

	SELECT *
	FROM #T1
	' + @OrderBy + '
	OFFSET (@PageIndex - 1) * @PageSize ROWS
	FETCH NEXT @PageSize ROWS ONLY;'

	PRINT @SQL

	EXEC sp_executesql @SQL, N'
	@BeginDate		DATETIME,
	@EndDate		DATETIME,
	@CurrencyId		VARCHAR(10),
	@Market			VARCHAR(10),
	@MerchantCode	VARCHAR(30),
	@BetNumber		VARCHAR(20),
	@DrawId			VARCHAR(20),
	@GameCategory	INT,
	@PageIndex		INT,
	@PageSize		INT,
	@RecordsCount	INT OUTPUT',
	@BeginDate,
	@EndDate,
	@CurrencyId,
	@Market,
	@MerchantCode,
	@BetNumber,
	@DrawId,
	@GameCategory,
	@PageIndex,
	@PageSize,
	@RecordsCount OUTPUT

	SET NOCOUNT, ARITHABORT OFF
END
GO