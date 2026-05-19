-- Configure the linked server  
-- Add one Azure SQL Database as Linked Server  

EXEC sp_addlinkedserver  
  @server='IC-BO-DB', -- here you can specify the name of the linked server  
  @srvproduct='',       
  @provider='SQLNCLI',		--using SQL Server Native Client  
  @datasrc='10.20.2.43',	--IP
  @location='',  
  @provstr=''  
  --,@catalog=''  -- add here your database name as initial catalog (you cannot connect to the master database)  

-- Add credentials and options to this linked server  
EXEC sp_addlinkedsrvlogin  
  @rmtsrvname = 'IC-BO-DB',  
  @useself = 'false',  
  @rmtuser = 'sa',			-- add here your login on DB  
  @rmtpassword = '1qaz'		-- add here your password on DB  

EXEC sp_serveroption 'IC-BO-DB', 'rpc out', true;
GO

----------------------------------linked_server (read-only)----------------------------------------

--EXEC master.dbo.sp_addlinkedserver 
--  @server = N'LISTENER', 
--  @srvproduct=N'SQL', 
--  @provider=N'SQLNCLI11', 
--  @datasrc=N'LISTENER,3341', 
--  @provstr=N'ApplicationIntent=ReadOnly; MultiSubnetFailover=Yes;', 
--  @catalog=N'master'
  