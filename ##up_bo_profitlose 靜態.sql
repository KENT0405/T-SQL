-- =================================================================================
-- Author:		<zhen.fang>
-- Create date: <2019-09-19>
-- Description:	<merchant winlose>
--
-- ==================================================================================
--exec [up_bo_profitlose] '2021-12-01 00:00:00','2021-12-01 23:59:00','','-',1
CREATE OR ALTER PROCEDURE [dbo].[##up_bo_profitlose]
	@BeginDate		DATETIME = '',
	@EndDate		DATETIME = '',
	@ServerCode		VARCHAR(10) = '',
	@MerchantCode	VARCHAR(MAX) = '',  -- MerchantCode : - for all
	@IsAll			BIT = 0,
	@Channel		VARCHAR(10) = '',
	@Currency		VARCHAR(5) = '',
	@Marketing		VARCHAR(100) = '',
	@MarketingPre	VARCHAR(100) = '',
	@PageIndex		INT = 1,
	@PageSize		INT = 20,
	@RecordsCount	INT = 0 OUTPUT
AS
BEGIN
	SET NOCOUNT, ARITHABORT ON;

	DROP TABLE IF EXISTS #temp, #page, #temp_merchant, #temp_sub;

	CREATE TABLE #temp_merchant
	(
		sub_merchant_code VARCHAR(100),
		server_code VARCHAR(100),
		marketing VARCHAR(200),
		upline VARCHAR(150),
		marketing_history VARCHAR(1000)
	)

	IF(@MarketingPre <> '')
	BEGIN
		SET @MarketingPre = N'%' + @MarketingPre + '%'
	END

	IF(@MerchantCode = '-')
	BEGIN
		INSERT INTO #temp_merchant EXEC ##up_bo_merchant_marketing
	END

	IF(@IsAll = 1 AND @MerchantCode <> '-')
	BEGIN
		INSERT INTO #temp_merchant EXEC ##up_bo_merchant_marketing @ServerCode,@MerchantCode
	END

	IF(@IsAll <> 1 AND @MerchantCode <> '' AND @MerchantCode <> '-')
	BEGIN
		INSERT INTO #temp_merchant EXEC ##up_bo_merchant_marketing @ServerCode
	END

	SELECT DISTINCT
		sub_merchant_code,
		upline,
		marketing,
		server_code,
		marketing_history
	INTO #temp_sub
	FROM #temp_merchant
	WHERE (sub_merchant_code IN (SELECT * FROM FN_StrToTable (REPLACE(REPLACE(@MerchantCode,'[',''),']',''))) OR (@MerchantCode = '') OR @IsAll = 1)

	SELECT
		mdt.server_code,
		Merchant_Code,
		marketing,
		marketing_history,
		upline,
		currency,
		bet_count,
		ttl_bet,
		success_bet,
		jp_contribute_amt,
		wl_amt,
		jp_win,
		real_curr_rate_after,
		bonus_percent,
		ISNULL(draw_amt,0) draw_amt,
		tran_date
	INTO #temp
	FROM central_merchant_daily_tran AS mdt WITH (NOLOCK)
	INNER JOIN #temp_sub AS q
	ON q.sub_merchant_code = mdt.merchant_code
	AND q.server_code = mdt.server_code
	INNER JOIN sys_currency_log AS scl WITH (NOLOCK)
	ON scl.curr_id = mdt.currency
	AND scl.curr_status = 1
	AND scl.curr_month = CONVERT(VARCHAR(7),mdt.tran_date,120)
	AND mdt.tran_date >=  curr_mth_start
	AND mdt.tran_date < curr_mth_end
	WHERE tran_date BETWEEN @BeginDate AND @EndDate
	AND (currency = @Currency OR @Currency = '')
	AND (marketing = @Marketing OR @Marketing = '')
	AND (marketing_history LIKE @MarketingPre OR @MarketingPre = '')

	SELECT
		server_code AS ServerCode,
		Merchant_Code AS MerchantCode,
		upline AS Upline,
		marketing AS Marketing,
		marketing_history AS MarketingHistory,
		currency AS CurrencyId,
		SUM(bet_count) AS BetCount,
		SUM(ttl_bet) AS BetAmount,
		SUM(success_bet) AS ValidBetAmount,
		SUM(jp_contribute_amt) AS JPContributeAmt,
		SUM(wl_amt) AS TotalWL,
		SUM(draw_amt) AS BonusAmt,
		SUM(draw_amt * (ISNULL(bonus_percent,0)/100.0)) AS BonusBearAmt,
		SUM(ttl_bet * real_curr_rate_after) AS MainBetAmount,
		SUM(success_bet * real_curr_rate_after) AS MainValidBetAmount,
		SUM(jp_contribute_amt * real_curr_rate_after) AS MainJPContributeAmt,
		SUM(wl_amt * real_curr_rate_after) AS MainTotalWL,
		SUM(draw_amt * real_curr_rate_after) AS MainBonusAmt,
		SUM(draw_amt * real_curr_rate_after * (ISNULL(bonus_percent,0)/100.0)) AS MainBonusBearAmt,
		SUM(jp_win) AS JpAmt,
		SUM(jp_win * real_curr_rate_after) AS MainJpAmt,
		SUM(jp_contribute_amt+wl_amt- draw_amt * (ISNULL(bonus_percent,0)/100.0)) AS JpTotalWL,
		SUM((jp_contribute_amt+wl_amt-draw_amt * (ISNULL(bonus_percent,0)/100.0)) * real_curr_rate_after) AS MainJpTotalWL
	INTO #page
	FROM #temp
	GROUP BY
		Merchant_Code,
		upline,
		marketing,
		marketing_history,
		server_code,
		currency

	SET @RecordsCount = @@ROWCOUNT

	SELECT *
	FROM #page
	ORDER BY
		ServerCode,
		MerchantCode,
		CurrencyId
	OFFSET (@PageIndex - 1) * @PageSize ROWS
	FETCH NEXT @PageSize ROWS ONLY;

 	SET NOCOUNT, ARITHABORT OFF;
END



