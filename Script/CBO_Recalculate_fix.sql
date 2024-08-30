----------------------------------------------------------
--------------- --重撈 ByDate 的資料 ---------------------
----------------------------------------------------------
DECLARE
	@BeginDate DATE = '2024-01-31',
	@EndDate DATE = '2024-01-31',
	@ServerCode VARCHAR(10) = '-',
	@sn INT = 1,
	@_sn INT

DECLARE cur_server CURSOR FOR
SELECT sg_type
FROM sys_central_servername
WHERE sg_type <> 'EUMT'
AND (sg_type = @ServerCode OR @ServerCode = '-')

WHILE @BeginDate <= @EndDate
BEGIN

	OPEN cur_server

	FETCH NEXT FROM cur_server
	INTO @ServerCode

	WHILE @@FETCH_STATUS = 0
	BEGIN

		--選擇要重撈哪幾張表
		EXEC [dbo].[PROC_Get_central_acct_daily_duration]				@ServerCode,@BeginDate

		EXEC [dbo].[PROC_Get_central_acct_daily_tran]					@ServerCode,@BeginDate

		EXEC [dbo].[PROC_Get_central_acct_game_daily_tran]				@ServerCode,@BeginDate

		EXEC [dbo].[PROC_Get_central_acct_game_entrant]					@ServerCode,@BeginDate

		EXEC [dbo].[PROC_Get_central_acct_denom_daily_tran]				@ServerCode,@BeginDate

		EXEC [dbo].[PROC_Get_central_currency_daily_bet_tran]			@ServerCode,@BeginDate

		EXEC [dbo].[PROC_Get_central_device_daily_tran]					@ServerCode,@BeginDate

		EXEC [dbo].[PROC_Get_central_fish_daily_tran]					@ServerCode,@BeginDate

		EXEC [dbo].[PROC_Get_central_fish_acct_daily_tran] 				@ServerCode,@BeginDate

		EXEC [dbo].[PROC_Get_central_game_fish_denom_bet_daily_tran]	@ServerCode,@BeginDate

		EXEC [dbo].[PROC_Get_central_merchant_currency_daily_bet_tran]	@ServerCode,@BeginDate

		EXEC [dbo].[PROC_Get_central_merchant_daily_tran]				@ServerCode,@BeginDate

		EXEC [dbo].[PROC_Get_central_merchant_game_daily_bet_tran]		@ServerCode,@BeginDate

		EXEC [dbo].[PROC_Get_central_merchant_hour_tran_main]			@ServerCode,@BeginDate

		EXEC [dbo].[PROC_Get_central_game_respin_warning_log]			@ServerCode,@BeginDate

		FETCH NEXT FROM cur_server
		INTO @ServerCode
	END

	CLOSE cur_server

	SET @BeginDate = DATEADD(DAY,1,@BeginDate)
END

DEALLOCATE cur_server
GO

----------------------------------------------------------
-----------------重算 ByMonth 的資料 ---------------------
----------------------------------------------------------

EXEC dbo.up_central_monthly_sum_Main_Recalculate 'All','2024-06-01','2024-09-01',1,1,1,1
GO








/*
DECLARE
	@BeginDate DATE = '2023-11-02',
	@d DATE = '2021-11-02'

WHILE @BeginDate <= @d
BEGIN
	EXEC [PROC_Get_central_merchant_daily_tran] 'BBIN',@BeginDate
	EXEC [PROC_Get_central_merchant_daily_tran] 'EUCY',@BeginDate
	EXEC [PROC_Get_central_merchant_daily_tran] 'IBC',@BeginDate
	EXEC [PROC_Get_central_merchant_daily_tran] 'IC',@BeginDate
	EXEC [PROC_Get_central_merchant_daily_tran] 'IM',@BeginDate
	EXEC [PROC_Get_central_merchant_daily_tran] 'LEBO',@BeginDate
	EXEC [PROC_Get_central_merchant_daily_tran] 'PGR',@BeginDate
	EXEC [PROC_Get_central_merchant_daily_tran] 'SG',@BeginDate
	EXEC [PROC_Get_central_merchant_daily_tran] 'SGPRO',@BeginDate
	EXEC [PROC_Get_central_merchant_daily_tran] 'SKY',@BeginDate
	EXEC [PROC_Get_central_merchant_daily_tran] 'SRC',@BeginDate
	SET @BeginDate = DATEADD(DAY,1,@BeginDate)
END;
*/
