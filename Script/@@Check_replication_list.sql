DECLARE
	@SQL NVARCHAR(MAX) = '',
	@SQL_column_list NVARCHAR(MAX) = '',
	@article VARCHAR(100) = '',
	@TB_or_PROC INT = 3 --1:TB, 2:PROC, 3:ALL

DROP TABLE IF EXISTS ##temp_repl, #column_list;

CREATE TABLE #column_list
(
	publication VARCHAR(50),
	article VARCHAR(50),
	column_list VARCHAR(MAX)
)

SELECT @SQL += '
SELECT
    @@SERVERNAME AS publisher,
    ''' + d.name + ''' AS db,
    p.name AS publication,
    a.article,
    s.srvname AS subscriber,
    a.ins,
    a.upd,
    a.del,
    a.filter_clause,
    a.schema_option
FROM
(
	SELECT
        a.name AS article,
        CASE WHEN a.ins_cmd = ''NONE'' THEN ''NONE'' ELSE ''v'' END AS ins,
        CASE WHEN a.upd_cmd = ''NONE'' THEN ''NONE'' ELSE ''v'' END AS upd,
        CASE WHEN a.del_cmd = ''NONE'' THEN ''NONE'' ELSE ''v'' END AS del,
        a.filter_clause,
        a.schema_option,
        a.pubid,
        a.artid,
		''T'' AS type
    FROM ' + QUOTENAME(d.name) + '..sysarticles a
	UNION ALL
    SELECT
        sch.name AS article,
        ''---'' AS ins,
        ''---'' AS upd,
        ''---'' AS del,
        ''---'' AS filter_clause,
        sch.schema_option,
        sch.pubid,
        sch.artid,
		''P'' AS type
    FROM ' + QUOTENAME(d.name) + '..sysschemaarticles sch
) a
JOIN ' + QUOTENAME(d.name) + '..syspublications p ON p.pubid = a.pubid
JOIN ' + QUOTENAME(d.name) + '..syssubscriptions s ON s.artid = a.artid
WHERE s.srvid <> -1
AND type = ' + CASE @TB_or_PROC WHEN 1 THEN '''T''' WHEN 2 THEN '''P''' WHEN 3 THEN 'type' END + '
UNION ALL
'
FROM sys.databases d
WHERE d.database_id > 4
AND d.is_published = 1

SET @SQL = 'SELECT * INTO ##Temp_repl FROM (' + LEFT(@SQL, LEN(@SQL) - 11) + ') a'

--SELECT @SQL
EXEC(@SQL)

SELECT @SQL_column_list += '
;WITH CTE
AS
(
    SELECT
        p.name AS publication,
        a.name AS article,
        c.name AS CL,
        a.artid,
        a.objid,
        ac.colid,
        c.column_id
    FROM ' + QUOTENAME(d.name) + '..sysarticles a
    JOIN ' + QUOTENAME(d.name) + '..syspublications p ON a.pubid = p.pubid
    JOIN ' + QUOTENAME(d.name) + '.sys.columns c ON a.objid = c.object_id
    LEFT JOIN ' + QUOTENAME(d.name) + '..sysarticlecolumns ac ON a.artid = ac.artid AND c.column_id = ac.colid
),CTE2
AS
(
    SELECT
        publication,
        article,
        COUNT(DISTINCT colid) AS repl_cols,
        COUNT(DISTINCT column_id) AS real_cols
    FROM CTE
    GROUP BY publication, article
)
INSERT INTO #column_list(publication,article,column_list)
SELECT
    a.publication,
    a.article,
    CASE
        WHEN a.repl_cols = a.real_cols THEN ''All_Column''
        ELSE STUFF((
            SELECT '','' + b.CL
            FROM CTE b
            WHERE b.publication = a.publication
            AND b.article = a.article
            AND b.colid IS NOT NULL
            FOR XML PATH('''')),1,1,'''')
    END AS column_list
FROM CTE2 a
'
FROM sys.databases d
WHERE d.database_id > 4
AND d.is_published = 1

EXEC (@SQL_column_list)

SELECT
	a.*,
	b.column_list
FROM ##Temp_repl a
LEFT JOIN #column_list b ON a.publication = b.publication AND a.article = b.article
WHERE a.publisher <> 'IC-DIS-DB'
AND (a.article = @article OR @article = '')

SELECT
	a.*,
	b.column_list
FROM ##Temp_repl a
LEFT JOIN #column_list b ON a.publication = b.publication AND a.article = b.article
WHERE a.publisher = 'IC-DIS-DB'
AND (a.article = @article OR @article = '')
