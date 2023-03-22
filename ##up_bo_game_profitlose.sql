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

	DECLARE
		@SQL			NVARCHAR(MAX) = '',
		@SQL_condition	NVARCHAR(MAX) = ''

	DROP TABLE IF EXISTS #temp;
	DROP TABLE IF EXISTS #temp_main;

	IF(@MerchantCode = '-' AND @IsAll = 1 AND @SumGroup = 0)
	BEGIN
		SET @MerchantCode = ''
		SET @IsAll = 0
	END

	IF (@IsAll = 1)
	BEGIN
		IF (CHARINDEX(',',@MerchantCode) = 0)
		BEGIN
			SET @SQL += N'
			SELECT DISTINCT sub_merchant_code
			INTO #temp
			FROM merchant_relation WITH(NOLOCK)
			WHERE merchant_Code = @MerchantCode'
		END
		ELSE
		BEGIN
			SET @SQL += N'
			SELECT DISTINCT sub_merchant_code
			INTO #temp
			FROM merchant_relation WITH(NOLOCK)
			WHERE merchant_Code in(select * from FN_StrToTable (REPLACE(REPLACE('''+@MerchantCode+ ''',''['',''''),'']'','''')))'
		END

		IF(@ServerCode <> '')
		BEGIN
			SET @SQL += N' AND server_code = @ServerCode'
		END

		SET @SQL_condition += N' AND merchant_Code IN (SELECT sub_merchant_code FROM #temp)'
	END
	ELSE
	BEGIN
		IF (@MerchantCode <> '')
		BEGIN
			IF (CHARINDEX(',',@MerchantCode) = 0)
			BEGIN
				SET @SQL_condition += N' AND merchant_code = @MerchantCode '
			END
			ELSE
			BEGIN
				SET @SQL_condition += N' AND merchant_code in(select * from FN_StrToTable (REPLACE(REPLACE('''+@MerchantCode+ ''',''['',''''),'']'',''''))) '
			END
		END
	END

	IF(@ServerCode <> '')
	BEGIN
		SET @SQL_condition += N' AND server_code = @ServerCode'
	END

	IF (@Game <> '')
	BEGIN
		SET @SQL_condition += N' AND mdr.game_code = @Game '
	END

	IF ( @Channel <> '' )
	BEGIN
		SET @SQL_condition += N' AND mdr.channel = @Channel '
	END

	IF ( @Currency <> '' )
	BEGIN
		SET @SQL_condition += N' AND mdr.curr_id = @Currency '
	END

	IF ( @GameCode <> '' )
	BEGIN
		SET @SQL_condition += N' AND mdr.game_category = @GameCode '
	END

	SET @SQL += '
	SELECT *
	INTO #temp_main
	FROM central_acct_game_daily_tran mdr WITH(NOLOCK)
	WHERE mdr.tran_date between @BeginDate and @EndDate
	' + @SQL_condition + '

	SELECT
		' + CASE WHEN @IsAll = 1 AND @SumGroup = 1
		THEN '''-''' ELSE 'mdr.Merchant_Code' END + ' AS MerchantCode
		,mdr.server_code AS ServerCode
		,mdr.curr_id AS CurrencyId
		,mdr.game_category AS GameCode
		,mdr.game_code AS BetType
		,SUM(mdr.bet_count) AS TotalBetNum
		,SUM(mdr.ttl_bet) AS TotalBetAmount
		,SUM(mdr.success_bet) AS TotalValidBet
		,SUM(mdr.wl_amt) AS TotalWL
		,COUNT(distinct mdr.login_id + ''@'' + merchant_code) AS TotalPlayer
		,SUM(mdr.jp_contribute_amt) AS JPContributeAmt
		,SUM(mdr.jp_win) AS JpWin
		,SUM(mdr.success_bet * real_curr_rate_after) AS MainValidBetAmount
		,SUM(mdr.jp_contribute_amt * real_curr_rate_after) AS MainJPContributeAmt
		,SUM(mdr.wl_amt * real_curr_rate_after) AS MainTotalWL
		,mdr.server_code
	FROM #temp_main as mdr WITH (NOLOCK)
	INNER JOIN sys_currency_log AS scl WITH(NOLOCK)
	ON scl.curr_id = mdr.curr_id
	AND scl.curr_status = 1
	AND scl.curr_month = CONVERT(VARCHAR(7),mdr.tran_date,120)
	AND mdr.tran_date >= curr_mth_start
	AND mdr.tran_date < curr_mth_end
	GROUP BY
	' + CASE WHEN @IsAll = 1 AND @SumGroup = 1 THEN '' ELSE 'mdr.Merchant_Code,' END + '
		mdr.curr_id,
		mdr.game_category,
		mdr.game_code,
		mdr.server_code
	ORDER BY
		ServerCode ASC,
	' + CASE @Type
		WHEN 1 THEN ' TotalValidBet DESC'
		WHEN 2 THEN ' TotalBetNum DESC'
		WHEN 3 THEN ' TotalPlayer DESC' END + '
	OFFSET (@PageIndex - 1) * @PageSize ROWS
	FETCH NEXT @PageSize ROWS ONLY;

	SELECT @RecordsCount = COUNT( 1 )
	FROM
	(
		SELECT ' + CASE WHEN @IsAll = 1 AND @SumGroup = 1
		THEN '''-''' ELSE 'mdr.Merchant_Code' END + ' AS MerchantCode
		FROM #temp_main
		GROUP BY
			' + CASE WHEN @IsAll = 1 AND @SumGroup = 1 THEN '' ELSE 'Merchant_Code,' END + '
			curr_id,
			game_category,
			game_code,
			server_code
	) q;

	SELECT
		COUNT(DISTINCT mdr.login_id + ''@'' + merchant_code) AS TotalPlayer,
		SUM(mdr.bet_count) AS TotalBetNum,
		SUM(mdr.success_bet * real_curr_rate_after) AS MainValidBetAmount,
		SUM(mdr.jp_contribute_amt * real_curr_rate_after) AS MainJPContributeAmt,
		SUM(mdr.wl_amt * real_curr_rate_after) AS MainTotalWL
	FROM #temp_main mdr WITH(NOLOCK)
	INNER JOIN sys_currency_log AS scl WITH(NOLOCK)
	ON scl.curr_id = mdr.curr_id
	AND scl.curr_status = 1
	AND scl.curr_month = CONVERT(VARCHAR(7),mdr.tran_date,120)
	AND mdr.tran_date >=  curr_mth_start
	AND mdr.tran_date < curr_mth_end'

	PRINT @SQL

    EXEC sp_executesql @SQL,N'
	@BeginDate		DATETIME,
	@EndDate		DATETIME,
	@MerchantCode	VARCHAR(20),
	@Currency		VARCHAR(20),
	@Channel		VARCHAR(10),
	@GameCode		VARCHAR(10),
	@game			VARCHAR(10),
	@PageIndex		INT,
	@PageSize		INT,
	@ServerCode		VARCHAR(10),
	@RecordsCount	INT OUTPUT',
	@BeginDate,
	@EndDate,
	@MerchantCode,
	@Currency,
	@Channel,
	@GameCode,
	@Game,
	@PageIndex,
	@PageSize,
	@ServerCode,
	@RecordsCount OUTPUT;

	SET NOCOUNT, ARITHABORT OFF;
END

