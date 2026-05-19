USE master
GO

--開啟進階選項
EXEC sp_configure 'show advanced option', '1';
RECONFIGURE
GO

--設定啟用Database Mail
EXEC sp_configure 'Database Mail XPs','1'
RECONFIGURE
GO

--檢視設定是否成功
EXEC sp_configure
GO

--建立設定檔
EXECUTE  msdb.dbo.sysmail_add_profile_sp 
@profile_name = 'Notifications',
@description = 'TEST' 
GO

--授予設定檔的存取權限
EXECUTE msdb.dbo.sysmail_add_principalprofile_sp
@profile_name = 'Notifications',
@principal_name = 'public',   --指定 DBMail Users 角色才可以使用 My DBMail Profile 這個設定檔
@is_default = 1 
GO

--建立帳號
EXECUTE msdb.dbo.sysmail_add_account_sp
@account_name = 'sqlMail',
@description = 'TEST',
@email_address = 'kent.lin@collaborate.tw',
@mailserver_name = 'webmail.bcnet.tw',
@port = 25
GO

--建立設定檔的帳號
EXECUTE  msdb.dbo.sysmail_add_profileaccount_sp   
@profile_name = 'Notifications',
@account_name = 'sqlMail',
@sequence_number = 1
GO


/*
查詢設定檔
EXECUTE msdb.dbo.sysmail_help_profileaccount_sp                     --回傳全部設定檔
EXECUTE msdb.dbo.sysmail_help_profileaccount_sp @profile_id = 4 ;   --回傳指定設定檔
*/

--測試
EXEC msdb.dbo.sp_send_dbmail 
	@profile_name='Notifications',
	@recipients='kent.lin@collaborate.tw',
	@subject= 'DataBase Mail 功能測試',
	@body='test'
GO

/*
DECLARE @GETDATE DATETIME = GETDATE()
EXECUTE msdb.dbo.sysmail_delete_mailitems_sp @sent_before = @GETDATE;  
EXECUTE msdb.dbo.sysmail_delete_log_sp @logged_before = @GETDATE

EXECUTE msdb.dbo.sysmail_help_queue_sp @queue_type = 'Mail' 
*/

-- Mail Server 狀態
select * from msdb.dbo.sysmail_server
select * from msdb.dbo.sysmail_servertype
select * from msdb.dbo.sysmail_configuration

----- 檢查 Email 發送狀態
-- 顯示全部
select * from msdb.dbo.sysmail_allitems
-- 已送出
select * from msdb.dbo.sysmail_sentitems
-- 尚未送出
select * from msdb.dbo.sysmail_unsentitems
-- 發送失敗
select * from msdb.dbo.sysmail_faileditems  

-----------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------

--建立信件內容主體
DECLARE @msg VARCHAR(8000)
SET @msg = ''

--透過執行sp_send_dbmail寄出信件
EXEC msdb.dbo.sp_send_dbmail
	@profile_name = 'Notifications',     --設定檔名稱(剛剛要讀者記住的名稱)
	@recipients = '***@***',             --收件者
	--@copy_recipients='***@***',        --副本
	--@blind_copy_recipients='***@***',  --密件副本
	@subject='SQLServer測試',            --主旨
	@body = @msg,                        --內容
	--@query='select getdate()',         --可以下SQL
	--@file_attachments='C:\test.txt',   --附件
	--@attach_query_result_as_file=1,    --把query結果設為附件，若不設定就會出現在mail內容中
	@body_format = TEXT                  --內容使用text格式
	--@body_format = 'HTML'              --內容使用HTML格式