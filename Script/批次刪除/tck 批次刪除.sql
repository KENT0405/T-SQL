SET NOCOUNT ON;

DROP TABLE IF EXISTS #T;
CREATE TABLE #T 
(
	sn INT IDENTITY(1,1),
	TB_name VARCHAR(50),
	date_type VARCHAR(50)
)
GO

INSERT INTO #T(TB_name,date_type) VALUES('ticket_all','ticket_date')
INSERT INTO #T(TB_name,date_type) VALUES('acct_daily_tran','tran_date')
INSERT INTO #T(TB_name,date_type) VALUES('acct_game_daily_tran','tran_date')
INSERT INTO #T(TB_name,date_type) VALUES('acct_daily_tran_main','tran_date')
INSERT INTO #T(TB_name,date_type) VALUES('acct_game_daily_tran_main','tran_date')
INSERT INTO #T(TB_name,date_type) VALUES('acct_game_monthly_tran','tran_date')
INSERT INTO #T(TB_name,date_type) VALUES('game_daily_jackpot_pools','tran_date')
INSERT INTO #T(TB_name,date_type) VALUES('acct_monthly_tran','tran_date')
INSERT INTO #T(TB_name,date_type) VALUES('game_fish_acct_tran_item','create_date')
INSERT INTO #T(TB_name,date_type) VALUES('merchant_daily_tran_main','tran_date')
INSERT INTO #T(TB_name,date_type) VALUES('acct_denom_daily_tran','tran_date')
INSERT INTO #T(TB_name,date_type) VALUES('merchant_game_daily_tran_main','tran_date')
INSERT INTO #T(TB_name,date_type) VALUES('fish_acct_daily_tran','tran_date')
INSERT INTO #T(TB_name,date_type) VALUES('merchant_game_daily_bet_tran','tran_date')
INSERT INTO #T(TB_name,date_type) VALUES('fish_daily_tran','tran_date')
INSERT INTO #T(TB_name,date_type) VALUES('acct_game_duration_log','create_date')
INSERT INTO #T(TB_name,date_type) VALUES('game_fish_denom_bet_daily_tran','tran_date')
INSERT INTO #T(TB_name,date_type) VALUES('merchant_currency_daily_bet_tran','tran_date')
INSERT INTO #T(TB_name,date_type) VALUES('acct_game_duration_daily_tran','tran_date')
INSERT INTO #T(TB_name,date_type) VALUES('merchant_all_monthly_tran','tran_date')
INSERT INTO #T(TB_name,date_type) VALUES('game_channel_daily_tran_main','tran_date')

DECLARE 
	@SQL		NVARCHAR(MAX) = '',
	@TB_name	VARCHAR(50) = '',
	@date_type	VARCHAR(50) = '',
	@i			INT = 1

WHILE(1=1)
BEGIN
	SELECT 
		@TB_name = TB_name,
		@date_type = date_type
	FROM #T
	WHERE sn = @i 

	IF @@ROWCOUNT = 0
		BREAK;

	SET @SQL ='
	RAISERROR(''' + @TB_name + ''',0,1) WITH NOWAIT;
	WHILE (1=1)
	BEGIN
		DELETE TOP (5000)
		FROM ' + @TB_name + ' WITH (ROWLOCK)
		WHERE ' + @date_type + ' < ''2023-01-01 00:00.000''
		IF @@ROWCOUNT < 5000
		BEGIN BREAK END
	END'
	
	PRINT @SQL
	
	--EXEC sp_executesql @SQL

	SET @i += 1
END

SET NOCOUNT OFF;
