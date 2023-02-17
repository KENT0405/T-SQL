--Pk+cluser:
USE [ticket_data_hbs]
GO
ALTER TABLE [dbo].[TB_ProviderTicketHBS_20220401] ADD  CONSTRAINT [PK_TB_ProviderTicketHBS_TicketId_20220401] PRIMARY KEY CLUSTERED 
(
	[ticket_id] ASC,
	[balance_date] ASC
)WITH (SORT_IN_TEMPDB = ON) ON [ticket_data_hbs_202204]
GO


--Pk+noncluser:
USE [ticket_data_hbs]
GO
ALTER TABLE [dbo].[TB_ProviderTicketHBS_20220401] ADD  CONSTRAINT [PK_TB_ProviderTicketHBS_TicketId_20220401] PRIMARY KEY NONCLUSTERED 
(
	[ticket_id] ASC,
	[balance_date] ASC
)WITH (SORT_IN_TEMPDB = ON) ON [ticket_data_hbs_202204]
GO

--not pk+cluster:
USE [ticket_data_hbs]
GO
CREATE (UNIQUE) CLUSTERED INDEX [IX_ProviderTicketHBS_BalanceDate7_20220401] ON [dbo].[TB_ProviderTicketHBS_20220401]
(
	[balance_date] ASC,
	[currency] ASC,
	[merchant_id] ASC,
	[member_id] ASC,
	[promote_id] ASC,
	[is_cancel] ASC,
	[is_finish] ASC
)WITH (SORT_IN_TEMPDB = ON) ON [ticket_data_hbs_202204]
GO


--not pk+noncluster:
USE [ticket_data_hbs]
GO
CREATE (UNIQUE) NONCLUSTERED INDEX [IX_ProviderTicketHBS_BalanceDate7_20220805] ON [dbo].[TB_ProviderTicketHBS_20220805]
(
	[merchant_id] ASC,
	[member_id] ASC,
	[currency] ASC,
	[promote_id] ASC,
	[is_cancel] ASC,
	[is_finish] ASC
)INCLUDE([ticket_id],[ticket_time],[login_id],[product_id],[category_id],[game_code],[bet_type],[bet_amt],[wl_amt],[valid_bet],[jackpot_amt],[ticket_status]) WITH (SORT_IN_TEMPDB = ON) ON [ticket_data_hbs_202208]
GO

