USE [fs_egame_data]
GO
/****** Object:  Table [dbo].[acct_adjustment]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[acct_adjustment](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[acct_id] [varchar](80) NULL,
	[login_id] [varchar](60) NULL,
	[merchant_code] [varchar](10) NULL,
	[create_id] [varchar](60) NULL,
	[create_date] [datetime] NULL,
	[currency] [varchar](3) NOT NULL,
	[value_before] [decimal](20, 4) NOT NULL,
	[value_change] [decimal](20, 4) NOT NULL,
	[value_after] [decimal](20, 4) NULL,
	[status] [char](1) NULL,
	[approve_id] [varchar](30) NULL,
	[approve_time] [datetime] NULL,
	[note] [nvarchar](400) NULL,
	[remark] [nvarchar](400) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[acct_balance_warning_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[acct_balance_warning_log](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[acct_id] [varchar](80) NULL,
	[game_code] [varchar](10) NULL,
	[game_category] [varchar](10) NULL,
	[merchant_code] [varchar](10) NULL,
	[login_id] [varchar](70) NULL,
	[curr_id] [varchar](10) NULL,
	[ticket_balance] [decimal](18, 6) NULL,
	[current_balance] [decimal](18, 6) NULL,
	[diff_amt] [decimal](18, 6) NULL,
	[ticket_id] [bigint] NULL,
	[transfer_id] [varchar](36) NULL,
	[reference_id] [varchar](36) NULL,
	[create_date] [datetime] NULL,
 CONSTRAINT [PK_acct_balance_warning_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[acct_behavior_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[acct_behavior_log](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[merchant_code] [varchar](20) NULL,
	[acct_id] [varchar](80) NULL,
	[login_id] [varchar](60) NULL,
	[game_code] [varchar](10) NULL,
	[key_] [varchar](36) NULL,
	[value_] [varchar](100) NULL,
	[create_date] [datetime] NULL,
 CONSTRAINT [PK_acct_behavior_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[acct_credit]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[acct_credit](
	[acct_id] [varchar](80) NOT NULL,
	[curr_id] [varchar](3) NOT NULL,
	[bal_amt] [decimal](20, 4) NOT NULL,
	[frozen_amt] [decimal](20, 4) NULL,
	[pending_amt] [decimal](20, 4) NULL,
	[bonus_amt] [decimal](20, 4) NULL,
 CONSTRAINT [PK_acct_credit] PRIMARY KEY CLUSTERED 
(
	[acct_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[acct_credit_archive]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[acct_credit_archive](
	[acct_id] [varchar](80) NOT NULL,
	[curr_id] [varchar](3) NOT NULL,
	[bal_amt] [decimal](20, 4) NOT NULL,
	[frozen_amt] [decimal](20, 4) NULL,
	[pending_amt] [decimal](20, 4) NULL,
	[bonus_amt] [decimal](20, 4) NULL,
 CONSTRAINT [PK_acct_credit_archive] PRIMARY KEY CLUSTERED 
(
	[acct_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[acct_credit_local_transfer]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[acct_credit_local_transfer](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[acct_id] [varchar](70) NULL,
	[login_id] [varchar](50) NULL,
	[merchant_code] [varchar](30) NULL,
	[tran_type] [varchar](10) NOT NULL,
	[currency] [varchar](3) NOT NULL,
	[value_before] [decimal](20, 6) NOT NULL,
	[value_change] [decimal](20, 6) NOT NULL,
	[value_after] [decimal](20, 6) NOT NULL,
	[operate_time] [datetime] NOT NULL,
	[remark] [nvarchar](200) NULL,
	[is_valid] [bit] NULL,
	[transfer_no] [varchar](50) NULL,
	[transfer_id] [varchar](50) NULL,
	[value_warning] [decimal](20, 6) NULL,
 CONSTRAINT [PK_acct_credit_local_transfer] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[acct_credit_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[acct_credit_log](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[acct_id] [varchar](80) NULL,
	[login_id] [varchar](60) NULL,
	[merchant_code] [varchar](10) NULL,
	[tran_type] [varchar](10) NOT NULL,
	[operate_id] [varchar](60) NULL,
	[currency] [varchar](3) NOT NULL,
	[value_before] [decimal](20, 6) NOT NULL,
	[value_change] [decimal](20, 6) NOT NULL,
	[value_after] [decimal](20, 6) NOT NULL,
	[operate_time] [datetime] NOT NULL,
	[remark] [nvarchar](400) NULL,
	[fingerprint] [varchar](256) NULL,
	[is_valid] [bit] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[acct_credit_reset_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[acct_credit_reset_log](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[acct_id] [varchar](100) NULL,
	[curr_id] [varchar](10) NULL,
	[merchant_code] [varchar](10) NULL,
	[reset_amt] [numeric](18, 6) NULL,
	[create_date] [datetime] NULL,
 CONSTRAINT [PK_acct_credit_reset_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[acct_credit_transfer]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[acct_credit_transfer](
	[id] [bigint] NOT NULL,
	[acct_id] [varchar](70) NULL,
	[login_id] [varchar](50) NULL,
	[merchant_code] [varchar](30) NULL,
	[tran_type] [varchar](10) NOT NULL,
	[currency] [varchar](3) NOT NULL,
	[value_before] [decimal](20, 6) NOT NULL,
	[value_change] [decimal](20, 6) NOT NULL,
	[value_after] [decimal](20, 6) NOT NULL,
	[operate_time] [datetime] NOT NULL,
	[remark] [nvarchar](400) NULL,
	[is_valid] [bit] NULL,
	[transfer_no] [varchar](50) NULL,
 CONSTRAINT [PK__acct_credit_transfer] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[acct_game_behavior_key_daily_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[acct_game_behavior_key_daily_log](
	[acct_id] [varchar](80) NOT NULL,
	[game_code] [varchar](10) NOT NULL,
	[key_] [varchar](36) NOT NULL,
	[tran_date] [datetime] NOT NULL,
	[behavior_count] [int] NULL,
	[merchant_code] [varchar](10) NULL,
	[login_id] [varchar](70) NULL,
	[create_date] [datetime] NULL,
 CONSTRAINT [PK_acct_game_behavior_key_daily_log] PRIMARY KEY CLUSTERED 
(
	[acct_id] ASC,
	[game_code] ASC,
	[key_] ASC,
	[tran_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[acct_game_big_win_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[acct_game_big_win_log](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[ticket_id] [bigint] NULL,
	[acct_id] [varchar](80) NULL,
	[merchant_code] [varchar](10) NULL,
	[login_id] [varchar](70) NULL,
	[game_code] [varchar](10) NULL,
	[category_id] [varchar](10) NULL,
	[curr_id] [varchar](10) NULL,
	[ticket_date] [datetime] NULL,
	[bet_amt] [decimal](18, 6) NULL,
	[wl_amt] [decimal](18, 6) NULL,
	[win_amt] [decimal](18, 6) NULL,
	[channel] [varchar](10) NULL,
	[client_ip] [varchar](50) NULL,
 CONSTRAINT [PK_acct_game_big_win_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[acct_game_daily_tran_error]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[acct_game_daily_tran_error](
	[tran_id] [bigint] IDENTITY(1,1) NOT NULL,
	[acct_id] [varchar](80) NOT NULL,
	[tran_date] [datetime] NOT NULL,
	[tran_type] [varchar](3) NOT NULL,
	[game_code] [varchar](10) NOT NULL,
	[merchant_code] [varchar](10) NOT NULL,
	[login_id] [varchar](60) NULL,
	[bet_count] [numeric](18, 0) NULL,
	[ttl_bet] [numeric](18, 4) NULL,
	[success_bet] [numeric](18, 4) NULL,
	[wl_amt] [numeric](18, 4) NULL,
	[net_amt] [numeric](18, 4) NULL,
	[create_date] [datetime] NULL,
	[jp_contribute_amt] [decimal](18, 6) NULL,
	[channel] [varchar](20) NOT NULL,
	[jp_win] [numeric](18, 6) NULL,
	[curr_id] [varchar](5) NULL,
 CONSTRAINT [PK_acct_game_daily_tran_error] PRIMARY KEY CLUSTERED 
(
	[acct_id] ASC,
	[tran_date] ASC,
	[tran_type] ASC,
	[channel] ASC,
	[game_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[acct_game_daily_tran_fix_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[acct_game_daily_tran_fix_log](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[tran_date] [datetime] NOT NULL,
	[acct_id] [varchar](80) NOT NULL,
	[tran_type] [varchar](3) NOT NULL,
	[game_code] [varchar](10) NOT NULL,
	[channel] [varchar](20) NOT NULL,
	[provider] [varchar](30) NOT NULL,
	[merchant_code] [varchar](10) NOT NULL,
	[login_id] [varchar](60) NULL,
	[curr_id] [varchar](5) NULL,
	[game_category] [varchar](30) NULL,
	[bet_count] [numeric](18, 0) NULL,
	[ttl_bet] [numeric](18, 6) NULL,
	[wl_amt] [numeric](18, 6) NULL,
	[net_amt] [numeric](18, 6) NULL,
	[jp_contribute_amt] [decimal](18, 6) NULL,
	[jp_win] [numeric](18, 6) NULL,
	[draw_amt] [numeric](18, 6) NULL,
	[t_bet_count] [numeric](18, 0) NULL,
	[t_ttl_bet] [numeric](18, 6) NULL,
	[t_wl_amt] [numeric](18, 6) NULL,
	[t_net_amt] [numeric](18, 6) NULL,
	[t_jp_contribute_amt] [decimal](18, 6) NULL,
	[t_jp_win] [numeric](18, 6) NULL,
	[t_draw_amt] [numeric](18, 6) NULL,
	[create_date] [datetime] NULL,
	[status] [tinyint] NULL,
	[logic_code] [varchar](10) NULL,
	[update_date] [datetime] NULL,
 CONSTRAINT [PK_acct_game_daily_tran_fix_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[acct_game_duration_daily_tran]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[acct_game_duration_daily_tran](
	[tran_date] [datetime] NOT NULL,
	[acct_id] [varchar](80) NOT NULL,
	[game_code] [varchar](10) NOT NULL,
	[login_id] [varchar](60) NULL,
	[merchant_code] [varchar](10) NOT NULL,
	[curr_id] [varchar](5) NULL,
	[game_category] [varchar](30) NULL,
	[duration] [bigint] NULL,
	[acct_create_date] [datetime] NULL,
 CONSTRAINT [PK_acct_game_duration_daily_tran] PRIMARY KEY CLUSTERED 
(
	[tran_date] ASC,
	[acct_id] ASC,
	[game_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[acct_game_favourite]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[acct_game_favourite](
	[acct_id] [varchar](70) NOT NULL,
	[create_date] [datetime] NOT NULL,
	[game_list] [varchar](max) NULL,
 CONSTRAINT [PK_acct_id] PRIMARY KEY CLUSTERED 
(
	[acct_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[acct_game_loading_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[acct_game_loading_log](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[acct_id] [varchar](80) NULL,
	[merchant_code] [varchar](10) NULL,
	[login_id] [varchar](70) NULL,
	[game_code] [varchar](10) NULL,
	[channel] [varchar](10) NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[elapsed_seconds] [bigint] NULL,
	[create_date] [datetime] NULL,
	[client_ip] [varchar](50) NULL,
	[country_code] [varchar](30) NULL,
	[city] [varchar](128) NULL,
 CONSTRAINT [PK_acct_game_loading_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[acct_info]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[acct_info](
	[acct_id] [varchar](80) NOT NULL,
	[merchant_code] [varchar](10) NULL,
	[login_id] [varchar](60) NULL,
	[acct_name] [nvarchar](100) NULL,
	[acct_pwd] [varchar](250) NULL,
	[status] [smallint] NOT NULL,
	[acct_phone] [varchar](50) NULL,
	[acct_email] [varchar](100) NULL,
	[creator_id] [varchar](60) NULL,
	[create_date] [datetime] NOT NULL,
	[last_update_id] [varchar](60) NULL,
	[last_update_date] [datetime] NULL,
	[login_time] [datetime] NULL,
	[login_ip] [varchar](50) NULL,
	[login_ip_geo] [nvarchar](128) NULL,
	[login_sid] [varchar](128) NULL,
	[is_online] [smallint] NULL,
	[limit_group_code] [varchar](10) NULL,
	[risk] [tinyint] NULL,
	[parent_id] [varchar](30) NULL,
	[is_lock] [smallint] NOT NULL,
	[error_count] [int] NOT NULL,
	[site_id] [varchar](36) NULL,
	[play] [bit] NULL,
	[curr_id] [varchar](3) NOT NULL,
	[is_robot] [smallint] NULL,
	[login_token] [varchar](512) NULL,
	[type] [int] NULL,
 CONSTRAINT [PK_acct_info] PRIMARY KEY CLUSTERED 
(
	[acct_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[acct_info_archive]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[acct_info_archive](
	[acct_id] [varchar](80) NOT NULL,
	[merchant_code] [varchar](10) NULL,
	[login_id] [varchar](60) NULL,
	[acct_name] [nvarchar](50) NULL,
	[acct_pwd] [varchar](250) NULL,
	[status] [smallint] NOT NULL,
	[acct_phone] [varchar](50) NULL,
	[acct_email] [varchar](100) NULL,
	[creator_id] [varchar](60) NULL,
	[create_date] [datetime] NOT NULL,
	[last_update_id] [varchar](60) NULL,
	[last_update_date] [datetime] NULL,
	[login_time] [datetime] NULL,
	[login_ip] [varchar](50) NULL,
	[login_ip_geo] [nvarchar](128) NULL,
	[login_sid] [varchar](128) NULL,
	[is_online] [smallint] NULL,
	[limit_group_code] [varchar](10) NULL,
	[risk] [tinyint] NULL,
	[parent_id] [varchar](30) NULL,
	[is_lock] [smallint] NOT NULL,
	[error_count] [int] NOT NULL,
	[site_id] [varchar](30) NULL,
	[play] [bit] NULL,
	[curr_id] [varchar](3) NOT NULL,
	[is_robot] [smallint] NULL,
	[login_token] [varchar](512) NULL,
	[type] [int] NULL,
 CONSTRAINT [PK_acct_info_archive] PRIMARY KEY CLUSTERED 
(
	[acct_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[acct_login_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[acct_login_log](
	[acct_id] [varchar](80) NOT NULL,
	[client_ip] [varchar](50) NOT NULL,
	[merchant_code] [varchar](10) NULL,
	[login_id] [varchar](60) NULL,
	[create_date] [datetime] NULL,
	[client_ip_geo] [varchar](128) NULL,
	[country_code] [varchar](30) NULL,
 CONSTRAINT [PK_acct_login_log] PRIMARY KEY CLUSTERED 
(
	[acct_id] ASC,
	[client_ip] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[acct_pwd_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[acct_pwd_log](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[acct_id] [varchar](80) NULL,
	[login_id] [varchar](60) NULL,
	[update_by] [varchar](80) NULL,
	[update_login] [varchar](60) NULL,
	[update_date] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[acct_risk_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[acct_risk_setting](
	[acct_id] [varchar](80) NOT NULL,
	[type] [int] NULL,
	[multiply] [int] NULL,
	[remarks] [varchar](5000) NOT NULL,
	[update_by] [varchar](80) NOT NULL,
	[update_date] [datetime] NULL,
 CONSTRAINT [PK_acct_risk_setting] PRIMARY KEY CLUSTERED 
(
	[acct_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[acct_session_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[acct_session_log](
	[log_id] [bigint] IDENTITY(1,1) NOT NULL,
	[acct_id] [varchar](80) NULL,
	[login_id] [varchar](60) NULL,
	[merchant_code] [varchar](10) NULL,
	[session_id] [varchar](50) NULL,
	[login_time] [datetime] NULL,
	[logout_time] [datetime] NULL,
	[duration] [int] NULL,
	[login_ip] [varchar](50) NULL,
	[login_ip_geo] [nvarchar](128) NULL,
	[channel] [varchar](10) NULL,
	[country_code] [varchar](30) NULL,
	[device] [varchar](100) NULL,
	[browser] [varchar](50) NULL,
	[version] [varchar](10) NULL,
	[curr_id] [varchar](3) NULL,
PRIMARY KEY CLUSTERED 
(
	[log_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[agency]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[agency](
	[acct_id] [varchar](80) NOT NULL,
	[merchant_code] [varchar](10) NULL,
	[login_id] [varchar](60) NULL,
	[acct_name] [nvarchar](100) NULL,
	[acct_pwd] [varchar](250) NULL,
	[status] [smallint] NOT NULL,
	[acct_phone] [varchar](50) NULL,
	[acct_email] [varchar](100) NULL,
	[creator_id] [varchar](30) NULL,
	[create_date] [datetime] NOT NULL,
	[last_update_id] [varchar](30) NULL,
	[last_update_date] [datetime] NULL,
	[login_time] [datetime] NULL,
	[login_ip] [varchar](50) NULL,
	[login_ip_geo] [nvarchar](128) NULL,
	[login_sid] [varchar](128) NULL,
	[is_online] [smallint] NULL,
	[limit_group_code] [varchar](10) NULL,
	[risk] [tinyint] NULL,
	[parent_id] [varchar](80) NULL,
	[upline] [varchar](128) NULL,
	[is_lock] [smallint] NOT NULL,
	[is_createAgent] [smallint] NOT NULL,
	[effect] [varchar](80) NULL,
 CONSTRAINT [Pk_AGENCY_ACCT_ID] PRIMARY KEY CLUSTERED 
(
	[acct_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[agency_credit]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[agency_credit](
	[acct_id] [varchar](80) NOT NULL,
	[curr_id] [varchar](3) NOT NULL,
	[bal_amt] [decimal](20, 4) NOT NULL,
	[pending_amt] [decimal](20, 4) NULL,
 CONSTRAINT [PK_agency_credit] PRIMARY KEY CLUSTERED 
(
	[acct_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[agent_info]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[agent_info](
	[agent_id] [varchar](80) NULL,
	[agent_name] [varchar](50) NULL,
	[agent_list] [varchar](500) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[aggregator_session_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[aggregator_session_log](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[acct_id] [varchar](80) NULL,
	[login_id] [varchar](60) NULL,
	[merchant_code] [varchar](10) NULL,
	[session_id] [varchar](50) NULL,
	[merchant_token] [varchar](256) NULL,
	[login_time] [datetime] NULL,
	[logout_time] [datetime] NULL,
	[duration] [int] NULL,
	[attrs] [varchar](2048) NULL,
 CONSTRAINT [PK_aggregator_session_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[aggregator_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[aggregator_setting](
	[aggr_code] [varchar](20) NOT NULL,
	[param_setting] [bigint] NULL,
	[api_token] [varchar](50) NULL,
	[error_count] [bigint] NULL,
	[suspend_minutes] [bigint] NULL,
 CONSTRAINT [PK_aggregator_setting] PRIMARY KEY CLUSTERED 
(
	[aggr_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[aggregator_transfer]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[aggregator_transfer](
	[transfer_id] [varchar](32) NOT NULL,
	[acct_id] [varchar](80) NULL,
	[login_id] [varchar](60) NULL,
	[merchant_code] [varchar](16) NULL,
	[created_date] [datetime] NULL,
	[status] [int] NULL,
	[attr_map] [varchar](1024) NULL,
 CONSTRAINT [PK_aggregator_transfer] PRIMARY KEY CLUSTERED 
(
	[transfer_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[api_call_error_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[api_call_error_log](
	[log_id] [bigint] IDENTITY(1,1) NOT NULL,
	[merchant] [varchar](10) NULL,
	[acct_id] [varchar](80) NULL,
	[serial_no] [varchar](50) NULL,
	[api] [varchar](20) NULL,
	[create_time] [datetime] NULL,
	[code] [int] NULL,
	[msg] [varchar](2048) NULL,
	[req] [varchar](5000) NULL,
	[rsp] [varchar](5000) NULL,
	[login_id] [varchar](70) NULL,
	[api_type] [varchar](20) NULL,
	[game_code] [varchar](20) NULL,
 CONSTRAINT [PK_api_call_error_log] PRIMARY KEY CLUSTERED 
(
	[log_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[api_call_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[api_call_log](
	[log_id] [bigint] IDENTITY(1,1) NOT NULL,
	[merchant] [varchar](10) NULL,
	[serial_no] [varchar](50) NULL,
	[api] [varchar](20) NULL,
	[request_time] [datetime] NULL,
	[response_time] [datetime] NULL,
	[result_code] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[log_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BI_AcctSession]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BI_AcctSession](
	[SG_type] [varchar](5) NOT NULL,
	[acct_id] [varchar](80) NULL,
	[merchant_code] [varchar](10) NULL,
	[login_date] [date] NULL,
	[login_ip] [varchar](20) NULL,
	[login_ip_geo] [varchar](256) NULL,
	[channel] [varchar](10) NULL,
	[country_code] [varchar](30) NULL,
	[device] [varchar](100) NOT NULL,
	[duration] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[BI_Report]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BI_Report](
	[SG_type] [varchar](5) NOT NULL,
	[merchant_code] [varchar](10) NOT NULL,
	[acct_id] [varchar](70) NOT NULL,
	[curr_id] [varchar](3) NOT NULL,
	[game_code] [varchar](10) NOT NULL,
	[bet_amt] [numeric](18, 6) NOT NULL,
	[ticket_date] [date] NOT NULL,
	[cnt] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[device_daily_tran]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[device_daily_tran](
	[merchant_code] [varchar](10) NOT NULL,
	[tran_date] [datetime] NOT NULL,
	[channel] [varchar](10) NOT NULL,
	[country_code] [varchar](30) NOT NULL,
	[device] [varchar](100) NOT NULL,
	[total_count] [bigint] NULL,
	[browser] [varchar](50) NULL,
	[version] [varchar](10) NULL,
 CONSTRAINT [PK_device_daily_tran] PRIMARY KEY CLUSTERED 
(
	[merchant_code] ASC,
	[tran_date] ASC,
	[channel] ASC,
	[country_code] ASC,
	[device] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[fish_acct_daily_tran]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[fish_acct_daily_tran](
	[tran_date] [datetime] NOT NULL,
	[game_code] [varchar](10) NOT NULL,
	[merchant_code] [varchar](10) NOT NULL,
	[curr_id] [varchar](3) NOT NULL,
	[acct_id] [varchar](70) NOT NULL,
	[kind_id] [int] NOT NULL,
	[login_id] [varchar](60) NOT NULL,
	[bet_count] [int] NULL,
	[bet_amt] [decimal](18, 6) NULL,
	[win_count] [int] NULL,
	[win_amt] [decimal](18, 6) NULL,
	[create_date] [datetime] NULL,
	[curr_rate] [decimal](18, 6) NULL,
 CONSTRAINT [PK_fish_acct_daily_tran] PRIMARY KEY CLUSTERED 
(
	[tran_date] ASC,
	[game_code] ASC,
	[merchant_code] ASC,
	[curr_id] ASC,
	[acct_id] ASC,
	[kind_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[fs_cdn_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[fs_cdn_setting](
	[country_code] [varchar](10) NOT NULL,
	[websocket] [varchar](100) NULL,
	[loader] [varchar](100) NULL,
 CONSTRAINT [PK_fs_cdn_setting] PRIMARY KEY CLUSTERED 
(
	[country_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_arcade_ante_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_arcade_ante_log](
	[ante_id] [int] IDENTITY(1,1) NOT NULL,
	[round_id] [int] NOT NULL,
	[ante_bet_id] [int] NULL,
	[result_ante_id] [int] NULL,
	[bet_amount] [decimal](18, 2) NULL,
	[win_amount] [decimal](18, 2) NULL,
	[ante_odd] [decimal](18, 2) NULL,
	[created_date] [datetime] NULL,
 CONSTRAINT [PK_game_arcade_ante_log] PRIMARY KEY CLUSTERED 
(
	[ante_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_arcade_bet_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_arcade_bet_log](
	[bet_id] [int] IDENTITY(1,1) NOT NULL,
	[round_id] [int] NOT NULL,
	[bet_area_id] [int] NULL,
	[bet_area_odd] [decimal](18, 2) NULL,
	[bet_amount] [decimal](18, 2) NULL,
	[win_amount] [decimal](18, 2) NULL,
	[bet_area_desc] [varchar](50) NULL,
	[created_date] [datetime] NULL,
 CONSTRAINT [PK_game_arcade_bet_log] PRIMARY KEY CLUSTERED 
(
	[bet_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_arcade_free_game_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_arcade_free_game_log](
	[round_id] [int] NOT NULL,
	[bonus_spin_win] [int] NULL,
	[bonus_spin_round] [int] NULL,
	[bonus_round_result] [varchar](200) NULL,
	[free_spin_win] [int] NULL,
	[free_spin_round] [int] NULL,
	[free_spin_round_id] [int] NULL,
	[free_spin_multiplyer] [int] NULL,
	[completed] [bit] NULL,
	[bonus_base_multiplyer] [int] NULL,
	[bonus_base_win] [decimal](18, 6) NULL,
	[pay_table_index] [int] NULL,
	[game_code] [varchar](10) NULL,
	[created_by] [varchar](100) NULL,
	[created_date] [datetime] NULL,
	[transferId] [varchar](60) NULL,
	[status] [tinyint] NOT NULL,
	[merchant_code] [varchar](10) NULL,
	[spin_count] [int] NULL,
	[spin_sequence] [int] NULL,
 CONSTRAINT [PK_game_arcade_free_game_log] PRIMARY KEY CLUSTERED 
(
	[round_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_arcade_free_game_log_archive]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_arcade_free_game_log_archive](
	[round_id] [int] NOT NULL,
	[bonus_spin_win] [int] NULL,
	[bonus_spin_round] [int] NULL,
	[bonus_round_result] [varchar](200) NULL,
	[free_spin_win] [int] NULL,
	[free_spin_round] [int] NULL,
	[free_spin_round_id] [int] NULL,
	[free_spin_multiplyer] [int] NULL,
	[completed] [bit] NULL,
	[bonus_base_multiplyer] [int] NULL,
	[bonus_base_win] [decimal](18, 6) NULL,
	[pay_table_index] [int] NULL,
	[game_code] [varchar](10) NULL,
	[created_by] [varchar](100) NULL,
	[created_date] [datetime] NULL,
	[transferId] [varchar](60) NULL,
	[status] [tinyint] NOT NULL,
	[merchant_code] [varchar](10) NULL,
	[spin_count] [int] NULL,
	[spin_sequence] [int] NULL,
 CONSTRAINT [PK_game_arcade_free_game_log_archive] PRIMARY KEY CLUSTERED 
(
	[round_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_arcade_game_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_arcade_game_log](
	[round_id] [int] IDENTITY(1,1) NOT NULL,
	[game_code] [varchar](10) NULL,
	[result] [varchar](128) NULL,
	[multiply] [decimal](18, 2) NULL,
	[extra_multiply] [int] NULL,
	[jackpot_multiply] [int] NULL,
	[jackpot_win] [decimal](18, 6) NULL,
	[total_bet] [decimal](18, 2) NULL,
	[total_win] [decimal](18, 2) NULL,
	[logic_param] [int] NULL,
	[created_by] [varchar](70) NULL,
	[created_date] [datetime] NULL,
	[rank_symbol_index] [int] NULL,
	[rank_color_index] [int] NULL,
	[bpt_result] [int] NULL,
	[bonus_result] [varchar](200) NULL,
	[hit_count] [varchar](128) NULL,
 CONSTRAINT [PK_game_arcade_game_log] PRIMARY KEY CLUSTERED 
(
	[round_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_arcade_game_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_arcade_game_setting](
	[game_code] [varchar](10) NOT NULL,
	[curr_id] [varchar](3) NOT NULL,
	[bet_odd] [varchar](200) NULL,
	[default_bet_odd] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_game_arcade_game_setting] PRIMARY KEY CLUSTERED 
(
	[game_code] ASC,
	[curr_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_arcade_merchant_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_arcade_merchant_setting](
	[merchant_code] [varchar](20) NOT NULL,
	[game_code] [varchar](10) NOT NULL,
	[multiples] [varchar](1000) NOT NULL,
	[use_multiple] [varchar](1000) NOT NULL,
 CONSTRAINT [PK_game_arcade_merchant_setting] PRIMARY KEY CLUSTERED 
(
	[merchant_code] ASC,
	[game_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_archive_finish_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_archive_finish_log](
	[id] [varchar](50) NOT NULL,
	[status] [int] NULL,
	[create_date] [datetime] NULL,
 CONSTRAINT [PK_game_archive_finish_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_big_jackpot_pools]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_big_jackpot_pools](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[big_jackpot_name] [varchar](50) NULL,
	[big_jackpot_amt] [numeric](18, 4) NOT NULL,
	[probability] [int] NULL,
	[sequence] [int] NULL,
	[currency] [varchar](3) NOT NULL,
	[open_game] [varchar](1000) NULL,
	[max_amt] [numeric](18, 4) NULL,
	[min_amt] [numeric](18, 4) NULL,
	[contribute_amt] [numeric](18, 4) NULL,
	[release_amt] [numeric](18, 4) NULL,
	[contribute_percent] [numeric](18, 4) NULL,
	[bet_contribute_Percent] [numeric](18, 4) NULL,
	[status] [tinyint] NULL,
	[big_jackpot_code] [varchar](50) NULL,
 CONSTRAINT [PK_big_jackpot_pools_id] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_big_jackpot_pools_ticket]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_big_jackpot_pools_ticket](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[big_jackpot_id] [int] NULL,
	[merchant_group] [varchar](50) NOT NULL,
	[open_amt] [numeric](18, 4) NULL,
	[release_open_amt] [numeric](18, 4) NULL,
	[open_from] [datetime] NOT NULL,
	[open_to] [datetime] NOT NULL,
	[open_nums] [int] NULL,
	[status] [tinyint] NULL,
 CONSTRAINT [PK_big_jackpot_pools_ticket_id] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_board_acct_tran]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_board_acct_tran](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[acct_id] [varchar](80) NULL,
	[login_id] [varchar](60) NULL,
	[merchant_code] [varchar](15) NULL,
	[curr_id] [varchar](5) NULL,
	[curr_rate] [decimal](18, 6) NULL,
	[game_code] [varchar](10) NULL,
	[channel] [varchar](10) NULL,
	[client_ip] [varchar](50) NULL,
	[acct_create_date] [datetime] NULL,
	[hall_id] [varchar](21) NULL,
	[room_id] [varchar](10) NULL,
	[desk_id] [int] NULL,
	[gambling_code] [bigint] NULL,
	[chair_id] [int] NULL,
	[taxes] [int] NULL,
	[robot_taxes] [int] NULL,
	[is_banker] [bit] NULL,
	[is_robot] [bit] NULL,
	[bet_amt] [decimal](18, 6) NULL,
	[cancel_amt] [decimal](18, 6) NULL,
	[taxes_amt] [decimal](18, 6) NULL,
	[jackpot_win] [decimal](18, 6) NULL,
	[win_amt] [decimal](18, 6) NULL,
	[balance_before] [decimal](18, 6) NULL,
	[balance_after] [decimal](18, 6) NULL,
	[result] [varchar](2048) NULL,
	[status] [tinyint] NULL,
	[ticket_id] [bigint] NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[save_date] [datetime] NULL,
	[is_one_wallet] [tinyint] NULL,
	[transfer_id] [varchar](50) NULL,
	[valid_amt] [decimal](18, 6) NULL,
	[server_name] [varchar](10) NULL,
	[merchant_token] [varchar](512) NULL,
	[category_id] [varchar](5) NULL,
	[session_id] [varchar](50) NULL,
	[rtp] [int] NULL,
	[volatility] [varchar](50) NULL,
 CONSTRAINT [PK_game_board_acct_tran] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_board_bet_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_board_bet_log](
	[bet_id] [bigint] IDENTITY(1,1) NOT NULL,
	[game_code] [varchar](10) NULL,
	[merchant_code] [varchar](15) NULL,
	[curr_id] [varchar](5) NULL,
	[room_id] [varchar](10) NULL,
	[gambling_code] [bigint] NOT NULL,
	[chair_id] [tinyint] NULL,
	[acct_id] [varchar](100) NULL,
	[actions] [tinyint] NULL,
	[banker_multiple] [decimal](18, 2) NULL,
	[bet_multiple] [decimal](18, 2) NULL,
	[bet_amt] [decimal](18, 6) NULL,
	[rounds] [tinyint] NULL,
	[is_banker] [bit] NULL,
	[is_robot] [bit] NULL,
	[bet_date] [datetime] NULL,
	[status] [tinyint] NULL,
 CONSTRAINT [PK_game_board_bet_log] PRIMARY KEY CLUSTERED 
(
	[bet_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_board_cdn_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_board_cdn_setting](
	[country_code] [varchar](10) NOT NULL,
	[websocket] [varchar](100) NULL,
	[loader] [varchar](100) NULL,
 CONSTRAINT [PK_game_board_cdn_setting] PRIMARY KEY CLUSTERED 
(
	[country_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_board_commission_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_board_commission_setting](
	[game_code] [varchar](10) NOT NULL,
	[curr_id] [varchar](5) NOT NULL,
	[taxes] [int] NULL,
	[robot_taxes] [int] NULL,
 CONSTRAINT [PK_game_board_commission] PRIMARY KEY CLUSTERED 
(
	[game_code] ASC,
	[curr_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_board_game_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_board_game_log](
	[round_id] [bigint] IDENTITY(1,1) NOT NULL,
	[game_code] [varchar](10) NULL,
	[merchant_code] [varchar](10) NULL,
	[curr_id] [varchar](10) NULL,
	[room_id] [varchar](10) NULL,
	[desk_id] [int] NULL,
	[gambling_code] [varchar](50) NULL,
	[created_date] [datetime] NULL,
	[status] [int] NULL,
	[result] [varchar](max) NULL,
	[completed_date] [datetime] NULL,
	[pay_table] [varchar](max) NULL,
 CONSTRAINT [PK_game_board_game_log] PRIMARY KEY CLUSTERED 
(
	[round_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_board_limit_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_board_limit_setting](
	[game_code] [varchar](10) NOT NULL,
	[curr_id] [varchar](5) NOT NULL,
	[room_id] [varchar](5) NOT NULL,
	[status] [tinyint] NULL,
	[ante] [decimal](18, 2) NULL,
	[banker_multiples] [varchar](1024) NULL,
	[bet_credits] [varchar](1024) NULL,
	[big_win_notification] [decimal](18, 2) NULL,
	[max_round] [int] NULL,
	[min_allowed] [decimal](18, 2) NULL,
	[max_allowed] [decimal](18, 2) NULL,
 CONSTRAINT [PK_game_board_limit_setting] PRIMARY KEY CLUSTERED 
(
	[game_code] ASC,
	[curr_id] ASC,
	[room_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_board_merchant_room_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_board_merchant_room_setting](
	[merchant_code] [varchar](10) NOT NULL,
	[game_code] [varchar](20) NOT NULL,
	[curr_id] [varchar](5) NOT NULL,
	[room_ids] [varchar](1024) NULL,
 CONSTRAINT [PK_game_board_merchant_rooms] PRIMARY KEY CLUSTERED 
(
	[merchant_code] ASC,
	[game_code] ASC,
	[curr_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_board_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_board_setting](
	[game_code] [varchar](10) NOT NULL,
	[max_chair] [int] NULL,
	[min_playing] [int] NULL,
	[match_time] [int] NULL,
	[banker_time] [int] NULL,
	[bet_time] [int] NULL,
	[show_time] [int] NULL,
	[has_robot] [bit] NULL,
	[status] [smallint] NOT NULL,
	[pool_init_amt] [decimal](18, 4) NULL,
	[risk_type] [tinyint] NULL,
	[fast_match_time] [int] NULL,
	[fast_banker_time] [int] NULL,
	[fast_bet_time] [int] NULL,
	[fast_show_time] [int] NULL,
	[category_id] [varchar](5) NULL,
	[pool_init_max_amt] [decimal](18, 4) NULL,
	[settlement_waiting_time] [int] NULL,
 CONSTRAINT [PK_game_board_setting] PRIMARY KEY CLUSTERED 
(
	[game_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_board_table_config]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_board_table_config](
	[game_code] [varchar](10) NOT NULL,
	[curr_id] [varchar](10) NOT NULL,
	[strategy_code] [varchar](50) NULL,
	[version] [varchar](16) NULL,
	[volatility] [varchar](20) NULL,
	[rtp] [int] NOT NULL,
	[medium_rtp] [int] NULL,
	[low_rtp] [int] NULL,
	[random_type] [varchar](10) NULL,
	[share] [bit] NULL,
	[remark] [varchar](100) NULL,
	[control_rtp] [int] NULL,
 CONSTRAINT [PK_game_board_table_config] PRIMARY KEY CLUSTERED 
(
	[game_code] ASC,
	[curr_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_board_table_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_board_table_setting](
	[game_code] [varchar](10) NOT NULL,
	[curr_id] [varchar](5) NOT NULL,
	[room_id] [varchar](10) NOT NULL,
	[reel_id] [int] NOT NULL,
	[min_amt] [decimal](18, 4) NOT NULL,
	[max_amt] [decimal](18, 4) NOT NULL,
	[odds] [decimal](18, 4) NULL,
	[results] [varchar](128) NULL,
	[description] [varchar](128) NULL,
 CONSTRAINT [PK_game_board_table_setting] PRIMARY KEY CLUSTERED 
(
	[game_code] ASC,
	[curr_id] ASC,
	[room_id] ASC,
	[reel_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_category]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_category](
	[category_id] [varchar](5) NOT NULL,
	[category_desc] [nvarchar](60) NOT NULL,
 CONSTRAINT [PK_game_category] PRIMARY KEY CLUSTERED 
(
	[category_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_channel_status]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_channel_status](
	[game_code] [varchar](20) NOT NULL,
	[channel] [varchar](20) NOT NULL,
	[status] [varchar](10) NOT NULL,
 CONSTRAINT [pk_game_channel_status] PRIMARY KEY CLUSTERED 
(
	[game_code] ASC,
	[channel] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_confirmation_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_confirmation_log](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[round_id] [bigint] NULL,
	[table_name] [varchar](50) NULL,
	[create_date] [datetime] NULL,
 CONSTRAINT [PK_game_confirmation_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_currency_group_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_currency_group_setting](
	[curr_group] [varchar](80) NOT NULL,
	[game_code] [varchar](10) NOT NULL,
	[order_by] [int] NULL,
	[min_online_amt] [int] NULL,
	[max_online_amt] [int] NULL,
	[min_favourite_amt] [int] NULL,
	[max_favourite_amt] [int] NULL,
	[last_month_rank] [int] NULL,
 CONSTRAINT [PK_game_currency_group_setting] PRIMARY KEY CLUSTERED 
(
	[curr_group] ASC,
	[game_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_currency_order]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_currency_order](
	[curr_id] [varchar](80) NOT NULL,
	[game_code] [varchar](10) NOT NULL,
	[order_by] [int] NULL,
 CONSTRAINT [PK_game_currency_order] PRIMARY KEY CLUSTERED 
(
	[curr_id] ASC,
	[game_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_daily_jackpot_pools]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_daily_jackpot_pools](
	[tran_date] [datetime] NOT NULL,
	[merchant_code] [varchar](10) NOT NULL,
	[curr_id] [varchar](3) NOT NULL,
	[game_code] [varchar](20) NOT NULL,
	[volatility] [varchar](20) NOT NULL,
	[rtp] [int] NOT NULL,
	[table_id] [varchar](10) NOT NULL,
	[min_bet] [decimal](18, 6) NOT NULL,
	[max_bet] [decimal](18, 6) NOT NULL,
	[game_category] [varchar](5) NULL,
	[bet_count] [int] NULL,
	[games_win] [decimal](18, 6) NULL,
	[games_lose] [decimal](18, 6) NULL,
	[control_win] [decimal](18, 6) NULL,
	[id] [varchar](100) NOT NULL,
 CONSTRAINT [PK_game_daily_jackpot_pools] PRIMARY KEY CLUSTERED 
(
	[id] ASC,
	[tran_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_daily_jackpot_pools_archive]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_daily_jackpot_pools_archive](
	[tran_date] [datetime] NOT NULL,
	[merchant_code] [varchar](10) NOT NULL,
	[curr_id] [varchar](3) NOT NULL,
	[game_code] [varchar](20) NOT NULL,
	[volatility] [varchar](20) NOT NULL,
	[rtp] [int] NOT NULL,
	[table_id] [varchar](10) NOT NULL,
	[min_bet] [decimal](18, 6) NOT NULL,
	[max_bet] [decimal](18, 6) NOT NULL,
	[game_category] [varchar](5) NULL,
	[bet_count] [int] NULL,
	[games_win] [decimal](18, 6) NULL,
	[games_lose] [decimal](18, 6) NULL,
	[control_win] [decimal](18, 6) NULL,
	[id] [varchar](100) NOT NULL,
 CONSTRAINT [PK_game_daily_jackpot_pools_archive] PRIMARY KEY CLUSTERED 
(
	[id] ASC,
	[tran_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_error_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_error_log](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[merchant_code] [varchar](20) NULL,
	[curr_id] [varchar](10) NULL,
	[acct_id] [varchar](80) NULL,
	[game_category] [varchar](10) NULL,
	[game_code] [varchar](10) NULL,
	[ip] [varchar](50) NULL,
	[channel] [varchar](20) NULL,
	[create_date] [datetime] NOT NULL,
	[level] [tinyint] NULL,
	[is_processed] [int] NULL,
	[code] [int] NULL,
	[msg] [varchar](1000) NULL,
	[login_id] [varchar](70) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_fish_acct_tran]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_fish_acct_tran](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[acct_id] [varchar](80) NULL,
	[login_id] [varchar](60) NULL,
	[merchant_code] [varchar](15) NULL,
	[curr_id] [varchar](5) NULL,
	[game_code] [varchar](10) NULL,
	[volatility] [varchar](10) NULL,
	[rtp] [int] NULL,
	[channel] [varchar](10) NULL,
	[server_name] [varchar](10) NULL,
	[client_ip] [varchar](50) NULL,
	[curr_rate] [decimal](18, 6) NULL,
	[is_one_wallet] [tinyint] NULL,
	[acct_create_date] [datetime] NULL,
	[hall_id] [varchar](5) NULL,
	[room_id] [varchar](10) NULL,
	[desk_id] [int] NULL,
	[status] [tinyint] NULL,
	[ticket_id] [bigint] NULL,
	[bet_count] [int] NULL,
	[bet_amt] [decimal](18, 6) NULL,
	[cancel_count] [int] NULL,
	[cancel_amt] [decimal](18, 6) NULL,
	[payout_count] [int] NULL,
	[win_count] [int] NULL,
	[win_amt] [decimal](18, 6) NULL,
	[balance_before] [decimal](18, 6) NULL,
	[balance_after] [decimal](18, 6) NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[save_date] [datetime] NULL,
	[result] [varchar](2048) NULL,
	[transfer_no] [varchar](36) NULL,
	[transfer_id] [varchar](50) NULL,
	[merchant_token] [varchar](512) NULL,
	[transfer_split] [tinyint] NULL,
	[session_id] [varchar](50) NULL,
	[lucky_tran_id] [bigint] NULL,
	[logic_code] [varchar](10) NULL,
 CONSTRAINT [PK_game_fish_acct_tran] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_fish_bet_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_fish_bet_log](
	[id] [varchar](36) NOT NULL,
	[server_name] [varchar](10) NULL,
	[acct_tran_id] [bigint] NULL,
	[acct_id] [varchar](80) NULL,
	[game_code] [varchar](10) NULL,
	[volatility] [varchar](10) NULL,
	[rtp] [int] NULL,
	[type] [int] NULL,
	[shoot_type] [int] NULL,
	[kind_id] [int] NULL,
	[bet_amt] [decimal](18, 6) NULL,
	[win_amt] [decimal](18, 6) NULL,
	[balance] [decimal](18, 6) NULL,
	[round_id] [bigint] NULL,
	[base_round_id] [bigint] NULL,
	[free_count] [int] NULL,
	[free_index] [int] NULL,
	[transfer_id] [varchar](36) NULL,
	[reference_id] [varchar](36) NULL,
	[bet_time] [datetime] NULL,
	[settle_time] [datetime] NULL,
	[save_time] [datetime] NULL,
	[result] [varchar](2048) NULL,
 CONSTRAINT [PK_game_fish_bet_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_fish_cdn_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_fish_cdn_setting](
	[country_code] [varchar](10) NOT NULL,
	[curr_id] [varchar](10) NOT NULL,
	[websocket] [varchar](100) NULL,
	[loader] [varchar](100) NULL,
 CONSTRAINT [PK_game_fish_cdn_setting] PRIMARY KEY CLUSTERED 
(
	[country_code] ASC,
	[curr_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_fish_game_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_fish_game_log](
	[round_id] [bigint] IDENTITY(1,1) NOT NULL,
	[acct_tran_id] [bigint] NULL,
	[merchant_code] [varchar](15) NULL,
	[game_code] [varchar](10) NULL,
	[volatility] [varchar](10) NULL,
	[rtp] [int] NULL,
	[acct_id] [varchar](80) NULL,
	[hall_id] [varchar](5) NULL,
	[room_id] [varchar](10) NULL,
	[desk_id] [int] NULL,
	[client_ip] [varchar](50) NULL,
	[bullet_log_id] [varchar](36) NULL,
	[transfer_id] [varchar](36) NULL,
	[ref_round_id] [bigint] NULL,
	[base_round_id] [bigint] NULL,
	[status] [tinyint] NULL,
	[fish_kind_id] [int] NULL,
	[odds] [decimal](18, 6) NULL,
	[swept_odds] [decimal](18, 6) NULL,
	[free_count] [int] NULL,
	[free_index] [int] NULL,
	[bet_amt] [decimal](18, 6) NULL,
	[win_amt] [decimal](18, 6) NULL,
	[bet_time] [datetime] NULL,
	[create_time] [datetime] NULL,
	[login_id] [varchar](70) NULL,
 CONSTRAINT [PK_game_fish_game_log] PRIMARY KEY CLUSTERED 
(
	[round_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_fish_group_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_fish_group_setting](
	[game_code] [varchar](10) NOT NULL,
	[group_code] [varchar](5) NOT NULL,
	[total_count] [int] NOT NULL,
	[range_start] [int] NOT NULL,
	[range_end] [int] NOT NULL,
	[step] [float] NOT NULL,
	[last_stop_create] [int] NOT NULL,
	[initial_seconds] [int] NULL,
	[scenes] [varchar](1024) NULL,
	[extend_scenes] [varchar](1024) NULL,
	[group_name] [nvarchar](500) NULL,
 CONSTRAINT [PK_game_fish_group_setting] PRIMARY KEY CLUSTERED 
(
	[game_code] ASC,
	[group_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_fish_kind_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_fish_kind_setting](
	[game_code] [varchar](10) NOT NULL,
	[kind_id] [int] NOT NULL,
	[speed] [int] NOT NULL,
 CONSTRAINT [PK_game_fish_kind_setting] PRIMARY KEY CLUSTERED 
(
	[game_code] ASC,
	[kind_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_fish_rng_config]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_fish_rng_config](
	[game_code] [varchar](10) NOT NULL,
	[curr_id] [varchar](10) NOT NULL,
	[strategy_code] [varchar](50) NULL,
	[versions] [varchar](16) NULL,
	[volatility] [varchar](20) NULL,
	[rtp] [int] NOT NULL,
	[medium_rtp] [int] NULL,
	[low_rtp] [int] NULL,
	[free_rtp] [int] NOT NULL,
	[free_medium_rtp] [int] NULL,
	[free_low_rtp] [int] NULL,
	[random_type] [varchar](10) NULL,
	[share] [bit] NULL,
	[remark] [varchar](100) NULL,
 CONSTRAINT [PK_game_fish_rng_config] PRIMARY KEY CLUSTERED 
(
	[game_code] ASC,
	[curr_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_fish_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_fish_setting](
	[game_code] [varchar](10) NOT NULL,
	[curr_id] [varchar](5) NOT NULL,
	[level] [varchar](10) NOT NULL,
	[denomination] [varchar](1024) NULL,
	[default_denomination] [decimal](18, 2) NULL,
	[orderby] [int] NULL,
	[status] [tinyint] NULL,
	[big_win_odds] [int] NULL,
 CONSTRAINT [PK_game_fish_setting] PRIMARY KEY CLUSTERED 
(
	[game_code] ASC,
	[curr_id] ASC,
	[level] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_fish_transfer_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_fish_transfer_log](
	[id] [varchar](50) NOT NULL,
	[tran_id] [bigint] NULL,
	[acct_id] [varchar](80) NULL,
	[game_code] [varchar](10) NULL,
	[bet_amt] [decimal](18, 6) NULL,
	[win_amt] [decimal](18, 6) NULL,
	[balance] [decimal](18, 6) NULL,
	[transfer_date] [datetime] NULL,
	[tran_date] [datetime] NULL,
	[result] [varchar](2048) NULL,
 CONSTRAINT [PK_game_fish_transfer_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_fish_warning_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_fish_warning_log](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[acct_id] [varchar](80) NULL,
	[balance] [numeric](18, 6) NULL,
	[status] [tinyint] NULL,
	[create_date] [datetime] NULL,
	[update_date] [datetime] NULL,
 CONSTRAINT [PK_game_fish_warning_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_gamble_weight_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_gamble_weight_setting](
	[gamble_id] [int] IDENTITY(1,1) NOT NULL,
	[win_weight] [int] NULL,
	[lose_weight] [int] NULL,
	[gamble_type] [varchar](20) NULL,
	[round] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[gamble_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_habit_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_habit_setting](
	[acct_id] [varchar](80) NOT NULL,
	[game_code] [varchar](10) NOT NULL,
	[category_id] [varchar](30) NOT NULL,
	[merchant_code] [varchar](10) NOT NULL,
	[curr_id] [varchar](3) NOT NULL,
	[line] [int] NULL,
	[denomination] [decimal](18, 6) NULL,
	[bet] [decimal](18, 6) NULL,
	[credit] [decimal](18, 6) NULL,
	[local_bets] [varchar](256) NULL,
	[logic_value] [int] NULL,
	[logic_params] [varchar](1024) NULL,
	[param_code] [bigint] NULL,
	[update_date] [datetime] NOT NULL,
	[ticket_id] [bigint] NULL,
	[ticket_date] [datetime] NULL,
	[login_id] [varchar](60) NULL,
 CONSTRAINT [PK_game_habit_setting] PRIMARY KEY CLUSTERED 
(
	[acct_id] ASC,
	[game_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_icon]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_icon](
	[game_code] [varchar](10) NOT NULL,
	[language] [varchar](10) NOT NULL,
	[type] [varchar](20) NOT NULL,
	[game_category] [varchar](10) NULL,
	[img_base64] [text] NULL,
 CONSTRAINT [PK_game_icon] PRIMARY KEY CLUSTERED 
(
	[game_code] ASC,
	[language] ASC,
	[type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_info]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_info](
	[game_code] [varchar](10) NOT NULL,
	[game_name] [varchar](35) NOT NULL,
	[game_category] [varchar](5) NOT NULL,
	[jackpot_code] [varchar](20) NULL,
	[description] [nvarchar](1024) NULL,
	[game_type] [varchar](5) NULL,
	[status] [char](1) NULL,
	[line] [int] NULL,
	[orderby] [int] NULL,
	[game_code_3rd] [varchar](20) NULL,
	[game_name_cn] [nvarchar](100) NULL,
	[provider_code] [varchar](10) NULL,
	[game_tag] [varchar](5) NULL,
	[param_setting] [bigint] NULL,
	[logic_code] [varchar](100) NULL,
 CONSTRAINT [PK_game] PRIMARY KEY CLUSTERED 
(
	[game_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_jackpot_pools]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_jackpot_pools](
	[pool_id] [int] NOT NULL,
	[curr_id] [varchar](3) NOT NULL,
	[game_category] [varchar](5) NOT NULL,
	[table_id] [varchar](3) NOT NULL,
	[payout_percent] [decimal](4, 2) NOT NULL,
	[games_win] [decimal](18, 6) NOT NULL,
	[games_lose] [decimal](18, 6) NOT NULL,
	[capital] [decimal](18, 6) NOT NULL,
	[jp_contribute_amt] [decimal](18, 6) NOT NULL,
	[min_bet] [decimal](18, 6) NULL,
	[max_bet] [decimal](18, 6) NULL,
	[max_lose_limit] [decimal](18, 6) NULL,
	[merchant_group] [varchar](10) NULL,
	[game_code] [varchar](20) NULL,
	[rtp] [int] NULL,
	[volatility] [varchar](20) NULL,
	[control_win] [decimal](18, 6) NULL,
 CONSTRAINT [PK_game_jackpot_pools] PRIMARY KEY CLUSTERED 
(
	[pool_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_jackpot_pools_bet_range]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_jackpot_pools_bet_range](
	[bet_range_id] [int] IDENTITY(1,1) NOT NULL,
	[curr_id] [varchar](3) NOT NULL,
	[min_bet] [decimal](18, 2) NOT NULL,
	[max_bet] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_game_win_lose_bet_range] PRIMARY KEY CLUSTERED 
(
	[bet_range_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_jackpot_pools_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_jackpot_pools_log](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[pool_id] [int] NOT NULL,
	[payout_percent_before] [decimal](4, 2) NULL,
	[payout_percent_after] [decimal](4, 2) NULL,
	[adjust_before] [decimal](18, 6) NULL,
	[adjust_amount] [decimal](18, 6) NULL,
	[created_by] [varchar](30) NOT NULL,
	[created_date] [datetime] NOT NULL,
 CONSTRAINT [PK_game_jackpot_pools_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_jackpot_win_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_jackpot_win_log](
	[jackpot_win_id] [int] IDENTITY(1,1) NOT NULL,
	[jackpot_code] [varchar](20) NOT NULL,
	[round_id] [int] NOT NULL,
	[game_code] [varchar](10) NOT NULL,
	[jp_amt] [decimal](18, 6) NOT NULL,
	[currency] [varchar](3) NOT NULL,
	[curr_rate] [decimal](18, 6) NOT NULL,
	[jp_amt_in_curr] [decimal](18, 6) NOT NULL,
	[created_by] [varchar](30) NOT NULL,
	[created_date] [datetime] NOT NULL,
	[sequence] [tinyint] NULL,
	[merchant_group] [varchar](30) NULL,
	[rtp] [int] NULL,
	[volatility] [varchar](20) NULL,
	[acct_curr_id] [varchar](10) NULL,
 CONSTRAINT [PK_game_jackpot_win_log] PRIMARY KEY CLUSTERED 
(
	[jackpot_win_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_limit_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_limit_setting](
	[game_code] [varchar](20) NOT NULL,
	[curr_id] [varchar](3) NOT NULL,
	[max_lose_limit] [decimal](18, 6) NULL,
	[medium_tdr_bet] [decimal](18, 6) NULL,
	[max_ticket_limit] [decimal](18, 6) NULL,
	[low_tdr_bet] [decimal](18, 6) NULL,
	[max_bet] [decimal](18, 6) NULL,
	[min_bet] [decimal](18, 6) NULL,
	[multiple] [int] NULL,
 CONSTRAINT [PK_GAME_LIMT_SETTING] PRIMARY KEY CLUSTERED 
(
	[game_code] ASC,
	[curr_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_logic_param_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_logic_param_log](
	[param_id] [int] IDENTITY(1,1) NOT NULL,
	[game_code] [varchar](10) NULL,
	[logic_type] [varchar](100) NULL,
	[param_value] [varchar](128) NULL,
	[last_update_time] [datetime] NULL,
	[created_by] [varchar](80) NULL,
	[created_date] [datetime] NULL,
	[last_domination] [decimal](18, 2) NULL,
	[last_line_bet] [int] NULL,
	[last_credit] [decimal](18, 6) NULL,
	[last_total_bet] [decimal](18, 2) NULL,
	[last_local_bet] [varchar](100) NULL,
	[completed] [bit] NULL,
	[is_change] [bit] NULL,
 CONSTRAINT [PK_game_logic_param_log] PRIMARY KEY CLUSTERED 
(
	[param_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_logic_param_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_logic_param_setting](
	[param_id] [int] NOT NULL,
	[game_code] [varchar](10) NOT NULL,
	[param_value] [nvarchar](128) NOT NULL,
	[currency] [varchar](3) NULL,
	[order_by] [tinyint] NOT NULL,
	[description] [nvarchar](256) NULL,
 CONSTRAINT [PK_game_logic_param_setting] PRIMARY KEY CLUSTERED 
(
	[param_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_multiplayer_cdn_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_multiplayer_cdn_setting](
	[country_code] [varchar](10) NOT NULL,
	[websocket] [varchar](100) NULL,
 CONSTRAINT [PK_game_multiplayer_cdn_setting] PRIMARY KEY CLUSTERED 
(
	[country_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_multiplayer_free_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_multiplayer_free_log](
	[log_id] [int] IDENTITY(10000,1) NOT NULL,
	[round_id] [int] NOT NULL,
	[bonus_spin_win] [int] NULL,
	[bonus_spin_round] [int] NULL,
	[bonus_round_result] [varchar](200) NULL,
	[free_spin_win] [int] NULL,
	[free_spin_round] [int] NULL,
	[free_spin_round_id] [int] NULL,
	[free_spin_multiplyer] [int] NULL,
	[completed] [bit] NULL,
	[bonus_base_multiplyer] [int] NULL,
	[bonus_base_win] [decimal](18, 6) NULL,
	[pay_table_index] [int] NULL,
	[game_code] [varchar](10) NULL,
	[created_by] [varchar](100) NULL,
	[created_date] [datetime] NULL,
 CONSTRAINT [PK_game_multiplayer_free_log] PRIMARY KEY CLUSTERED 
(
	[log_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_multiplayer_table_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_multiplayer_table_setting](
	[games_bet_setting_id] [int] NOT NULL,
	[table_count] [tinyint] NOT NULL,
	[seat_count] [tinyint] NOT NULL,
	[timer] [tinyint] NOT NULL,
 CONSTRAINT [PK_game_multiplayer_table_setting] PRIMARY KEY CLUSTERED 
(
	[games_bet_setting_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_mutiplayer_arcade_bet_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_mutiplayer_arcade_bet_log](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[round_id] [bigint] NOT NULL,
	[pool_id] [varchar](100) NULL,
	[merchant_code] [varchar](10) NULL,
	[acct_id] [varchar](70) NULL,
	[game_code] [varchar](10) NULL,
	[created_date] [datetime] NULL,
	[total_bet] [numeric](18, 6) NULL,
	[curr_id] [varchar](3) NULL,
	[curr_rate] [numeric](18, 4) NULL,
	[result] [varchar](200) NULL,
	[client_ip] [varchar](50) NULL,
	[merchant_txid] [varchar](100) NULL,
	[channel] [varchar](10) NULL,
	[table_id] [varchar](20) NULL,
	[is_one_wallet] [int] NULL,
	[reference_id] [varchar](50) NULL,
	[loc_bets] [varchar](200) NULL,
	[bpt_loc_bets] [varchar](200) NULL,
	[status] [int] NOT NULL,
	[payout] [int] NULL,
	[login_id] [varchar](70) NULL,
 CONSTRAINT [PK_game_mutiplayer_arcade_bet_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_mutiplayer_arcade_result_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_mutiplayer_arcade_result_log](
	[round_id] [bigint] NOT NULL,
	[pay_table_index] [int] NULL,
	[pay_table] [varchar](200) NULL,
	[color_table_index] [int] NULL,
	[color_table] [varchar](200) NULL,
	[rank] [varchar](200) NULL,
	[symbol_index] [int] NULL,
	[color_index] [int] NULL,
	[bonus_round] [int] NULL,
	[draw_id] [int] NULL,
	[bonus_result] [varchar](200) NULL,
	[game_code] [varchar](10) NULL,
	[bpt_result] [tinyint] NULL,
 CONSTRAINT [PK_game_mutiplayer_arcade_result_log] PRIMARY KEY CLUSTERED 
(
	[round_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_mutiplayer_cancel_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_mutiplayer_cancel_log](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[bet_log_id] [bigint] NULL,
	[round_id] [bigint] NULL,
	[create_date] [datetime] NULL,
	[msg] [varchar](1024) NULL,
 CONSTRAINT [PK_GAMW_MUTIPLAYER_CANCEL_LOG] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_mutiplayer_derby_bet_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_mutiplayer_derby_bet_log](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[round_id] [bigint] NOT NULL,
	[pool_id] [varchar](100) NULL,
	[merchant_code] [varchar](10) NULL,
	[acct_id] [varchar](70) NULL,
	[game_code] [varchar](10) NULL,
	[created_date] [datetime] NULL,
	[total_bet] [numeric](18, 6) NULL,
	[curr_id] [varchar](3) NULL,
	[curr_rate] [numeric](18, 4) NULL,
	[result] [varchar](200) NULL,
	[client_ip] [varchar](50) NULL,
	[merchant_txid] [varchar](100) NULL,
	[channel] [varchar](10) NULL,
	[table_id] [varchar](20) NULL,
	[is_one_wallet] [int] NULL,
	[reference_id] [varchar](50) NULL,
	[loc_bets] [varchar](200) NULL,
	[bpt_loc_bets] [varchar](200) NULL,
	[status] [int] NOT NULL,
 CONSTRAINT [PK_game_mutiplayer_derby_bet_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_mutiplayer_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_mutiplayer_setting](
	[game_code] [varchar](10) NOT NULL,
	[round_seconds] [int] NULL,
	[result_seconds] [int] NULL,
	[wait_seconds] [int] NULL,
	[status] [int] NULL,
	[special_game_seconds] [int] NULL,
 CONSTRAINT [PK_game_mutiplayer_setting] PRIMARY KEY CLUSTERED 
(
	[game_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_mutiplayer_ticket]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_mutiplayer_ticket](
	[ticket_id] [bigint] NOT NULL,
	[round_id] [bigint] NOT NULL,
 CONSTRAINT [PK_game_mutiplayer_ticket] PRIMARY KEY CLUSTERED 
(
	[ticket_id] ASC,
	[round_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_mutiplayer_tran]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_mutiplayer_tran](
	[round_id] [bigint] NOT NULL,
	[draw_id] [int] NOT NULL,
	[tickets] [int] NULL,
	[game_code] [varchar](10) NOT NULL,
	[game_category] [varchar](10) NULL,
	[status] [int] NULL,
	[result] [varchar](200) NULL,
	[pay_table_index] [int] NULL,
	[tran_date] [datetime] NULL,
	[created_time] [datetime] NULL,
	[resulted_time] [datetime] NULL,
	[stop_beted_time] [datetime] NULL,
	[completed_time] [datetime] NULL,
	[started_time] [datetime] NULL,
 CONSTRAINT [PK_game_mutiplayer_tran] PRIMARY KEY CLUSTERED 
(
	[round_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_playing_card_color_ref]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_playing_card_color_ref](
	[playing_card_color_id] [tinyint] NOT NULL,
	[description] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_game_playing_card_color_ref] PRIMARY KEY CLUSTERED 
(
	[playing_card_color_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_playing_card_ref]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_playing_card_ref](
	[playing_card_id] [tinyint] NOT NULL,
	[playing_card_color_id] [tinyint] NOT NULL,
	[playing_card_suit_id] [tinyint] NOT NULL,
	[description] [varchar](20) NOT NULL,
	[baccarat_point] [tinyint] NOT NULL,
	[blackjack_point] [tinyint] NOT NULL,
	[caribbean_poker_point] [tinyint] NOT NULL,
	[dragon_tiger_point] [tinyint] NOT NULL,
 CONSTRAINT [PK_game_playing_card_ref] PRIMARY KEY CLUSTERED 
(
	[playing_card_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_playing_card_suit_ref]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_playing_card_suit_ref](
	[playing_card_suit_id] [tinyint] NOT NULL,
	[description] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_game_playing_card_suit_ref] PRIMARY KEY CLUSTERED 
(
	[playing_card_suit_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_pool_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_pool_log](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[pool_id] [varchar](100) NULL,
	[adjust_before] [decimal](18, 6) NULL,
	[adjust_amount] [decimal](18, 6) NULL,
	[created_by] [varchar](30) NOT NULL,
	[created_date] [datetime] NOT NULL,
	[games_win_before] [decimal](18, 6) NULL,
	[games_win_amount] [decimal](18, 6) NULL,
	[games_lose_before] [decimal](18, 6) NULL,
	[games_lose_amount] [decimal](18, 6) NULL,
 CONSTRAINT [PK_game_pool_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_respin_warning_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_respin_warning_log](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[merchant_code] [varchar](10) NULL,
	[acct_id] [varchar](70) NULL,
	[login_id] [varchar](60) NULL,
	[game_code] [varchar](10) NULL,
	[curr_id] [varchar](5) NULL,
	[bet_amt] [numeric](18, 6) NULL,
	[origin_bet_amt] [numeric](18, 6) NULL,
	[win_amt] [numeric](18, 6) NULL,
	[multiple] [numeric](18, 6) NULL,
	[reference_id] [varchar](50) NULL,
	[create_date] [datetime] NULL,
	[remarks] [varchar](300) NULL,
	[client_ip] [varchar](50) NULL,
 CONSTRAINT [PK_game_respin_warning_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_rng_config]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_rng_config](
	[game_code] [varchar](10) NOT NULL,
	[curr_id] [varchar](10) NOT NULL,
	[strategy_code] [varchar](50) NULL,
	[versions] [varchar](16) NULL,
	[volatility] [varchar](20) NULL,
	[rtp] [int] NOT NULL,
	[medium_rtp] [int] NULL,
	[low_rtp] [int] NULL,
	[random_type] [varchar](10) NULL,
	[share] [bit] NULL,
	[remark] [varchar](100) NULL,
 CONSTRAINT [PK_game_rng_config] PRIMARY KEY CLUSTERED 
(
	[game_code] ASC,
	[curr_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_rtp_warning_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_rtp_warning_setting](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[bet_count_begin] [bigint] NOT NULL,
	[bet_count_end] [bigint] NOT NULL,
	[diff_rtp] [int] NOT NULL,
	[target_rtp] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_setting](
	[game_code] [varchar](10) NOT NULL,
	[channels] [varchar](50) NULL,
	[languages] [varchar](1024) NULL,
	[currencies] [varchar](300) NULL,
	[jackpot_currencies] [varchar](300) NULL,
	[tags] [varchar](200) NULL,
 CONSTRAINT [PK_game_setting] PRIMARY KEY CLUSTERED 
(
	[game_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_slot_machine_currency_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_slot_machine_currency_setting](
	[curr_id] [varchar](3) NOT NULL,
	[game_code] [varchar](10) NOT NULL,
	[dominations] [varchar](100) NULL,
	[default_domination] [decimal](18, 2) NULL,
	[line_bets] [varchar](100) NULL,
	[default_lineBet] [decimal](18, 0) NULL,
	[min_bet] [decimal](18, 2) NULL,
	[max_bet] [decimal](18, 2) NULL,
	[max_lose_limit] [decimal](18, 2) NULL,
	[medium_turn_down_rtp] [decimal](18, 2) NULL,
	[low_turn_down_rtp] [decimal](18, 2) NULL,
	[max_ticket_limit] [decimal](18, 2) NULL,
	[created_by] [varchar](50) NULL,
	[created_date] [datetime] NULL,
 CONSTRAINT [PK_game_currency_setting] PRIMARY KEY CLUSTERED 
(
	[curr_id] ASC,
	[game_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_slot_machine_gamble_dice_game_ref]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_slot_machine_gamble_dice_game_ref](
	[gamble_dice_ref_id] [int] NOT NULL,
	[description] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_game_slot_machine_gamble_dice_game_ref] PRIMARY KEY CLUSTERED 
(
	[gamble_dice_ref_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_slot_machine_gamble_game_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_slot_machine_gamble_game_log](
	[gamble_game_log_id] [int] IDENTITY(1,1) NOT NULL,
	[round_id] [int] NOT NULL,
	[bet_amount] [decimal](18, 6) NOT NULL,
	[win_amount] [decimal](18, 6) NOT NULL,
	[playing_card_id] [tinyint] NOT NULL,
	[gamble_game_ref_id] [tinyint] NOT NULL,
	[created_date] [datetime] NOT NULL,
	[created_by] [varchar](80) NULL,
	[game_code] [varchar](10) NULL,
	[banker_card_id] [int] NULL,
	[gamble_type] [tinyint] NULL,
 CONSTRAINT [PK_game_slot_machine_gamble_game_log] PRIMARY KEY CLUSTERED 
(
	[gamble_game_log_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_slot_machine_gamble_game_ref]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_slot_machine_gamble_game_ref](
	[gamble_game_ref_id] [tinyint] NOT NULL,
	[description] [nvarchar](20) NOT NULL,
 CONSTRAINT [PK_game_slot_machine_gamble_game_ref] PRIMARY KEY CLUSTERED 
(
	[gamble_game_ref_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_slot_machine_game_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_slot_machine_game_log](
	[round_id] [bigint] IDENTITY(1,1) NOT NULL,
	[line] [int] NOT NULL,
	[line_bet] [decimal](18, 6) NOT NULL,
	[bonus_round_win] [tinyint] NOT NULL,
	[bonus_round_completed] [tinyint] NOT NULL,
	[free_spin_round_win] [tinyint] NOT NULL,
	[free_spin_round_completed] [tinyint] NOT NULL,
	[free_spin_round_id] [bigint] NOT NULL,
	[free_spin_multiplyer] [tinyint] NOT NULL,
	[created_date] [datetime] NOT NULL,
	[created_by] [varchar](80) NULL,
	[completed] [bit] NULL,
	[game_code] [varchar](10) NULL,
	[domination] [decimal](18, 6) NULL,
	[transferId] [varchar](60) NULL,
	[game_win] [numeric](18, 6) NULL,
	[free_spin_index] [int] NULL,
	[remaining_count] [int] NULL,
	[base_id] [bigint] NULL,
	[bonus_round_multiplyer] [tinyint] NULL,
	[free_multiply_index] [int] NULL,
	[merchant_code] [varchar](10) NULL,
	[login_id] [varchar](50) NULL,
	[retain_wild_index] [varchar](256) NULL,
	[credit] [decimal](18, 6) NULL,
	[spin_count] [int] NULL,
	[spin_sequence] [int] NULL,
	[src_type] [tinyint] NULL,
	[promotion_log_id] [bigint] NULL,
	[promotion_status] [tinyint] NULL,
	[symbols_win] [varchar](1024) NULL,
	[logic_code] [varchar](10) NULL,
	[status] [tinyint] NOT NULL,
	[base_log_date] [datetime] NULL,
	[logic_json] [varchar](1024) NULL,
 CONSTRAINT [PK_game_slot_machine_game_log] PRIMARY KEY CLUSTERED 
(
	[round_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_slot_machine_game_log_archive]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_slot_machine_game_log_archive](
	[round_id] [bigint] NOT NULL,
	[line] [int] NOT NULL,
	[line_bet] [decimal](18, 6) NOT NULL,
	[bonus_round_win] [tinyint] NOT NULL,
	[bonus_round_completed] [tinyint] NOT NULL,
	[free_spin_round_win] [tinyint] NOT NULL,
	[free_spin_round_completed] [tinyint] NOT NULL,
	[free_spin_round_id] [int] NOT NULL,
	[free_spin_multiplyer] [tinyint] NOT NULL,
	[created_date] [datetime] NOT NULL,
	[created_by] [varchar](80) NULL,
	[completed] [bit] NULL,
	[game_code] [varchar](10) NULL,
	[domination] [decimal](18, 6) NULL,
	[transferId] [varchar](60) NULL,
	[game_win] [numeric](18, 6) NULL,
	[free_spin_index] [int] NULL,
	[remaining_count] [int] NULL,
	[base_id] [bigint] NULL,
	[bonus_round_multiplyer] [tinyint] NULL,
	[free_multiply_index] [int] NULL,
	[merchant_code] [varchar](10) NULL,
	[login_id] [varchar](50) NULL,
	[retain_wild_index] [varchar](256) NULL,
	[credit] [decimal](18, 6) NULL,
	[spin_count] [int] NULL,
	[spin_sequence] [int] NULL,
	[src_type] [tinyint] NULL,
	[promotion_log_id] [bigint] NULL,
	[promotion_status] [tinyint] NULL,
	[symbols_win] [varchar](1024) NULL,
	[logic_code] [varchar](10) NULL,
	[status] [tinyint] NOT NULL,
	[base_log_date] [datetime] NULL,
	[logic_json] [varchar](1024) NULL,
 CONSTRAINT [PK_game_slot_machine_game_log_archive] PRIMARY KEY CLUSTERED 
(
	[round_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_slot_machine_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_slot_machine_setting](
	[curr_id] [varchar](3) NOT NULL,
	[line_bet] [varchar](100) NOT NULL,
	[default_line_bet] [decimal](18, 2) NULL,
	[domination] [varchar](256) NULL,
	[default_domination] [decimal](18, 2) NULL,
	[line] [int] NOT NULL,
	[gamble_game_multiply] [varchar](30) NOT NULL,
	[game_code] [varchar](10) NOT NULL,
	[ways_credit] [varchar](100) NULL,
 CONSTRAINT [PK_game_slot_machine_setting] PRIMARY KEY CLUSTERED 
(
	[game_code] ASC,
	[curr_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_slot_machine_symbol_pay]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_slot_machine_symbol_pay](
	[pay_id] [smallint] IDENTITY(1001,1) NOT NULL,
	[symbol_id] [smallint] NOT NULL,
	[line_unit] [smallint] NOT NULL,
	[hits] [smallint] NOT NULL,
	[odd] [int] NULL,
	[table_type] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[pay_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game_slot_machine_symbol_ref]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game_slot_machine_symbol_ref](
	[symbol_id] [smallint] NOT NULL,
	[description] [varchar](20) NOT NULL,
	[probability] [smallint] NOT NULL,
	[odd_1] [smallint] NOT NULL,
	[odd_2] [smallint] NOT NULL,
	[odd_3] [smallint] NOT NULL,
	[odd_4] [smallint] NOT NULL,
	[odd_5] [smallint] NOT NULL,
	[is_wild] [bit] NOT NULL,
	[is_bonus] [bit] NOT NULL,
	[is_scatter] [bit] NOT NULL,
	[min_amount] [decimal](18, 6) NOT NULL,
	[game_code] [varchar](10) NOT NULL,
	[replace_by_wild] [bit] NULL,
	[combination_code] [int] NULL,
	[wild_type] [int] NULL,
	[replaceble_symbol] [varchar](50) NULL,
 CONSTRAINT [PK_game_slot_machine_symbol_ref] PRIMARY KEY CLUSTERED 
(
	[symbol_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[jackpot_info]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[jackpot_info](
	[jackpot_code] [varchar](20) NOT NULL,
	[jackpot_name] [varchar](50) NULL,
	[draw_type] [tinyint] NULL,
	[cut_off_limit_s] [decimal](18, 6) NULL,
	[cut_off_limit_m] [decimal](18, 6) NULL,
	[cut_off_limit_l] [decimal](18, 6) NULL,
	[cut_off_limit_xl] [decimal](18, 6) NULL,
	[cut_off_limit_xxl] [decimal](18, 6) NULL,
	[cut_off_limit_s_contrib] [decimal](18, 6) NULL,
	[cut_off_limit_m_contrib] [decimal](18, 6) NULL,
	[cut_off_limit_l_contrib] [decimal](18, 6) NULL,
	[cut_off_limit_xl_contrib] [decimal](18, 6) NULL,
	[cut_off_limit_xxl_contrib] [decimal](18, 6) NULL,
	[default_game_payout] [decimal](4, 2) NULL,
	[default_capital] [decimal](18, 6) NULL,
	[games_max_lose_limit] [decimal](18, 6) NULL,
	[is_limit] [bit] NULL,
	[is_rng] [bit] NULL,
	[logic_code] [varchar](20) NULL,
 CONSTRAINT [PK_jackpot_info] PRIMARY KEY CLUSTERED 
(
	[jackpot_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[jackpot_name]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[jackpot_name](
	[code] [varchar](20) NOT NULL,
	[en_name] [varchar](50) NULL,
	[cn_name] [varchar](50) NULL,
	[seq_en_names] [varchar](500) NULL,
	[seq_cn_names] [varchar](500) NULL,
	[logic_code] [varchar](20) NULL,
 CONSTRAINT [PK_jackpot_name] PRIMARY KEY CLUSTERED 
(
	[code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[jackpot_pools]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[jackpot_pools](
	[jackpot_code] [varchar](20) NOT NULL,
	[merchant_group] [varchar](10) NOT NULL,
	[curr_id] [varchar](3) NOT NULL,
	[jackpot_amt] [decimal](18, 6) NULL,
	[contribute_amt] [decimal](18, 6) NULL,
	[release_amt] [decimal](18, 6) NULL,
	[sequence] [tinyint] NOT NULL,
	[probability] [smallint] NULL,
	[min_amt] [decimal](18, 6) NULL,
	[max_amt] [decimal](18, 6) NULL,
	[min_bet] [decimal](18, 6) NULL,
	[contribute_percent] [decimal](6, 4) NULL,
	[bet_contribute_percent] [decimal](6, 4) NULL,
	[jackpot_type] [varchar](12) NULL,
	[compulsory] [bit] NULL,
	[pending_amt] [decimal](22, 10) NULL,
	[adj_contribute_amt] [decimal](22, 10) NULL,
 CONSTRAINT [PK_jackpot_pools] PRIMARY KEY CLUSTERED 
(
	[jackpot_code] ASC,
	[merchant_group] ASC,
	[curr_id] ASC,
	[sequence] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[limit_group]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[limit_group](
	[group_code] [varchar](10) NOT NULL,
	[group_desc] [varchar](50) NULL,
	[merchant_code] [varchar](30) NOT NULL,
	[is_active] [int] NULL,
	[created_by] [varchar](30) NULL,
	[created_date] [datetime] NULL,
	[updated_by] [varchar](30) NULL,
	[updated_date] [datetime] NULL,
 CONSTRAINT [PK_limit_group] PRIMARY KEY CLUSTERED 
(
	[group_code] ASC,
	[merchant_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 100) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[limit_group_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[limit_group_setting](
	[game_id] [varchar](10) NOT NULL,
	[currency] [varchar](10) NOT NULL,
	[min_bet] [decimal](18, 4) NULL,
	[max_bet] [decimal](18, 4) NULL,
	[merchant_code] [varchar](30) NOT NULL,
	[table_id] [varchar](3) NOT NULL,
	[max_spot_bet] [decimal](18, 6) NULL,
 CONSTRAINT [PK_limit_group_setting] PRIMARY KEY CLUSTERED 
(
	[game_id] ASC,
	[currency] ASC,
	[merchant_code] ASC,
	[table_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_bonus_credit_flush_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_bonus_credit_flush_log](
	[log_id] [bigint] IDENTITY(1,1) NOT NULL,
	[tran_id] [bigint] NULL,
	[promotion_id] [bigint] NULL,
	[merchant_code] [varchar](10) NOT NULL,
	[curr_id] [varchar](5) NOT NULL,
	[acct_id] [varchar](80) NULL,
	[ref_id] [varchar](50) NULL,
	[type] [varchar](10) NULL,
	[amount] [decimal](18, 6) NULL,
	[create_date] [datetime] NULL,
	[ticket_id] [bigint] NULL,
	[client_ip] [varchar](50) NULL,
 CONSTRAINT [PK_lucky_bonus_credit_flush_log] PRIMARY KEY CLUSTERED 
(
	[log_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_bonus_credit_tran]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_bonus_credit_tran](
	[tran_id] [bigint] IDENTITY(1,1) NOT NULL,
	[merchant_code] [varchar](10) NOT NULL,
	[curr_id] [varchar](5) NOT NULL,
	[begin_date] [datetime] NOT NULL,
	[end_date] [datetime] NOT NULL,
	[create_by] [varchar](50) NULL,
	[create_date] [datetime] NULL,
	[update_by] [varchar](50) NULL,
	[update_date] [datetime] NULL,
	[status] [tinyint] NULL,
	[fixed_amt] [bit] NULL,
	[cancel_by] [varchar](50) NULL,
	[cancel_date] [datetime] NULL,
	[bonus_amt] [numeric](18, 6) NULL,
	[bonus_count] [int] NULL,
	[release_amt] [numeric](18, 6) NULL,
	[release_count] [int] NULL,
	[bonus_min_amt] [numeric](18, 6) NULL,
	[bonus_max_amt] [numeric](18, 6) NULL,
	[allow_multi_bonus] [bit] NULL,
	[multiple_turnover] [int] NULL,
	[max_withdraw_amt] [numeric](18, 6) NULL,
	[buffer_time] [int] NULL,
	[game_list] [varchar](max) NULL,
	[excluded] [bit] NULL,
	[promotion_id] [bigint] NULL,
	[promotion_end_date] [datetime] NULL,
	[site_list] [varchar](5000) NULL,
 CONSTRAINT [PK_lucky_bonus_credit_tran] PRIMARY KEY CLUSTERED 
(
	[tran_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_bonus_credit_tran_fixed_item]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_bonus_credit_tran_fixed_item](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[tran_id] [bigint] NOT NULL,
	[qty] [int] NOT NULL,
	[amt] [numeric](18, 0) NOT NULL,
	[release_count] [int] NULL,
	[release_amt] [numeric](18, 6) NULL,
	[status] [bit] NOT NULL,
	[create_by] [varchar](50) NULL,
	[create_date] [datetime] NULL,
 CONSTRAINT [PK_lucky_bonus_credit_tran_fixed_item] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_bonus_credit_tran_item]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_bonus_credit_tran_item](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[tran_id] [bigint] NOT NULL,
	[lucky_amt] [numeric](18, 6) NOT NULL,
	[lucky_count] [int] NOT NULL,
	[release_amt] [numeric](18, 6) NULL,
	[release_count] [int] NULL,
	[bonus_min_amt] [numeric](18, 6) NULL,
	[bonus_max_amt] [numeric](18, 6) NULL,
	[status] [bit] NOT NULL,
	[create_by] [varchar](50) NULL,
	[create_date] [datetime] NULL,
	[draw_amts] [varchar](max) NULL,
	[promotion_id] [bigint] NULL,
 CONSTRAINT [PK_lucky_bonus_credit_tran_item] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_bonus_credit_tran_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_bonus_credit_tran_log](
	[tran_id] [bigint] NOT NULL,
	[lucky_item_id] [bigint] NOT NULL,
	[merchant_code] [varchar](10) NULL,
	[curr_id] [varchar](5) NULL,
	[acct_id] [varchar](80) NOT NULL,
	[reference_id] [varchar](30) NOT NULL,
	[create_date] [datetime] NULL,
	[lucky_amt] [numeric](18, 6) NULL,
	[serial_no] [varchar](32) NULL,
	[login_id] [varchar](60) NULL,
	[client_ip] [varchar](50) NULL,
	[transaction_id] [varchar](36) NULL,
	[status] [int] NULL,
	[rolling] [numeric](18, 6) NULL,
	[target_turnover] [numeric](18, 6) NULL,
	[promotion_id] [bigint] NULL,
 CONSTRAINT [PK_lucky_bonus_credit_tran_log] PRIMARY KEY CLUSTERED 
(
	[tran_id] ASC,
	[acct_id] ASC,
	[reference_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_challenge]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_challenge](
	[tran_id] [bigint] IDENTITY(1,1) NOT NULL,
	[promotion_id] [bigint] NULL,
	[merchant_list] [varchar](max) NULL,
	[curr_list] [varchar](1000) NULL,
	[begin_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[status] [tinyint] NULL,
	[lucky_count] [int] NULL,
	[init_second] [int] NULL,
	[payment] [int] NULL,
	[examine] [bit] NULL,
	[examine_date] [datetime] NULL,
	[examine_by] [varchar](50) NULL,
	[examine_status] [tinyint] NULL,
	[prize_send_status] [bit] NULL,
	[default_rate] [bit] NULL,
	[rate] [varchar](max) NULL,
	[total_prize_amt] [numeric](18, 0) NULL,
	[total_prize_rank] [int] NULL,
	[proceed_payment] [bit] NULL,
	[proceed_by] [varchar](50) NULL,
	[proceed_date] [datetime] NULL,
	[buffer_time] [int] NULL,
	[buffer_date] [datetime] NULL,
	[auto_proceed_time] [int] NULL,
	[auto_proceed_date] [datetime] NULL,
	[create_date] [datetime] NULL,
	[create_by] [varchar](50) NULL,
	[cancel_date] [datetime] NULL,
	[cancel_by] [varchar](50) NULL,
	[update_date] [datetime] NULL,
	[update_by] [varchar](50) NULL,
	[site_list] [varchar](5000) NULL,
	[manual_merchant_list] [varchar](max) NULL,
 CONSTRAINT [PK_lucky_challenge] PRIMARY KEY CLUSTERED 
(
	[tran_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_challenge_award]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_challenge_award](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[tran_id] [bigint] NOT NULL,
	[prize_amount] [numeric](18, 0) NULL,
	[prize_qty] [int] NULL,
	[rank] [int] NULL,
	[status] [bit] NULL,
 CONSTRAINT [PK_lucky_challenge_award] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_challenge_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_challenge_log](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[tran_id] [bigint] NULL,
	[merchant_code] [varchar](10) NULL,
	[curr_id] [varchar](5) NULL,
	[acct_id] [varchar](80) NULL,
	[login_id] [varchar](70) NULL,
	[client_ip] [varchar](50) NULL,
	[channel] [varchar](10) NULL,
	[distance] [numeric](18, 6) NULL,
	[rate] [numeric](18, 6) NULL,
	[bonus] [numeric](18, 2) NULL,
	[rank] [int] NULL,
	[status] [tinyint] NULL,
	[ticket_id] [bigint] NULL,
	[ticket_date] [datetime] NULL,
	[create_date] [datetime] NULL,
	[win_amt] [numeric](18, 6) NULL,
	[begin_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[promotion_id] [bigint] NULL,
 CONSTRAINT [PK_lucky_challenge_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_challenge_rank]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_challenge_rank](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[tran_id] [bigint] NULL,
	[merchant_code] [varchar](10) NULL,
	[curr_id] [varchar](5) NULL,
	[acct_id] [varchar](80) NULL,
	[login_id] [varchar](70) NULL,
	[client_ip] [varchar](50) NULL,
	[channel] [varchar](10) NULL,
	[distance] [numeric](18, 6) NULL,
	[rate] [numeric](18, 6) NULL,
	[create_date] [datetime] NULL,
	[win_amt] [numeric](18, 6) NULL,
	[promotion_id] [bigint] NULL,
 CONSTRAINT [PK_lucky_challenge_rank] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_challenge_rate]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_challenge_rate](
	[tran_id] [bigint] NOT NULL,
	[curr_id] [varchar](10) NOT NULL,
	[curr_rate] [numeric](18, 6) NULL,
	[real_curr_rate] [numeric](18, 6) NULL,
 CONSTRAINT [PK_lucky_challenge_rate] PRIMARY KEY CLUSTERED 
(
	[tran_id] ASC,
	[curr_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_challenge_rate_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_challenge_rate_log](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[tran_id] [bigint] NULL,
	[curr_id] [varchar](10) NULL,
	[before_curr_rate] [numeric](18, 6) NULL,
	[after_curr_rate] [numeric](18, 6) NULL,
	[before_real_curr_rate] [numeric](18, 6) NULL,
	[after_real_curr_rate] [numeric](18, 6) NULL,
	[create_date] [datetime] NULL,
	[create_by] [varchar](50) NULL,
 CONSTRAINT [PK_lucky_challenge_rate_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_challenge_robot_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_challenge_robot_setting](
	[acct_id] [varchar](80) NOT NULL,
	[tran_id] [bigint] NOT NULL,
	[login_id] [varchar](70) NULL,
	[win_amt] [varchar](70) NULL,
	[curr_id] [varchar](10) NULL,
	[points] [decimal](18, 6) NULL,
	[status] [bit] NULL,
	[create_date] [datetime] NULL,
	[create_by] [varchar](80) NULL,
	[type] [int] NULL,
	[min] [decimal](18, 6) NULL,
	[max] [decimal](18, 6) NULL,
	[multiplier] [decimal](18, 6) NULL,
	[max_points] [decimal](18, 6) NULL,
	[over_max_points] [bit] NULL,
 CONSTRAINT [PK_lucky_challenge_robot_setting] PRIMARY KEY CLUSTERED 
(
	[acct_id] ASC,
	[tran_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_draw]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_draw](
	[lucky_draw_id] [bigint] IDENTITY(1,1) NOT NULL,
	[lucky_draw_name] [varchar](50) NULL,
	[description] [varchar](100) NULL,
	[lucky_draw_type] [varchar](50) NULL,
	[img_url] [varchar](100) NULL,
 CONSTRAINT [PK_lucky_draw] PRIMARY KEY CLUSTERED 
(
	[lucky_draw_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_draw_config]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_draw_config](
	[tran_id] [bigint] NOT NULL,
	[merchant_code] [varchar](10) NOT NULL,
	[curr_id] [varchar](10) NOT NULL,
	[lucky_count] [int] NULL,
	[release_count] [int] NULL,
	[lucky_amt] [decimal](18, 6) NULL,
	[release_amt] [decimal](18, 6) NULL,
	[status] [bit] NULL,
	[draw_amts] [varchar](max) NULL,
 CONSTRAINT [PK_lucky_draw_config] PRIMARY KEY CLUSTERED 
(
	[tran_id] ASC,
	[merchant_code] ASC,
	[curr_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_draw_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_draw_log](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[lucky_draw_id] [bigint] NULL,
	[tran_id] [bigint] NULL,
	[merchant_code] [varchar](10) NULL,
	[curr_id] [varchar](10) NULL,
	[acct_id] [varchar](80) NULL,
	[game_code] [varchar](10) NULL,
	[draw_time] [datetime] NULL,
	[lucky_amt] [decimal](18, 4) NULL,
	[channel] [varchar](10) NULL,
	[login_id] [varchar](60) NULL,
	[client_ip] [varchar](50) NULL,
	[category] [varchar](5) NULL,
	[begin_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[promotion_id] [bigint] NULL,
 CONSTRAINT [PK_LUCKY_DRAW_LOG] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_draw_tran]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_draw_tran](
	[tran_id] [bigint] IDENTITY(1,1) NOT NULL,
	[merchant_code] [varchar](10) NULL,
	[curr_id] [varchar](5) NULL,
	[lucky_draw_id] [bigint] NULL,
	[begin_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[probability] [int] NULL,
	[create_by] [varchar](50) NULL,
	[create_date] [datetime] NULL,
	[update_by] [varchar](50) NULL,
	[update_date] [datetime] NULL,
	[lucky_amt] [decimal](18, 4) NULL,
	[lucky_count] [int] NULL,
	[release_amt] [decimal](18, 4) NULL,
	[release_count] [int] NULL,
	[game_list] [varchar](3000) NULL,
	[status] [tinyint] NULL,
	[turnover] [decimal](18, 4) NULL,
	[draw_min_amt] [decimal](18, 4) NULL,
	[draw_max_amt] [decimal](18, 4) NULL,
	[draw_amts] [varchar](max) NULL,
	[cancel_by] [varchar](50) NULL,
	[cancel_date] [datetime] NULL,
	[count_down] [int] NULL,
	[accumulate_time] [int] NULL,
	[ip_control] [int] NULL,
	[fixedAmt] [bit] NULL,
	[site_list] [varchar](5000) NULL,
	[promotion_id] [bigint] NULL,
	[accumulate_date] [datetime] NULL,
	[included_downline] [bit] NULL,
	[merchant_downline] [varchar](max) NULL,
	[random_count] [bit] NULL,
	[total_reward] [numeric](18, 6) NULL,
	[total_unit] [int] NULL,
	[lucky_max_amt] [numeric](18, 6) NULL,
 CONSTRAINT [PK_lucky_draw_tran] PRIMARY KEY CLUSTERED 
(
	[tran_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_draw_tran_item]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_draw_tran_item](
	[id] [bigint] IDENTITY(1000,1) NOT NULL,
	[amt] [numeric](18, 6) NULL,
	[qty] [int] NULL,
	[tran_id] [bigint] NULL,
	[release_count] [int] NULL,
	[release_amt] [decimal](18, 4) NULL,
	[merchant_code] [varchar](10) NULL,
	[curr_id] [varchar](10) NULL,
 CONSTRAINT [PK_red_packet_item] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_draw_tran_spin]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_draw_tran_spin](
	[merchant_code] [varchar](10) NOT NULL,
	[curr_id] [varchar](10) NOT NULL,
	[game_code] [varchar](10) NOT NULL,
	[acct_id] [varchar](70) NOT NULL,
	[login_id] [varchar](50) NULL,
	[tran_date] [datetime] NULL,
	[tran_id] [bigint] NOT NULL,
	[bet_amt] [numeric](18, 6) NULL,
	[bet_count] [int] NULL,
	[end_date] [datetime] NULL,
 CONSTRAINT [PK_lucky_draw_tran_spin] PRIMARY KEY CLUSTERED 
(
	[merchant_code] ASC,
	[curr_id] ASC,
	[acct_id] ASC,
	[tran_id] ASC,
	[game_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_fish_tournament]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_fish_tournament](
	[tran_id] [bigint] IDENTITY(1,1) NOT NULL,
	[promotion_id] [bigint] NULL,
	[merchant_list] [varchar](max) NULL,
	[curr_list] [varchar](1000) NULL,
	[begin_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[status] [tinyint] NULL,
	[lucky_count] [int] NULL,
	[countdown_second] [int] NULL,
	[payment] [int] NULL,
	[examine] [bit] NULL,
	[examine_date] [datetime] NULL,
	[examine_by] [varchar](50) NULL,
	[examine_status] [tinyint] NULL,
	[prize_send_status] [bit] NULL,
	[default_rate] [bit] NULL,
	[rate] [varchar](max) NULL,
	[name_en] [varchar](50) NULL,
	[name_cn] [varchar](50) NULL,
	[total_prize_amt] [numeric](18, 0) NULL,
	[total_prize_rank] [int] NULL,
	[proceed_payment] [bit] NULL,
	[proceed_by] [varchar](50) NULL,
	[proceed_date] [datetime] NULL,
	[limit_minimum] [bit] NULL,
	[minnimum] [numeric](18, 6) NULL,
	[min_bet_str] [varchar](3000) NULL,
	[countdown] [int] NULL,
	[countdown_date] [datetime] NULL,
	[buffer_time] [int] NULL,
	[buffer_date] [datetime] NULL,
	[auto_proceed_time] [int] NULL,
	[auto_proceed_date] [datetime] NULL,
	[create_date] [datetime] NULL,
	[create_by] [varchar](50) NULL,
	[cancel_date] [datetime] NULL,
	[cancel_by] [varchar](50) NULL,
	[update_date] [datetime] NULL,
	[update_by] [varchar](50) NULL,
	[site_list] [varchar](5000) NULL,
	[game_list] [varchar](5000) NULL,
	[excluded] [bit] NULL,
	[room_list] [varchar](30) NULL,
	[manual_merchant_list] [varchar](max) NULL,
 CONSTRAINT [PK_lucky_fish_tournament] PRIMARY KEY CLUSTERED 
(
	[tran_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_fish_tournament_award]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_fish_tournament_award](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[tran_id] [bigint] NOT NULL,
	[prize_name_en] [varchar](50) NULL,
	[prize_name_cn] [varchar](50) NULL,
	[prize_amount] [numeric](18, 0) NULL,
	[prize_qty] [int] NULL,
	[rank] [int] NULL,
	[status] [bit] NULL,
 CONSTRAINT [PK_lucky_fish_tournament_award] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_fish_tournament_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_fish_tournament_log](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[tran_id] [bigint] NULL,
	[merchant_code] [varchar](10) NULL,
	[curr_id] [varchar](5) NULL,
	[acct_id] [varchar](80) NULL,
	[login_id] [varchar](70) NULL,
	[client_ip] [varchar](50) NULL,
	[channel] [varchar](10) NULL,
	[turnover] [numeric](18, 6) NULL,
	[turnover_before_exchange] [numeric](18, 6) NULL,
	[rate] [numeric](18, 6) NULL,
	[origin_rate] [numeric](18, 6) NULL,
	[bonus] [numeric](18, 2) NULL,
	[rank] [int] NULL,
	[status] [tinyint] NULL,
	[ticket_id] [bigint] NULL,
	[ticket_date] [datetime] NULL,
	[create_date] [datetime] NULL,
	[prize_name_en] [varchar](50) NULL,
	[prize_name_cn] [varchar](50) NULL,
	[begin_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[promotion_id] [bigint] NULL,
 CONSTRAINT [PK_lucky_fish_tournament_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_fish_tournament_rank]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_fish_tournament_rank](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[tran_id] [bigint] NULL,
	[merchant_code] [varchar](10) NULL,
	[curr_id] [varchar](5) NULL,
	[acct_id] [varchar](80) NULL,
	[login_id] [varchar](70) NULL,
	[client_ip] [varchar](50) NULL,
	[channel] [varchar](10) NULL,
	[turnover] [numeric](18, 6) NULL,
	[turnover_before_exchange] [numeric](18, 6) NULL,
	[rate] [numeric](18, 6) NULL,
	[origin_rate] [numeric](18, 6) NULL,
	[create_date] [datetime] NULL,
	[promotion_id] [bigint] NULL,
 CONSTRAINT [PK_lucky_fish_tournament_rank] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_fish_tournament_rate]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_fish_tournament_rate](
	[tran_id] [bigint] NOT NULL,
	[curr_id] [varchar](10) NOT NULL,
	[curr_rate] [numeric](18, 6) NULL,
	[real_curr_rate] [numeric](18, 6) NULL,
 CONSTRAINT [PK_lucky_fish_tournament_rate] PRIMARY KEY CLUSTERED 
(
	[tran_id] ASC,
	[curr_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_fish_tournament_rate_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_fish_tournament_rate_log](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[tran_id] [bigint] NULL,
	[curr_id] [varchar](10) NULL,
	[before_curr_rate] [numeric](18, 6) NULL,
	[after_curr_rate] [numeric](18, 6) NULL,
	[before_real_curr_rate] [numeric](18, 6) NULL,
	[after_real_curr_rate] [numeric](18, 6) NULL,
	[create_date] [datetime] NULL,
	[create_by] [varchar](50) NULL,
 CONSTRAINT [PK_lucky_fish_tournament_rate_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_fish_tournament_robot_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_fish_tournament_robot_setting](
	[acct_id] [varchar](80) NOT NULL,
	[tran_id] [bigint] NOT NULL,
	[login_id] [varchar](70) NULL,
	[curr_id] [varchar](10) NULL,
	[points] [decimal](18, 6) NULL,
	[status] [bit] NULL,
	[create_date] [datetime] NULL,
	[create_by] [varchar](80) NULL,
	[type] [int] NULL,
	[min] [decimal](18, 6) NULL,
	[max] [decimal](18, 6) NULL,
	[multiplier] [decimal](18, 6) NULL,
	[max_points] [decimal](18, 6) NULL,
	[over_max_points] [bit] NULL,
 CONSTRAINT [PK_lucky_fish_tournament_robot_setting] PRIMARY KEY CLUSTERED 
(
	[acct_id] ASC,
	[tran_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_free_spin]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_free_spin](
	[tran_id] [bigint] IDENTITY(1,1) NOT NULL,
	[begin_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[merchant_code] [varchar](10) NULL,
	[curr_id] [varchar](10) NULL,
	[promotion_id] [bigint] NULL,
	[max_buffer_time] [datetime] NULL,
	[merchant_downline] [varchar](max) NULL,
	[type] [int] NULL,
	[total_reward] [numeric](18, 6) NULL,
	[total_unit] [int] NULL,
 CONSTRAINT [PK_lucky_free_spin] PRIMARY KEY CLUSTERED 
(
	[tran_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_free_spin_acct_group]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_free_spin_acct_group](
	[tran_id] [bigint] NOT NULL,
	[login_id] [varchar](80) NULL,
	[acct_id] [varchar](100) NOT NULL,
	[promotion_group] [int] NOT NULL,
	[status] [bit] NULL,
 CONSTRAINT [PK_lucky_free_spin_acct_group] PRIMARY KEY CLUSTERED 
(
	[tran_id] ASC,
	[acct_id] ASC,
	[promotion_group] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_free_spin_config]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_free_spin_config](
	[tran_id] [bigint] NOT NULL,
	[merchant_code] [varchar](10) NOT NULL,
	[promotion_code] [varchar](10) NOT NULL,
	[promotion_group] [int] NOT NULL,
	[curr_id] [varchar](10) NOT NULL,
	[lucky_count] [int] NULL,
	[release_count] [int] NULL,
	[status] [bit] NULL,
 CONSTRAINT [PK_lucky_free_spin_config] PRIMARY KEY CLUSTERED 
(
	[tran_id] ASC,
	[merchant_code] ASC,
	[promotion_code] ASC,
	[promotion_group] ASC,
	[curr_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_free_spin_game_config]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_free_spin_game_config](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[tran_id] [bigint] NULL,
	[promotion_group] [int] NULL,
	[promotion_code] [varchar](10) NULL,
	[game_code] [varchar](10) NULL,
	[free_spin_no] [int] NULL,
	[cost_per_bet] [numeric](18, 6) NULL,
	[percentage] [int] NULL,
	[empty_card] [bit] NULL,
	[lines] [int] NULL,
	[free_spin_index] [int] NULL,
	[credit] [numeric](18, 6) NULL,
	[multiple] [varchar](2000) NULL,
	[line_bet] [numeric](18, 6) NULL,
	[bet_cost] [numeric](18, 6) NULL,
	[game_reward_count] [int] NULL,
	[game_release_count] [int] NULL,
	[random_type] [int] NULL,
 CONSTRAINT [PK_lucky_free_spin_game_config] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_free_spin_integral]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_free_spin_integral](
	[tran_id] [bigint] NOT NULL,
	[acct_id] [varchar](80) NOT NULL,
	[type] [varchar](10) NOT NULL,
	[login_id] [varchar](60) NULL,
	[merchant_code] [varchar](10) NULL,
	[curr_id] [varchar](10) NULL,
	[total_amt] [decimal](18, 4) NULL,
	[spin_amt] [decimal](18, 4) NULL,
	[spin_count] [int] NULL,
	[create_date] [datetime] NULL,
	[latest_update_date] [datetime] NULL,
 CONSTRAINT [PK_lucky_free_spin_integral] PRIMARY KEY CLUSTERED 
(
	[type] ASC,
	[tran_id] ASC,
	[acct_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_free_spin_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_free_spin_log](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[tran_id] [bigint] NULL,
	[game_code] [varchar](10) NULL,
	[begin_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[merchant_code] [varchar](10) NULL,
	[curr_id] [varchar](10) NULL,
	[acct_id] [varchar](100) NULL,
	[free_spin_no] [int] NULL,
	[completed_spin_no] [int] NULL,
	[create_date] [datetime] NULL,
	[forfeit_date] [datetime] NULL,
	[status] [int] NULL,
	[promotion_group] [int] NULL,
	[promotion_code] [varchar](10) NULL,
	[client_ip] [varchar](50) NULL,
	[game_win] [numeric](18, 6) NULL,
	[domination] [decimal](18, 6) NULL,
	[lines] [int] NULL,
	[credit] [decimal](18, 6) NULL,
	[line_bet] [decimal](18, 6) NULL,
	[total_bet_amt] [decimal](18, 6) NULL,
	[promotion_status] [int] NULL,
	[total_spin_no] [int] NULL,
	[draw_amt] [decimal](18, 6) NULL,
	[login_id] [varchar](70) NULL,
	[promotion_id] [bigint] NULL,
 CONSTRAINT [PK_lucky_free_spin_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_free_spin_refill_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_free_spin_refill_log](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[tran_id] [bigint] NULL,
	[promotion_group] [int] NULL,
	[promotion_code] [varchar](10) NULL,
	[total_reward_count] [int] NULL,
	[remaining_count] [int] NULL,
	[refill_count] [int] NULL,
	[current_count] [int] NULL,
	[release_count] [int] NULL,
	[original_player] [varchar](max) NULL,
	[refill_player] [varchar](max) NULL,
	[refill_by] [varchar](50) NULL,
	[refill_date] [datetime] NULL,
 CONSTRAINT [PK_lucky_free_spin_refill_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_free_spin_reward_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_free_spin_reward_log](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[tran_id] [bigint] NULL,
	[before_reward] [int] NULL,
	[after_reward] [int] NULL,
	[update_by] [varchar](50) NULL,
	[update_date] [datetime] NULL,
 CONSTRAINT [PK_lucky_free_spin_reward_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_free_spin_sub]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_free_spin_sub](
	[tran_id] [bigint] NOT NULL,
	[promotion_code] [varchar](10) NOT NULL,
	[promotion_group] [int] NOT NULL,
	[begin_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[merchant_code] [varchar](10) NULL,
	[curr_id] [varchar](10) NULL,
	[forfeit_date] [datetime] NULL,
	[buffer_time] [int] NULL,
	[control_ip] [bit] NULL,
	[reward_count] [int] NULL,
	[release_count] [int] NULL,
	[max_ticket_payout] [numeric](18, 6) NULL,
	[est_max_payout] [numeric](18, 6) NULL,
	[status] [int] NULL,
	[create_by] [varchar](50) NULL,
	[create_date] [datetime] NULL,
	[approved_by] [varchar](50) NULL,
	[approved_date] [datetime] NULL,
	[cancel_by] [varchar](50) NULL,
	[cancel_date] [datetime] NULL,
	[update_by] [varchar](50) NULL,
	[update_date] [datetime] NULL,
	[game_list] [varchar](max) NULL,
	[combination] [int] NULL,
	[turnover] [numeric](18, 6) NULL,
	[wl_amt] [numeric](18, 6) NULL,
	[promotion_end_date] [datetime] NULL,
	[free_spin_config] [varchar](max) NULL,
	[site_list] [varchar](5000) NULL,
	[total_begin_date] [datetime] NULL,
	[total_end_date] [datetime] NULL,
	[excluded] [bit] NULL,
	[promotion_id] [bigint] NULL,
	[create_by_admin] [bit] NULL,
	[free_spin_percentage] [varchar](max) NULL,
	[term] [int] NULL,
	[total_amt] [numeric](18, 6) NULL,
	[scheduler_time] [int] NULL,
	[scheduler_type] [int] NULL,
	[last_scheduler_time] [datetime] NULL,
	[scheduler_process] [int] NULL,
	[name_en] [varchar](50) NULL,
	[name_cn] [varchar](50) NULL,
	[max_buffer_time] [datetime] NULL,
	[forfeit] [bit] NULL,
	[merchant_downline] [varchar](max) NULL,
	[type] [int] NULL,
	[config_random_type] [int] NULL,
	[included_downline] [bit] NULL,
	[random_count] [bit] NULL,
	[total_reward] [numeric](18, 6) NULL,
	[total_unit] [int] NULL,
 CONSTRAINT [PK_lucky_free_spin_sub] PRIMARY KEY CLUSTERED 
(
	[tran_id] ASC,
	[promotion_code] ASC,
	[promotion_group] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_merchant_promotion_blacklist]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_merchant_promotion_blacklist](
	[promotion_id] [bigint] NOT NULL,
	[promotion_code] [varchar](10) NOT NULL,
	[merchant_code] [varchar](10) NULL,
	[curr_id] [varchar](10) NULL,
	[acct_id] [varchar](100) NOT NULL,
	[login_id] [varchar](100) NULL,
 CONSTRAINT [PK_lucky_merchant_promotion_blacklist] PRIMARY KEY CLUSTERED 
(
	[promotion_id] ASC,
	[promotion_code] ASC,
	[acct_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_packet]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_packet](
	[tran_id] [bigint] IDENTITY(1,1) NOT NULL,
	[merchant_code] [varchar](10) NULL,
	[curr_id] [varchar](5) NULL,
	[begin_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[status] [int] NULL,
	[type] [int] NULL,
	[control_level] [int] NULL,
	[lucky_count] [int] NULL,
	[release_amt] [decimal](18, 4) NULL,
	[release_count] [int] NULL,
	[game_list] [varchar](max) NULL,
	[control_ip] [int] NULL,
	[site_list] [varchar](max) NULL,
	[merchant_downline] [varchar](max) NULL,
	[promotion_id] [bigint] NULL,
	[count_down] [int] NULL,
	[accumulate_date] [datetime] NULL,
	[turnover] [varchar](500) NULL,
	[create_by] [varchar](50) NULL,
	[create_date] [datetime] NULL,
	[update_by] [varchar](50) NULL,
	[update_date] [datetime] NULL,
	[apply_by] [varchar](50) NULL,
	[apply_date] [datetime] NULL,
	[cancel_by] [varchar](50) NULL,
	[cancel_date] [datetime] NULL,
	[lucky_max_amt] [numeric](18, 6) NULL,
	[total_reward] [numeric](18, 6) NULL,
	[total_unit] [int] NULL,
 CONSTRAINT [PK_lucky_packet] PRIMARY KEY CLUSTERED 
(
	[tran_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_packet_config]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_packet_config](
	[tran_id] [bigint] NOT NULL,
	[merchant_code] [varchar](10) NOT NULL,
	[curr_id] [varchar](5) NOT NULL,
	[lucky_count] [int] NULL,
	[release_amt] [decimal](18, 4) NULL,
	[release_count] [int] NULL,
 CONSTRAINT [PK_lucky_packet_config] PRIMARY KEY CLUSTERED 
(
	[tran_id] ASC,
	[merchant_code] ASC,
	[curr_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_packet_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_packet_log](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[tran_id] [bigint] NULL,
	[merchant_code] [varchar](10) NULL,
	[curr_id] [varchar](5) NULL,
	[acct_id] [varchar](80) NULL,
	[login_id] [varchar](60) NULL,
	[game_code] [varchar](10) NULL,
	[create_date] [datetime] NULL,
	[lucky_amt] [decimal](18, 4) NULL,
	[level] [int] NULL,
	[turnover] [decimal](18, 4) NULL,
	[channel] [varchar](10) NULL,
	[client_ip] [varchar](50) NULL,
	[game_category] [varchar](5) NULL,
	[promotion_id] [bigint] NULL,
 CONSTRAINT [PK_lucky_packet_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_packet_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_packet_setting](
	[tran_id] [bigint] NOT NULL,
	[level] [int] NOT NULL,
	[turnover] [decimal](18, 4) NULL,
	[min_amt] [decimal](18, 4) NULL,
	[max_amt] [decimal](18, 4) NULL,
	[fix_amts] [varchar](max) NULL,
 CONSTRAINT [PK_lucky_packet_setting] PRIMARY KEY CLUSTERED 
(
	[tran_id] ASC,
	[level] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_promotion_blacklist]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_promotion_blacklist](
	[acct_id] [varchar](100) NOT NULL,
	[promotion_id] [bigint] NOT NULL,
	[merchant_code] [varchar](10) NULL,
	[curr_id] [varchar](10) NULL,
	[status] [bit] NULL,
	[login_id] [varchar](100) NULL,
 CONSTRAINT [PK_lucky_promotion_blacklist] PRIMARY KEY CLUSTERED 
(
	[acct_id] ASC,
	[promotion_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_tournament]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_tournament](
	[tran_id] [bigint] IDENTITY(1,1) NOT NULL,
	[begin_date] [datetime] NOT NULL,
	[end_date] [datetime] NOT NULL,
	[merchant_code] [varchar](10) NOT NULL,
	[curr_id] [varchar](10) NOT NULL,
	[promotion_id] [bigint] NULL,
	[merchant_list] [varchar](max) NULL,
	[tournament_mode] [int] NULL,
	[default_rate] [bit] NULL,
	[tournament_rate] [varchar](5000) NULL,
	[countdown] [datetime] NULL,
	[buffer_zone] [datetime] NULL,
	[cp_tran_id] [bigint] NULL,
 CONSTRAINT [PK_lucky_tournament] PRIMARY KEY CLUSTERED 
(
	[tran_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_tournament_award]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_tournament_award](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[tran_id] [bigint] NOT NULL,
	[game_code] [varchar](10) NOT NULL,
	[prize_name_en] [varchar](50) NULL,
	[prize_name_cn] [varchar](50) NULL,
	[prize_amount] [numeric](18, 0) NULL,
	[prize_qty] [int] NULL,
	[rank] [int] NULL,
	[status] [bit] NULL,
 CONSTRAINT [PK_lucky_tournament_award] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_tournament_currency]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_tournament_currency](
	[promotion_id] [bigint] NOT NULL,
	[curr_id] [varchar](10) NOT NULL,
	[min_bet_amt] [numeric](18, 6) NULL,
 CONSTRAINT [PK_lucky_tournament_currency] PRIMARY KEY CLUSTERED 
(
	[promotion_id] ASC,
	[curr_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_tournament_integral_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_tournament_integral_log](
	[tran_id] [bigint] NOT NULL,
	[acct_id] [varchar](80) NOT NULL,
	[status] [int] NULL,
	[login_id] [varchar](60) NULL,
	[merchant_code] [varchar](10) NULL,
	[turnover_amt] [decimal](18, 4) NULL,
	[wl_amt] [decimal](18, 4) NULL,
	[multiple] [decimal](18, 4) NULL,
	[create_date] [datetime] NULL,
	[latest_update_date] [datetime] NULL,
	[military] [varchar](10) NULL,
	[civil] [varchar](10) NULL,
	[min_bet_amt] [decimal](18, 6) NULL,
	[origin_rate] [decimal](18, 6) NULL,
	[tournament_rate] [decimal](18, 6) NULL,
	[curr_id] [varchar](10) NULL,
	[id] [varchar](100) NOT NULL,
	[military_ticket_id] [bigint] NULL,
	[civil_ticket_id] [bigint] NULL,
 CONSTRAINT [PK_lucky_tournament_integral_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_tournament_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_tournament_log](
	[id] [bigint] IDENTITY(1000,1) NOT NULL,
	[tournament_id] [bigint] NULL,
	[merchant_code] [varchar](10) NULL,
	[acct_id] [varchar](80) NULL,
	[tournament_game_code] [varchar](20) NULL,
	[curr_id] [varchar](5) NULL,
	[ticket_id] [bigint] NULL,
	[bet_amt] [numeric](18, 6) NULL,
	[wl_amt] [numeric](18, 6) NULL,
	[win_amt] [numeric](18, 6) NULL,
	[multiple] [numeric](18, 2) NULL,
	[bonus] [numeric](18, 2) NULL,
	[ranking] [int] NULL,
	[created_date] [datetime] NULL,
	[status] [tinyint] NULL,
	[ticket_date] [datetime] NULL,
	[reference_id] [bigint] NULL,
	[round_id] [bigint] NULL,
	[client_ip] [varchar](50) NULL,
	[base_log_id] [bigint] NULL,
	[game_code] [varchar](10) NULL,
	[prize_name_en] [varchar](50) NULL,
	[prize_name_cn] [varchar](50) NULL,
	[category] [varchar](10) NULL,
	[tournament_rate] [numeric](18, 6) NULL,
	[tournament_mode] [int] NULL,
	[wl_amt_before_exchange] [numeric](18, 6) NULL,
	[win_amt_before_exchange] [numeric](18, 6) NULL,
	[bet_amt_before_exchange] [numeric](18, 6) NULL,
	[min_bet_amt] [numeric](18, 6) NULL,
	[login_id] [varchar](70) NULL,
	[cp_log_id] [bigint] NULL,
	[begin_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[promotion_id] [bigint] NULL,
 CONSTRAINT [PK_lucky_tournament_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_tournament_rank]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_tournament_rank](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[tran_id] [bigint] NULL,
	[tournament_game_code] [varchar](10) NULL,
	[acct_id] [varchar](80) NULL,
	[ticket_id] [bigint] NULL,
	[base_log_id] [bigint] NULL,
	[spin_id] [bigint] NULL,
	[bet_amt] [decimal](18, 6) NULL,
	[win_amt] [decimal](18, 6) NULL,
	[wl_amt] [decimal](18, 6) NULL,
	[multiple] [decimal](18, 6) NULL,
	[ticket_date] [datetime] NULL,
	[curr_id] [varchar](10) NULL,
	[game_code] [varchar](10) NULL,
	[create_date] [datetime] NULL,
	[client_ip] [varchar](50) NULL,
	[tournament_mode] [int] NULL,
	[tournament_rate] [decimal](18, 6) NULL,
	[origin_rate] [decimal](18, 6) NULL,
	[wl_amt_before_exchange] [decimal](18, 6) NULL,
	[win_amt_before_exchange] [decimal](18, 6) NULL,
	[bet_amt_before_exchange] [decimal](18, 6) NULL,
	[min_bet_amt] [decimal](18, 6) NULL,
	[login_id] [varchar](70) NULL,
	[merchant_code] [varchar](10) NULL,
 CONSTRAINT [PK_lucky_tournament_rank] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_tournament_rate]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_tournament_rate](
	[promotion_id] [bigint] NOT NULL,
	[curr_id] [varchar](10) NOT NULL,
	[curr_rate] [numeric](18, 6) NULL,
	[real_curr_rate] [numeric](18, 6) NULL,
 CONSTRAINT [PK_lucky_tournament_rate] PRIMARY KEY CLUSTERED 
(
	[promotion_id] ASC,
	[curr_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_tournament_rate_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_tournament_rate_log](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[promotion_id] [bigint] NULL,
	[curr_id] [varchar](10) NULL,
	[before_curr_rate] [numeric](18, 6) NULL,
	[after_curr_rate] [numeric](18, 6) NULL,
	[before_real_curr_rate] [numeric](18, 6) NULL,
	[after_real_curr_rate] [numeric](18, 6) NULL,
	[create_by] [varchar](50) NULL,
	[create_date] [datetime] NULL,
 CONSTRAINT [PK_lucky_tournament_rate_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_tournament_robot_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_tournament_robot_setting](
	[acct_id] [varchar](80) NOT NULL,
	[tran_id] [bigint] NOT NULL,
	[tournament_code] [varchar](10) NOT NULL,
	[login_id] [varchar](70) NULL,
	[curr_id] [varchar](10) NULL,
	[game_code] [varchar](10) NULL,
	[points] [decimal](18, 6) NULL,
	[status] [bit] NULL,
	[create_date] [datetime] NULL,
	[create_by] [varchar](80) NULL,
	[type] [int] NULL,
	[min] [decimal](18, 6) NULL,
	[max] [decimal](18, 6) NULL,
	[multiplier] [decimal](18, 6) NULL,
	[max_points] [decimal](18, 6) NULL,
	[over_max_points] [bit] NULL,
 CONSTRAINT [PK_lucky_tournament_robot_setting] PRIMARY KEY CLUSTERED 
(
	[acct_id] ASC,
	[tran_id] ASC,
	[tournament_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_tournament_sub]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_tournament_sub](
	[tran_id] [bigint] NOT NULL,
	[game_code] [varchar](10) NOT NULL,
	[begin_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[merchant_code] [varchar](10) NULL,
	[curr_id] [varchar](10) NULL,
	[name_en] [varchar](50) NULL,
	[name_cn] [varchar](50) NULL,
	[type_name_en] [varchar](50) NULL,
	[type_name_cn] [varchar](50) NULL,
	[total_prize_amt] [numeric](18, 0) NULL,
	[total_prize_rank] [int] NULL,
	[lucky_count] [int] NULL,
	[lucky_amt] [varchar](2000) NULL,
	[excluded] [bit] NULL,
	[game_list] [varchar](max) NULL,
	[create_date] [datetime] NULL,
	[create_by] [varchar](50) NULL,
	[cancel_date] [datetime] NULL,
	[cancel_by] [varchar](50) NULL,
	[update_date] [datetime] NULL,
	[update_by] [varchar](50) NULL,
	[status] [tinyint] NULL,
	[examine] [bit] NULL,
	[examine_by] [varchar](50) NULL,
	[examine_date] [datetime] NULL,
	[examine_status] [tinyint] NULL,
	[prize_send_status] [bit] NULL,
	[site_list] [varchar](5000) NULL,
	[buffer_time] [int] NULL,
	[proceed_payment] [bit] NULL,
	[proceed_by] [varchar](50) NULL,
	[proceed_date] [datetime] NULL,
	[auto_proceed_date] [datetime] NULL,
	[merchant_list] [varchar](max) NULL,
	[tournament_mode] [int] NULL,
	[default_rate] [bit] NULL,
	[min_bet_amt] [numeric](18, 6) NULL,
	[payment] [int] NULL,
	[countdown] [datetime] NULL,
	[buffer_zone] [datetime] NULL,
	[limit_minimum] [int] NULL,
	[minnimum] [decimal](18, 6) NULL,
	[cp_tran_id] [bigint] NULL,
	[manual_merchant_list] [varchar](max) NULL,
 CONSTRAINT [PK_lucky_tournament_sub] PRIMARY KEY CLUSTERED 
(
	[tran_id] ASC,
	[game_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_wheel_config]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_wheel_config](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[merchant_code] [varchar](10) NOT NULL,
	[curr_id] [varchar](10) NOT NULL,
	[prizes] [varchar](100) NULL,
	[status] [bit] NOT NULL,
	[prizes_config] [varchar](100) NULL,
	[mystery_gift_config] [numeric](18, 2) NULL,
	[no_gift] [bit] NULL,
	[update_date] [datetime] NULL,
	[update_by] [varchar](50) NULL,
	[latest_prizes_config] [varchar](100) NULL,
	[latest_gift_config] [numeric](18, 2) NULL,
	[create_date] [datetime] NULL,
	[create_by] [varchar](50) NULL,
 CONSTRAINT [PK_lucky_wheel_config] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [Unique_lucky_wheel_config] UNIQUE NONCLUSTERED 
(
	[merchant_code] ASC,
	[curr_id] ASC,
	[prizes] ASC,
	[prizes_config] ASC,
	[mystery_gift_config] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_wheel_config_edit_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_wheel_config_edit_log](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[config_id] [bigint] NOT NULL,
	[before_prizes] [varchar](100) NULL,
	[after_prizes] [varchar](100) NULL,
	[before_prizes_config] [varchar](100) NULL,
	[after_prizes_config] [varchar](100) NULL,
	[before_gift_config] [numeric](18, 2) NULL,
	[after_gift_config] [numeric](18, 2) NULL,
	[update_by] [varchar](50) NULL,
	[update_date] [datetime] NULL,
	[gift_config] [numeric](18, 2) NULL,
 CONSTRAINT [PK_lucky_wheel_config_edit_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_wheel_gift]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_wheel_gift](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name_en] [varchar](50) NULL,
	[name_cn] [varchar](50) NULL,
	[status] [bit] NOT NULL,
	[gift_desc] [varchar](100) NULL,
	[photo] [varchar](100) NULL,
	[img_base64] [text] NULL,
 CONSTRAINT [PK_lucky_wheel_gift_setting] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_wheel_stop_detail]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_wheel_stop_detail](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[tran_id] [bigint] NOT NULL,
	[begin_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[buffer_time] [int] NULL,
	[status] [tinyint] NULL,
	[create_date] [datetime] NULL,
	[create_by] [varchar](50) NULL,
	[update_by] [varchar](50) NULL,
	[update_date] [datetime] NULL,
	[bonus] [varchar](100) NULL,
	[bonus_config] [varchar](100) NULL,
	[gift_config] [numeric](18, 2) NULL,
 CONSTRAINT [PK_lucky_wheel_stop_detail] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_wheel_tran]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_wheel_tran](
	[tran_id] [bigint] IDENTITY(1,1) NOT NULL,
	[merchant_code] [varchar](10) NOT NULL,
	[curr_id] [varchar](5) NOT NULL,
	[begin_date] [datetime] NOT NULL,
	[end_date] [datetime] NOT NULL,
	[turnover] [numeric](18, 0) NULL,
	[gift_id] [int] NULL,
	[config_id] [int] NULL,
	[status] [tinyint] NULL,
	[games] [varchar](max) NULL,
	[create_by] [varchar](50) NULL,
	[create_date] [datetime] NULL,
	[stop_by] [varchar](50) NULL,
	[stop_date] [datetime] NULL,
	[cancel_by] [varchar](50) NULL,
	[cancel_date] [datetime] NULL,
	[update_by] [varchar](50) NULL,
	[update_date] [datetime] NULL,
	[statistics_date] [datetime] NULL,
	[buffer_time] [int] NULL,
	[is_excluded_game] [bit] NULL,
	[bonus_config] [varchar](100) NULL,
	[bonus] [varchar](100) NULL,
	[gift_config] [numeric](18, 2) NULL,
	[original_start_date] [datetime] NULL,
	[original_end_date] [datetime] NULL,
	[promotion_end_date] [datetime] NULL,
	[promotion_id] [bigint] NULL,
	[site_list] [varchar](5000) NULL,
	[total_reward] [numeric](18, 6) NULL,
	[total_unit] [int] NULL,
 CONSTRAINT [PK_lucky_wheel_setting] PRIMARY KEY CLUSTERED 
(
	[tran_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_wheel_tran_item]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_wheel_tran_item](
	[tran_id] [bigint] NOT NULL,
	[acct_id] [varchar](80) NOT NULL,
	[bet_amt] [numeric](18, 6) NULL,
	[spin_count] [int] NULL,
	[spin_amt] [numeric](18, 6) NULL,
	[update_date] [datetime] NULL,
	[spin_remain] [int] NULL,
	[merchant_code] [varchar](10) NULL,
	[curr_id] [varchar](10) NULL,
	[create_date] [datetime] NULL,
	[spin_max] [bit] NULL,
	[spin_gift] [bit] NULL,
	[valid_bet_amt] [numeric](18, 6) NULL,
	[login_id] [varchar](70) NULL,
 CONSTRAINT [PK_lucky_wheel_tran_item] PRIMARY KEY CLUSTERED 
(
	[tran_id] ASC,
	[acct_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_wheel_tran_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_wheel_tran_log](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[tran_id] [bigint] NOT NULL,
	[merchant_code] [varchar](10) NOT NULL,
	[curr_id] [varchar](5) NOT NULL,
	[begin_date] [datetime] NOT NULL,
	[end_date] [datetime] NOT NULL,
	[turnover] [numeric](18, 0) NULL,
	[gift_id] [int] NULL,
	[config_id] [int] NULL,
	[status] [tinyint] NULL,
	[games] [varchar](max) NULL,
	[create_by] [varchar](50) NULL,
	[create_date] [datetime] NULL,
	[stop_by] [varchar](50) NULL,
	[stop_date] [datetime] NULL,
	[cancel_by] [varchar](50) NULL,
	[cancel_date] [datetime] NULL,
	[update_by] [varchar](50) NULL,
	[update_date] [datetime] NULL,
	[statistics_date] [datetime] NULL,
	[buffer_time] [int] NULL,
	[after_begin_date] [datetime] NULL,
	[after_buffer_time] [int] NULL,
	[bonus] [varchar](100) NULL,
	[bonus_config] [varchar](100) NULL,
	[gift_config] [numeric](18, 2) NULL,
 CONSTRAINT [PK_lucky_wheel_setting_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lucky_wheel_tran_spin_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lucky_wheel_tran_spin_log](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[tran_id] [bigint] NOT NULL,
	[acct_id] [varchar](80) NOT NULL,
	[ticket_id] [bigint] NULL,
	[merchant_code] [varchar](10) NULL,
	[curr_id] [varchar](5) NULL,
	[game_code] [varchar](10) NULL,
	[prize] [numeric](18, 6) NULL,
	[mystery_gift] [varchar](50) NULL,
	[mystery_gift_id] [int] NULL,
	[turnover] [numeric](18, 6) NULL,
	[channel] [varchar](10) NULL,
	[spin_count] [int] NULL,
	[spin_amt] [numeric](18, 6) NULL,
	[login_id] [varchar](60) NULL,
	[client_ip] [varchar](50) NULL,
	[create_date] [datetime] NULL,
	[bet_amt] [numeric](18, 6) NULL,
	[spin_index] [int] NULL,
	[category] [varchar](5) NULL,
	[begin_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[promotion_id] [bigint] NULL,
 CONSTRAINT [PK_lucky_wheel_tran_spin_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[merchant]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[merchant](
	[merchant_code] [varchar](10) NOT NULL,
	[merchant_name] [nvarchar](100) NOT NULL,
	[merchant_group] [varchar](10) NULL,
	[support_currency] [varchar](500) NULL,
	[total_player] [int] NULL,
	[default_limit_group] [varchar](15) NULL,
	[create_date] [datetime] NULL,
	[authorize_url] [varchar](128) NULL,
	[notify_url] [varchar](128) NULL,
	[api_data_type] [varchar](20) NULL,
	[status] [char](1) NULL,
	[is_one_wallet] [int] NOT NULL,
	[icashier_url] [varchar](128) NULL,
	[iauthorize_url] [varchar](128) NULL,
	[api_white_ip] [varchar](2000) NULL,
	[bo_white_ip] [varchar](2000) NULL,
	[private_key] [varchar](3000) NULL,
	[parent_code] [varchar](10) NULL,
	[level] [int] NULL,
	[home_close] [int] NULL,
	[bonus_percent] [int] NULL,
	[number] [bigint] IDENTITY(100,1) NOT NULL,
	[promotion_url] [varchar](128) NULL,
	[lobby_url] [varchar](128) NULL,
	[param_setting] [bigint] NOT NULL,
	[aggr_code] [varchar](20) NULL,
	[api_security_key] [varchar](256) NULL,
	[home_url] [varchar](128) NULL,
	[ow_param_setting] [bigint] NULL,
	[game_white_ip] [varchar](2000) NULL,
 CONSTRAINT [PK_MERCHANT] PRIMARY KEY CLUSTERED 
(
	[merchant_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[merchant_archive]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[merchant_archive](
	[merchant_code] [varchar](10) NOT NULL,
	[merchant_name] [nvarchar](50) NOT NULL,
	[merchant_group] [varchar](10) NULL,
	[support_currency] [varchar](500) NULL,
	[total_player] [int] NULL,
	[default_limit_group] [varchar](15) NULL,
	[create_date] [datetime] NULL,
	[authorize_url] [varchar](128) NULL,
	[notify_url] [varchar](128) NULL,
	[api_data_type] [varchar](20) NULL,
	[status] [char](1) NULL,
	[is_one_wallet] [int] NOT NULL,
	[icashier_url] [varchar](128) NULL,
	[iauthorize_url] [varchar](128) NULL,
	[api_white_ip] [varchar](2000) NULL,
	[bo_white_ip] [varchar](2000) NULL,
	[parent_code] [varchar](10) NULL,
	[level] [int] NULL,
	[private_key] [varchar](3000) NULL,
	[number] [bigint] IDENTITY(100,1) NOT NULL,
	[home_close] [int] NULL,
	[bonus_percent] [int] NULL,
	[promotion_url] [varchar](128) NULL,
	[lobby_url] [varchar](128) NULL,
	[param_setting] [bigint] NULL,
	[aggr_code] [varchar](20) NULL,
	[archive_date] [datetime] NULL,
	[api_security_key] [varchar](256) NULL,
	[home_url] [varchar](128) NULL,
	[ow_param_setting] [bigint] NULL,
	[game_white_ip] [varchar](2000) NULL,
 CONSTRAINT [PK_merchant_archive] PRIMARY KEY CLUSTERED 
(
	[merchant_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[merchant_archive_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[merchant_archive_log](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[merchant_code] [varchar](10) NULL,
	[create_by] [varchar](50) NULL,
	[create_date] [datetime] NULL,
 CONSTRAINT [PK_merchant_archive_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[merchant_behavior_key_daily_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[merchant_behavior_key_daily_log](
	[merchant_code] [varchar](10) NOT NULL,
	[game_code] [varchar](10) NOT NULL,
	[key_] [varchar](36) NOT NULL,
	[tran_date] [datetime] NOT NULL,
	[behavior_count] [int] NULL,
	[create_date] [datetime] NULL,
 CONSTRAINT [PK_merchant_behavior_key_daily_log] PRIMARY KEY CLUSTERED 
(
	[merchant_code] ASC,
	[game_code] ASC,
	[key_] ASC,
	[tran_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[merchant_cdn_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[merchant_cdn_setting](
	[country_code] [varchar](10) NOT NULL,
	[merchant_code] [varchar](10) NOT NULL,
	[websocket] [varchar](100) NULL,
	[fish_websocket] [varchar](100) NULL,
 CONSTRAINT [PK_merchant_cdn_setting] PRIMARY KEY CLUSTERED 
(
	[country_code] ASC,
	[merchant_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[merchant_channel_oper_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[merchant_channel_oper_log](
	[merchant_code] [varchar](50) NOT NULL,
	[channel] [varchar](15) NOT NULL,
	[merchant_list] [varchar](3000) NOT NULL,
	[user_id] [varchar](50) NULL,
	[create_time] [datetime] NULL,
 CONSTRAINT [PK_merchant_channel_oper_log] PRIMARY KEY CLUSTERED 
(
	[merchant_code] ASC,
	[channel] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[merchant_control_pool]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[merchant_control_pool](
	[merchant_code] [varchar](30) NOT NULL,
	[curr_id] [varchar](3) NOT NULL,
	[game_code] [varchar](10) NOT NULL,
	[games_win] [decimal](18, 6) NULL,
	[games_lose] [decimal](18, 6) NULL,
	[max_lose_limit] [decimal](18, 6) NULL,
	[volatility] [varchar](20) NOT NULL,
	[rtp] [int] NOT NULL,
	[control_win] [decimal](18, 6) NULL,
	[last_update_time] [datetime] NULL,
 CONSTRAINT [PK_merchant_control_game_amount] PRIMARY KEY CLUSTERED 
(
	[merchant_code] ASC,
	[curr_id] ASC,
	[game_code] ASC,
	[volatility] ASC,
	[rtp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[merchant_currency_oper_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[merchant_currency_oper_log](
	[merchant_code] [varchar](50) NOT NULL,
	[curr_id] [varchar](10) NOT NULL,
	[merchant_list] [varchar](3000) NOT NULL,
	[user_id] [varchar](50) NULL,
	[create_time] [datetime] NULL,
 CONSTRAINT [PK_merchant_currency_oper_log] PRIMARY KEY CLUSTERED 
(
	[merchant_code] ASC,
	[curr_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[merchant_dns_failed]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[merchant_dns_failed](
	[domain] [varchar](50) NOT NULL,
	[update_date] [datetime] NULL,
 CONSTRAINT [PK_merchant_dns_failed] PRIMARY KEY CLUSTERED 
(
	[domain] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[merchant_domain_relation]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[merchant_domain_relation](
	[domain] [varchar](128) NOT NULL,
	[merchant_list] [varchar](max) NULL,
	[status] [int] NULL,
 CONSTRAINT [PK_merchant_domain_relation] PRIMARY KEY CLUSTERED 
(
	[domain] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[merchant_email]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[merchant_email](
	[email_name] [varchar](30) NOT NULL,
	[email_address] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[merchant_email_notification_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[merchant_email_notification_setting](
	[curr_id] [varchar](5) NOT NULL,
	[max_limit] [decimal](20, 4) NULL,
	[daily_big_win] [decimal](18, 6) NULL,
 CONSTRAINT [PK_merchant_email_notification_setting_curr_id] PRIMARY KEY CLUSTERED 
(
	[curr_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[merchant_email_ref]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[merchant_email_ref](
	[email_address] [varchar](50) NOT NULL,
	[merchant_code] [varchar](20) NOT NULL,
 CONSTRAINT [PK_merchant_email_ref] PRIMARY KEY CLUSTERED 
(
	[email_address] ASC,
	[merchant_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[merchant_game_log_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[merchant_game_log_setting](
	[merchant_code] [varchar](50) NOT NULL,
	[valid_hours] [int] NULL,
 CONSTRAINT [PK_merchant_game_log_setting] PRIMARY KEY CLUSTERED 
(
	[merchant_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[merchant_game_oper_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[merchant_game_oper_log](
	[merchant_code] [varchar](50) NOT NULL,
	[game_code] [varchar](10) NOT NULL,
	[channel] [varchar](20) NOT NULL,
	[merchant_list] [varchar](3000) NOT NULL,
	[user_id] [varchar](50) NULL,
	[create_time] [datetime] NULL,
 CONSTRAINT [PK_merchant_game_oper_log] PRIMARY KEY CLUSTERED 
(
	[merchant_code] ASC,
	[game_code] ASC,
	[channel] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[merchant_game_room_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[merchant_game_room_setting](
	[merchant_code] [varchar](10) NOT NULL,
	[game_code] [varchar](20) NOT NULL,
	[curr_id] [varchar](5) NOT NULL,
	[room_ids] [varchar](1024) NULL,
 CONSTRAINT [PK_merchant_game_room_setting] PRIMARY KEY CLUSTERED 
(
	[merchant_code] ASC,
	[game_code] ASC,
	[curr_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[merchant_game_whitelist]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[merchant_game_whitelist](
	[merchant_code] [varchar](10) NOT NULL,
	[white_list] [varchar](500) NULL,
 CONSTRAINT [PK_MERCHANT_GAME_WHITELIST] PRIMARY KEY CLUSTERED 
(
	[merchant_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[merchant_group]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[merchant_group](
	[group_code] [varchar](10) NOT NULL,
	[group_desc] [varchar](50) NULL,
	[is_active] [bit] NULL,
	[created_by] [varchar](30) NULL,
	[created_date] [datetime] NULL,
	[updated_by] [varchar](30) NULL,
	[updated_date] [datetime] NULL,
 CONSTRAINT [PK_merchant_group] PRIMARY KEY CLUSTERED 
(
	[group_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[merchant_ip_access]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[merchant_ip_access](
	[client_ip] [varchar](50) NOT NULL,
	[last_access_date] [datetime] NULL,
 CONSTRAINT [PK_merchant_ip_access] PRIMARY KEY CLUSTERED 
(
	[client_ip] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[merchant_ip_relation]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[merchant_ip_relation](
	[client_ip] [varchar](50) NOT NULL,
	[merchant_list] [varchar](max) NULL,
	[status] [int] NULL,
 CONSTRAINT [PK_merchant_ip_relation] PRIMARY KEY CLUSTERED 
(
	[client_ip] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[merchant_login_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[merchant_login_log](
	[merchant_code] [varchar](10) NOT NULL,
	[client_ip] [varchar](50) NOT NULL,
	[login_ip_geo] [varchar](256) NULL,
	[country_code] [varchar](30) NULL,
	[create_date] [datetime] NULL,
	[update_date] [datetime] NULL,
 CONSTRAINT [PK_merchant_login_log] PRIMARY KEY CLUSTERED 
(
	[merchant_code] ASC,
	[client_ip] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[merchant_logo_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[merchant_logo_setting](
	[merchant_code] [varchar](20) NOT NULL,
	[status] [int] NOT NULL,
	[apply_sub] [int] NOT NULL,
	[img_format] [varchar](20) NULL,
	[img_url] [varchar](200) NULL,
	[img_base64] [text] NULL,
 CONSTRAINT [PK_merchant_logo_setting] PRIMARY KEY CLUSTERED 
(
	[merchant_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[merchant_promotion]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[merchant_promotion](
	[promotion_id] [bigint] IDENTITY(1,1) NOT NULL,
	[merchant_code] [varchar](10) NULL,
	[curr_id] [varchar](5) NULL,
	[status] [bit] NULL,
	[begin_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[game_code] [varchar](10) NULL,
	[tran_id] [bigint] NULL,
	[remark] [varchar](max) NULL,
	[promotion_begin_date] [datetime] NULL,
	[promotion_end_date] [datetime] NULL,
	[promotion_status] [int] NULL,
	[cp_tran_id] [bigint] NULL,
	[type] [int] NULL,
	[merchant_list] [varchar](max) NULL,
	[curr_list] [varchar](1000) NULL,
 CONSTRAINT [PK_merchant_promotion] PRIMARY KEY CLUSTERED 
(
	[promotion_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[merchant_promotion_fish]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[merchant_promotion_fish](
	[promotion_id] [bigint] IDENTITY(1,1) NOT NULL,
	[merchant_list] [varchar](max) NULL,
	[curr_list] [varchar](1000) NULL,
	[status] [bit] NULL,
	[begin_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[game_code] [varchar](10) NULL,
	[tran_id] [bigint] NULL,
	[promotion_begin_date] [datetime] NULL,
	[promotion_end_date] [datetime] NULL,
	[promotion_status] [int] NULL,
 CONSTRAINT [PK_merchant_promotion_fish] PRIMARY KEY CLUSTERED 
(
	[promotion_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[merchant_promotion_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[merchant_promotion_setting](
	[merchant_code] [varchar](10) NOT NULL,
	[curr_id] [varchar](5) NOT NULL,
	[status] [bit] NULL,
	[create_date] [datetime] NULL,
 CONSTRAINT [PK_merchant_promotion_setting] PRIMARY KEY CLUSTERED 
(
	[merchant_code] ASC,
	[curr_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[merchant_provider_oper_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[merchant_provider_oper_log](
	[merchant_code] [varchar](50) NOT NULL,
	[provider_code] [varchar](15) NOT NULL,
	[merchant_list] [varchar](3000) NOT NULL,
	[user_id] [varchar](50) NULL,
	[create_time] [datetime] NULL,
 CONSTRAINT [PK_merchant_provider_oper_log] PRIMARY KEY CLUSTERED 
(
	[merchant_code] ASC,
	[provider_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[merchant_relation]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[merchant_relation](
	[merchant_code] [varchar](50) NOT NULL,
	[sub_merchant_code] [varchar](50) NOT NULL,
	[upline] [varchar](200) NULL,
 CONSTRAINT [PK_merchant_relation] PRIMARY KEY CLUSTERED 
(
	[merchant_code] ASC,
	[sub_merchant_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[merchant_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[merchant_setting](
	[merchant_code] [varchar](10) NOT NULL,
	[jackpot_list] [varchar](200) NULL,
	[game_list] [varchar](2500) NULL,
	[mobile_game_list] [varchar](2500) NULL,
	[android_game_list] [varchar](2500) NULL,
	[ios_game_list] [varchar](2500) NULL,
	[pc_game_list] [varchar](2500) NULL,
	[channel_list] [varchar](50) NULL,
	[menu_list] [varchar](100) NULL,
	[provider_list] [varchar](200) NULL,
	[transfer_error_count] [int] NULL,
	[call_timeout_seconds] [int] NULL,
	[game_log_valid_hours] [int] NULL,
 CONSTRAINT [PK_MERCHANT_SETTING] PRIMARY KEY CLUSTERED 
(
	[merchant_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[merchant_setting_archive]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[merchant_setting_archive](
	[merchant_code] [varchar](10) NOT NULL,
	[jackpot_list] [varchar](200) NULL,
	[game_list] [varchar](2500) NULL,
	[mobile_game_list] [varchar](2500) NULL,
	[android_game_list] [varchar](2500) NULL,
	[ios_game_list] [varchar](2500) NULL,
	[pc_game_list] [varchar](2500) NULL,
	[channel_list] [varchar](50) NULL,
	[menu_list] [varchar](100) NULL,
	[provider_list] [varchar](200) NULL,
	[transfer_error_count] [int] NULL,
	[call_timeout_seconds] [int] NULL,
	[game_log_valid_hours] [int] NULL,
 CONSTRAINT [PK_merchant_setting_archive] PRIMARY KEY CLUSTERED 
(
	[merchant_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[merchant_setting_oper_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[merchant_setting_oper_log](
	[id] [varchar](50) NOT NULL,
	[merchant_list] [varchar](max) NOT NULL,
	[user_id] [varchar](50) NULL,
	[create_time] [datetime] NULL,
 CONSTRAINT [PK_merchant_setting_oper_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[merchant_site_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[merchant_site_setting](
	[merchant_code] [varchar](10) NOT NULL,
	[site_id] [varchar](30) NOT NULL,
	[currency_list] [varchar](1000) NULL,
	[status] [bit] NULL,
 CONSTRAINT [PK_merchant_site_setting] PRIMARY KEY CLUSTERED 
(
	[merchant_code] ASC,
	[site_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[merchant_site_setting_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[merchant_site_setting_log](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[merchant_code] [varchar](10) NULL,
	[site_id] [varchar](30) NULL,
	[currency_list] [varchar](1000) NULL,
	[prev_currency_list] [varchar](1000) NULL,
	[status] [bit] NULL,
	[prev_status] [bit] NULL,
	[create_by] [varchar](30) NULL,
	[create_date] [datetime] NULL,
	[ip] [varchar](50) NULL,
 CONSTRAINT [PK_merchant_site_setting_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[merchant_token]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[merchant_token](
	[merchant_token] [varchar](512) NOT NULL,
	[session_id] [varchar](50) NOT NULL,
	[acct_id] [varchar](80) NULL,
	[created_date] [datetime] NULL,
 CONSTRAINT [PK_merchant_token] PRIMARY KEY CLUSTERED 
(
	[merchant_token] ASC,
	[session_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[merchant_transfer_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[merchant_transfer_setting](
	[merchant_code] [varchar](20) NOT NULL,
	[split_seconds] [int] NOT NULL,
	[error_count] [int] NOT NULL,
	[transfer_count] [int] NOT NULL,
	[invalid_count] [int] NULL,
 CONSTRAINT [PK_merchant_transfer_setting] PRIMARY KEY CLUSTERED 
(
	[merchant_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[one_wallet_transfer]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[one_wallet_transfer](
	[id] [varchar](50) NOT NULL,
	[acct_id] [varchar](80) NULL,
	[login_id] [varchar](60) NULL,
	[merchant_code] [varchar](20) NULL,
	[tran_type] [int] NULL,
	[currency] [varchar](3) NOT NULL,
	[transfer_amount] [decimal](18, 4) NULL,
	[operate_time] [datetime] NULL,
	[game_code] [varchar](10) NULL,
	[ticket_id] [bigint] NULL,
	[reference_id] [varchar](50) NULL,
	[is_success] [int] NULL,
	[remark] [varchar](200) NULL,
	[request_serial_no] [varchar](50) NULL,
	[merchant_tx_id] [varchar](100) NULL,
	[channel] [varchar](10) NULL,
	[special_type] [varchar](20) NULL,
	[special_count] [int] NULL,
	[special_seq] [int] NULL,
	[ref_ticket_ids] [varchar](4096) NULL,
	[save_date] [datetime] NULL,
	[merchant_token] [varchar](512) NULL,
	[client_ip] [varchar](50) NULL,
	[completed] [bit] NULL,
	[round_id] [bigint] NULL,
	[bet_amount] [decimal](18, 4) NULL,
	[result] [varchar](2048) NULL,
	[cancel_id] [varchar](50) NULL,
	[require_amount] [decimal](18, 6) NULL,
	[partition_date] [datetime] NOT NULL,
	[attrs] [varchar](1024) NULL,
	[balance] [decimal](18, 6) NULL,
 CONSTRAINT [PK_one_wallet_transfer] PRIMARY KEY CLUSTERED 
(
	[id] ASC,
	[partition_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[one_wallet_transfer_all]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[one_wallet_transfer_all](
	[id] [varchar](50) NOT NULL,
	[acct_id] [varchar](80) NULL,
	[login_id] [varchar](60) NULL,
	[merchant_code] [varchar](20) NULL,
	[tran_type] [int] NULL,
	[currency] [varchar](3) NOT NULL,
	[transfer_amount] [decimal](18, 4) NULL,
	[operate_time] [datetime] NOT NULL,
	[game_code] [varchar](10) NULL,
	[ticket_id] [bigint] NULL,
	[reference_id] [varchar](50) NULL,
	[is_success] [int] NULL,
	[remark] [varchar](200) NULL,
	[request_serial_no] [varchar](50) NULL,
	[merchant_tx_id] [varchar](100) NULL,
	[channel] [varchar](10) NULL,
	[special_type] [varchar](20) NULL,
	[special_count] [int] NULL,
	[special_seq] [int] NULL,
	[ref_ticket_ids] [varchar](4096) NULL,
	[save_date] [datetime] NULL,
	[merchant_token] [varchar](512) NULL,
	[client_ip] [varchar](50) NULL,
	[completed] [bit] NULL,
	[round_id] [bigint] NULL,
	[bet_amount] [decimal](18, 4) NULL,
	[result] [varchar](2048) NULL,
	[cancel_id] [varchar](50) NULL,
	[require_amount] [decimal](18, 6) NULL,
	[partition_date] [datetime] NULL,
	[attrs] [varchar](1024) NULL,
	[balance] [decimal](18, 6) NULL,
 CONSTRAINT [PK_one_wallet_transfer_all] PRIMARY KEY CLUSTERED 
(
	[id] ASC,
	[operate_time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [Psh_owt]([operate_time])
) ON [Psh_owt]([operate_time])
GO
/****** Object:  Table [dbo].[one_wallet_transfer_all_archive]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[one_wallet_transfer_all_archive](
	[id] [varchar](50) NOT NULL,
	[acct_id] [varchar](80) NULL,
	[login_id] [varchar](60) NULL,
	[merchant_code] [varchar](20) NULL,
	[tran_type] [int] NULL,
	[currency] [varchar](3) NOT NULL,
	[transfer_amount] [decimal](18, 4) NULL,
	[operate_time] [datetime] NOT NULL,
	[game_code] [varchar](10) NULL,
	[ticket_id] [bigint] NULL,
	[reference_id] [varchar](50) NULL,
	[is_success] [int] NULL,
	[remark] [varchar](200) NULL,
	[request_serial_no] [varchar](50) NULL,
	[merchant_tx_id] [varchar](100) NULL,
	[channel] [varchar](10) NULL,
	[special_type] [varchar](20) NULL,
	[special_count] [int] NULL,
	[special_seq] [int] NULL,
	[ref_ticket_ids] [varchar](4096) NULL,
	[save_date] [datetime] NULL,
	[merchant_token] [varchar](512) NULL,
	[client_ip] [varchar](50) NULL,
	[completed] [bit] NULL,
	[round_id] [bigint] NULL,
	[bet_amount] [decimal](18, 4) NULL,
	[result] [varchar](2048) NULL,
	[cancel_id] [varchar](50) NULL,
	[require_amount] [decimal](18, 6) NULL,
	[partition_date] [datetime] NULL,
	[attrs] [varchar](1024) NULL,
	[balance] [decimal](18, 6) NULL,
 CONSTRAINT [PK_one_wallet_transfer_all_archive] PRIMARY KEY CLUSTERED 
(
	[id] ASC,
	[operate_time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [Psh_owt]([operate_time])
) ON [Psh_owt]([operate_time])
GO
/****** Object:  Table [dbo].[one_wallet_transfer_cancel_exception_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[one_wallet_transfer_cancel_exception_log](
	[id] [varchar](80) NOT NULL,
	[cancel_id] [varchar](50) NULL,
	[ticket_id] [bigint] NOT NULL,
	[merchant_code] [varchar](20) NULL,
	[acct_id] [varchar](80) NULL,
	[login_id] [varchar](80) NULL,
	[game_code] [varchar](10) NULL,
	[tran_type] [int] NULL,
	[status] [int] NULL,
	[create_date] [datetime] NULL,
	[update_date] [datetime] NULL,
 CONSTRAINT [PK_one_wallet_transfer_cancel_exception_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[one_wallet_transfer_cancel_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[one_wallet_transfer_cancel_log](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[acct_id] [varchar](80) NULL,
	[merchant_code] [varchar](20) NULL,
	[game_code] [varchar](10) NULL,
	[tran_type] [int] NULL,
	[bet_id] [varchar](50) NULL,
	[cancel_id] [varchar](50) NULL,
	[ticket_id] [bigint] NOT NULL,
	[status] [int] NULL,
	[create_date] [datetime] NULL,
	[create_by] [varchar](50) NULL,
	[login_id] [varchar](70) NULL,
 CONSTRAINT [PK_one_wallet_transfer_cancel_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[provider_ab_acct_info]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[provider_ab_acct_info](
	[ab_id] [varchar](64) NOT NULL,
	[login_id] [varchar](60) NULL,
	[acct_id] [varchar](80) NULL,
	[merchant_code] [varchar](10) NULL,
	[create_date] [datetime] NULL,
	[pwd] [varchar](20) NULL,
	[created] [int] NULL,
 CONSTRAINT [PK_provider_ab_acct_info] PRIMARY KEY CLUSTERED 
(
	[ab_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[provider_ab_ticket]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[provider_ab_ticket](
	[ticket_id] [bigint] NOT NULL,
	[bet_time] [datetime] NULL,
	[bet_type] [int] NULL,
	[game_type] [int] NULL,
	[game_round_id] [bigint] NULL,
	[state] [int] NULL,
	[bet_amt] [numeric](18, 6) NULL,
	[valid_amt] [numeric](18, 6) NULL,
	[wl_amt] [numeric](18, 6) NULL,
	[curr_rate] [numeric](18, 6) NULL,
	[result] [varchar](500) NULL,
	[result2] [varchar](500) NULL,
	[start_time] [datetime] NULL,
	[end_time] [datetime] NULL,
	[commission] [int] NULL,
	[table_id] [varchar](30) NULL,
	[player_id] [varchar](80) NULL,
	[acct_id] [varchar](80) NULL,
	[login_id] [varchar](60) NULL,
	[merchant_code] [varchar](10) NULL,
	[curr_id] [varchar](5) NULL,
	[game_code] [varchar](10) NULL,
 CONSTRAINT [PK_provider_ab_ticket] PRIMARY KEY CLUSTERED 
(
	[ticket_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[provider_ab_transfer_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[provider_ab_transfer_log](
	[ticket_id] [bigint] NULL,
	[tran_id] [varchar](50) NOT NULL,
	[reference_id] [varchar](50) NULL,
	[acct_id] [varchar](80) NULL,
	[login_id] [varchar](50) NULL,
	[ab_acct_id] [varchar](60) NULL,
	[merchant_code] [varchar](10) NULL,
	[curr_id] [varchar](3) NULL,
	[tran_type] [int] NULL,
	[transfer_amount] [decimal](18, 4) NULL,
	[operate_time] [datetime] NULL,
	[table_id] [varchar](30) NULL,
	[game_code] [varchar](10) NULL,
	[channel] [varchar](10) NULL,
	[status] [int] NULL,
	[onewallet_bet_id] [varchar](50) NULL,
	[id] [varchar](50) NOT NULL,
	[round_id] [varchar](50) NULL,
 CONSTRAINT [PK_provider_ab_transfer_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[provider_acct_daily_tran]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[provider_acct_daily_tran](
	[tran_id] [bigint] IDENTITY(1,1) NOT NULL,
	[acct_id] [varchar](80) NOT NULL,
	[tran_date] [datetime] NOT NULL,
	[tran_type] [varchar](3) NOT NULL,
	[merchant_code] [varchar](10) NOT NULL,
	[login_id] [varchar](60) NULL,
	[in_count] [numeric](18, 0) NULL,
	[in_amt] [numeric](18, 6) NULL,
	[out_count] [numeric](18, 0) NULL,
	[out_amt] [numeric](18, 6) NULL,
	[adj_count] [numeric](18, 0) NULL,
	[adj_amt] [numeric](18, 6) NULL,
	[bet_count] [numeric](18, 0) NULL,
	[ttl_bet] [numeric](18, 6) NULL,
	[success_bet] [numeric](18, 6) NULL,
	[wl_amt] [numeric](18, 6) NULL,
	[net_amt] [numeric](18, 6) NULL,
	[create_date] [datetime] NULL,
	[jp_contribute_amt] [decimal](18, 6) NULL,
	[channel] [varchar](20) NOT NULL,
	[jp_win] [numeric](18, 6) NULL,
	[curr_id] [varchar](5) NULL,
	[draw_amt] [numeric](18, 6) NULL,
	[provider] [varchar](30) NOT NULL,
	[acct_create_date] [datetime] NULL,
 CONSTRAINT [PK_provider_acct_daily_tran] PRIMARY KEY CLUSTERED 
(
	[acct_id] ASC,
	[tran_date] ASC,
	[tran_type] ASC,
	[channel] ASC,
	[provider] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[provider_acct_game_daily_tran]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[provider_acct_game_daily_tran](
	[tran_id] [bigint] IDENTITY(1,1) NOT NULL,
	[acct_id] [varchar](80) NOT NULL,
	[tran_date] [datetime] NOT NULL,
	[tran_type] [varchar](3) NOT NULL,
	[game_code] [varchar](10) NOT NULL,
	[merchant_code] [varchar](10) NOT NULL,
	[login_id] [varchar](60) NULL,
	[bet_count] [numeric](18, 0) NULL,
	[ttl_bet] [numeric](18, 6) NULL,
	[success_bet] [numeric](18, 6) NULL,
	[wl_amt] [numeric](18, 6) NULL,
	[net_amt] [numeric](18, 6) NULL,
	[create_date] [datetime] NULL,
	[jp_contribute_amt] [decimal](18, 6) NULL,
	[channel] [varchar](20) NOT NULL,
	[jp_win] [numeric](18, 6) NULL,
	[curr_id] [varchar](5) NULL,
	[draw_amt] [numeric](18, 6) NULL,
	[provider] [varchar](30) NOT NULL,
	[game_category] [varchar](30) NULL,
	[acct_create_date] [datetime] NULL,
	[logic_code] [varchar](10) NOT NULL,
 CONSTRAINT [PK_provider_acct_game_daily_tran] PRIMARY KEY CLUSTERED 
(
	[tran_date] ASC,
	[acct_id] ASC,
	[tran_type] ASC,
	[game_code] ASC,
	[channel] ASC,
	[provider] ASC,
	[logic_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[provider_ag_acct_info]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[provider_ag_acct_info](
	[ag_id] [varchar](64) NOT NULL,
	[login_id] [varchar](60) NULL,
	[acct_id] [varchar](80) NULL,
	[merchant_code] [varchar](10) NULL,
	[create_date] [datetime] NULL,
	[pwd] [varchar](20) NULL,
	[created] [int] NULL,
 CONSTRAINT [PK_provider_ag_acct_info] PRIMARY KEY CLUSTERED 
(
	[ag_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[provider_ag_bet_confirm]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[provider_ag_bet_confirm](
	[ticket_id] [varchar](30) NOT NULL,
	[tran_id] [varchar](50) NOT NULL,
	[bet_amt] [numeric](18, 6) NULL,
	[bet_type] [int] NULL,
	[val] [varchar](150) NULL,
 CONSTRAINT [PK_provider_ag_bet_confirm] PRIMARY KEY CLUSTERED 
(
	[ticket_id] ASC,
	[tran_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[provider_ag_ticket]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[provider_ag_ticket](
	[ticket_id] [varchar](30) NOT NULL,
	[settle_time] [datetime] NULL,
	[bet_type] [int] NULL,
	[game_type] [varchar](10) NULL,
	[game_round_id] [varchar](30) NULL,
	[table_code] [varchar](10) NULL,
	[tran_id] [varchar](1000) NULL,
	[tran_type] [varchar](10) NULL,
	[tran_code] [varchar](10) NULL,
	[ticket_status] [varchar](10) NULL,
	[game_result] [varchar](500) NULL,
	[finish] [varchar](5) NULL,
	[bet_amt] [numeric](18, 6) NULL,
	[valid_amt] [numeric](18, 6) NULL,
	[wl_amt] [numeric](18, 6) NULL,
	[player_id] [varchar](80) NULL,
	[acct_id] [varchar](80) NULL,
	[login_id] [varchar](60) NULL,
	[merchant_code] [varchar](10) NULL,
	[curr_id] [varchar](5) NULL,
	[game_code] [varchar](10) NULL,
	[bet_time] [datetime] NULL,
	[device_type] [varchar](20) NULL,
 CONSTRAINT [PK_provider_ag_ticket] PRIMARY KEY CLUSTERED 
(
	[ticket_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[provider_ag_transfer_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[provider_ag_transfer_log](
	[ticket_id] [bigint] NULL,
	[tran_id] [varchar](1000) NULL,
	[reference_id] [varchar](50) NULL,
	[bet_type] [int] NULL,
	[round_id] [varchar](50) NULL,
	[acct_id] [varchar](80) NULL,
	[login_id] [varchar](50) NULL,
	[ag_acct_id] [varchar](60) NULL,
	[merchant_code] [varchar](10) NULL,
	[curr_id] [varchar](3) NULL,
	[tran_type] [int] NULL,
	[transfer_amount] [decimal](18, 4) NULL,
	[operate_time] [datetime] NULL,
	[table_id] [varchar](30) NULL,
	[table_code] [varchar](20) NULL,
	[game_code] [varchar](10) NULL,
	[channel] [varchar](10) NULL,
	[status] [int] NULL,
	[onewallet_bet_id] [varchar](50) NULL,
	[id] [varchar](100) NOT NULL,
	[bet_time] [datetime] NULL,
 CONSTRAINT [PK_provider_ag_transfer_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[provider_category]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[provider_category](
	[code] [varchar](15) NOT NULL,
	[category_id] [varchar](5) NOT NULL,
 CONSTRAINT [PK_provider_category] PRIMARY KEY CLUSTERED 
(
	[code] ASC,
	[category_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[provider_currency_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[provider_currency_setting](
	[provider_code] [varchar](15) NOT NULL,
	[curr_id] [varchar](5) NOT NULL,
	[provider_curr_id] [varchar](5) NULL,
	[odd_type] [varchar](10) NULL,
 CONSTRAINT [PK_provider_currency_setting] PRIMARY KEY CLUSTERED 
(
	[provider_code] ASC,
	[curr_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[provider_ev_acct_info]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[provider_ev_acct_info](
	[ev_id] [varchar](64) NOT NULL,
	[login_id] [varchar](60) NULL,
	[acct_id] [varchar](80) NULL,
	[merchant_code] [varchar](10) NULL,
	[create_date] [datetime] NULL,
	[created] [int] NULL,
 CONSTRAINT [PK_provider_ev_acct_info] PRIMARY KEY CLUSTERED 
(
	[ev_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[provider_ev_game_bet_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[provider_ev_game_bet_log](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[ticket_id] [varchar](50) NULL,
	[player_id] [varchar](80) NULL,
	[acct_id] [varchar](80) NULL,
	[login_id] [varchar](60) NULL,
	[merchant_code] [varchar](10) NULL,
	[curr_id] [varchar](5) NULL,
	[payout] [numeric](18, 6) NULL,
	[stake] [numeric](18, 6) NULL,
	[description] [varchar](500) NULL,
	[placed_on] [datetime] NULL,
	[code] [varchar](50) NULL,
	[transaction_id] [varchar](50) NULL,
 CONSTRAINT [PK_provider_ev_game_bet_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[provider_ev_ticket]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[provider_ev_ticket](
	[ticket_id] [varchar](50) NOT NULL,
	[started_at] [datetime] NULL,
	[settled_at] [datetime] NULL,
	[status] [varchar](20) NULL,
	[game_type] [varchar](20) NULL,
	[curr_id] [varchar](5) NULL,
	[result] [varchar](3000) NULL,
	[table_id] [varchar](30) NULL,
	[table_name] [varchar](30) NULL,
	[wager] [numeric](18, 6) NULL,
	[payout] [numeric](18, 6) NULL,
	[game_code] [varchar](10) NULL,
 CONSTRAINT [PK_provider_ev_ticket] PRIMARY KEY CLUSTERED 
(
	[ticket_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[provider_ev_transfer_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[provider_ev_transfer_log](
	[tran_id] [varchar](50) NOT NULL,
	[reference_id] [varchar](50) NULL,
	[acct_id] [varchar](80) NULL,
	[login_id] [varchar](50) NULL,
	[ev_acct_id] [varchar](60) NULL,
	[merchant_code] [varchar](10) NULL,
	[curr_id] [varchar](3) NULL,
	[tran_type] [int] NULL,
	[transfer_amount] [decimal](18, 4) NULL,
	[operate_time] [datetime] NULL,
	[table_id] [varchar](30) NULL,
	[game_code] [varchar](10) NULL,
	[channel] [varchar](10) NULL,
	[status] [int] NULL,
	[onewallet_bet_id] [varchar](50) NULL,
	[sid] [varchar](80) NULL,
	[id] [varchar](50) NOT NULL,
 CONSTRAINT [PK_provider_ev_transfer_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[provider_game_info]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[provider_game_info](
	[provider_code] [varchar](15) NOT NULL,
	[provider_game_code] [varchar](30) NOT NULL,
	[game_code] [varchar](10) NOT NULL,
	[channel] [varchar](10) NULL,
 CONSTRAINT [PK_provider_game_info] PRIMARY KEY CLUSTERED 
(
	[provider_code] ASC,
	[provider_game_code] ASC,
	[game_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[provider_handicap_info]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[provider_handicap_info](
	[provider_code] [varchar](15) NOT NULL,
	[odd_type] [varchar](10) NOT NULL,
	[remark] [varchar](20) NULL,
 CONSTRAINT [PK_provider_handicap_info] PRIMARY KEY CLUSTERED 
(
	[provider_code] ASC,
	[odd_type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[provider_history_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[provider_history_log](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[provider_code] [varchar](5) NULL,
	[begin_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[creator] [varchar](50) NULL,
	[create_time] [datetime] NULL,
	[status] [varchar](10) NULL,
	[run_begin_date] [datetime] NULL,
	[run_end_date] [datetime] NULL,
 CONSTRAINT [PK_provider_history_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[provider_info]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[provider_info](
	[code] [varchar](15) NOT NULL,
	[name] [varchar](30) NULL,
	[status] [int] NOT NULL,
	[api_white_ip] [varchar](5000) NULL,
	[orderby] [int] NULL,
 CONSTRAINT [PK_provider_info] PRIMARY KEY CLUSTERED 
(
	[code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[provider_maintenance_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[provider_maintenance_setting](
	[maintenance_id] [bigint] IDENTITY(1,1) NOT NULL,
	[provider_code] [varchar](15) NOT NULL,
	[maintenance_start_time] [datetime] NULL,
	[maintenance_end_time] [datetime] NULL,
	[maintenance_remark] [nvarchar](200) NULL,
	[creator_id] [varchar](80) NULL,
	[create_date] [datetime] NULL,
	[last_update_id] [varchar](80) NULL,
	[last_update_date] [datetime] NULL,
 CONSTRAINT [PK_ss_provider_maintenance_setting] PRIMARY KEY CLUSTERED 
(
	[maintenance_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[provider_merchant_daily_tran]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[provider_merchant_daily_tran](
	[merchant_code] [varchar](10) NOT NULL,
	[tran_date] [datetime] NOT NULL,
	[game_code] [varchar](10) NOT NULL,
	[currency] [varchar](3) NOT NULL,
	[bet_count] [numeric](18, 0) NULL,
	[ttl_bet] [numeric](18, 6) NULL,
	[success_bet] [numeric](18, 6) NULL,
	[wl_amt] [numeric](18, 6) NULL,
	[net_amt] [numeric](18, 6) NULL,
	[create_date] [datetime] NULL,
	[jp_contribute_amt] [decimal](18, 6) NULL,
	[channel] [varchar](20) NOT NULL,
	[jp_win] [numeric](18, 6) NULL,
	[draw_amt] [numeric](18, 6) NULL,
	[provider] [varchar](30) NOT NULL,
	[game_category] [varchar](30) NULL,
	[logic_code] [varchar](10) NOT NULL,
 CONSTRAINT [PK_provider_merchant_daily_tran] PRIMARY KEY CLUSTERED 
(
	[tran_date] ASC,
	[merchant_code] ASC,
	[game_code] ASC,
	[currency] ASC,
	[channel] ASC,
	[provider] ASC,
	[logic_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[risk_acct_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[risk_acct_log](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[acct_id] [varchar](80) NULL,
	[merchant_code] [varchar](20) NULL,
	[game_code] [varchar](10) NULL,
	[client_ip] [varchar](50) NULL,
	[create_date] [datetime] NULL,
	[bet_count] [int] NULL,
	[bet_amt] [numeric](18, 6) NULL,
	[wl_amt] [numeric](18, 6) NULL,
	[risk_type] [varchar](10) NULL,
	[login_id] [varchar](70) NULL,
	[curr_id] [varchar](10) NULL,
	[level] [varchar](20) NULL,
	[multiple] [numeric](18, 2) NULL,
 CONSTRAINT [PK_risk_acct_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[risk_check_result]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[risk_check_result](
	[sn] [bigint] IDENTITY(1,1) NOT NULL,
	[begin_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[acct_id] [varchar](80) NULL,
	[login_id] [varchar](70) NULL,
	[merchant_code] [varchar](10) NULL,
	[min_ticket_id] [bigint] NULL,
	[max_ticket_id] [bigint] NULL,
	[min_ticket_date] [datetime] NULL,
	[max_ticket_date] [datetime] NULL,
	[min_type] [varchar](80) NULL,
	[max_type] [varchar](80) NULL,
	[min_bal] [decimal](18, 6) NULL,
	[max_bal] [decimal](18, 6) NULL,
	[min_wl_amt] [decimal](18, 6) NULL,
	[max_wl_amt] [decimal](18, 6) NULL,
	[total_wl_amt] [decimal](18, 6) NULL,
	[diff_wl_amt] [decimal](18, 6) NULL,
	[final_bal] [decimal](18, 6) NULL,
	[diff_bal] [decimal](18, 6) NULL,
	[create_date] [datetime] NULL,
 CONSTRAINT [PK_risk_check_result] PRIMARY KEY CLUSTERED 
(
	[sn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[risk_check_result_detail]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[risk_check_result_detail](
	[sn] [bigint] IDENTITY(1,1) NOT NULL,
	[begin_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[row_id] [bigint] NULL,
	[ticket_id] [bigint] NULL,
	[acct_id] [varchar](80) NULL,
	[wl_amt] [decimal](18, 6) NULL,
	[last_balance] [decimal](18, 6) NULL,
	[ticket_date] [datetime] NULL,
	[type] [varchar](20) NULL,
	[row_id_after] [bigint] NULL,
	[ticket_id_after] [bigint] NULL,
	[wl_amt_after] [decimal](18, 6) NULL,
	[last_balance_after] [decimal](18, 6) NULL,
	[ticket_date_after] [datetime] NULL,
	[type_after] [varchar](20) NULL,
	[login_id] [varchar](50) NULL,
	[merchant_code] [varchar](10) NULL,
	[create_date] [datetime] NULL,
 CONSTRAINT [PK_risk_check_result_detail] PRIMARY KEY CLUSTERED 
(
	[sn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[risk_check_result_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[risk_check_result_log](
	[sn] [bigint] IDENTITY(1,1) NOT NULL,
	[begin_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[records_count] [int] NULL,
	[create_date] [datetime] NULL,
 CONSTRAINT [PK_risk_check_result_log] PRIMARY KEY CLUSTERED 
(
	[sn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[risk_game_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[risk_game_setting](
	[game_code] [varchar](10) NOT NULL,
	[low_count] [int] NOT NULL,
	[medium_count] [int] NOT NULL,
	[high_count] [int] NOT NULL,
	[low_wl_multiple] [int] NOT NULL,
	[medium_wl_multiple] [int] NOT NULL,
	[high_wl_multiple] [int] NOT NULL,
	[super_count_multiple] [decimal](18, 2) NULL,
	[super_wl_multiple] [decimal](18, 2) NULL,
 CONSTRAINT [PK_risk_game_setting] PRIMARY KEY CLUSTERED 
(
	[game_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[risk_ip]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[risk_ip](
	[client_ip] [varchar](50) NOT NULL,
	[status] [smallint] NOT NULL,
	[create_date] [datetime] NOT NULL,
	[acct_id] [varchar](80) NULL,
	[risk_count] [int] NULL,
	[artificial_update] [tinyint] NULL,
	[update_date] [datetime] NULL,
 CONSTRAINT [PK_risk_ip] PRIMARY KEY CLUSTERED 
(
	[client_ip] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[rng_config]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[rng_config](
	[game_code] [varchar](10) NOT NULL,
	[randomiser_rtp] [int] NOT NULL,
	[create_time] [datetime] NOT NULL,
	[update_time] [datetime] NOT NULL,
	[volatility] [varchar](20) NULL,
	[strategy_code] [varchar](50) NULL,
	[medium_tdr_rtp] [decimal](20, 4) NULL,
	[low_tdr_rtp] [int] NULL,
	[random_type] [varchar](10) NULL,
	[versions] [varchar](16) NULL,
	[share] [bit] NULL,
	[remark] [varchar](100) NULL,
 CONSTRAINT [PK_rng_config] PRIMARY KEY CLUSTERED 
(
	[game_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sys_currency]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sys_currency](
	[curr_id] [varchar](3) NOT NULL,
	[curr_desc] [varchar](30) NULL,
	[curr_rate] [decimal](20, 8) NULL,
	[max_ticket_limit] [decimal](20, 4) NULL,
	[real_curr_rate] [decimal](20, 8) NULL,
	[limit_type] [int] NULL,
	[curr_type] [int] NOT NULL,
	[group_code] [varchar](20) NULL,
 CONSTRAINT [PK_sys_currency] PRIMARY KEY CLUSTERED 
(
	[curr_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sys_currency_group]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sys_currency_group](
	[group_code] [varchar](20) NOT NULL,
	[group_desc] [varchar](200) NULL,
	[is_active] [bit] NULL,
	[created_by] [varchar](30) NULL,
	[created_date] [datetime] NULL,
 CONSTRAINT [PK_sys_currency_group] PRIMARY KEY CLUSTERED 
(
	[group_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sys_currency_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sys_currency_log](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[curr_id] [varchar](3) NOT NULL,
	[curr_desc] [varchar](30) NULL,
	[curr_month] [varchar](20) NULL,
	[curr_rate_before] [decimal](20, 8) NULL,
	[curr_rate_after] [decimal](20, 8) NULL,
	[create_time] [datetime] NULL,
	[creator_id] [varchar](30) NOT NULL,
	[curr_status] [int] NULL,
	[curr_mth_start] [datetime] NULL,
	[curr_mth_end] [datetime] NULL,
	[real_curr_rate_before] [decimal](20, 8) NULL,
	[real_curr_rate_after] [decimal](20, 8) NULL,
 CONSTRAINT [PK_sys_currency_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sys_currency_rate]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sys_currency_rate](
	[curr_id] [varchar](20) NOT NULL,
	[curr_desc] [varchar](20) NULL,
	[curr_month] [varchar](20) NOT NULL,
	[curr_rate] [decimal](20, 8) NULL,
	[real_curr_rate] [decimal](20, 8) NULL,
 CONSTRAINT [PK_sys_currency_rate] PRIMARY KEY CLUSTERED 
(
	[curr_id] ASC,
	[curr_month] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sys_data_copy_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sys_data_copy_log](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[table_name] [varchar](50) NULL,
	[save_start_date] [datetime] NULL,
	[save_end_date] [datetime] NULL,
	[copy_date] [datetime] NULL,
	[copy_records_count] [int] NULL,
	[delete_date] [datetime] NULL,
	[del_records_count] [int] NULL,
	[status] [smallint] NULL,
	[log_date] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sys_game_common_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sys_game_common_setting](
	[curr_id] [varchar](20) NOT NULL,
	[game_code] [varchar](20) NOT NULL,
	[is_active] [bit] NULL,
	[is_jackpot] [bit] NULL,
	[tag_list] [varchar](500) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sys_game_language]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sys_game_language](
	[name] [varchar](10) NOT NULL,
	[description] [varchar](50) NULL,
	[iso639] [varchar](10) NULL,
 CONSTRAINT [PK_sys_game_language] PRIMARY KEY CLUSTERED 
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sys_game_tag]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sys_game_tag](
	[name] [varchar](20) NOT NULL,
	[description] [varchar](50) NULL,
	[orderby] [int] NULL,
	[description_cn] [varchar](50) NULL,
 CONSTRAINT [PK_name] PRIMARY KEY CLUSTERED 
(
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sys_ip_control]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sys_ip_control](
	[curr_id] [varchar](10) NOT NULL,
	[merchant_code] [varchar](255) NULL,
	[country_code] [varchar](10) NULL,
	[ip_ctrl] [bit] NULL,
	[white_ip_list] [varchar](1000) NULL,
PRIMARY KEY CLUSTERED 
(
	[curr_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sys_ipControl_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sys_ipControl_log](
	[Id_P] [int] IDENTITY(1,1) NOT NULL,
	[curr_id] [varchar](10) NULL,
	[merchant_code] [varchar](255) NULL,
	[country_code] [varchar](10) NULL,
	[ip_ctrl] [bit] NULL,
	[create_date] [datetime] NULL,
	[update_date] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Id_P] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sys_jobs_errormessage]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sys_jobs_errormessage](
	[sn] [int] IDENTITY(1,1) NOT NULL,
	[ErrorNumber] [int] NULL,
	[ErrorSeverity] [int] NULL,
	[ErrorState] [int] NULL,
	[ErrorProcedure] [varchar](100) NULL,
	[ErrorLine] [int] NULL,
	[ErrorMessage] [nvarchar](500) NULL,
	[Error_date] [datetime] NULL,
	[ErrorDatabase] [varchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[sn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sys_lobby_cdn_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sys_lobby_cdn_setting](
	[country_code] [varchar](10) NOT NULL,
	[domain] [varchar](100) NOT NULL,
	[app_domain] [varchar](100) NULL,
	[websocket] [varchar](100) NULL,
 CONSTRAINT [PK_sys_lobby_cdn_setting] PRIMARY KEY CLUSTERED 
(
	[country_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sys_lobby_cdn_setting_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sys_lobby_cdn_setting_log](
	[log_id] [int] IDENTITY(1000,1) NOT NULL,
	[old_domain] [varchar](100) NULL,
	[new_domain] [varchar](100) NULL,
	[old_app_domain] [varchar](100) NULL,
	[new_app_domain] [varchar](100) NULL,
	[update_time] [datetime] NOT NULL,
	[author] [varchar](100) NOT NULL,
 CONSTRAINT [PK_lobby_cdn_setting_log] PRIMARY KEY CLUSTERED 
(
	[log_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sys_main_sum_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sys_main_sum_log](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[tran_date] [datetime] NOT NULL,
	[begin_date] [datetime] NOT NULL,
	[end_date] [datetime] NOT NULL,
 CONSTRAINT [PK_sys_main_sum_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sys_maintenance]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sys_maintenance](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[begin_time] [datetime] NULL,
	[end_time] [datetime] NULL,
	[msg] [varchar](500) NULL,
	[create_by] [varchar](50) NULL,
	[create_time] [datetime] NULL,
	[merchant_code] [varchar](10) NOT NULL,
	[channel] [varchar](20) NULL,
	[channel_list] [varchar](50) NULL,
	[merchant_list] [varchar](max) NULL,
 CONSTRAINT [PK_sys_maintenance] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sys_menu]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sys_menu](
	[menu_id] [int] NOT NULL,
	[menu_name] [varchar](50) NOT NULL,
	[menu_url] [varchar](100) NOT NULL,
	[menu_seq] [int] NOT NULL,
	[title_id] [int] NOT NULL,
	[menu_en] [varchar](100) NULL,
	[menu_cn] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[menu_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sys_menu_button]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sys_menu_button](
	[menu_id] [int] NOT NULL,
	[btn_id] [varchar](50) NOT NULL,
	[url] [varchar](200) NULL,
	[seq] [int] NULL,
	[btn_en] [varchar](50) NULL,
	[btn_cn] [varchar](50) NULL,
 CONSTRAINT [PK_sys_menu_button] PRIMARY KEY CLUSTERED 
(
	[menu_id] ASC,
	[btn_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sys_merchant_currency_setting]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sys_merchant_currency_setting](
	[merchant_code] [varchar](20) NOT NULL,
	[curr_id] [varchar](20) NOT NULL,
	[white_ip_list] [varchar](1000) NULL,
 CONSTRAINT [PK_merchant_curr_setting] PRIMARY KEY CLUSTERED 
(
	[merchant_code] ASC,
	[curr_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sys_notice]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sys_notice](
	[notice_id] [bigint] IDENTITY(1,1) NOT NULL,
	[expired_date] [datetime] NOT NULL,
	[show_seq] [int] NULL,
	[disp_en] [varchar](200) NULL,
	[disp_cn] [nvarchar](400) NULL,
	[disp_th] [nvarchar](400) NULL,
	[disp_vn] [nvarchar](400) NULL,
	[disp_id] [nvarchar](400) NULL,
	[create_date] [datetime] NULL,
	[receiver] [varchar](5000) NULL,
	[creator_id] [varchar](30) NULL,
	[receiver_type] [varchar](10) NULL,
PRIMARY KEY CLUSTERED 
(
	[notice_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sys_operation_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sys_operation_log](
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[operator] [varchar](50) NULL,
	[ip] [varchar](50) NULL,
	[operation] [varchar](30) NULL,
	[bean_name] [varchar](100) NULL,
	[bean_key] [varchar](30) NULL,
	[bean_id] [varchar](256) NULL,
	[content] [varchar](max) NULL,
	[operated_date] [datetime] NOT NULL,
	[session_id] [varchar](128) NULL,
	[ip_geo] [nvarchar](256) NULL,
	[user_agent] [varchar](256) NULL,
	[server_id] [varchar](50) NULL,
	[merchant_code] [varchar](10) NULL,
	[merchant_group] [varchar](10) NULL,
	[agent] [varchar](50) NULL,
	[is_admin] [int] NULL,
	[role_id] [int] NULL,
 CONSTRAINT [PK_sys_operation_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sys_param]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sys_param](
	[id] [int] NOT NULL,
	[description] [nvarchar](400) NOT NULL,
	[val] [nvarchar](2000) NOT NULL,
	[tag] [varchar](20) NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sys_role_menu_button]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sys_role_menu_button](
	[role_id] [int] NOT NULL,
	[menu_id] [int] NOT NULL,
	[btn_id] [varchar](50) NOT NULL,
	[access_right] [bit] NULL,
 CONSTRAINT [PK_sys_role_menu_button] PRIMARY KEY CLUSTERED 
(
	[role_id] ASC,
	[menu_id] ASC,
	[btn_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sys_slow_query]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sys_slow_query](
	[sn] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[log_date] [datetime] NOT NULL,
	[avg_sec] [numeric](26, 6) NULL,
	[statement_text] [nvarchar](max) NULL,
	[text] [nvarchar](max) NULL,
	[report_text]  AS (((((('--'+format([log_date],'yyyy-MM-dd HH:mm:ss'))+' sec:')+CONVERT([varchar],[avg_sec],(0)))+char((13)))+[statement_text])+char((13))),
 CONSTRAINT [PK_sys_slow_query] PRIMARY KEY CLUSTERED 
(
	[sn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sys_title]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sys_title](
	[title_id] [int] NOT NULL,
	[title_desc] [varchar](50) NOT NULL,
	[title_en] [varchar](30) NULL,
	[title_cn] [varchar](30) NULL,
	[title_seq] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[title_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sys_up_api_bet_history_execution]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sys_up_api_bet_history_execution](
	[sn] [int] IDENTITY(1,1) NOT NULL,
	[merchant] [varchar](10) NULL,
	[beginDate] [datetime] NULL,
	[enddate] [datetime] NULL,
	[pageindex] [int] NULL,
	[pagesize] [int] NULL,
	[record] [int] NULL,
	[starttime] [datetime] NULL,
	[endtime] [datetime] NULL,
	[sec]  AS (datediff(second,[starttime],[endtime])),
PRIMARY KEY CLUSTERED 
(
	[sn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[sys_update_flag]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sys_update_flag](
	[table_name] [varchar](50) NULL,
	[updatetime] [datetime] NULL,
	[flag] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[system_config_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[system_config_log](
	[log_id] [int] IDENTITY(1,1) NOT NULL,
	[c_name] [varchar](50) NOT NULL,
	[old_value] [varchar](256) NOT NULL,
	[config_value] [varchar](256) NOT NULL,
	[created_by] [varchar](50) NULL,
	[created_date] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[log_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ticket_all_archive]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ticket_all_archive](
	[ticket_id] [bigint] NOT NULL,
	[merchant_code] [varchar](10) NULL,
	[acct_id] [varchar](70) NULL,
	[login_id] [varchar](50) NULL,
	[category_id] [varchar](30) NULL,
	[game_code] [varchar](10) NULL,
	[ticket_date] [datetime] NOT NULL,
	[bet_amt] [numeric](18, 6) NULL,
	[wl_amt] [numeric](18, 6) NULL,
	[curr_id] [varchar](3) NULL,
	[curr_rate] [numeric](18, 4) NULL,
	[last_balance] [numeric](18, 6) NULL,
	[jp_amt] [numeric](18, 6) NULL,
	[result] [varchar](1024) NULL,
	[client_ip] [varchar](50) NULL,
	[lucky_draw_id] [int] NULL,
	[round_id] [int] NULL,
	[is_complete] [int] NULL,
	[merchant_txid] [varchar](100) NULL,
	[sequence] [tinyint] NULL,
	[channel] [varchar](10) NULL,
	[fingerprint] [varchar](256) NULL,
	[is_valid] [bit] NULL,
	[rtp] [int] NULL,
	[volatility] [varchar](20) NULL,
	[jp_win] [numeric](18, 6) NULL,
	[is_one_wallet] [int] NULL,
	[reference_id] [varchar](50) NULL,
	[save_date] [datetime] NULL,
	[result_rule] [varchar](256) NULL,
	[spin_id] [bigint] NULL,
	[server_name] [varchar](10) NULL,
	[special_type] [varchar](20) NULL,
	[special_count] [int] NULL,
	[special_seq] [int] NULL,
	[base_log_id] [bigint] NULL,
	[logic_code] [varchar](10) NULL,
	[provider] [varchar](5) NULL,
	[game_code_view] [varchar](10) NULL,
	[temp_bet_amt] [numeric](18, 6) NULL,
	[draw_amt] [numeric](18, 6) NULL,
	[logic_num] [numeric](18, 6) NULL,
	[multiple] [numeric](5, 2) NULL,
	[game_round_id] [bigint] NULL,
	[multiples] [numeric](10, 2) NULL,
	[session_id] [varchar](50) NULL,
 CONSTRAINT [PK_ticket_all_archive] PRIMARY KEY CLUSTERED 
(
	[ticket_id] ASC,
	[ticket_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ticket_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ticket_log](
	[ticket_id] [varchar](30) NOT NULL,
	[ref_id] [bigint] NULL,
	[ticket_date] [datetime] NULL,
	[req] [varchar](8000) NULL,
	[rsp] [varchar](max) NULL,
 CONSTRAINT [PK_ticket_log] PRIMARY KEY CLUSTERED 
(
	[ticket_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tournament]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tournament](
	[id] [bigint] IDENTITY(1000,1) NOT NULL,
	[begin_time] [datetime] NULL,
	[end_time] [datetime] NULL,
	[merchant_code] [varchar](30) NULL,
	[lucky_num] [int] NULL,
	[bonus] [varchar](100) NULL,
	[create_by] [varchar](30) NULL,
	[create_time] [datetime] NULL,
	[cancel_by] [varchar](30) NULL,
	[cancel_time] [datetime] NULL,
	[update_by] [varchar](30) NULL,
	[update_time] [datetime] NULL,
	[status] [int] NULL,
	[checks] [int] NULL,
	[check_by] [varchar](30) NULL,
	[check_time] [datetime] NULL,
	[check_status] [int] NULL,
	[turnover] [numeric](18, 2) NULL,
	[currency] [varchar](30) NULL,
	[game_code] [varchar](30) NULL,
	[bonus_send_status] [int] NULL,
 CONSTRAINT [PK_tournament] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tournament_result_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tournament_result_log](
	[id] [bigint] IDENTITY(1000,1) NOT NULL,
	[tournament_id] [bigint] NULL,
	[merchant_code] [varchar](10) NULL,
	[acct_id] [varchar](80) NULL,
	[game_code] [varchar](20) NULL,
	[curr_id] [varchar](5) NULL,
	[ticket_id] [bigint] NULL,
	[bet_amt] [numeric](18, 6) NULL,
	[wl_amt] [numeric](18, 6) NULL,
	[win_amt] [numeric](18, 6) NULL,
	[multiple] [numeric](18, 2) NULL,
	[bonus] [numeric](18, 2) NULL,
	[ranking] [int] NULL,
	[created_date] [datetime] NULL,
	[status] [tinyint] NULL,
	[ticket_date] [datetime] NULL,
	[reference_id] [bigint] NULL,
 CONSTRAINT [PK_tournament_result_log] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tracking_system]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tracking_system](
	[tracking_id] [bigint] IDENTITY(1000,1) NOT NULL,
	[type] [int] NULL,
	[merchant_code] [varchar](20) NULL,
	[description] [varchar](5000) NULL,
	[solution] [varchar](5000) NULL,
	[resolution] [int] NULL,
	[owner_by] [varchar](30) NULL,
	[create_date] [datetime] NULL,
 CONSTRAINT [PK_trancking_system] PRIMARY KEY CLUSTERED 
(
	[tracking_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[user_info]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[user_info](
	[user_id] [varchar](30) NOT NULL,
	[merchant_code] [varchar](10) NOT NULL,
	[user_name] [nvarchar](100) NOT NULL,
	[acct_pwd] [varchar](252) NOT NULL,
	[status] [smallint] NOT NULL,
	[is_power_admin] [int] NULL,
	[role_id] [int] NOT NULL,
	[is_lock] [smallint] NULL,
	[error_count] [int] NOT NULL,
	[creator_id] [varchar](30) NULL,
	[create_date] [datetime] NULL,
	[last_update_id] [varchar](30) NULL,
	[last_update_date] [datetime] NULL,
	[is_online] [smallint] NULL,
	[login_time] [datetime] NULL,
	[login_ip] [varchar](50) NULL,
	[login_ip_geo] [varchar](256) NULL,
	[login_sid] [varchar](128) NULL,
	[is_risk] [int] NOT NULL,
	[agent] [varchar](50) NULL,
 CONSTRAINT [PK_user_info] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC,
	[merchant_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[user_role]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[user_role](
	[merchant_code] [varchar](10) NOT NULL,
	[role_id] [int] IDENTITY(7,1) NOT NULL,
	[role_desc] [nvarchar](100) NULL,
	[created_by] [varchar](30) NULL,
	[created_date] [datetime] NULL,
	[updated_by] [varchar](30) NULL,
	[updated_date] [datetime] NULL,
	[role_mark] [varchar](50) NULL,
	[parent_role] [int] NULL,
 CONSTRAINT [PK_user_role] PRIMARY KEY CLUSTERED 
(
	[merchant_code] ASC,
	[role_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[user_role_menu]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[user_role_menu](
	[merchant_code] [varchar](10) NOT NULL,
	[role_id] [int] NOT NULL,
	[menu_id] [int] NOT NULL,
	[access_right] [int] NULL,
 CONSTRAINT [PK_user_role_menu] PRIMARY KEY CLUSTERED 
(
	[merchant_code] ASC,
	[role_id] ASC,
	[menu_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[user_session_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[user_session_log](
	[log_id] [bigint] IDENTITY(1,1) NOT NULL,
	[merchant_code] [varchar](10) NOT NULL,
	[user_id] [varchar](30) NULL,
	[session_id] [varchar](50) NULL,
	[login_time] [datetime] NULL,
	[login_ip] [varchar](50) NULL,
	[login_ip_geo] [nvarchar](128) NULL,
	[logout_time] [datetime] NULL,
	[duration] [int] NULL,
 CONSTRAINT [PK_user_session_log] PRIMARY KEY CLUSTERED 
(
	[log_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[warning_data]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[warning_data](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[merchant] [varchar](20) NOT NULL,
	[player] [varchar](50) NOT NULL,
	[ip] [varchar](50) NULL,
	[create_date] [datetime] NOT NULL,
	[is_processed] [int] NOT NULL,
	[remarks] [varchar](500) NOT NULL,
	[game_code] [varchar](10) NOT NULL,
	[curr_id] [varchar](10) NOT NULL,
	[level] [tinyint] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[win_big_jackpot_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[win_big_jackpot_log](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[acct_id] [varchar](20) NOT NULL,
	[sequence] [int] NOT NULL,
	[curr_id] [varchar](10) NOT NULL,
	[jackpot_code] [varchar](30) NULL,
	[jackpot_amt] [decimal](18, 6) NOT NULL,
	[win_date] [datetime] NOT NULL,
	[message] [varchar](1000) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_time_merchant]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_time_merchant] ON [dbo].[acct_credit_local_transfer]
(
	[operate_time] ASC,
	[merchant_code] ASC,
	[value_warning] ASC
)
INCLUDE([id],[acct_id],[login_id],[tran_type],[currency],[value_before],[value_change],[value_after],[transfer_no]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_operate_time]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_operate_time] ON [dbo].[acct_credit_log]
(
	[operate_time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [idx_date]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_date] ON [dbo].[acct_credit_transfer]
(
	[operate_time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [idx_operate_time_idx]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_operate_time_idx] ON [dbo].[acct_credit_transfer]
(
	[operate_time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [idx_ticket_date]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_ticket_date] ON [dbo].[acct_game_big_win_log]
(
	[ticket_date] ASC,
	[merchant_code] ASC
)
INCLUDE([ticket_id],[login_id],[game_code],[curr_id],[win_amt]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_acct_game]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_acct_game] ON [dbo].[acct_game_daily_tran_fix_log]
(
	[tran_date] ASC,
	[acct_id] ASC,
	[tran_type] ASC,
	[game_code] ASC,
	[channel] ASC,
	[provider] ASC
)
INCLUDE([t_bet_count],[t_ttl_bet],[t_wl_amt],[t_jp_contribute_amt],[t_jp_win],[t_draw_amt]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_create_date_merchant_code]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_create_date_merchant_code] ON [dbo].[acct_info]
(
	[create_date] ASC,
	[merchant_code] ASC
)
INCLUDE([acct_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [idx_login_time]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_login_time] ON [dbo].[acct_info]
(
	[is_online] ASC,
	[login_time] ASC
)
INCLUDE([acct_id],[login_sid]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_merchant_code]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_merchant_code] ON [dbo].[acct_info]
(
	[merchant_code] ASC,
	[create_date] ASC
)
INCLUDE([login_id],[acct_id],[acct_name],[status],[is_online],[risk],[site_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_acct_session_id]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_acct_session_id] ON [dbo].[acct_session_log]
(
	[acct_id] ASC,
	[session_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_login_duration_acct]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_login_duration_acct] ON [dbo].[acct_session_log]
(
	[login_time] ASC,
	[duration] ASC,
	[acct_id] ASC
)
INCLUDE([log_id],[session_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IDX_acct_token]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IDX_acct_token] ON [dbo].[aggregator_session_log]
(
	[acct_id] ASC,
	[merchant_token] ASC
)
INCLUDE([attrs]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_serial_no]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_serial_no] ON [dbo].[api_call_log]
(
	[serial_no] ASC,
	[merchant] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_date_device]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_date_device] ON [dbo].[device_daily_tran]
(
	[tran_date] ASC,
	[device] ASC
)
INCLUDE([total_count]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [arcade_ante_log_round_id_index]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [arcade_ante_log_round_id_index] ON [dbo].[game_arcade_ante_log]
(
	[round_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [arcade_bet_log_round_id_index]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [arcade_bet_log_round_id_index] ON [dbo].[game_arcade_bet_log]
(
	[round_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_acct_game]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_acct_game] ON [dbo].[game_arcade_free_game_log]
(
	[merchant_code] ASC,
	[created_by] ASC,
	[completed] ASC
)
INCLUDE([round_id],[bonus_spin_win],[bonus_spin_round],[bonus_round_result],[free_spin_win],[free_spin_round],[free_spin_round_id],[free_spin_multiplyer],[bonus_base_multiplyer],[bonus_base_win],[pay_table_index],[game_code],[created_date],[transferId],[status]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IDX_big_jackpot_pools]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IDX_big_jackpot_pools] ON [dbo].[game_big_jackpot_pools]
(
	[currency] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_date_status_acct]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_date_status_acct] ON [dbo].[game_fish_acct_tran]
(
	[start_date] ASC,
	[status] ASC,
	[acct_id] ASC
)
INCLUDE([id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_ticket_date]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_ticket_date] ON [dbo].[game_fish_acct_tran]
(
	[end_date] ASC,
	[status] ASC,
	[acct_id] ASC
)
INCLUDE([ticket_id],[login_id],[merchant_code],[curr_id],[game_code],[start_date],[hall_id],[room_id],[bet_count],[bet_amt],[win_amt],[cancel_amt],[cancel_count],[result]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [IDX_game_fish_bet_log_acct_tran_id]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [IDX_game_fish_bet_log_acct_tran_id] ON [dbo].[game_fish_bet_log]
(
	[acct_tran_id] ASC,
	[type] ASC
)
INCLUDE([bet_amt],[win_amt],[result],[id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_create_time]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_create_time] ON [dbo].[game_fish_game_log]
(
	[create_time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_date_status]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_date_status] ON [dbo].[game_fish_warning_log]
(
	[create_date] ASC,
	[status] ASC,
	[acct_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_rtp]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_rtp] ON [dbo].[game_jackpot_pools]
(
	[rtp] ASC
)
INCLUDE([curr_id],[games_win],[games_lose],[max_lose_limit],[merchant_group],[game_code],[volatility]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_create_id_date]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_create_id_date] ON [dbo].[game_jackpot_win_log]
(
	[created_by] ASC,
	[created_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_game_code]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_game_code] ON [dbo].[game_jackpot_win_log]
(
	[game_code] ASC,
	[jackpot_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_round_id]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_round_id] ON [dbo].[game_jackpot_win_log]
(
	[round_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IDX_GAME_LIMIT_SETTING]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE UNIQUE NONCLUSTERED INDEX [IDX_GAME_LIMIT_SETTING] ON [dbo].[game_limit_setting]
(
	[game_code] ASC,
	[curr_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_game_logic_param]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_game_logic_param] ON [dbo].[game_logic_param_log]
(
	[game_code] ASC,
	[created_by] ASC,
	[logic_type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IDX_game_logic_param_setting_gameCode]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [IDX_game_logic_param_setting_gameCode] ON [dbo].[game_logic_param_setting]
(
	[game_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [Idx_game_mutiplayer_arcade_result_log_game_code]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [Idx_game_mutiplayer_arcade_result_log_game_code] ON [dbo].[game_mutiplayer_arcade_result_log]
(
	[game_code] ASC
)
INCLUDE([round_id],[pay_table_index],[pay_table],[color_table_index],[color_table],[symbol_index],[color_index],[bonus_round],[draw_id],[rank],[bonus_result]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_game_mutiplayer_derby_bet_log_agc]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_game_mutiplayer_derby_bet_log_agc] ON [dbo].[game_mutiplayer_derby_bet_log]
(
	[acct_id] ASC,
	[game_code] ASC,
	[created_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_date]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_date] ON [dbo].[game_respin_warning_log]
(
	[create_date] ASC,
	[merchant_code] ASC,
	[login_id] ASC
)
INCLUDE([game_code],[curr_id],[bet_amt],[origin_bet_amt],[win_amt],[multiple],[reference_id],[remarks],[client_ip]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [idx_bet_count_begin_bet_count_end]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE UNIQUE NONCLUSTERED INDEX [idx_bet_count_begin_bet_count_end] ON [dbo].[game_rtp_warning_setting]
(
	[bet_count_begin] ASC,
	[bet_count_end] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_acct_game]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_acct_game] ON [dbo].[game_slot_machine_game_log]
(
	[merchant_code] ASC,
	[created_by] ASC,
	[game_code] ASC,
	[completed] ASC
)
INCLUDE([round_id],[line],[line_bet],[bonus_round_win],[bonus_round_completed],[free_spin_round_win],[free_spin_round_completed],[free_spin_round_id],[free_spin_multiplyer],[created_date],[domination],[transferId],[game_win],[login_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_promotion]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_promotion] ON [dbo].[game_slot_machine_game_log]
(
	[completed] ASC,
	[promotion_log_id] ASC
)
INCLUDE([round_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_acct_game]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_acct_game] ON [dbo].[game_slot_machine_game_log_archive]
(
	[merchant_code] ASC,
	[created_by] ASC,
	[game_code] ASC,
	[completed] ASC
)
INCLUDE([round_id],[line],[line_bet],[bonus_round_win],[bonus_round_completed],[free_spin_round_win],[free_spin_round_completed],[free_spin_round_id],[free_spin_multiplyer],[created_date],[domination],[transferId],[game_win],[login_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_date]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_date] ON [dbo].[game_slot_machine_game_log_archive]
(
	[created_date] ASC,
	[transferId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IDX_MERCHANT_CURR_STATUS]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [IDX_MERCHANT_CURR_STATUS] ON [dbo].[lucky_bonus_credit_tran]
(
	[merchant_code] ASC,
	[curr_id] ASC,
	[status] ASC
)
INCLUDE([begin_date],[end_date],[promotion_end_date]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [IDX_TRAN_ID]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [IDX_TRAN_ID] ON [dbo].[lucky_bonus_credit_tran_fixed_item]
(
	[tran_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [idx_tran_id]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_tran_id] ON [dbo].[lucky_bonus_credit_tran_item]
(
	[tran_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_lucky_draw_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_lucky_draw_log] ON [dbo].[lucky_draw_log]
(
	[tran_id] ASC,
	[acct_id] ASC,
	[merchant_code] ASC,
	[curr_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_time_merchant_currId]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_time_merchant_currId] ON [dbo].[lucky_draw_log]
(
	[draw_time] ASC,
	[merchant_code] ASC,
	[curr_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IDX_MERCHANT_CURR]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [IDX_MERCHANT_CURR] ON [dbo].[lucky_draw_tran]
(
	[merchant_code] ASC,
	[curr_id] ASC
)
INCLUDE([begin_date],[end_date],[accumulate_date],[status]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [idx_red_packet_item_tran_id]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_red_packet_item_tran_id] ON [dbo].[lucky_draw_tran_item]
(
	[tran_id] ASC,
	[amt] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = ON, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [idx_tran_id_group]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_tran_id_group] ON [dbo].[lucky_free_spin_acct_group]
(
	[tran_id] ASC,
	[promotion_group] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_tran_id_code_group]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_tran_id_code_group] ON [dbo].[lucky_free_spin_game_config]
(
	[tran_id] ASC,
	[promotion_code] ASC,
	[promotion_group] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [idx_status]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_status] ON [dbo].[lucky_free_spin_log]
(
	[status] ASC,
	[tran_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_tran_id_code_group]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_tran_id_code_group] ON [dbo].[lucky_free_spin_refill_log]
(
	[tran_id] ASC,
	[promotion_code] ASC,
	[promotion_group] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_list_lucky_free_spin_sub]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_list_lucky_free_spin_sub] ON [dbo].[lucky_free_spin_sub]
(
	[begin_date] ASC,
	[merchant_code] ASC,
	[curr_id] ASC,
	[status] ASC,
	[tran_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [idx_tranId_status]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_tranId_status] ON [dbo].[lucky_free_spin_sub]
(
	[tran_id] ASC,
	[status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_pid_code]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_pid_code] ON [dbo].[lucky_merchant_promotion_blacklist]
(
	[promotion_id] ASC,
	[promotion_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_pid_merchantCode_currId]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_pid_merchantCode_currId] ON [dbo].[lucky_promotion_blacklist]
(
	[promotion_id] ASC,
	[merchant_code] ASC,
	[curr_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [idx_status_tranId_gameCode]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_status_tranId_gameCode] ON [dbo].[lucky_tournament_award]
(
	[status] ASC,
	[tran_id] ASC,
	[game_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_unique]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE UNIQUE NONCLUSTERED INDEX [idx_unique] ON [dbo].[lucky_tournament_integral_log]
(
	[acct_id] ASC,
	[tran_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_tranId_code]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_tranId_code] ON [dbo].[lucky_tournament_log]
(
	[tournament_id] ASC,
	[tournament_game_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_tran_id]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_tran_id] ON [dbo].[lucky_tournament_rank]
(
	[tran_id] ASC,
	[tournament_game_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [idx_beginDate_merchant_currId_status_examine_examineStatus]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_beginDate_merchant_currId_status_examine_examineStatus] ON [dbo].[lucky_tournament_sub]
(
	[begin_date] ASC,
	[merchant_code] ASC,
	[curr_id] ASC,
	[status] ASC,
	[examine] ASC,
	[examine_status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [idx_tranId_status]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_tranId_status] ON [dbo].[lucky_tournament_sub]
(
	[tran_id] ASC,
	[status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_lucky_wheel_config_merchant_currId_status]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_lucky_wheel_config_merchant_currId_status] ON [dbo].[lucky_wheel_config]
(
	[merchant_code] ASC,
	[curr_id] ASC,
	[status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [idx_tranId_status]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_tranId_status] ON [dbo].[lucky_wheel_stop_detail]
(
	[tran_id] ASC,
	[status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_lucky_wheel_tran_merchant_code_status]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_lucky_wheel_tran_merchant_code_status] ON [dbo].[lucky_wheel_tran]
(
	[original_start_date] ASC,
	[merchant_code] ASC,
	[status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_lucky_wheel_tran_item_merchant_currId_acct]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_lucky_wheel_tran_item_merchant_currId_acct] ON [dbo].[lucky_wheel_tran_item]
(
	[merchant_code] ASC,
	[curr_id] ASC,
	[acct_id] ASC
)
INCLUDE([tran_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_lucky_wheel_tran_log_merchant_code_status]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_lucky_wheel_tran_log_merchant_code_status] ON [dbo].[lucky_wheel_tran_log]
(
	[begin_date] ASC,
	[merchant_code] ASC,
	[status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_lucky_wheel_spin_log_tranId_acctId_spinIndex]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_lucky_wheel_spin_log_tranId_acctId_spinIndex] ON [dbo].[lucky_wheel_tran_spin_log]
(
	[tran_id] ASC,
	[acct_id] ASC,
	[spin_index] ASC
)
INCLUDE([mystery_gift_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_lucky_wheel_tran_spin_log_time_merchant_currId_game_channel]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_lucky_wheel_tran_spin_log_time_merchant_currId_game_channel] ON [dbo].[lucky_wheel_tran_spin_log]
(
	[create_date] ASC,
	[merchant_code] ASC,
	[curr_id] ASC,
	[category] ASC,
	[game_code] ASC,
	[acct_id] ASC,
	[channel] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IDX_STATUS_MERCHANT_CURR]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [IDX_STATUS_MERCHANT_CURR] ON [dbo].[merchant_promotion]
(
	[status] ASC,
	[merchant_code] ASC,
	[curr_id] ASC
)
INCLUDE([begin_date],[end_date],[game_code],[tran_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_merchant_site_setting_merchant_code_status]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_merchant_site_setting_merchant_code_status] ON [dbo].[merchant_site_setting]
(
	[merchant_code] ASC,
	[status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_date_merchant]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_date_merchant] ON [dbo].[one_wallet_transfer]
(
	[operate_time] ASC,
	[is_success] ASC,
	[merchant_code] ASC,
	[tran_type] ASC
)
INCLUDE([login_id],[ticket_id],[reference_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_date_merchant]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_date_merchant] ON [dbo].[one_wallet_transfer_all]
(
	[operate_time] ASC,
	[is_success] ASC,
	[merchant_code] ASC,
	[tran_type] ASC
)
INCLUDE([login_id],[ticket_id],[reference_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [Psh_owt]([operate_time])
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_date_merchant]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_date_merchant] ON [dbo].[one_wallet_transfer_all_archive]
(
	[operate_time] ASC,
	[is_success] ASC,
	[merchant_code] ASC,
	[tran_type] ASC
)
INCLUDE([login_id],[ticket_id],[reference_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [Psh_owt]([operate_time])
GO
/****** Object:  Index [idx_date_status_type]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_date_status_type] ON [dbo].[one_wallet_transfer_cancel_exception_log]
(
	[create_date] ASC,
	[status] ASC,
	[tran_type] ASC
)
INCLUDE([id],[ticket_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_check_id]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_check_id] ON [dbo].[provider_ab_transfer_log]
(
	[reference_id] ASC,
	[tran_type] ASC
)
INCLUDE([id],[tran_id],[ticket_id],[acct_id],[round_id],[login_id],[ab_acct_id],[merchant_code],[curr_id],[transfer_amount],[operate_time],[table_id],[game_code],[channel],[status],[onewallet_bet_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_check_id]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_check_id] ON [dbo].[provider_ag_transfer_log]
(
	[reference_id] ASC,
	[tran_type] ASC
)
INCLUDE([id],[ticket_id],[tran_id],[bet_type],[round_id],[table_code],[acct_id],[login_id],[ag_acct_id],[merchant_code],[curr_id],[transfer_amount],[operate_time],[table_id],[game_code],[channel],[status],[bet_time],[onewallet_bet_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_check_id]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_check_id] ON [dbo].[provider_ev_transfer_log]
(
	[reference_id] ASC,
	[tran_type] ASC
)
INCLUDE([id],[acct_id],[tran_id],[login_id],[ev_acct_id],[merchant_code],[curr_id],[transfer_amount],[operate_time],[table_id],[game_code],[channel],[status],[onewallet_bet_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_date_type_merchant_acct_ip]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_date_type_merchant_acct_ip] ON [dbo].[risk_acct_log]
(
	[create_date] ASC,
	[risk_type] ASC,
	[merchant_code] ASC,
	[acct_id] ASC,
	[client_ip] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [idx_create_date_status]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_create_date_status] ON [dbo].[risk_ip]
(
	[create_date] ASC,
	[status] ASC
)
INCLUDE([client_ip]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_currency_date]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_currency_date] ON [dbo].[sys_currency_log]
(
	[curr_id] ASC,
	[curr_status] ASC,
	[curr_month] ASC,
	[curr_mth_start] ASC,
	[curr_mth_end] ASC
)
INCLUDE([real_curr_rate_after]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_table_name]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_table_name] ON [dbo].[sys_data_copy_log]
(
	[table_name] ASC,
	[status] ASC,
	[save_end_date] ASC,
	[log_date] ASC
)
INCLUDE([id],[save_start_date],[copy_records_count]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IDX_DATE]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [IDX_DATE] ON [dbo].[sys_maintenance]
(
	[begin_time] ASC,
	[end_time] ASC
)
INCLUDE([msg],[create_by],[create_time]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [idx_tournament_date]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_tournament_date] ON [dbo].[tournament]
(
	[begin_time] ASC,
	[status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [idx_tournament_result_log_tournament_id]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_tournament_result_log_tournament_id] ON [dbo].[tournament_result_log]
(
	[tournament_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_win_big_jackpot_log]    Script Date: 2022/11/14 下午 04:55:19 ******/
CREATE NONCLUSTERED INDEX [idx_win_big_jackpot_log] ON [dbo].[win_big_jackpot_log]
(
	[acct_id] ASC,
	[sequence] ASC,
	[curr_id] ASC,
	[jackpot_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[acct_game_daily_tran_error] ADD  CONSTRAINT [DF_acct_game_daily_tran_error_jp_contribute_amt]  DEFAULT ((0)) FOR [jp_contribute_amt]
GO
ALTER TABLE [dbo].[acct_game_daily_tran_error] ADD  CONSTRAINT [DF_acct_game_daily_tran_error_channel]  DEFAULT ('Web') FOR [channel]
GO
ALTER TABLE [dbo].[acct_game_daily_tran_fix_log] ADD  DEFAULT (getdate()) FOR [create_date]
GO
ALTER TABLE [dbo].[acct_game_daily_tran_fix_log] ADD  DEFAULT ((0)) FOR [status]
GO
ALTER TABLE [dbo].[acct_info] ADD  DEFAULT ((0)) FOR [is_lock]
GO
ALTER TABLE [dbo].[acct_info] ADD  DEFAULT ((0)) FOR [error_count]
GO
ALTER TABLE [dbo].[acct_info] ADD  DEFAULT ((0)) FOR [type]
GO
ALTER TABLE [dbo].[acct_info_archive] ADD  DEFAULT ((0)) FOR [is_lock]
GO
ALTER TABLE [dbo].[acct_info_archive] ADD  DEFAULT ((0)) FOR [error_count]
GO
ALTER TABLE [dbo].[acct_info_archive] ADD  DEFAULT ((0)) FOR [type]
GO
ALTER TABLE [dbo].[acct_session_log] ADD  DEFAULT ('Web') FOR [channel]
GO
ALTER TABLE [dbo].[game_arcade_free_game_log] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[game_arcade_free_game_log_archive] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[game_board_setting] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[game_fish_group_setting] ADD  DEFAULT (NULL) FOR [group_name]
GO
ALTER TABLE [dbo].[game_info] ADD  CONSTRAINT [DF_game_info_param_setting]  DEFAULT ((0)) FOR [param_setting]
GO
ALTER TABLE [dbo].[game_mutiplayer_setting] ADD  DEFAULT ((0)) FOR [special_game_seconds]
GO
ALTER TABLE [dbo].[game_slot_machine_gamble_game_log] ADD  DEFAULT ((0)) FOR [banker_card_id]
GO
ALTER TABLE [dbo].[game_slot_machine_game_log] ADD  DEFAULT ((0)) FOR [game_win]
GO
ALTER TABLE [dbo].[game_slot_machine_game_log] ADD  DEFAULT ((0)) FOR [free_spin_index]
GO
ALTER TABLE [dbo].[game_slot_machine_game_log] ADD  DEFAULT ((0)) FOR [remaining_count]
GO
ALTER TABLE [dbo].[game_slot_machine_game_log] ADD  DEFAULT ((1)) FOR [bonus_round_multiplyer]
GO
ALTER TABLE [dbo].[game_slot_machine_game_log] ADD  DEFAULT ((0)) FOR [free_multiply_index]
GO
ALTER TABLE [dbo].[game_slot_machine_game_log] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[game_slot_machine_game_log_archive] ADD  DEFAULT ((0)) FOR [game_win]
GO
ALTER TABLE [dbo].[game_slot_machine_game_log_archive] ADD  DEFAULT ((0)) FOR [free_spin_index]
GO
ALTER TABLE [dbo].[game_slot_machine_game_log_archive] ADD  DEFAULT ((0)) FOR [remaining_count]
GO
ALTER TABLE [dbo].[game_slot_machine_game_log_archive] ADD  DEFAULT ((1)) FOR [bonus_round_multiplyer]
GO
ALTER TABLE [dbo].[game_slot_machine_game_log_archive] ADD  DEFAULT ((0)) FOR [free_multiply_index]
GO
ALTER TABLE [dbo].[game_slot_machine_game_log_archive] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[game_slot_machine_symbol_pay] ADD  DEFAULT ((0)) FOR [table_type]
GO
ALTER TABLE [dbo].[game_slot_machine_symbol_ref] ADD  DEFAULT ((0)) FOR [wild_type]
GO
ALTER TABLE [dbo].[lucky_free_spin] ADD  DEFAULT ((0)) FOR [type]
GO
ALTER TABLE [dbo].[lucky_free_spin_game_config] ADD  DEFAULT ((1)) FOR [random_type]
GO
ALTER TABLE [dbo].[lucky_free_spin_sub] ADD  DEFAULT ((0)) FOR [type]
GO
ALTER TABLE [dbo].[merchant] ADD  DEFAULT ((0)) FOR [ow_param_setting]
GO
ALTER TABLE [dbo].[merchant_archive] ADD  DEFAULT ((0)) FOR [ow_param_setting]
GO
ALTER TABLE [dbo].[merchant_email_notification_setting] ADD  DEFAULT ((0.00)) FOR [daily_big_win]
GO
ALTER TABLE [dbo].[merchant_transfer_setting] ADD  DEFAULT ((0)) FOR [invalid_count]
GO
ALTER TABLE [dbo].[provider_acct_daily_tran] ADD  CONSTRAINT [DF_provider_acct_daily_tran_jp_contribute_amt]  DEFAULT ((0)) FOR [jp_contribute_amt]
GO
ALTER TABLE [dbo].[provider_acct_daily_tran] ADD  DEFAULT ('Web') FOR [channel]
GO
ALTER TABLE [dbo].[provider_acct_daily_tran] ADD  DEFAULT (NULL) FOR [acct_create_date]
GO
ALTER TABLE [dbo].[provider_acct_game_daily_tran] ADD  CONSTRAINT [DF_provider_acct_game_daily_tran_jp_contribute_amt]  DEFAULT ((0)) FOR [jp_contribute_amt]
GO
ALTER TABLE [dbo].[provider_acct_game_daily_tran] ADD  CONSTRAINT [DF_provider_acct_game_daily_tran_channel]  DEFAULT ('Web') FOR [channel]
GO
ALTER TABLE [dbo].[provider_acct_game_daily_tran] ADD  DEFAULT (NULL) FOR [acct_create_date]
GO
ALTER TABLE [dbo].[risk_game_setting] ADD  DEFAULT ((0)) FOR [low_wl_multiple]
GO
ALTER TABLE [dbo].[risk_game_setting] ADD  DEFAULT ((0)) FOR [medium_wl_multiple]
GO
ALTER TABLE [dbo].[risk_game_setting] ADD  DEFAULT ((0)) FOR [high_wl_multiple]
GO
ALTER TABLE [dbo].[sys_currency] ADD  DEFAULT ((0)) FOR [curr_type]
GO
ALTER TABLE [dbo].[sys_currency_log] ADD  CONSTRAINT [DF_sys_currency_log_curr_rate1]  DEFAULT ((1)) FOR [curr_rate_before]
GO
ALTER TABLE [dbo].[sys_currency_log] ADD  CONSTRAINT [DF_sys_currency_log_curr_rate]  DEFAULT ((1)) FOR [curr_rate_after]
GO
ALTER TABLE [dbo].[sys_game_common_setting] ADD  DEFAULT ((0)) FOR [is_active]
GO
ALTER TABLE [dbo].[sys_game_common_setting] ADD  DEFAULT ((1)) FOR [is_jackpot]
GO
ALTER TABLE [dbo].[sys_jobs_errormessage] ADD  DEFAULT (getdate()) FOR [Error_date]
GO
ALTER TABLE [dbo].[sys_lobby_cdn_setting_log] ADD  CONSTRAINT [DF_lobby_cdn_setting_log_author]  DEFAULT ('ROOT') FOR [author]
GO
ALTER TABLE [dbo].[sys_maintenance] ADD  DEFAULT ('-') FOR [merchant_code]
GO
ALTER TABLE [dbo].[sys_maintenance] ADD  DEFAULT (NULL) FOR [channel]
GO
ALTER TABLE [dbo].[ticket_all_archive] ADD  CONSTRAINT [DF_ticket_archive_is_complete]  DEFAULT ((1)) FOR [is_complete]
GO
ALTER TABLE [dbo].[ticket_all_archive] ADD  CONSTRAINT [DF_ticket_archive_channel]  DEFAULT ('Web') FOR [channel]
GO
ALTER TABLE [dbo].[ticket_log] ADD  DEFAULT ((0)) FOR [ref_id]
GO
ALTER TABLE [dbo].[tournament] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[tournament] ADD  DEFAULT ((0)) FOR [checks]
GO
ALTER TABLE [dbo].[tournament] ADD  DEFAULT ((0)) FOR [check_status]
GO
ALTER TABLE [dbo].[tournament] ADD  DEFAULT ((0)) FOR [bonus_send_status]
GO
ALTER TABLE [dbo].[user_info] ADD  DEFAULT ((0)) FOR [is_risk]
GO
ALTER TABLE [dbo].[warning_data] ADD  DEFAULT ('') FOR [game_code]
GO
ALTER TABLE [dbo].[warning_data] ADD  DEFAULT ('') FOR [curr_id]
GO
/****** Object:  Trigger [dbo].[tr_acct_credit_log_rollback]    Script Date: 2022/11/14 下午 04:55:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[tr_acct_credit_log_rollback] 
   ON  [dbo].[acct_credit_log] 
   AFTER DELETE,UPDATE
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    ROLLBACK

END



GO
ALTER TABLE [dbo].[acct_credit_log] ENABLE TRIGGER [tr_acct_credit_log_rollback]
GO
/****** Object:  Trigger [dbo].[tri_sys_merchant_promotion]    Script Date: 2022/11/14 下午 04:55:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   TRIGGER [dbo].[tri_sys_merchant_promotion] ON [dbo].[merchant_promotion]
AFTER INSERT,UPDATE,DELETE
AS 
BEGIN
	SET NOCOUNT, ARITHABORT ON;
	
	BEGIN TRY

	UPDATE sys_update_flag SET flag = 1 , updatetime = GETDATE() WHERE table_name = 'merchant_promotion'

	END TRY
	BEGIN CATCH
		EXEC up_sys_error_log
	END CATCH

	SET NOCOUNT, ARITHABORT OFF;
END
GO
ALTER TABLE [dbo].[merchant_promotion] ENABLE TRIGGER [tri_sys_merchant_promotion]
GO
/****** Object:  Trigger [dbo].[tri_merchant_relation]    Script Date: 2022/11/14 下午 04:55:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   TRIGGER [dbo].[tri_merchant_relation] ON [dbo].[merchant_relation]
AFTER INSERT,UPDATE,DELETE
AS 
BEGIN
	SET NOCOUNT, ARITHABORT ON;
	
	BEGIN TRY
	
	--以前寫法 (安全性加固不支持)
	--DECLARE @RunStoredProcSQL VARCHAR(200);
	--SET @RunStoredProcSQL = 'EXEC [ic_egame_ticket].[dbo].[sp_sync_merchant_relation]';
	--EXEC (@RunStoredProcSQL) AT [IC-DB-TICK];

	UPDATE sys_update_flag SET flag = 1 , updatetime = GETDATE() WHERE table_name = 'merchant_relation'

	END TRY
	BEGIN CATCH
		EXEC up_sys_error_log
	END CATCH

	SET NOCOUNT, ARITHABORT OFF;
END
GO
ALTER TABLE [dbo].[merchant_relation] ENABLE TRIGGER [tri_merchant_relation]
GO
/****** Object:  Trigger [dbo].[tri_sys_currency_log]    Script Date: 2022/11/14 下午 04:55:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   TRIGGER [dbo].[tri_sys_currency_log] ON [dbo].[sys_currency_log]
AFTER INSERT,UPDATE,DELETE
AS 
BEGIN
	SET NOCOUNT, ARITHABORT ON;
	
	BEGIN TRY

	--以前寫法 (安全性加固不支持)
	--DECLARE @RunStoredProcSQL VARCHAR(200);
	--SET @RunStoredProcSQL = 'EXEC [ic_egame_ticket].[dbo].[sp_sync_sys_currency_log]';
	--EXEC (@RunStoredProcSQL) AT [IC-DB-TICK];

	UPDATE sys_update_flag SET updatetime = GETDATE() WHERE table_name = 'sys_currency_log'

	END TRY
	BEGIN CATCH
		EXEC up_sys_error_log
	END CATCH

	SET NOCOUNT, ARITHABORT OFF;
END
GO
ALTER TABLE [dbo].[sys_currency_log] ENABLE TRIGGER [tri_sys_currency_log]
GO
/****** Object:  Trigger [dbo].[tri_sys_sys_param]    Script Date: 2022/11/14 下午 04:55:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   TRIGGER [dbo].[tri_sys_sys_param] ON [dbo].[sys_param]
AFTER INSERT,UPDATE,DELETE
AS 
BEGIN
	SET NOCOUNT, ARITHABORT ON;
	
	BEGIN TRY

	--以前寫法 (安全性加固不支持)
	--DECLARE @RunStoredProcSQL VARCHAR(200);
	--SET @RunStoredProcSQL = 'EXEC [ic_egame_ticket].[dbo].[sp_sync_sys_param]';
	--EXEC (@RunStoredProcSQL) AT [IC-DB-TICK];

	UPDATE sys_update_flag SET flag = 1 , updatetime = GETDATE() WHERE table_name = 'sys_param'

	END TRY
	BEGIN CATCH
		EXEC up_sys_error_log
	END CATCH

	SET NOCOUNT, ARITHABORT OFF;
END
GO
ALTER TABLE [dbo].[sys_param] ENABLE TRIGGER [tri_sys_sys_param]
GO
