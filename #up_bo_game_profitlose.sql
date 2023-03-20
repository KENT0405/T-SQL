/*
declare @p15 int
set @p15=NULL
exec sp_executesql N'EXEC [dbo].[up_bo_game_profitlose]  @P0, @P1, @P2, @P3, @P4, @P5, @P6, @P7, @P8, @P9, @P10, @P11, @P12 OUT',
N'@P0 datetime2,@P1 datetime2,@P2 varchar(8000),@P3 bit,@P4 bit,@P5 varchar(8000),@P6 varchar(8000),@P7 varchar(8000),@P8 varchar(8000),@P9 varchar(8000),@P10 int,@P11 int,@P12 int OUTPUT',
'2023-03-01 00:00:00','2023-03-19 23:59:59.9970000','-',1,1,'','','','','',1,20,@p15 output
select @p15
GO

declare @p15 int
set @p15=NULL
exec sp_executesql N'EXEC [dbo].[#up_bo_game_profitlose]  @P0, @P1, @P2, @P3, @P4, @P5, @P6, @P7, @P8, @P9, @P10, @P11, @P12 OUT',
N'@P0 datetime2,@P1 datetime2,@P2 varchar(8000),@P3 bit,@P4 bit,@P5 varchar(8000),@P6 varchar(8000),@P7 varchar(8000),@P8 varchar(8000),@P9 varchar(8000),@P10 int,@P11 int,@P12 int OUTPUT',
'2023-03-01 00:00:00','2023-03-19 23:59:59.9970000','-',1,1,'','','','','',1,20,@p15 output
select @p15
*/
-- =============================================
-- Author:		<kent/luna>
-- Create date: <2022-12-13>
-- Description:	<up_bo_game_profitlose_include_downline>
-- =============================================
-- exec up_bo_game_profitlose_include_downline '2020-10-10 00:00:00','2020-10-20 23:59:59','-',1,0,'SM','Web','PTS','S-LY01'

CREATE OR ALTER PROCEDURE [dbo].[#up_bo_game_profitlose]
	@BeginDate		DATETIME = '',
	@EndDate		DATETIME = '',
	@MerchantCode	VARCHAR(10) = '',
	@IsAll			BIT = 0,
	@SumGroup		BIT = 0,
	@GameCategory	VARCHAR(2) = '',
	@Channel		VARCHAR(10) = '',
	@Currency		VARCHAR(10) = '',
	@GameCode		VARCHAR(10) = '',
	@Provider		VARCHAR(10) = '',
	@PageIndex		INT = 1,
	@PageSize		INT = 10,
	@RecordsCount	INT = 0 OUTPUT
AS
BEGIN
	SET NOCOUNT ,ARITHABORT ON;

	DROP TABLE IF EXISTS #acct_game;
	DROP TABLE IF EXISTS #merchant_relation;

	CREATE TABLE #merchant_relation
	(
		merchant_code		VARCHAR(50),
		sub_merchant_code	VARCHAR(50)
	)

	IF (@IsAll = 1)
	BEGIN
		INSERT INTO #merchant_relation(merchant_code,sub_merchant_code)
		SELECT
			merchant_code,
			sub_merchant_code
		FROM dbo.merchant_relation mr WITH (NOLOCK)
		WHERE mr.Merchant_Code = @MerchantCode
	END
	ELSE
	BEGIN
		INSERT INTO #merchant_relation(merchant_code,sub_merchant_code)
		SELECT '', @MerchantCode
	END

	SELECT
		CASE WHEN @IsAll = 1 THEN
			CASE WHEN @SumGroup = 1
			THEN mr.Merchant_Code
			ELSE mdr.Merchant_Code END
		ELSE mdr.Merchant_Code END  AS merchant_code,
		mdr.curr_id					AS curr_id,
		mdr.game_category			AS game_category,
		mdr.game_code				AS game_code,
		SUM(mdr.bet_count)			AS bet_count,
		SUM(mdr.ttl_bet)			AS ttl_bet,
		SUM(mdr.success_bet)		AS success_bet,
		SUM(mdr.wl_amt)				AS wl_amt,
		COUNT(DISTINCT mdr.acct_id) AS total_player,
		SUM(mdr.jp_contribute_amt)	AS jp_contribute_amt,
		SUM(mdr.jp_win)				AS jp_win,
		provider
	INTO #acct_game
	FROM acct_game_daily_tran AS mdr WITH (NOLOCK)
	INNER JOIN #merchant_relation mr
	ON mdr.merchant_code = mr.sub_merchant_code
	WHERE mdr.tran_date BETWEEN @BeginDate AND @EndDate
	AND (mdr.game_code = @GameCode OR @GameCode = '')
	AND (mdr.channel = @Channel OR @Channel = '')
	AND (mdr.curr_id = @Currency OR @Currency = '')
	AND (mdr.provider = @Provider OR @Provider = '')
	AND (mdr.game_category = @GameCategory OR @GameCategory = '')
	GROUP BY
		CASE WHEN @IsAll = 1 THEN
			CASE WHEN @SumGroup = 1
			THEN  mr.Merchant_Code
			ELSE  mdr.Merchant_Code  END
		ELSE mdr.Merchant_Code END,
		mdr.curr_id,
		mdr.game_category,
		mdr.game_code,
		provider

	SELECT @RecordsCount = @@ROWCOUNT

	SELECT *
	FROM #acct_game
	ORDER BY success_bet DESC
	OFFSET (@PageIndex - 1) * @PageSize ROWS
	FETCH NEXT @PageSize ROWS ONLY

	SET NOCOUNT ,ARITHABORT OFF;
END
