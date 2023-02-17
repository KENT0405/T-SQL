SELECT
  CONVERT(char(100), SERVERPROPERTY('Servername')) AS 'Server Name',
  msdb.dbo.backupset.database_name,
  msdb.dbo.backupset.backup_start_date,
  msdb.dbo.backupset.backup_finish_date,
  DATEDIFF(SS, msdb.dbo.backupset.backup_start_date, msdb.dbo.backupset.backup_finish_date) AS 'Duraction Time(s)',
  CASE msdb..backupset.type
    WHEN 'D' THEN 'Database'
    WHEN 'L' THEN 'Log'
    WHEN 'I' THEN 'Differential database '
  END AS backup_type,
  msdb.dbo.backupset.backup_size / 1024 / 1024 / 1024 AS 'Size(GB)',
  msdb.dbo.backupset.backup_size / 1024 / 1024 / 1 + DATEDIFF(SS, msdb.dbo.backupset.backup_start_date, msdb.dbo.backupset.backup_finish_date) AS 'Process(MB/s)',
  msdb.dbo.backupset.name AS backupset_name,
  compressed_backup_size / backup_size * 100 AS 'compress rate(%)'
FROM msdb.dbo.backupset
WHERE (CONVERT(datetime, msdb.dbo.backupset.backup_start_date, 102) >= GETDATE() - 7)
ORDER BY msdb.dbo.backupset.database_name,
msdb.dbo.backupset.backup_finish_date