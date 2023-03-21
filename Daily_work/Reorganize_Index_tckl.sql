------------------------------------------------------------
------------------------每日重組index(ticket)----------------
------------------------------------------------------------

DECLARE @Yesterday			DATE = GETDATE() - 1,
		@PartitionNumber	INT,
		@PartitionNumber_jp INT

SET @PartitionNumber 	= $Partition.[Pfn_datetime_tck](@Yesterday)
SET @PartitionNumber_jp = $Partition.[Pfn_datetime_dlt](@Yesterday)

--ticket_all
ALTER INDEX [PK_ticket_all] ON dbo.ticket_all REORGANIZE PARTITION = @PartitionNumber WITH ( LOB_COMPACTION = ON );
ALTER INDEX [idx_acct_id_ticket] ON dbo.ticket_all REORGANIZE PARTITION = @PartitionNumber WITH ( LOB_COMPACTION = ON );
ALTER INDEX [idx_merchant_date] ON dbo.ticket_all REORGANIZE PARTITION = @PartitionNumber WITH ( LOB_COMPACTION = ON );
ALTER INDEX [idx_save_date] ON dbo.ticket_all REORGANIZE PARTITION = @PartitionNumber WITH ( LOB_COMPACTION = ON );
ALTER INDEX [idx_ticket_date] ON dbo.ticket_all REORGANIZE PARTITION = @PartitionNumber WITH ( LOB_COMPACTION = ON );

--game_daily_jackpot_pools
ALTER INDEX [IDX_game_daily_jackpot_pools] ON dbo.game_daily_jackpot_pools REORGANIZE PARTITION = @PartitionNumber_jp WITH ( LOB_COMPACTION = ON );
ALTER INDEX [PK_game_daily_jackpot_pools] ON dbo.game_daily_jackpot_pools REORGANIZE PARTITION = @PartitionNumber_jp WITH ( LOB_COMPACTION = ON );

UPDATE STATISTICS ticket_all
UPDATE STATISTICS game_daily_jackpot_pools
GO

DECLARE @Yesterday			DATE = GETDATE() - 1,
		@PartitionNumber_jp INT

SET @PartitionNumber_jp = $Partition.[Pfn_datetime_dlt](@Yesterday)

ALTER INDEX [PK_game_daily_jackpot_pools] ON dbo.game_daily_jackpot_pools REORGANIZE PARTITION = @PartitionNumber_jp WITH ( LOB_COMPACTION = ON );

UPDATE STATISTICS game_daily_jackpot_pools
GO