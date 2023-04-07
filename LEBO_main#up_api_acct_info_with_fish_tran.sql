/*
declare @p7 int
set @p7=2035
exec sp_executesql N'EXEC [dbo].[up_api_acct_info_with_fish_tran] @P0, @P1, @P2, @P3, @P4 OUT ',N'@P0 varchar(8000),@P1 varchar(8000),@P2 int,@P3 int,@P4 int OUTPUT','','TTVIP',1,500,@p7 output
select @p7
GO

declare @p7 int
set @p7=2035
exec sp_executesql N'EXEC [dbo].[#up_api_acct_info_with_fish_tran] @P0, @P1, @P2, @P3, @P4 OUT ',
N'@P0 varchar(8000),@P1 varchar(8000),@P2 int,@P3 int,@P4 int OUTPUT',
'','TTVIP',1,500,@p7 output
select @p7
*/

CREATE OR ALTER PROCEDURE [dbo].[#up_api_acct_info_with_fish_tran]
	@AcctId			VARCHAR(60) = '',
	@Merchant		VARCHAR(10) = '',
	@PageIndex		INT = 1,
	@PageSize		INT = 10,
	@RecordsCount	INT = 0 OUTPUT
AS
BEGIN
	SET NOCOUNT, ARITHABORT ON;

	DROP TABLE IF EXISTS #temp;

	SELECT
		ar.acct_id,
		login_id AS acct_login_id,
		ISNULL(acct_name, '''') AS acct_name,
		ISNULL(ai.curr_id, '''') AS curr_id,
		bal_amt AS balance
	INTO #temp
	FROM acct_credit ar WITH (NOLOCK)
	INNER JOIN acct_info ai WITH (NOLOCK)
	ON ar.acct_id = ai.acct_id
	WHERE ai.merchant_code = @Merchant
	AND (ai.acct_id = @AcctId OR @AcctId = '')

	SET @RecordsCount = @@ROWCOUNT

	;WITH Q
	AS
	(
		SELECT
			acct_id,
			server_name
		FROM game_fish_acct_tran WITH(NOLOCK)
		WHERE [status] = 0
		AND merchant_code = @Merchant
		AND (acct_id = @AcctId OR @AcctId = '')
	)
	SELECT
		*,
		server_name
	FROM #temp ar
	LEFT JOIN Q
	ON ar.acct_id = Q.acct_id
	ORDER BY ar.acct_id DESC
	OFFSET (@PageIndex - 1) * @PageSize ROWS
	FETCH NEXT @PageSize ROWS ONLY;

	SET NOCOUNT, ARITHABORT OFF;
END
