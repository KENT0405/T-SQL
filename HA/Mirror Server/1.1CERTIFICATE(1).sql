USE master;
--Create the database Master Key, if needed.
CREATE MASTER KEY ENCRYPTION BY PASSWORD = '1qaz@WSX3edc';
GO

-- Make a certifcate on HOST_A server instance.
CREATE CERTIFICATE DB_PRIMARY
   WITH SUBJECT = 'DB_PRIMARY certificate';
GO

--Create a mirroring endpoint for the server instance on HOST_A.
CREATE ENDPOINT Endpoint_DB_PRIMARY
   STATE = STARTED
   AS TCP (
      LISTENER_PORT = 5022
      , LISTENER_IP = ALL
   ) 
   FOR DATABASE_MIRRORING ( 
      AUTHENTICATION = CERTIFICATE DB_PRIMARY
      , ENCRYPTION = REQUIRED ALGORITHM AES
      , ROLE = ALL
   );
GO

--Backup PRIMARY Server certificate.
BACKUP CERTIFICATE DB_PRIMARY TO FILE = 'D:\CERTIFICATE_bak\DB_PRIMARY_cert.cer';
--BACKUP CERTIFICATE DB_PRIMARY TO FILE = 'C:\Cer\DB_PRIMARY_cert.cer';
GO