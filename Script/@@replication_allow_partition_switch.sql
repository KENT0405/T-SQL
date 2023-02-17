DECLARE @publication AS sysname
SET @publication = N'TB_SourceDataICL_Main' --發行 TABLE 名稱

EXEC sp_helppublication @publication

EXEC sp_changepublication 
 @publication = @publication, 
 @property = N'allow_partition_switch', 
 @value = 'TRUE'

EXEC sp_changepublication 
 @publication = @publication, 
 @property = N'replicate_partition_switch',
 @value = 'FALSE'

EXEC sp_helppublication @publication

--強制移除指定DB的所有發行集
--EXEC sp_removedbreplication @dbname = N'source_data_sws'

/*
SELECT DISTINCT
	P.publication   AS Publication_Name,
	A.publisher_db  AS Database_Name,
	'
	USE ' + a.publisher_db + ';
	EXEC sp_changepublication
	@publication = N''' + P.publication + ''',
	@property = N''allow_partition_switch'',
	@value = ''TRUE''
	
	EXEC sp_changepublication
	@publication = N''' + P.publication + ''',
	@property = N''replicate_partition_switch'',
	@value = ''FALSE''
	
	EXEC sp_helppublication
	@publication = N''' + P.publication + '''
	' AS sp__helppublication
FROM distribution.dbo.MSarticles AS A
INNER JOIN distribution.dbo.MSpublications AS P ON A.publication_id = P.publication_id
ORDER BY P.publication
*/