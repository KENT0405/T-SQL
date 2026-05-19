--驗證BAK檔是否有效
RESTORE HEADERONLY FROM DISK = 'D:\BAKIBC\his\ibc_egame_data_his202309121623full.bak'
GO

RESTORE VERIFYONLY FROM DISK = 'D:\BAKIBC\his\ibc_egame_data_his202309121623full.bak' with stats = 5;
GO
