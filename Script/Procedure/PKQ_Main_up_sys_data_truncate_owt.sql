CREATE OR ALTER PROCEDURE [dbo].[up_sys_data_truncate_owt]
AS
BEGIN
	SET NOCOUNT ,ARITHABORT ON;

	DECLARE @log_date DATE
	--當天早上6點執行，取得昨天的時間
	SET @log_date =  DATEADD(DAY, -1, GETDATE())

	DECLARE
		@partition_num			INT,
		@save_date				DATETIME,
		@end_date				DATETIME,
		@rowback_records_count	INT = 0,
		@i						INT = 1

	DROP TABLE IF EXISTS #swt_copyfail;

	SET @partition_num = $PARTITION.Pfn_today_owt(@log_date)

	BEGIN TRY

		ALTER TABLE dbo.single_wallet_transfer SWITCH PARTITION @partition_num TO dbo.single_wallet_transfer_switch PARTITION @partition_num

		SELECT
			IDENTITY(INT,1,1) AS Num,
			save_start_date,
			save_end_date
		INTO #swt_copyfail
		FROM dbo.sys_data_copy_log WITH (NOLOCK)
		WHERE log_date = @log_date --昨天日期
		AND table_name = 'single_wallet_transfer'
		AND [status] < 0

		WHILE(1 = 1)
		BEGIN
			SELECT
				@save_date = save_start_date,
				@end_date  = save_end_date
			FROM #swt_copyfail
			WHERE Num = @i

			IF @@ROWCOUNT = 0
				BREAK;

			INSERT INTO dbo.single_wallet_transfer_copyfail
			SELECT *
			FROM dbo.single_wallet_transfer_switch WITH (NOLOCK)
			WHERE save_date >= @save_date
			AND   save_date <  @end_date
			SET @i += 1
		END

		INSERT INTO dbo.single_wallet_transfer
		SELECT *
		FROM dbo.single_wallet_transfer_switch WITH (NOLOCK) --小
		WHERE [status] <= 0

		SET @rowback_records_count = @@ROWCOUNT

		--清掉昨天的資料
		TRUNCATE TABLE dbo.single_wallet_transfer_switch WITH (PARTITIONS (@partition_num))

		IF (@rowback_records_count = 0)
		BEGIN
			UPDATE dbo.sys_data_copy_log
			SET delete_date = GETDATE(),
				del_records_count = copy_records_count,
				[status] = 2 --刪除過程成功
			WHERE log_date = @log_date
			AND table_name = 'single_wallet_transfer'
			AND [status] = 1
		END
		ELSE
		BEGIN
			UPDATE L
			SET delete_date = GETDATE(),
				del_records_count = D.del_records_count,
				[status] = CASE
								WHEN L.copy_records_count = D.del_records_count
								THEN 2  -- 複製筆數與刪除筆數一致
								ELSE 3  -- 複製筆數與刪除筆數不一致
						   END
			FROM dbo.sys_data_copy_log AS L
			CROSS APPLY
			(
				SELECT COUNT(*) AS del_records_count
				FROM dbo.single_wallet_transfer_switch AS T WITH (NOLOCK)
				WHERE T.save_date >= L.save_start_date
				  AND T.save_date <  L.save_end_date
				  AND T.[status] > 0
			) AS D
			WHERE L.log_date = @log_date
			AND L.table_name = 'single_wallet_transfer'
			AND L.[status] = 1
		END

	END TRY
	BEGIN CATCH

		--更新日志
		UPDATE dbo.sys_data_copy_log
		SET delete_date = GETDATE(),
			[status] = -2 --刪除過程失敗
		WHERE log_date = @log_date
		AND table_name = 'single_wallet_transfer'
		AND [status] = 1

		--寫入error_log
		EXEC dbo.up_sys_error_log

		PRINT ERROR_MESSAGE()

	END CATCH

	SET NOCOUNT ,ARITHABORT OFF;
END
GO