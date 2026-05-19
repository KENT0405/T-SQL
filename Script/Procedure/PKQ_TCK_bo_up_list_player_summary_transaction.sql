/*
declare @p18 int
set @p18=1
exec sp_executesql N'EXEC [#bo_up_list_player_summary_transaction]  @P0 ,  @P1 ,  @P2 ,  @P3 ,  @P4 ,  @P5 ,  @P6 ,  @P7 ,  @P8 ,  @P9 ,  @P10 ,  @P11 ,  @P12 ,  @P13 ,  @P14 ,  @P15  OUT',
N'@P0 varchar(8000),@P1 int,@P2 varchar(8000),@P3 int,@P4 varchar(8000),@P5 nvarchar(4000),@P6 varchar(8000),@P7 varchar(8000),@P8 varchar(8000),@P9 bit,@P10 bit,@P11 datetime,@P12 datetime,@P13 int,@P14 int,@P15 int OUTPUT',
'TNT',1,'TNT',1,'',N'','IDA000P0000000334921','','acct_id ASC',1,0,'2026-02-23 00:00:00','2026-04-21 23:59:59.997',1,50,@p18 output
select @p18
*/
-- =============================================
-- Author:		<DZX>
-- Create date: <2020-05-07>
-- Update date: <2020-08-07>
-- Description:	<PKQ BO 2.5Player Summary>
-- =============================================
-- exec [bo_up_list_player_summary_transaction] 'TNT',1,'ID',2,'','','','','transfer_in DESC,acct_id ASC',1,0,'2025-07-01 00:00:00.000','2025-07-22 23:59:59.995',1,100
CREATE OR ALTER PROCEDURE [dbo].[#bo_up_list_player_summary_transaction]
	@UplineAcctId VARCHAR(80),
	@UplineRoleId INT = 0,
	@ParentAcctId VARCHAR(80), --查询上级acctId
	@ParentRoleId INT = 0, --查询上级roleId
	@LoginId VARCHAR(60),
	@Nickname NVARCHAR(30),
	@AcctId VARCHAR(80),
	@Currency VARCHAR(3),
	@ParameterSort VARCHAR(50),
	@CheckDay BIT = 0,
	@OnlyQueryRecords BIT = 0,
	@BeginDate DATETIME,
	@EndDate DATETIME,
	@PageIndex INT = 1,
	@PageSize INT = 20,
	@RecordsCount INT = 0 OUTPUT
AS
BEGIN
	SET NOCOUNT, ARITHABORT ON;

	DECLARE
		@SQL NVARCHAR(MAX) = '',
		@SQL_condition NVARCHAR(MAX) = '',
		@Sw_BeginDate Datetime = @BeginDate,
		@Sw_EndDate Datetime = @EndDate

	DROP TABLE IF EXISTS #temp_acct, #temp_sw, #temp_result;

	IF(@CheckDay = 1)
	BEGIN
		-- 从按天汇总表中查询
		SET @BeginDate = CAST(@BeginDate AS DATE)
		SET @EndDate = CAST(@EndDate AS DATE)
	END

	IF(@ParentAcctId <> '')
	BEGIN
		SET @SQL_condition += N' AND agent_lv' + CONVERT(varchar(2),@ParentRoleId) + ' = @ParentAcctId '
	END

	IF(@AcctId <> '')
	BEGIN
		SET @SQL_condition += N' AND t.acct_id = @AcctId '
	END

	IF(@Currency <> '')
	BEGIN
		SET @SQL_condition += N' AND t.curr_id = @Currency '
	END

	IF(@LoginId <> '')
	BEGIN
		SET @SQL_condition += N' AND t.login_id = @LoginId '
	END

	IF(@Nickname <> '')
	BEGIN
		SET @SQL_condition += N' AND t.nick_name = @Nickname'
	END

	SET @SQL = N'
	/*
	SELECT
		acct_id,
		wl_amt_total
	INTO #temp_acct
	FROM acct_credit WITH (NOLOCK)
	' + IIF(@OnlyQueryRecords = 1, 'WHERE 1 <> 1','') + '
	*/

	SELECT
		acct_id,
		SUM(CASE tran_type WHEN ''Sw-In'' THEN value_change ELSE 0 END) sw_transfer_in,
		SUM(CASE tran_type WHEN ''Sw-Out'' THEN value_change ELSE 0 END) sw_transfer_out
	INTO #temp_sw
	FROM single_wallet_credit_transfer WITH (NOLOCK)
	WHERE operate_time BETWEEN @Sw_BeginDate AND @Sw_EndDate
	' + IIF(@OnlyQueryRecords = 1, 'AND 1 <> 1','') + '
	AND is_valid = 1
	GROUP BY acct_id

	SELECT
		t.curr_id,
		t.login_id,
		MAX(t.nick_name) AS nick_name,
		t.acct_id,
		t.agent_lv5 AS parent_id,
		SUM(ISNULL(t.wl_amt,0)) AS wl_amt,
		SUM(ISNULL(t.turnover,0)) AS turnover,
		SUM(ISNULL(t.jp_contribute_amt,0)) AS jp_bet,
		SUM(ISNULL(t.jp_win,0)) AS jp_wl_amt,
		SUM(ISNULL(t.in_amt,0)) AS transfer_in,
		SUM(ISNULL(t.in_count,0)) AS in_num,
		SUM(ISNULL(t.out_amt,0)) AS transfer_out,
		SUM(ISNULL(t.out_count,0)) AS out_num
	INTO #temp_result
	FROM acct_daily_tran t WITH (NOLOCK)
	WHERE t.tran_date BETWEEN @BeginDate AND @EndDate
	AND t.agent_lv' + CONVERT(VARCHAR(1),@UplineRoleId) + ' = @UplineAcctId
	' + @SQL_condition + '
	GROUP BY
		t.curr_id,
		t.login_id,
		t.acct_id,
		t.agent_lv5

	SET @RecordsCount = @@ROWCOUNT

	SELECT
		a.*,
		ISNULL(b.wl_amt_total,0) wl_amt_total,
		ISNULL(c.sw_transfer_in,0) sw_transfer_in,
		ISNULL(c.sw_transfer_out,0) sw_transfer_out
	FROM #temp_result AS a
	LEFT JOIN acct_credit AS b ON a.acct_id = b.acct_id
	LEFT JOIN #temp_sw AS c ON a.acct_id = c.acct_id
	' + IIF(@OnlyQueryRecords = 1, 'WHERE 1 <> 1','') + '
	ORDER BY ' + @ParameterSort + '
	OFFSET (@PageIndex - 1) * @PageSize ROWS
	FETCH NEXT @PageSize ROWS ONLY;
	'
    --PRINT @SQL
	EXEC sp_executesql @SQL,N'
	@UplineAcctId VARCHAR(80),
	@ParentAcctId VARCHAR(80),
	@LoginId VARCHAR(60),
	@Nickname NVARCHAR(30),
	@AcctId VARCHAR(80),
	@Currency VARCHAR(3),
	@BeginDate Datetime,
	@EndDate Datetime,
	@Sw_BeginDate Datetime,
	@Sw_EndDate Datetime,
	@PageIndex INT,
	@PageSize INT,
	@RecordsCount INT OUTPUT',
	@UplineAcctId,
	@ParentAcctId,
	@LoginId,
	@Nickname,
	@AcctId,
	@Currency,
	@BeginDate,
	@EndDate,
	@Sw_BeginDate,
	@Sw_EndDate,
	@PageIndex,
	@PageSize,
	@RecordsCount OUTPUT;
	--PRINT @RecordsCount

	SET NOCOUNT, ARITHABORT OFF;
END
GO