USE [idc_repl]
GO
/****** Object:  StoredProcedure [dbo].[sp_MSins_dbomem_daily_tran_tmp_rebate]    Script Date: 4/15/2026 10:06:10 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER procedure [dbo].[sp_MSins_dbomem_daily_tran_tmp_rebate]
    @c1 bigint,
    @c2 varchar(30),
    @c3 varchar(10),
    @c4 varchar(30),
    @c5 datetime,
    @c6 varchar(10),
    @c7 numeric(18,0),
    @c8 numeric(18,4),
    @c9 numeric(18,4),
    @c10 numeric(18,0),
    @c11 numeric(18,4),
    @c12 numeric(18,0),
    @c13 numeric(18,4),
    @c14 numeric(18,0),
    @c15 numeric(18,6),
    @c16 numeric(18,6),
    @c17 numeric(18,6),
    @c18 numeric(18,6),
    @c19 numeric(18,6),
    @c20 numeric(18,6),
    @c21 varchar(10),
    @c22 varchar(30),
    @c23 numeric(18,4),
    @c24 varchar(50),
    @c25 datetime,
    @c26 int,
    @c27 varchar(10),
    @c28 varchar(10),
    @c29 datetime
as
begin
	INSERT INTO mem_daily_tran_tmp_log (tran_date)
	SELECT CAST(@c5 AS DATE)
	EXCEPT
	SELECT tran_date FROM mem_daily_tran_tmp_log WITH (NOLOCK)
end
