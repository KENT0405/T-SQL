USE [master]
GO

/******
EXEC master.dbo.sp_dropserver @server=N'TKT-REPORT', @droplogins='droplogins'
GO
******/

/****** Object:  LinkedServer [TKT-REPORT]    Script Date: 8/19/2021 11:27:23 AM ******/
EXEC master.dbo.sp_addlinkedserver @server = N'TKT-REPORT', @srvproduct=N'', @provider=N'SQLNCLI', @datasrc=N'10.20.2.7,26387'
 /* For security reasons the linked server remote logins password is changed with ######## */
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'TKT-REPORT',@useself=N'False',@locallogin=NULL,@rmtuser=N'rd_user',@rmtpassword='bJ1(f*Z1+GTbun6aDZZM'
GO

EXEC master.dbo.sp_serveroption @server=N'TKT-REPORT', @optname=N'collation compatible', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'TKT-REPORT', @optname=N'data access', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'TKT-REPORT', @optname=N'dist', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'TKT-REPORT', @optname=N'pub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'TKT-REPORT', @optname=N'rpc', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'TKT-REPORT', @optname=N'rpc out', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'TKT-REPORT', @optname=N'sub', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'TKT-REPORT', @optname=N'connect timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'TKT-REPORT', @optname=N'collation name', @optvalue=null
GO

EXEC master.dbo.sp_serveroption @server=N'TKT-REPORT', @optname=N'lazy schema validation', @optvalue=N'false'
GO

EXEC master.dbo.sp_serveroption @server=N'TKT-REPORT', @optname=N'query timeout', @optvalue=N'0'
GO

EXEC master.dbo.sp_serveroption @server=N'TKT-REPORT', @optname=N'use remote collation', @optvalue=N'true'
GO

EXEC master.dbo.sp_serveroption @server=N'TKT-REPORT', @optname=N'remote proc transaction promotion', @optvalue=N'true'
GO


