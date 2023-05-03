SELECT
	ob.name				AS TableName,
    col.name			AS ColumnsName,
    tp.name + ''		AS ColumnsType,
	col.prec			AS ColumnsLength,
    CASE col.isnullable
		WHEN 1 THEN 'NULL'
		ELSE 'NOT NOLL '
	END					AS [IsNull]
FROM sysobjects			AS ob
INNER JOIN syscolumns	AS col ON ob.id = col.id
INNER JOIN systypes		AS tp ON col.xusertype = tp.xusertype
WHERE ob.xtype = 'U'
AND ob.name = 'game_info'
AND col.name = 'game_name_cn'