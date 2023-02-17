SET NOCOUNT ON;

DROP TABLE IF EXISTS #T;
CREATE TABLE #T 
(
	sn INT IDENTITY(1,1),
	TB_name VARCHAR(50),
	date_type VARCHAR(50)
)
GO

INSERT INTO #T(TB_name,date_type) VALUES('one_wallet_transfer_all','operate_time')
INSERT INTO #T(TB_name,date_type) VALUES('game_fish_game_log','create_time')
INSERT INTO #T(TB_name,date_type) VALUES('acct_credit_transfer','operate_time')
INSERT INTO #T(TB_name,date_type) VALUES('acct_credit_local_transfer','operate_time')
INSERT INTO #T(TB_name,date_type) VALUES('acct_game_behavior_key_daily_log','create_date')
INSERT INTO #T(TB_name,date_type) VALUES('one_wallet_transfer','operate_time')
INSERT INTO #T(TB_name,date_type) VALUES('game_slot_machine_game_log','created_date')

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