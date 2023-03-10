--DROP DATABASE IF EXISTS [Create_Code]
--CREATE DATABASE [Create_Code]
DROP TABLE IF EXISTS [Create_Code_Table]
CREATE TABLE [Create_Code_Table]
(
	a_identity INT IDENTITY(1,1),
	----------------字串(元)資料 (Character & Strings Data)：----------------
	b_char CHAR(20), 
	c_varchar VARCHAR(100) NOT NULL, 
	d_varchar VARCHAR(MAX), 
	e_test TEXT, 
	-----------------Unicode 字串：------------------------------------------
	f_nchar NCHAR(20),
	g_NVARCHAR NVARCHAR(100),
	h_NVARCHAR NVARCHAR(MAX),
	i_ntext NTEXT,
	-----------------Number 類型：-------------------------------------------
	j_smallint SMALLINT,
	k_int INT UNIQUE,
	l_bigint BIGINT NOT NULL,
	m_decimal DECIMAL(16,8),
	n_numeric NUMERIC(16,8),
	o_float FLOAT(2),
	-----------------Date 類型：-------------------------------------------
	p_datetime DATETIME NOT NULL,
	q_datetime2 DATETIME2,
	r_smalldatetime	 SMALLDATETIME,	
	s_date DATE,
	t_time TIME UNIQUE,
	-----------------Binary 類型：-------------------------------------------
	u_varbinary VARBINARY(20),
	v_varbinary VARBINARY(MAX),
	w_image IMAGE,
 CONSTRAINT [PK_Create_Code_Table] PRIMARY KEY NONCLUSTERED 
(
	[a_identity] ASC,
	[k_int] DESC,
	[p_datetime] ASC
) ON [PRIMARY]
) ON [PRIMARY]

--CREATE CLUSTERED INDEX [cluster_idx_Create_Code_Table] ON [dbo].[Create_Code_Table]
--(
--	b_char ASC,
--	f_nchar ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

CREATE UNIQUE CLUSTERED INDEX [cluster_idx_Create_Code_Table_unique] ON [dbo].[Create_Code_Table]
(
	b_char DESC,
	f_nchar ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [idx_Create_Code_Table] ON [dbo].[Create_Code_Table]
(
	j_smallint ASC,
	s_date DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]

CREATE UNIQUE NONCLUSTERED INDEX [idx_Create_Code_Table_unique] ON [dbo].[Create_Code_Table]
(
	l_bigint DESC,
	t_time ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


-------------------------------------------------------------------------------------------------------------------------------------------

---- PARTITION TABLE
----DROP PARTITION SCHEME [Psh_test]
----DROP PARTITION FUNCTION [Pfn_test]
--DROP TABLE IF EXISTS [Create_ParTB_test]
--CREATE TABLE [Create_ParTB_test]
--(
--	SN INT IDENTITY(1,1) NOT NULL,
--	tran_date DATETIME NOT NULL
--)
--GO

----CREATE PARTITION FUNCTION [Pfn_test](DATETIME) AS RANGE RIGHT FOR VALUES('2022-01-01','2022-02-01')
----CREATE PARTITION SCHEME [Psh_test] AS PARTITION [Pfn_test] TO ([PRIMARY],[TEST_1],[TEST_2])

--ALTER TABLE [dbo].[Create_ParTB_test] ADD CONSTRAINT [PK_Create_ParTB_test] PRIMARY KEY CLUSTERED
--(
--	SN ,
--	tran_date 
--) ON [Psh_test](tran_date)

