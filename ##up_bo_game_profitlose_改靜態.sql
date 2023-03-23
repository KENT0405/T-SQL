-- =====================================================================================
-- Author:		<zhen.fang>
-- Create date: <2019-09-19>
-- Description:	<backoffice game profitlose>
-- =====================================================================================
-- exec up_bo_game_profitlose '2021-12-01 00:00:00','2021-12-30 23:59:00','BBIN','-',1,1,'','','','',1,5
CREATE OR ALTER PROCEDURE [dbo].[##up_bo_game_profitlose]
	@BeginDate		DATETIME = '',
	@EndDate 		DATETIME = '',
	@ServerCode		VARCHAR(10) = '',
	@MerchantCode	VARCHAR(MAX) = '',  -- MerchantCode : - for all split(TEST,SKY777)
	@IsAll			BIT = 0 ,
	@SumGroup		BIT = 0 ,
	@GameCode		VARCHAR(2) = '',
	@Channel		VARCHAR(10) = '',
	@Currency		VARCHAR(10) = '',
	@Game			VARCHAR(10) = '',
	@Type			INT = 1,--1=ORDER BY Bet Amt,2= ORDER BY BETS,3=ORDER BY ACTICE PLAYER
	@PageIndex		INT = 1,
	@PageSize		INT = 10,
	@RecordsCount	INT = 0 OUTPUT
AS
BEGIN
	SET NOCOUNT, ARITHABORT ON;

	DROP TABLE IF EXISTS #merchant_code;
	DROP TABLE IF EXISTS #temp_page1;
	DROP TABLE IF EXISTS #temp_page2;
	DROP TABLE IF EXISTS #temp_main;

	CREATE TABLE #merchant_code
	(
		merchant_code VARCHAR(50)
	)

	IF(@MerchantCode = '-' AND @IsAll = 1 AND @SumGroup = 0)
	BEGIN
		SET @MerchantCode = ''
		SET @IsAll = 0
	END

	IF (@IsAll = 1)
	BEGIN
		INSERT INTO #merchant_code
		SELECT DISTINCT sub_merchant_code
		FROM merchant_relation WITH(NOLOCK)
		WHERE merchant_Code IN (SELECT * FROM FN_StrToTable (REPLACE(REPLACE(@MerchantCode,'[',''),']','')))
		AND (server_code = @ServerCode OR @ServerCode = '')
	END
	ELSE
	BEGIN
		IF (@MerchantCode <> '')
		BEGIN
			INSERT INTO #merchant_code
			SELECT * FROM FN_StrToTable ((REPLACE(REPLACE(@MerchantCode,'[',''),']','')))
		END
	END

	SELECT
		mdr.*,
		scl.real_curr_rate_after
	INTO #temp_main
	FROM central_acct_game_daily_tran mdr WITH(NOLOCK)
	INNER JOIN sys_currency_log AS scl WITH(NOLOCK)
	ON scl.curr_id = mdr.curr_id
	AND scl.curr_status = 1
	AND scl.curr_month = CONVERT(VARCHAR(7),mdr.tran_date,120)
	AND mdr.tran_date >= curr_mth_start
	AND mdr.tran_date < curr_mth_end
	WHERE mdr.tran_date BETWEEN @BeginDate AND @EndDate
	AND (server_code = @ServerCode OR @ServerCode = '')
	AND (mdr.game_code = @Game OR @Game = '')
	AND (mdr.channel = @Channel OR @Channel = '')
	AND (mdr.curr_id = @Currency OR @Currency = '')
	AND (mdr.game_category = @GameCode OR @GameCode = '')
	AND (merchant_Code IN (SELECT * FROM #merchant_code) OR @Merchant_Code = '')

	IF(@IsAll = 1 AND @SumGroup = 1)
	BEGIN
		SELECT
			 '-' AS MerchantCode
			,server_code AS ServerCode
			,curr_id AS CurrencyId
			,game_category AS GameCode
			,game_code AS BetType
			,SUM(bet_count) AS TotalBetNum
			,SUM(ttl_bet) AS TotalBetAmount
			,SUM(success_bet) AS TotalValidBet
			,SUM(wl_amt) AS TotalWL
			,COUNT(DISTINCT login_id + '@' + merchant_code) AS TotalPlayer
			,SUM(jp_contribute_amt) AS JPContributeAmt
			,SUM(jp_win) AS JpWin
			,SUM(success_bet * real_curr_rate_after) AS MainValidBetAmount
			,SUM(jp_contribute_amt * real_curr_rate_after) AS MainJPContributeAmt
			,SUM(wl_amt * real_curr_rate_after) AS MainTotalWL
			,server_code
		INTO #temp_page1
		FROM #temp_main
		GROUP BY
			curr_id,
			game_category,
			game_code,
			server_code

		SET @RecordsCount = @@ROWCOUNT

		SELECT *
		FROM #temp_page1
		ORDER BY
			ServerCode ASC,
			CASE @Type
			WHEN 1 THEN TotalValidBet
			WHEN 2 THEN TotalBetNum
			WHEN 3 THEN TotalPlayer END DESC
		OFFSET (@PageIndex - 1) * @PageSize ROWS
		FETCH NEXT @PageSize ROWS ONLY;
	END
	ELSE
	BEGIN
		SELECT
			 Merchant_Code AS MerchantCode
			,server_code AS ServerCode
			,curr_id AS CurrencyId
			,game_category AS GameCode
			,game_code AS BetType
			,SUM(bet_count) AS TotalBetNum
			,SUM(ttl_bet) AS TotalBetAmount
			,SUM(success_bet) AS TotalValidBet
			,SUM(wl_amt) AS TotalWL
			,COUNT(DISTINCT login_id + '@' + merchant_code) AS TotalPlayer
			,SUM(jp_contribute_amt) AS JPContributeAmt
			,SUM(jp_win) AS JpWin
			,SUM(success_bet * real_curr_rate_after) AS MainValidBetAmount
			,SUM(jp_contribute_amt * real_curr_rate_after) AS MainJPContributeAmt
			,SUM(wl_amt * real_curr_rate_after) AS MainTotalWL
			,server_code
		INTO #temp_page2
		FROM #temp_main
		GROUP BY
			Merchant_Code,
			curr_id,
			game_category,
			game_code,
			server_code

		SET @RecordsCount = @@ROWCOUNT

		SELECT *
		FROM #temp_page2
		ORDER BY
			ServerCode ASC,
			CASE @Type
			WHEN 1 THEN TotalValidBet
			WHEN 2 THEN TotalBetNum
			WHEN 3 THEN TotalPlayer END DESC
		OFFSET (@PageIndex - 1) * @PageSize ROWS
		FETCH NEXT @PageSize ROWS ONLY;
	END

	SELECT
		COUNT(DISTINCT login_id + '@' + merchant_code) AS TotalPlayer,
		SUM(bet_count) AS TotalBetNum,
		SUM(success_bet * real_curr_rate_after) AS MainValidBetAmount,
		SUM(jp_contribute_amt * real_curr_rate_after) AS MainJPContributeAmt,
		SUM(wl_amt * real_curr_rate_after) AS MainTotalWL
	FROM #temp_main

	SET NOCOUNT, ARITHABORT OFF;
END

