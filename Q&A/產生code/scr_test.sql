USE [Create_Code]
GO
/****** Object:  Table [dbo].[Create_Code_Table]    Script Date: 2022/12/1 下午 04:23:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Create_Code_Table](
	[a_identity] [int] IDENTITY(1,1) NOT NULL,
	[b_char] [char](20) NULL,
	[c_varchar] [varchar](100) NOT NULL,
	[d_varchar] [varchar](max) NULL,
	[e_test] [text] NULL,
	[f_nchar] [nchar](20) NULL,
	[g_NVARCHAR] [nvarchar](100) NULL,
	[h_NVARCHAR] [nvarchar](max) NULL,
	[i_ntext] [ntext] NULL,
	[j_smallint] [smallint] NULL,
	[k_int] [int] NOT NULL,
	[l_bigint] [bigint] NOT NULL,
	[m_decimal] [decimal](16, 8) NULL,
	[n_numeric] [numeric](16, 8) NULL,
	[o_float] [real] NULL,
	[p_datetime] [datetime] NOT NULL,
	[q_datetime2] [datetime2](7) NULL,
	[r_smalldatetime] [smalldatetime] NULL,
	[s_date] [date] NULL,
	[t_time] [time](7) NULL,
	[u_varbinary] [varbinary](20) NULL,
	[v_varbinary] [varbinary](max) NULL,
	[w_image] [image] NULL,
 CONSTRAINT [PK_Create_Code_Table] PRIMARY KEY NONCLUSTERED 
(
	[a_identity] ASC,
	[k_int] DESC,
	[p_datetime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[k_int] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[t_time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [cluster_idx_Create_Code_Table_unique]    Script Date: 2022/12/1 下午 04:23:34 ******/
CREATE UNIQUE CLUSTERED INDEX [cluster_idx_Create_Code_Table_unique] ON [dbo].[Create_Code_Table]
(
	[b_char] DESC,
	[f_nchar] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [idx_Create_Code_Table]    Script Date: 2022/12/1 下午 04:23:34 ******/
CREATE NONCLUSTERED INDEX [idx_Create_Code_Table] ON [dbo].[Create_Code_Table]
(
	[j_smallint] ASC,
	[s_date] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
/****** Object:  Index [idx_Create_Code_Table_unique]    Script Date: 2022/12/1 下午 04:23:34 ******/
CREATE UNIQUE NONCLUSTERED INDEX [idx_Create_Code_Table_unique] ON [dbo].[Create_Code_Table]
(
	[l_bigint] DESC,
	[t_time] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
