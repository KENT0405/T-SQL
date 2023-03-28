-- =============================================
-- Author:		<sl.chen>
-- Create date: <2020-12-10>
-- Description:	<merchant game pool>
-- =============================================
--exec up_bo_game_pool '','','','','','','10',1,95,1,1000
CREATE OR ALTER PROCEDURE [dbo].[##up_bo_game_pool]
	@MerchantCode	VARCHAR(10) = '',
	@CurrId			VARCHAR(10) = '',
	@GameType		VARCHAR(10) = '',
	@GameCode		VARCHAR(10) = '',
	@Volatility		VARCHAR(10) = '',
	@Rtp			INT = 0 ,
	@GameWin		VARCHAR(10) = '',
	@GameLose		VARCHAR(10) = '',
	@Percent		INT = 0,
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

	IF(@CurrId <> '')
	BEGIN
		SET @SQL_condition += ' AND gp.curr_id = @CurrId'
	END

	IF(@MerchantCode <> '')
	BEGIN
		SET @SQL_condition += ' AND gp.merchant_code = @MerchantCode'
	END

	IF(@GameType <> '')
	BEGIN
		SET @SQL_condition +=' AND gp.game_category = @GameType'
	END

	IF(@GameCode <> '')
	BEGIN
		SET @SQL_condition +=' AND gp.game_code = @GameCode'
	END

	IF(@Volatility <> '')
	BEGIN
		SET @SQL_condition +=' AND gp.volatility = @Volatility'
	END

	IF(@Rtp <> 0)
	BEGIN
		SET @SQL_condition +=' AND gp.rtp = @Rtp'
	END

	IF(@GameWin <> '')
	BEGIN
		SET @SQL_condition += ' AND gp.games_win >= CAST(@GameWin AS DECIMAL(18,6))'
	END

	IF(@GameLose <> '')
	BEGIN
		SET @SQL_condition += ' AND gp.games_lose >= CAST(@GameLose AS DECIMAL(18,6))'
	END

	IF(@Percent > 0)
	BEGIN
		SET @SQL_condition +=' AND gls.max_lose_limit < (gp.games_lose - gp.games_win * gp.rtp / (CASE WHEN gp.rtp > 100 THEN 1000 ELSE 100 END)) * 100 / (CASE WHEN gp.game_category = ''AD'' THEN 100 ELSE @Percent END)'
	END

	SET @SQL = '
	SELECT
		gp.*,
		gls.max_lose_limit real_max_lose_limit
	INTO #temp
	FROM game_pool gp WITH (NOLOCK)
	LEFT JOIN game_limit_setting gls WITH (NOLOCK)
	ON gp.game_code = gls.game_code
	AND gp.curr_id = gls.curr_id
	WHERE 1 = 1
	' + @SQL_condition + '

	SET @RecordsCount = @@ROWCOUNT

	SELECT *
	FROM #temp
	ORDER BY
		merchant_code,
		curr_id,
		game_code,
		volatility,
		rtp
	OFFSET (@PageIndex - 1) * @PageSize ROWS
	FETCH NEXT @PageSize ROWS ONLY'

	--PRINT @SQL

	EXEC sp_executesql @SQL,N'
	@MerchantCode	VARCHAR(10),
	@CurrId			VARCHAR(10),
	@GameType		VARCHAR(10),
	@GameCode		VARCHAR(10),
	@Volatility		VARCHAR(10),
	@Rtp			INT = 0,
	@GameWin		VARCHAR(10),
	@GameLose		VARCHAR(10),
	@Percent		INT = 0,
	@PageIndex		INT,
	@PageSize		INT,
	@RecordsCount	INT OUTPUT',
	@MerchantCode,
	@CurrId,
	@GameType,
	@GameCode,
	@Volatility,
	@Rtp,
	@GameWin,
	@GameLose,
	@Percent,
	@PageIndex,
	@PageSize,
	@RecordsCount OUTPUT;

	SET NOCOUNT, ARITHABORT OFF;
END