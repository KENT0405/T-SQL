/*
exec sp_executesql N'EXEC [dbo].[up_cbo_report_fast_spin_performance]  @P0, @P1, @P2, @P3, @P4, @P5',
N'@P0 datetime,@P1 datetime,@P2 varchar(8000),@P3 varchar(8000),@P4 varchar(8000),@P5 int',
'2023-10-01 00:00:00','2023-10-31 23:59:59.997','','','',1
GO
exec sp_executesql N'EXEC [dbo].[#up_cbo_report_fast_spin_performance]  @P0, @P1, @P2, @P3, @P4, @P5',
N'@P0 datetime,@P1 datetime,@P2 varchar(8000),@P3 varchar(8000),@P4 varchar(8000),@P5 int',
'2023-10-01 00:00:00','2023-10-31 23:59:59.997','','','',1
*/
-- =================================================================================
-- Author:		<wq.huang>
-- Create date: <2021-12-02>
-- Description:	<7.1 Player behavior acct list>
--
-- ==================================================================================
-- exec [up_cbo_report_fast_spin_performance] '2022-12-01 00:00:00','2023-2-28 23:59:00','','MYR,CNY,PTS','S-FO01',3
CREATE OR ALTER PROCEDURE [dbo].[#up_cbo_report_fast_spin_performance]
	@BeginDate DATETIME = '',
	@EndDate DATETIME = '',
	@ServerCode VARCHAR(10) = '',
	@CurrId VARCHAR(100) = '',
	@GameCode VARCHAR(MAX) = '',
	@Type INT = 1 --1=Group
AS
BEGIN
	SET NOCOUNT, ARITHABORT ON;

	DROP TABLE IF EXISTS #temp_currency, #temp_games;

	SELECT str2table currId INTO #temp_currency FROM FN_StrToTable(@CurrId)
	SELECT str2table gameCode INTO #temp_games FROM FN_StrToTable(@GameCode)

	;WITH tempBet
	AS
	(
		SELECT
			tran_date,
			CASE WHEN @Type = 2 THEN server_code WHEN @Type = 3 THEN curr_id ELSE '-' END AS by_type,
			COUNT(DISTINCT acct_id) AS total_player
		FROM acct_bet_monthly_tran WITH (NOLOCK)
		WHERE tran_date BETWEEN @BeginDate AND @EndDate
		AND game_category = 'SM'
		AND (server_code = @ServerCode OR @ServerCode = '')
		AND (curr_id IN (SELECT currId FROM #temp_currency) OR @CurrId = '')
		AND (game_code IN (SELECT gameCode FROM #temp_games) OR @GameCode = '')
		GROUP BY
			tran_date,
			CASE WHEN @Type = 2 THEN server_code WHEN @Type = 3 THEN curr_id ELSE '-' END
	), tempBi
	AS
	(
		SELECT
			tran_date,
			CASE WHEN @Type = 2 THEN server_code WHEN @Type = 3 THEN curr_id ELSE '-' END AS by_type,
			COUNT(DISTINCT acct_id) AS reels_player
		FROM acct_bi_monthly_tran WITH (NOLOCK)
		WHERE tran_date BETWEEN @BeginDate AND @EndDate
		AND master_code = 'game_super_fast_spin'
		AND game_category = 'SM'
		AND (server_code = @ServerCode OR @ServerCode = '')
		AND (curr_id IN (SELECT currId FROM #temp_currency) OR @CurrId = '')
		AND (game_code IN (SELECT gameCode FROM #temp_games) OR @GameCode = '')
		GROUP BY
			tran_date,
			CASE WHEN @Type = 2 THEN server_code WHEN @Type = 3 THEN curr_id ELSE '-' END
	)
	SELECT
		CONVERT(VARCHAR(7), t1.tran_date, 120) AS tran_date,
		t1.by_type,
		SUM(t1.total_player) AS total_player,
		ISNULL(SUM(t2.reels_player),0) AS reels_player
	FROM tempBet t1 LEFT JOIN tempBi t2
	ON t1.tran_date = t2.tran_date
	AND t1.by_type = t2.by_type
	GROUP BY
		CONVERT(VARCHAR(7), t1.tran_date, 120),
		t1.by_type
	ORDER BY CONVERT(VARCHAR(7), t1.tran_date, 120)
	--OPTION(RECOMPILE)

 	SET NOCOUNT ,ARITHABORT OFF;
END