USE master;
--Create the database Master Key, if needed.
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '1qaz@WSX3edc';
GO

-- Make a certifcate on HOST_B server instance.
CREATE CERTIFICATE DB_BACKUP 
   WITH SUBJECT = 'DB_BACKUP certificate'
GO

--Create a mirroring endpoint for the server instance on HOST_B.
CREATE ENDPOINT Endpoint_DB_BACKUP 
   STATE = STARTED
   AS TCP (
      LISTENER_PORT = 5022
      , LISTENER_IP = ALL
   ) 
   FOR DATABASE_MIRRORING ( 
      AUTHENTICATION = CERTIFICATE DB_BACKUP
      , ENCRYPTION = REQUIRED ALGORITHM AES
      , ROLE = ALL
   );
GO

--Backup MIRROR Server certificate.
BACKUP CERTIFICATE DB_BACKUP TO FILE = 'D:\CERTIFICATE_bak\DB_BACKUP_cert.cer';
--BACKUP CERTIFICATE DB_BACKUP TO FILE = 'C:\Cer\DB_BACKUP_cert.cer';
GO