DECLARE
	@SQL_TB NVARCHAR(MAX) = '',
	@SQL_CS NVARCHAR(MAX) = '',
    @SQL_TB_End NVARCHAR(MAX) = '',
    @SQL_DF NVARCHAR(MAX) = '',
    @SQL_FK NVARCHAR(MAX) = '',
    @SQL_CK NVARCHAR(MAX) = '',
	@TB_name VARCHAR(200) = 'mem_credit' --TB_SourceDataBSS_Main

-- TABLE COLUMN
SELECT
	@SQL_TB += IIF(ORDINAL_POSITION = 1,'CREATE TABLE ' + QUOTENAME((TABLE_SCHEMA)) + '.' + QUOTENAME(TABLE_NAME) + '(' + CHAR(10),'') +
	CHAR(9) + QUOTENAME(isc.column_name) + ' ' + IIF(ac.is_computed = 0,QUOTENAME(isc.data_type),'') +
	CASE isc.data_type
		WHEN 'numeric' THEN '(' + CAST(isc.numeric_precision AS VARCHAR(3)) + ',' + CAST(isc.numeric_scale AS VARCHAR(3)) + ')'
		WHEN 'decimal' THEN '(' + CAST(isc.numeric_precision AS VARCHAR(3)) + ',' + CAST(isc.numeric_scale AS VARCHAR(3)) + ')'
		WHEN 'char'	   THEN '(' + CAST(isc.character_maximum_length AS VARCHAR(5)) + ')'
		WHEN 'nchar'   THEN '(' + CAST(isc.character_maximum_length AS VARCHAR(5)) + ')'
		WHEN 'time'    THEN '(' + CAST(isc.datetime_precision AS VARCHAR(2)) + ')'
		WHEN 'datetime2' THEN '(' + CAST(isc.datetime_precision AS VARCHAR(2)) + ')'
		WHEN 'varchar' THEN CASE isc.character_maximum_length WHEN -1 THEN '(MAX)' ELSE '(' + CAST(isc.character_maximum_length AS VARCHAR(5)) + ')' END
		WHEN 'nvarchar' THEN CASE isc.character_maximum_length WHEN -1 THEN '(MAX)' ELSE '(' + CAST(isc.character_maximum_length AS VARCHAR(5)) + ')' END
		WHEN 'varbinary' THEN CASE isc.character_maximum_length WHEN -1 THEN '(MAX)' ELSE '(' + CAST(isc.character_maximum_length AS VARCHAR(5)) + ')' END
	ELSE '' END +
	CASE WHEN ac.is_identity = 1 THEN ' IDENTITY(' + CAST(ic.seed_value AS VARCHAR(5)) + ',' + CAST(ic.increment_value AS VARCHAR(5)) + ')' ELSE '' END +
	CASE WHEN ic.is_not_for_replication = 1 THEN ' NOT FOR REPLICATION' ELSE '' END +
	CASE WHEN ac.is_computed = 1 THEN ' AS ' + cc.definition + IIF(cc.is_persisted = 1,' PERSISTED','') ELSE '' END +
	CASE WHEN isc.is_nullable = 'NO' THEN ' NOT NULL,' ELSE ' NULL,' END + CHAR(10)
FROM information_schema.columns isc
INNER JOIN sys.tables tb ON isc.table_name = tb.name
INNER JOIN sys.all_columns ac ON tb.object_id = ac.object_id AND isc.column_name = ac.name
LEFT JOIN sys.computed_columns cc ON ac.object_id = cc.object_id AND ac.name = cc.name
LEFT JOIN sys.identity_columns ic ON tb.object_id = ic.object_id AND ac.column_id = ic.column_id
WHERE tb.name = @TB_name
ORDER BY ORDINAL_POSITION

-- CONSTRAINT INDEX
IF EXISTS(SELECT 1 FROM sys.key_constraints WHERE OBJECT_NAME(parent_object_id) = @TB_name)
BEGIN
    ;WITH base AS
    (
        SELECT
            kc.name AS constraint_name,
            kc.parent_object_id,
            i.index_id,
            i.type_desc,
            i.is_primary_key,
            i.is_unique_constraint,
            i.is_padded,
            i.ignore_dup_key,
            i.allow_row_locks,
            i.allow_page_locks,
            i.fill_factor,
            i.data_space_id
        FROM sys.key_constraints kc
        JOIN sys.indexes i ON i.object_id = kc.parent_object_id AND i.name = kc.name
        WHERE kc.parent_object_id = OBJECT_ID(@TB_name)
    ), compression AS
    (
        SELECT
            object_id,
            index_id,
            MAX(data_compression) AS data_compression
        FROM sys.partitions
        WHERE object_id = OBJECT_ID(@TB_name)
        GROUP BY object_id, index_id
    ), cols AS
    (
        SELECT
            b.constraint_name,
            STUFF((
                SELECT ', ' + QUOTENAME(c.name) + CASE WHEN ic.is_descending_key = 1 THEN ' DESC' ELSE ' ASC' END
                FROM sys.index_columns ic
                JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
                WHERE ic.object_id = b.parent_object_id
                AND ic.index_id = b.index_id
                ORDER BY ic.key_ordinal
                FOR XML PATH('')), 1, 1, '') AS IndexColumns
        FROM base b
    ), fg AS
    (
        SELECT
            b.constraint_name,
            CASE
                WHEN ds.type = 'PS' THEN 'ON ' + QUOTENAME(ds.name) + '(' + QUOTENAME(pc.partition_column) + ')'
                WHEN ds.type = 'FG' THEN 'ON ' + QUOTENAME(ds.name)
            END AS on_clause
        FROM base b
        JOIN sys.data_spaces ds ON b.data_space_id = ds.data_space_id
        OUTER APPLY (
            SELECT c.name AS partition_column
            FROM sys.index_columns ic
            JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
            WHERE ic.object_id = b.parent_object_id
            AND ic.index_id = b.index_id
            AND ic.partition_ordinal = 1
        ) pc
    )
    SELECT
        @SQL_CS += 'CONSTRAINT ' + QUOTENAME(b.constraint_name) + ' ' +
        CASE
            WHEN b.is_primary_key = 1 THEN 'PRIMARY KEY '
            WHEN b.is_unique_constraint = 1 THEN 'UNIQUE '
            ELSE ''
        END + b.type_desc + CHAR(10) +
        '( ' + CHAR(10) +
        CHAR(9) + c.IndexColumns + CHAR(10) +
        ') WITH (PAD_INDEX = ' + CASE WHEN b.is_padded = 1 THEN 'ON' ELSE 'OFF' END +
        ', IGNORE_DUP_KEY = ' + CASE WHEN b.ignore_dup_key = 1 THEN 'ON' ELSE 'OFF' END +
        ', ALLOW_ROW_LOCKS = ' + CASE WHEN b.allow_row_locks = 1 THEN 'ON' ELSE 'OFF' END +
        ', ALLOW_PAGE_LOCKS = ' + CASE WHEN b.allow_page_locks = 1 THEN 'ON' ELSE 'OFF' END +
        ', FILLFACTOR = ' + CASE WHEN b.fill_factor = 0 THEN '100' ELSE CAST(b.fill_factor AS NVARCHAR(3)) END +
        ', DATA_COMPRESSION = ' + CASE comp.data_compression WHEN 0 THEN 'NONE' WHEN 1 THEN 'ROW' ELSE 'PAGE' END + ') ' + f.on_clause + ',' + CHAR(10),
        @SQL_TB_End = CHAR(10) + ') ' + f.on_clause + CHAR(10) + 'GO'
    FROM base b
    JOIN cols c ON b.constraint_name = c.constraint_name
    JOIN fg f ON b.constraint_name = f.constraint_name
    LEFT JOIN compression comp ON b.parent_object_id = comp.object_id AND b.index_id = comp.index_id;
END

-- COLUMN DEFAULT CONSTRAINTS
IF EXISTS(SELECT 1 FROM sys.all_columns WHERE default_object_id <> 0 AND OBJECT_NAME(object_id) = @TB_name)
BEGIN
	SELECT @SQL_DF += CHAR(10) + 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(dc.object_id)) + '.' + QUOTENAME(@TB_name) +
    ' ADD CONSTRAINT ' + QUOTENAME(dc.name) +
    ' DEFAULT ' + dc.definition +
    ' FOR ' + QUOTENAME(c.name) +
    CHAR(10) + 'GO'
	FROM sys.default_constraints dc
	JOIN sys.columns c ON dc.parent_object_id = c.object_id AND dc.parent_column_id = c.column_id
	WHERE OBJECT_NAME(c.object_id) = @TB_name
END

-- FOREIGN KEYS
IF EXISTS(SELECT 1 FROM sys.foreign_keys WHERE OBJECT_NAME(parent_object_id) = @TB_name)
BEGIN
    SELECT @SQL_FK += CHAR(10) + 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(fk.parent_object_id)) + '.' + QUOTENAME(@TB_name) + CHAR(32) + CHAR(32) +
    'WITH ' + IIF(fk.is_not_trusted = 0,'CHECK','NOCHECK') + ' ADD  CONSTRAINT ' + QUOTENAME(fk.name) + CHAR(32) +
    'FOREIGN KEY(' + QUOTENAME(cp.name) + ')' + CHAR(10) +
    'REFERENCES ' + QUOTENAME(OBJECT_SCHEMA_NAME(fk.referenced_object_id)) + '.' + QUOTENAME(OBJECT_NAME(fk.referenced_object_id)) + CHAR(32) + '(' + QUOTENAME(cr.name) + ')' +
    CHAR(10) + 'GO' + CHAR(10) +
    CHAR(10) + 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(fk.parent_object_id)) + '.' + QUOTENAME(@TB_name) + CHAR(32) +
    IIF(fk.is_disabled = 0,'CHECK','NOCHECK') + ' CONSTRAINT ' + QUOTENAME(fk.name) +
    CHAR(10) + 'GO' + CHAR(10)
    FROM sys.foreign_keys fk
    JOIN sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
    JOIN sys.columns cp ON fkc.parent_object_id = cp.object_id AND fkc.parent_column_id = cp.column_id
    JOIN sys.columns cr ON fkc.referenced_object_id = cr.object_id AND fkc.referenced_column_id = cr.column_id
    WHERE OBJECT_NAME(fk.parent_object_id) = @TB_name
END

-- COLUMN CHECK CONSTRAINT
IF EXISTS(SELECT 1 FROM sys.check_constraints WHERE OBJECT_NAME(parent_object_id) = @TB_name)
BEGIN
    SELECT @SQL_CK += CHAR(10) + 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(cc.parent_object_id)) + '.' + QUOTENAME(@TB_name) + CHAR(32) + CHAR(32) +
    'WITH ' + IIF(cc.is_not_trusted = 0,'CHECK','NOCHECK') + ' ADD  CONSTRAINT ' + QUOTENAME(cc.name) + CHAR(32) +
    'CHECK  ' + cc.definition +
    CHAR(10) + 'GO' + CHAR(10) +
    CHAR(10) + 'ALTER TABLE ' + QUOTENAME(OBJECT_SCHEMA_NAME(cc.parent_object_id)) + '.' + QUOTENAME(@TB_name) + CHAR(32) +
    IIF(cc.is_disabled = 0,'CHECK','NOCHECK') + ' CONSTRAINT ' + QUOTENAME(cc.name) +
    CHAR(10) + 'GO' + CHAR(10)
    FROM sys.check_constraints cc
    JOIN sys.columns c ON cc.parent_object_id = c.object_id AND cc.parent_column_id = c.column_id
    WHERE OBJECT_NAME(cc.parent_object_id) = @TB_name
END

--SELECT @SQL_TB
--SELECT @SQL_CS
--SELECT @SQL_DF
--SELECT @SQL_FK
--SELECT @SQL_CK
SELECT @SQL_TB + LEFT(@SQL_CS, LEN(@SQL_CS) - 2) + @SQL_TB_End + CHAR(10) + @SQL_DF + CHAR(10) + @SQL_FK + @SQL_CK
