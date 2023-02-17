--1.always on
--2.add replication
--3.所有發行者host檔案&aliases都加上lister IP

--4.每個次要副本加上訂閱者hostname
EXEC sp_addlinkedserver @server = 'REPL-DB-SUB'; --DB-54
GO

--5.訂閱者
USE [distribution] 
GO  

EXEC sp_redirect_publisher   
@original_publisher = 'REPL-DB-01',  --主要副本 --DB-52
@publisher_db = 'CMDK_STOCK', --發行者DB 
@redirected_publisher = 'LS,port'; --listener
GO

USE [distribution] 
GO  

EXEC sp_redirect_publisher   
@original_publisher = 'REPL-DB-02',  --主要副本 --DB-53
@publisher_db = 'CMDK_STOCK', --發行者DB 
@redirected_publisher = 'LS,port'; --listener
GO


--6.訂閱者(檢查)
USE [distribution] 
GO  

DECLARE @redirected_publisher SYSNAME;  

EXEC sys.sp_validate_replica_hosts_as_publishers  
@original_publisher = 'REPL-DB-01',  --主要副本 --DB-52
@publisher_db = 'CMDK_STOCK', --發行者DB 
@redirected_publisher = @redirected_publisher OUTPUT;

SELECT @redirected_publisher --LISTENER

--7.failover