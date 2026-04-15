USE [idc_repl]
GO
/****** Object:  StoredProcedure [dbo].[sp_MSupd_dbomem_tran]    Script Date: 4/15/2026 10:06:30 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[sp_MSupd_dbomem_tran]
		@c1 bigint = NULL,
		@c2 varchar(30) = NULL,
		@c3 nvarchar(10) = NULL,
		@c4 datetime = NULL,
		@c5 varchar(10) = NULL,
		@c6 nvarchar(100) = NULL,
		@c7 numeric(18,2) = NULL,
		@c8 char(1) = NULL,
		@c9 datetime = NULL,
		@c10 varchar(20) = NULL,
		@c11 varchar(10) = NULL,
		@c12 varchar(10) = NULL,
		@c13 datetime = NULL,
		@c14 nvarchar(100) = NULL,
		@c15 varchar(20) = NULL,
		@c16 numeric(18,6) = NULL,
		@c17 numeric(18,6) = NULL,
		@c18 numeric(18,6) = NULL,
		@c19 varchar(30) = NULL,
		@c20 datetime = NULL,
		@c21 varchar(30) = NULL,
		@c22 nvarchar(100) = NULL,
		@c23 varchar(10) = NULL,
		@c24 numeric(18,6) = NULL,
		@c25 varchar(30) = NULL,
		@c26 bigint = NULL,
		@c27 bit = NULL,
		@c28 nvarchar(100) = NULL,
		@c29 nvarchar(100) = NULL,
		@c30 nvarchar(100) = NULL,
		@c31 varchar(30) = NULL,
		@c32 varchar(10) = NULL,
		@c33 varchar(100) = NULL,
		@c34 varchar(30) = NULL,
		@c35 tinyint = NULL,
		@pkc1 bigint = NULL,
		@pkc2 datetime = NULL,
		@bitmap binary(5)
as
begin

		IF (@c13 IS NOT NULL OR @c9 IS NOT NULL)
	BEGIN
		-- Insert realtime date
		IF(@c9 IS NOT NULL AND DATEDIFF(DAY, @c9, GETDATE()) <= 30)
			BEGIN
				INSERT INTO mem_tran_log
				(
					tran_date, -- change to datetime
					job_type, -- 0 = realtime, 1 = history
					job_status -- 0 = pending, 1 = in-progress
				)
				SELECT
					CASE
						WHEN (approval_date IS NOT NULL)
							--AND DATEADD(MINUTE, 5*(DATEDIFF(MINUTE, 0, @c9)/5), 0) <> DATEADD(MINUTE, 5*(DATEDIFF(MINUTE, 0, approval_date)/5), 0)
							AND DATEDIFF(MINUTE, approval_date, @c9) > 60
							THEN DATEADD(MINUTE, 5*(DATEDIFF(MINUTE, 0, approval_date)/5), 0)
						ELSE
							'1900-01-01'
					END,
					0,
					0
				FROM dbo.mem_tran WITH (NOLOCK)
				WHERE tran_no = @pkc1
				EXCEPT
				SELECT
					tran_date,
					job_type,
					job_status
				FROM dbo.mem_tran_log WITH (NOLOCK)
			END

		-- Insert history date
		INSERT INTO mem_tran_log
		(
			tran_date, -- change to datetime
			job_type, -- 0 = realtime, 1 = history
			job_status -- 0 = pending, 1 = in-progress
		)
		SELECT
			CASE
				WHEN booking_date IS NOT NULL THEN CAST(booking_date AS DATE)
				WHEN (@c13 IS NULL AND booking_date IS NULL) AND (approval_date IS NOT NULL) THEN CAST(approval_date AS DATE)
				ELSE '1900-01-01'
			END,
			1,
			0
		FROM dbo.mem_tran WITH (NOLOCK)
		WHERE tran_no = @pkc1
		-- New Booking Date
		UNION
		SELECT
			CAST(@c13 AS DATE),
			1,
			0
		WHERE @c13 IS NOT NULL
		EXCEPT
		SELECT
			tran_date,
			job_type,
			job_status
		FROM dbo.mem_tran_log WITH (NOLOCK)

	END

	declare @primarykey_text nvarchar(100) = ''
if (substring(@bitmap,1,1) & 8 = 8)
begin
update [dbo].[mem_tran] set
		[mem_id] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [mem_id] end,
		[curr_id] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [curr_id] end,
		[create_date] = case substring(@bitmap,1,1) & 8 when 8 then @c4 else [create_date] end,
		[tran_type] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [tran_type] end,
		[bank_id] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [bank_id] end,
		[amt] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [amt] end,
		[status] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [status] end,
		[approval_date] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [approval_date] end,
		[method_id] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [method_id] end,
		[merchant_id] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [merchant_id] end,
		[group_id] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [group_id] end,
		[booking_date] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [booking_date] end,
		[booking_bank_id] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [booking_bank_id] end,
		[pay_type] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [pay_type] end,
		[fee] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [fee] end,
		[rate_of_fee] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [rate_of_fee] end,
		[one_time_of_fee] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [one_time_of_fee] end,
		[verified_by] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [verified_by] end,
		[verified_time] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [verified_time] end,
		[mem_app_bank_id] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [mem_app_bank_id] end,
		[method_name] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [method_name] end,
		[mem_app_network] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [mem_app_network] end,
		[rate_of_currency] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [rate_of_currency] end,
		[cryptocurrency] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [cryptocurrency] end,
		[mem_wdlimit_id] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [mem_wdlimit_id] end,
		[is_free_tran] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [is_free_tran] end,
		[mem_bank_id] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [mem_bank_id] end,
		[mem_bank_acct_no] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [mem_bank_acct_no] end,
		[mem_bank_acct_name] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [mem_bank_acct_name] end,
		[mem_crypto] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [mem_crypto] end,
		[mem_crypto_network] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [mem_crypto_network] end,
		[mem_crypto_wallet_address] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [mem_crypto_wallet_address] end,
		[mem_phone_number] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [mem_phone_number] end,
		[order_tag] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [order_tag] end
		where [tran_no] = @pkc1
	  and [create_date] = @pkc2
end
else
begin

	update [dbo].[mem_tran] set
		[mem_id] = case substring(@bitmap,1,1) & 2 when 2 then @c2 else [mem_id] end,
		[curr_id] = case substring(@bitmap,1,1) & 4 when 4 then @c3 else [curr_id] end,
		[tran_type] = case substring(@bitmap,1,1) & 16 when 16 then @c5 else [tran_type] end,
		[bank_id] = case substring(@bitmap,1,1) & 32 when 32 then @c6 else [bank_id] end,
		[amt] = case substring(@bitmap,1,1) & 64 when 64 then @c7 else [amt] end,
		[status] = case substring(@bitmap,1,1) & 128 when 128 then @c8 else [status] end,
		[approval_date] = case substring(@bitmap,2,1) & 1 when 1 then @c9 else [approval_date] end,
		[method_id] = case substring(@bitmap,2,1) & 2 when 2 then @c10 else [method_id] end,
		[merchant_id] = case substring(@bitmap,2,1) & 4 when 4 then @c11 else [merchant_id] end,
		[group_id] = case substring(@bitmap,2,1) & 8 when 8 then @c12 else [group_id] end,
		[booking_date] = case substring(@bitmap,2,1) & 16 when 16 then @c13 else [booking_date] end,
		[booking_bank_id] = case substring(@bitmap,2,1) & 32 when 32 then @c14 else [booking_bank_id] end,
		[pay_type] = case substring(@bitmap,2,1) & 64 when 64 then @c15 else [pay_type] end,
		[fee] = case substring(@bitmap,2,1) & 128 when 128 then @c16 else [fee] end,
		[rate_of_fee] = case substring(@bitmap,3,1) & 1 when 1 then @c17 else [rate_of_fee] end,
		[one_time_of_fee] = case substring(@bitmap,3,1) & 2 when 2 then @c18 else [one_time_of_fee] end,
		[verified_by] = case substring(@bitmap,3,1) & 4 when 4 then @c19 else [verified_by] end,
		[verified_time] = case substring(@bitmap,3,1) & 8 when 8 then @c20 else [verified_time] end,
		[mem_app_bank_id] = case substring(@bitmap,3,1) & 16 when 16 then @c21 else [mem_app_bank_id] end,
		[method_name] = case substring(@bitmap,3,1) & 32 when 32 then @c22 else [method_name] end,
		[mem_app_network] = case substring(@bitmap,3,1) & 64 when 64 then @c23 else [mem_app_network] end,
		[rate_of_currency] = case substring(@bitmap,3,1) & 128 when 128 then @c24 else [rate_of_currency] end,
		[cryptocurrency] = case substring(@bitmap,4,1) & 1 when 1 then @c25 else [cryptocurrency] end,
		[mem_wdlimit_id] = case substring(@bitmap,4,1) & 2 when 2 then @c26 else [mem_wdlimit_id] end,
		[is_free_tran] = case substring(@bitmap,4,1) & 4 when 4 then @c27 else [is_free_tran] end,
		[mem_bank_id] = case substring(@bitmap,4,1) & 8 when 8 then @c28 else [mem_bank_id] end,
		[mem_bank_acct_no] = case substring(@bitmap,4,1) & 16 when 16 then @c29 else [mem_bank_acct_no] end,
		[mem_bank_acct_name] = case substring(@bitmap,4,1) & 32 when 32 then @c30 else [mem_bank_acct_name] end,
		[mem_crypto] = case substring(@bitmap,4,1) & 64 when 64 then @c31 else [mem_crypto] end,
		[mem_crypto_network] = case substring(@bitmap,4,1) & 128 when 128 then @c32 else [mem_crypto_network] end,
		[mem_crypto_wallet_address] = case substring(@bitmap,5,1) & 1 when 1 then @c33 else [mem_crypto_wallet_address] end,
		[mem_phone_number] = case substring(@bitmap,5,1) & 2 when 2 then @c34 else [mem_phone_number] end,
		[order_tag] = case substring(@bitmap,5,1) & 4 when 4 then @c35 else [order_tag] end
	where [tran_no] = @pkc1
  and [create_date] = @pkc2
end
end
