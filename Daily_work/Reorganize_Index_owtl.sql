------------------------------------------------------------
------------------------每日重組index(main)------------------
------------------------------------------------------------

DECLARE @Yesterday			DATE = GETDATE() - 1,
		@PartitionNumber	INT

SET @PartitionNumber = $Partition.[Pfn_datetime_owt](@Yesterday)

--one_wallet_transfer_all
ALTER INDEX [PK_one_wallet_transfer_all] ON dbo.one_wallet_transfer_all REORGANIZE PARTITION = @PartitionNumber WITH ( LOB_COMPACTION = ON );
ALTER INDEX [idx_date_merchant] ON dbo.one_wallet_transfer_all REORGANIZE PARTITION = @PartitionNumber WITH ( LOB_COMPACTION = ON );

UPDATE STATISTICS one_wallet_transfer_all