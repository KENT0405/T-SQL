--clone DB
DECLARE
	@SQL		NVARCHAR(MAX) = '',
	@SQL_Pfn	NVARCHAR(MAX) = '',
	@SQL_Psh	NVARCHAR(MAX) = '',
	@Pfn_name	VARCHAR(20) = '',
	@Psh_name	VARCHAR(20) = '',
	@Type_name	VARCHAR(20) = '',
	@ID			INT = 1	--@Pfn level

SET @SQL = '
USE [master]
GO

--------------------------------------------------------
--Open Sqlcmd
EXEC sp_configure ''show advanced options'',1;
RECONFIGURE;

EXEC sp_configure ''xp_cmdshell'',1;
RECONFIGURE;

EXEC sp_configure ''show advanced options'',0;
RECONFIGURE;
GO

--Create Folder
EXEC xp_cmdshell ''mkdir D:\DB\' + DB_NAME() + '''
GO
--------------------------------------------------------

--CLONE DB : [' + DB_NAME() + ']
CREATE DATABASE [' + DB_NAME() + ']
CONTAINMENT = NONE
ON
'

SELECT @SQL +=
CASE WHEN df.data_space_id = 1 THEN '' ELSE 'FILEGROUP ' END +
CASE WHEN df.data_space_id = 1 THEN f.[name] ELSE QUOTENAME(f.[name]) END +
' ( NAME = N''' + df.[name] + ''', FILENAME = N''' + physical_name + ''' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB ),
'
FROM sys.database_files df
JOIN sys.filegroups f ON df.data_space_id = f.data_space_id

SELECT @SQL = STUFF(@SQL,LEN(@SQL)-2,1,'') + 'LOG ON ( NAME = N''' + [name] + ''', FILENAME = N''' + physical_name + ''' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
'
FROM sys.database_files
WHERE data_space_id = 0

SET @SQL += '
USE [' + DB_NAME() + ']
GO
'

--Create Partition Scheme
WHILE(1 = 1)
BEGIN
	;WITH CTE
	AS
	(
		SELECT
			ROW_NUMBER() OVER(ORDER BY pf.[name]) AS ID,
			pf.[name] AS pf_name,
			ps.[name] AS ps_name,
			ty.[name] AS ty_name
		FROM sys.partition_functions pf
		JOIN sys.partition_schemes ps ON pf.function_id = ps.function_id
		JOIN sys.partition_parameters pp ON pf.function_id = pp.function_id
		JOIN sys.types ty ON pp.system_type_id = ty.system_type_id
	)
	SELECT
		@Pfn_name = pf_name,
		@Psh_name = ps_name,
		@Type_name = ty_name
	FROM CTE
	WHERE ID = @ID

	IF @@ROWCOUNT = 0
		BREAK;

	SET @SQL_Pfn = ''
	SET @SQL_Psh = ''

	SELECT
		@SQL_Pfn += ', N' + QUOTENAME(CONVERT(VARCHAR(30), prv_left_value , 120),''''),
		@SQL_Psh += ', ' + QUOTENAME(fg_name)
	FROM
	(
		SELECT DISTINCT
			CASE WHEN prv_left.value IS NULL THEN '' ELSE prv_left.value END AS prv_left_value,
			fg.name AS fg_name
		FROM sys.dm_db_partition_stats p
		INNER JOIN sys.indexes i ON i.object_id = p.object_id AND i.index_id = p.index_id
		INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id
		INNER JOIN sys.partition_functions pf ON ps.function_id = pf.function_id
		INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND  dds.destination_id = p.partition_number
		INNER JOIN sys.filegroups fg ON fg.data_space_id = dds.data_space_id
		LEFT JOIN sys.partition_range_values prv_left ON prv_left.function_id = ps.function_id AND prv_left.boundary_id = p.partition_number - 1
		WHERE ps.name = @Psh_name
		AND   pf.name = @Pfn_name
	) t

	SET @SQL += '
--Craete Partition Scheme
CREATE PARTITION FUNCTION [' + @Pfn_name + '](' + @Type_name + ') AS RANGE ' +
CASE WHEN (SELECT boundary_value_on_right FROM sys.partition_functions WHERE [name] = @Pfn_name) = 1 THEN 'RIGHT' ELSE 'LEFT' END +
' FOR VALUES (' + STUFF(@SQL_Pfn,1,6,'') + ')
GO
CREATE PARTITION SCHEME [' + @Psh_name + '] AS PARTITION [' + @Pfn_name + '] TO (' + STUFF(@SQL_Psh,1,1,'') + ')
GO
	'

	SET @ID += 1
END

SELECT @SQL