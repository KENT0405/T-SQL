----------------------------------STEP 1--------------------------------------------------------
--�ק�tempdb���|
USE master
GO
ALTER DATABASE tempdb MODIFY FILE (NAME = tempdev, FILENAME = 'D:\DB\sys_db\tempdb.mdf')
GO
ALTER DATABASE tempdb MODIFY FILE (NAME = temp2, FILENAME = 'D:\DB\sys_db\tempdb2.mdf')
GO
ALTER DATABASE tempdb MODIFY FILE (NAME = temp3, FILENAME = 'D:\DB\sys_db\tempdb3.mdf')
GO
ALTER DATABASE tempdb MODIFY FILE (NAME = temp4, FILENAME = 'D:\DB\sys_db\tempdb4.mdf')
GO
ALTER DATABASE tempdb MODIFY FILE (NAME = temp5, FILENAME = 'D:\DB\sys_db\tempdb5.mdf')
GO
ALTER DATABASE tempdb MODIFY FILE (NAME = temp6, FILENAME = 'D:\DB\sys_db\tempdb6.mdf')
GO
ALTER DATABASE tempdb MODIFY FILE (NAME = temp7, FILENAME = 'D:\DB\sys_db\tempdb7.mdf')
GO
ALTER DATABASE tempdb MODIFY FILE (NAME = temp8, FILENAME = 'D:\DB\sys_db\tempdb8.mdf')
GO
ALTER DATABASE tempdb MODIFY FILE (NAME = templog, FILENAME = 'D:\DB\sys_db\tempdb.ldf')
GO
----------------------------------STEP 2 --------------------------------------------------------
--����SQLserver�A�M���D�BC�Ѹ̪�tempdb�ɮקR��

----------------------------------STEP 3 --------------------------------------------------------
--�}��SQLserver