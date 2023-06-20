/* STEP 1
建立好AllwaysON 的情況下(以下都建好)
DB : LINKED_SERVER
Router : (AG-01、AG-02)
LS : (10.123.9.59,1743)
*/

--STEP 2: Primary >> CREATE LOGINS
USE [master] GO
CREATE LOGIN [LKuser] WITH PASSWORD=N'123456', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF GO

USE [LINKED_SERVER] GO
CREATE USER [LKuser] FOR LOGIN [LKuser] GO

USE [LINKED_SERVER] GO
ALTER ROLE [db_owner] ADD MEMBER [LKuser] GO

SELECT * FROM sys.syslogins --COPY SID

--STEP 3: Failover

--STEP 4: Primary (secondary) Paste SID
USE [master] GO
CREATE LOGIN [LKuser] WITH PASSWORD=N'123456',SID = 0x0366EB0EE6E52B48AC96B6F04F979266 , DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF GO

--STEP 5 Test: Connect to LS
--parm : Database=db_name;ApplicationIntent=ReadOnly;

-----------------------------------------------/ linked server to LS read-only /----------------------------------------------------------

EXEC master.dbo.sp_addlinkedserver 
  @server = N'LK_SERVER', 
  @srvproduct=N'', 
  @provider=N'SQLNCLI', 
  @datasrc=N'10.123.9.59,1743', 
  @provstr= 'Database=LINKED_SERVER;ApplicationIntent=ReadOnly;'

EXEC sp_addlinkedsrvlogin  
  @rmtsrvname = 'LK_SERVER',  
  @useself = 'false',  
  @rmtuser = 'LKuser',			-- add here your login on DB  
  @rmtpassword = '123456'		-- add here your password on DB  

EXEC sp_serveroption 'LK_SERVER', 'rpc out', true;
GO
