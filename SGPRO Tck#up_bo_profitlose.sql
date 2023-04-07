/*
exec sp_executesql N'EXEC [dbo].[#up_bo_profitlose]  @P0, @P1, @P2, @P3, @P4, @P5, @P6 ',
N'@P0 datetime2,@P1 datetime2,@P2 varchar(8000),@P3 bit,@P4 varchar(8000),@P5 varchar(8000),@P6 varchar(8000)',
'2023-03-01 00:00:00','2023-03-17 23:59:59.9970000','-',1,'','',''
*/
-- =============================================
-- Author:		<sl.chen,Tony>
-- Create date: <2018-04-02>
-- Update date: <2020-07-29>
-- Description:	<merchant winlose>
--
-- =============================================
--exec [up_bo_profitlose] '2022-03-01 00:00','2022-03-30 00:00'
CREATE OR ALTER PROCEDURE [dbo].[#up_bo_profitlose]
	@BeginDate		DATETIME = '',
	@EndDate		DATETIME = '',
	@MerchantCode	VARCHAR(15) = '-',  -- Merchantcode : - for all
	@IsAll			BIT = 0,
	@Channel		VARCHAR(10) = '',
	@Currency		VARCHAR(5) = '',
	@Provider		VARCHAR(10) = ''
AS
BEGIN
	SET NOCOUNT, ARITHABORT ON;

	DROP TABLE IF EXISTS #bonus, #tempGroup;

	CREATE TABLE #merchant
	(
		merchant_code VARCHAR(15)
	)

	IF (@MerchantCode <> '-' )
	BEGIN
		IF(@IsAll = 1)
		BEGIN
			INSERT INTO #merchant
			SELECT sub_merchant_code AS merchant_code
			FROM merchant_relation WITH (NOLOCK)
			WHERE Merchant_Code = @MerchantCode
		END
		ELSE
		BEGIN
			INSERT INTO #merchant SELECT @MerchantCode
		END
	END

	;WITH CTE
	AS
	(
		SELECT
			Merchant_Code,
			currency,
			promotion_id,
			ISNULL(draw_amt,0) draw_amt
		FROM [dbo].[promotion_daily_tran] WITH (NOLOCK)
		WHERE tran_date BETWEEN @BeginDate AND @EndDate
		AND (currency = @Currency OR @Currency = '')
		AND ([provider] = @Provider OR @Provider = '')
		AND ((merchant_code = @MerchantCode OR (@MerchantCode = '-' AND @IsAll = 1)) OR @MerchantCode = '-')
	)
	SELECT
		t1.Merchant_Code,
		currency,
		SUM(draw_amt) AS draw_amt,
		SUM(draw_amt * (ISNULL(t2.bonus_percent,0)/100.0)) AS bonus_amt
	INTO #bonus
	FROM CTE AS t1
	LEFT JOIN lucky_bonus_bear_setting AS t2 WITH (NOLOCK)
	ON t1.promotion_id = t2.promotion_id
	AND t1.merchant_code = t2.merchant_code
	GROUP BY
		t1.Merchant_Code,
		t1.currency

	;WITH CTE2
	AS
	(
		SELECT
			Merchant_Code,
			currency,
			bet_count,
			ttl_bet,
			success_bet,
			jp_contribute_amt,
			wl_amt,
			jp_win,
			ISNULL(draw_amt,0) draw_amt,
			tran_date
		FROM [dbo].[merchant_daily_tran] WITH (NOLOCK)
		WHERE tran_date BETWEEN @BeginDate AND @EndDate
		AND (currency = @Currency OR @Currency = '')
		AND ([provider] = @Provider OR @Provider = '')
		AND ((merchant_code = @MerchantCode OR (@MerchantCode = '-' AND @IsAll = 1)) OR @MerchantCode = '-')
	)
	SELECT
		adt.Merchant_Code AS MerchantCode,
		adt.currency AS CurrencyId,
		SUM(bet_count) AS BetCount,
		SUM(ttl_bet) AS BetAmount,
		SUM(success_bet) AS ValidBetAmount,
		SUM(jp_contribute_amt) AS JPContributeAmt,
		SUM(wl_amt) AS TotalWL,
		SUM(ttl_bet * real_curr_rate_after) AS MainBetAmount,
		SUM(success_bet * real_curr_rate_after) AS MainValidBetAmount,
		SUM(jp_contribute_amt * real_curr_rate_after) AS MainJPContributeAmt,
		SUM(wl_amt * real_curr_rate_after) AS MainTotalWL ,
		SUM(jp_win) AS JpAmt ,
		SUM(jp_win * real_curr_rate_after) AS MainJpAmt,
		MAX(real_curr_rate_after) AS real_curr_rate_after
	INTO #tempGroup
	FROM CTE2 adt
	INNER JOIN sys_currency_log AS scl WITH (NOLOCK)
	ON scl.curr_id = adt.currency
	AND scl.curr_status = 1
	AND scl.curr_month = CONVERT(VARCHAR(7),adt.tran_date,120)
	AND adt.tran_date >= curr_mth_start
	AND adt.tran_date < curr_mth_end
	AND ((EXISTS(SELECT 1 FROM #merchant c WHERE c.merchant_code = adt.merchant_code)) OR @MerchantCode = '-')
	GROUP BY
		adt.Merchant_Code,
		adt.currency

	SELECT
		MerchantCode,
		CurrencyId,
		BetCount,
		BetAmount,
		ValidBetAmount,
		JPContributeAmt,
		TotalWL,
		ISNULL(bbl.draw_amt,0) AS BonusAmt,
		ISNULL(bbl.bonus_amt,0) AS BonusBearAmt,
		MainBetAmount,
		MainValidBetAmount,
		MainJPContributeAmt,
		MainTotalWL,
		ISNULL(bbl.draw_amt,0) * real_curr_rate_after AS MainBonusAmt,
		ISNULL(bbl.bonus_amt,0) * real_curr_rate_after AS MainBonusBearAmt,
		JpAmt,
		MainJpAmt,
		JPContributeAmt+TotalWL - ISNULL(bbl.bonus_amt,0) AS JpTotalWL,
		(JPContributeAmt+TotalWL - ISNULL(bbl.bonus_amt,0)) * real_curr_rate_after AS MainJpTotalWL
	FROM #tempGroup AS adt
	LEFT JOIN #bonus AS bbl WITH (NOLOCK)
	ON bbl.merchant_code = adt.MerchantCode
	AND bbl.currency = adt.CurrencyId
	ORDER BY
		adt.MerchantCode,
		adt.CurrencyId

 	SET NOCOUNT, ARITHABORT OFF;
END
