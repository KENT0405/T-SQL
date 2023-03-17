/*
declare @p16 int
set @p16=83254
exec sp_executesql N'EXEC [dbo].[#up_bo_game_profitlose]  @P0, @P1, @P2, @P3, @P4, @P5, @P6, @P7, @P8, @P9, @P10, @P11, @P12 ,@P13 OUT',
N'@P0 datetime2,@P1 datetime2,@P2 nvarchar(4000),@P3 nvarchar(4000),@P4 bit,@P5 bit,@P6 nvarchar(4000),@P7 nvarchar(4000),@P8 nvarchar(4000),@P9 nvarchar(4000),@P10 int,@P11 int,@P12 int,@P13 int OUTPUT',
'2023-03-06 00:00:00','2023-03-12 23:59:59.9970000',N'',N'-',1,0,N'',N'',N'',N'',1,1,20,@p16 output
select @p16
GO
*/
-- =====================================================================================
-- Author:		<zhen.fang>
-- Create date: <2019-09-19>
-- Description:	<backoffice game profitlose>
-- =====================================================================================
-- exec up_bo_game_profitlose '2021-12-01 00:00:00','2021-12-30 23:59:00','BBIN','-',1,1,'','','','',1,5
CREATE OR ALTER PROCEDURE [dbo].[#up_bo_game_profitlose]
	@BeginDate		DATETIME = '',
	@EndDate		DATETIME = '',
	@ServerCode		VARCHAR(10) = '',
	@MerchantCode	VARCHAR(MAX) = '',  -- MerchantCode : - for all split(TEST,SKY777)
	@IsAll			BIT = 0,
	@SumGroup		BIT = 0,
	@GameCode		VARCHAR(2) = '',
	@Channel		VARCHAR(10) = '',
	@Currency		VARCHAR(10) = '',
	@Game			VARCHAR(10) = '',
	@Type			INT = 1,  --1=ORDER BY Bet Amt,2= ORDER BY BETS,3=ORDER BY ACTICE PLAYER
	@PageIndex		INT = 1,
	@PageSize		INT = 10,
	@RecordsCount	INT = 0 OUTPUT
AS
BEGIN
	SET NOCOUNT, ARITHABORT ON;

	DECLARE
		@SQL			NVARCHAR(MAX) = '',
		@SQL_CODE		NVARCHAR(100) = '',
		@SQL_MR			NVARCHAR(MAX) = '',
		@SQL_condition	NVARCHAR(MAX) = '',
		@SQL_TABLE		NVARCHAR(100) = '',
		@TableName		NVARCHAR(100) = ''

	DROP TABLE IF EXISTS #temp;
	DROP TABLE IF EXISTS #temp_main;

	SET @SQL_TABLE = N' mdr.Merchant_Code ';
	SET @SQL_CODE = N' mdr.Merchant_Code,';

	IF(@MerchantCode = '-' AND @IsAll = 1 AND @SumGroup = 0)
	BEGIN
		SET @MerchantCode = '';
		SET @IsAll = 0;
	END

	SELECT @TableName = dbo.FN_GetTableNameByServerCode(@ServerCode,'game');
	DECLARE @CharCount INT;
	SET @CharCount =  CHARINDEX(',',@MerchantCode)

	IF( @ServerCode <> '' )
	BEGIN
		SET @SQL_condition += N'AND server_code = @ServerCode'
	END

	IF (@IsAll = 1 )
	BEGIN
		IF (@CharCount = 0)
		BEGIN
			SET @SQL_MR +=N'
			SELECT DISTINCT sub_merchant_code
			INTO #temp
			FROM merchant_relation WITH(NOLOCK)
			WHERE merchant_Code = @MerchantCode'
		END
		ELSE
		BEGIN
			SET @SQL_MR +=N'
			SELECT DISTINCT sub_merchant_code
			INTO #temp
			FROM merchant_relation WITH(NOLOCK)
			WHERE merchant_Code in(select * from FN_StrToTable (REPLACE(REPLACE('''+@MerchantCode+ ''',''['',''''),'']'','''')))'
		END

		IF( @ServerCode <> '' )
		BEGIN
			SET @SQL_MR += N'AND server_code = @ServerCode'
		END

		SET @SQL_condition += N'AND merchant_Code IN (SELECT sub_merchant_code FROM #temp)'

		IF (@SumGroup = 1 )
		BEGIN
			SET @SQL_TABLE = N' ''-'' ';
			SET @SQL_CODE = ' ';
		END
	END
	ELSE
	BEGIN
		IF ( @MerchantCode<>'')
		BEGIN
			IF (@CharCount = 0)
			BEGIN
				SET @SQL_condition +=N' AND merchant_code = @MerchantCode '
			END
			ELSE
			BEGIN
				SET @SQL_condition +=N' AND merchant_code in(select * from FN_StrToTable (REPLACE(REPLACE('''+@MerchantCode+ ''',''['',''''),'']'',''''))) '
			END
		END
	END

	IF ( @Game <> '' )
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

	SET @SQL =
	@SQL_MR + '
	SELECT * INTO #temp_main
	FROM central_acct_game_daily_tran mdr WITH(NOLOCK)
	WHERE mdr.tran_date between @BeginDate and @EndDate'
	+ @SQL_condition  + '

	SELECT
		'+ @SQL_TABLE + 'as MerchantCode,
		mdr.server_code as ServerCode,
		mdr.curr_id as CurrencyId,
		mdr.game_category as GameCode,
		mdr.game_code as BetType,
		SUM(mdr.bet_count) as TotalBetNum,
		SUM(mdr.ttl_bet) as TotalBetAmount,
		SUM(mdr.success_bet) as TotalValidBet ,
		SUM(mdr.wl_amt) as TotalWL,
		COUNT(distinct mdr.login_id +''@''+merchant_code) as TotalPlayer,
		SUM(mdr.jp_contribute_amt) as JPContributeAmt,
		SUM(mdr.jp_win) as JpWin,
		SUM(mdr.success_bet * real_curr_rate_after) AS MainValidBetAmount,
		SUM(mdr.jp_contribute_amt * real_curr_rate_after) AS MainJPContributeAmt,
		SUM(mdr.wl_amt * real_curr_rate_after) AS MainTotalWL,
		mdr.server_code
	FROM #temp_main as mdr WITH (NOLOCK)
	INNER JOIN sys_currency_log AS scl WITH(NOLOCK)
	ON scl.curr_id = mdr.curr_id
	AND scl.curr_status = 1
	AND scl.curr_month = CONVERT(varchar(7),mdr.tran_date,120)
	AND mdr.tran_date >= curr_mth_start
	AND mdr.tran_date < curr_mth_end
	GROUP BY ' + @SQL_CODE + ' mdr.curr_id,mdr.game_category, mdr.game_code, mdr.server_code
	ORDER BY ServerCode ASC,'
	+ CASE @Type
		WHEN 1 THEN ' TotalValidBet DESC'
		WHEN 2 THEN ' TotalBetNum DESC'
		WHEN 3 THEN ' TotalPlayer DESC' END + '
	OFFSET (@PageIndex - 1) * @PageSize ROWS
	FETCH NEXT @PageSize ROWS ONLY;

	SELECT @RecordsCount = COUNT( 1 )
	FROM
	(
		SELECT ' + @SQL_TABLE + ' as MerchantCode
		FROM '+@TableName+' as mdr WITH (NOLOCK)
		WHERE mdr.tran_date between @BeginDate and @EndDate'
		+ @SQL_condition +'
		GROUP BY ' + @SQL_CODE + ' mdr.curr_id,mdr.game_category,mdr.game_code,mdr.server_code
	) q;

	SELECT
		COUNT(distinct mdr.login_id +''@''+merchant_code) as TotalPlayer,
		SUM(mdr.bet_count) as TotalBetNum,
		SUM(mdr.success_bet * real_curr_rate_after) AS MainValidBetAmount,
		SUM(mdr.jp_contribute_amt * real_curr_rate_after) AS MainJPContributeAmt,
		SUM(mdr.wl_amt * real_curr_rate_after) AS MainTotalWL
	FROM #temp_main mdr WITH(NOLOCK)
	INNER JOIN sys_currency_log AS scl WITH(NOLOCK)
	ON scl.curr_id = mdr.curr_id
	AND scl.curr_status = 1
	AND scl.curr_month = CONVERT(VARCHAR(7),mdr.tran_date,120)
	AND mdr.tran_date >= curr_mth_start
	AND mdr.tran_date < curr_mth_end
	'

	PRINT @SQL

    EXEC sp_executesql @SQL,N'
	@BeginDate		DATETIME,
	@EndDate		DATETIME,
	@ServerCode		VARCHAR(10),
	@MerchantCode	VARCHAR(20),
	@Currency		VARCHAR(20),
	@Channel		VARCHAR(10),
	@GameCode		VARCHAR(10),
	@game			VARCHAR(10),
	@PageIndex		INT,
	@PageSize		INT,
	@RecordsCount	INT OUTPUT',
	@BeginDate,
	@EndDate,
	@ServerCode,
	@MerchantCode,
	@Currency,
	@Channel,
	@GameCode,
	@game,
	@PageIndex,
	@PageSize,
	@RecordsCount OUTPUT;

	SET NOCOUNT, ARITHABORT OFF;
END


