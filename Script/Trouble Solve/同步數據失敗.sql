前提 : 7/19，FS拆庫(分成main、ticket)

Question(7/24) :  CBO(FS) 这个同步数据的，任务是不是从19号开始就失败了？

Solve :

    1.同步數據(Sync)是JOB在做的，先查看JOB有無問題  / Ans : 無

    2.查看JOB裡每一個Step的procedure執行語法，確認到源頭，是View所提供的資料 / Ans : 尋找view

    3.確認View是否能夠執行成功 / Ans : 否

    4.確認Linked Server是否連接成功 / Ans : 是

    5.修正View的語法(因先前換機器沒有一起更換到View裡面Linked Server的語法) / Ans : 更改語法

    6.重建View，因為Schema有可能不同所以需重建 / Ans : Drop And Create View

    7.執行同步數據procedure
        [dbo].[PROC_sync_daily_tran_ByDate] 'FS','2023-07-19'
        [dbo].[PROC_sync_daily_tran_ByDate] 'FS','2023-07-20'
        [dbo].[PROC_sync_daily_tran_ByDate] 'FS','2023-07-21'
        [dbo].[PROC_sync_daily_tran_ByDate] 'FS','2023-07-22'
        [dbo].[PROC_sync_daily_tran_ByDate] 'FS','2023-07-23'
        ，修正到問題發生前一天

    8.執行
        [dbo].[up_central_monthly_sum_Main_Recalculate] 'ALL','2023-07-01','2023-07-01',1,1,1,1
        進行重算




/***************************************************參數解釋******************************************************/

    up_central_monthly_sum_Main_Recalculate

    @server_code		VARCHAR(5) = 'ALL', --預設
	@BeginDate			DATE,       --要改動的日期起始點
	@EndDate			DATE,       --要改動的日期結束點
	@iscal_acct			BIT = 1,    -- 1 : 砍掉重灌
	@iscal_acct_game	BIT = 1,    -- 1 : 砍掉重灌
	@iscal_merchant		BIT = 1,    -- 1 : 砍掉重灌
	@iscal_device		BIT = 1     -- 1 : 砍掉重灌

    Example: 若要全部重算兩個月
         EXEC [up_central_monthly_sum_Main_Recalculate] 'ALL','2023-07-01','2023-08-01',1,1,1,1

/*****************************************************************************************************************/