DECLARE @Tck_DB_name	VARCHAR(30) = 'lebo_egame_ticket', --Ticket DB_name
		@Main_DB_name	VARCHAR(30) = 'lebo_egame_data', --Main DB_name
		@SQL			NVARCHAR(MAX) = '',
		@Ref_Table_list	NVARCHAR(MAX) = '',
		@name			VARCHAR(50),
		@proc_name		VARCHAR(30),
		@i				INT = 1,
		@q				INT = 1,
		@w				INT = 1

SET @SQL = N'
DROP TABLE IF EXISTS #Result
CREATE TABLE #Result
(
	proc_name			VARCHAR(100),
	script				NVARCHAR(MAX),
	ticket_table_name	VARCHAR(100)
)

DROP TABLE IF EXISTS #Result_T
CREATE TABLE #Result_T
(
	proc_name	VARCHAR(100),
	Ref_T		NVARCHAR(MAX),
)

DROP TABLE IF EXISTS #Ref_T;

SELECT DISTINCT
    OBJECT_NAME(referencing_id) AS proc_name, 
    referenced_entity_name AS Table_name
INTO #Ref_T
FROM sys.sql_expression_dependencies AS sed
INNER JOIN sys.objects AS o ON sed.referencing_id = o.object_id
WHERE o.type_desc = ''SQL_STORED_PROCEDURE''
AND referenced_entity_name NOT LIKE ''FN_%''
AND referenced_entity_name NOT LIKE ''Pfn_%''
ORDER BY OBJECT_NAME(referencing_id) ASC

WHILE(1=1)
BEGIN
	;WITH CTE_Ref
	AS
	(
		SELECT 
			ROW_NUMBER() OVER(ORDER BY proc_name ASC) AS ID, 
			proc_name
		FROM (SELECT DISTINCT proc_name FROM #Ref_T) AS A
	)
	SELECT @proc_name = proc_name
	FROM CTE_Ref
	WHERE ID = @q

	IF @@ROWCOUNT = 0
		BREAK;

	WHILE(1=1)
	BEGIN
		;WITH CTE_Ref_T
		AS
		(
			SELECT 
				ROW_NUMBER() OVER(ORDER BY Table_name ASC) AS ID,
				Table_name
			FROM #Ref_T
			WHERE proc_name = @proc_name
		)
		SELECT @Ref_Table_list += '' / '' + Table_name 
		FROM CTE_Ref_T
		WHERE ID = @w

		IF @@ROWCOUNT = 0
			BREAK;
		
		SET @w += 1
	END

	INSERT INTO #Result_T
	SELECT @proc_name,@Ref_Table_list

	SET @q += 1
	SET @w = 1
	SET @Ref_Table_list = ''''
END

DROP TABLE IF EXISTS #T
--Serach Ticket Table
;WITH CTE
AS
(
	SELECT [name]
	FROM ' + @Tck_DB_name + N'.sys.tables
	EXCEPT
	SELECT [name]
	FROM ' + @Main_DB_name + N'.sys.tables
)
SELECT	
	ROW_NUMBER() OVER(ORDER BY [name] ASC) AS ID,
	[name]
INTO #T
FROM CTE

WHILE(1 = 1)
BEGIN
	SELECT @name = ''%'' + [name] + ''%''
	FROM #T
	WHERE ID = @i

	IF @@ROWCOUNT = 0
		BREAK;

	INSERT INTO #Result
	SELECT 
		[name] AS PROC_name,
		OBJECT_DEFINITION(object_id) AS script,
		REPLACE(@name,''%'','''') AS Table_name
	FROM sys.objects
	WHERE type = ''P''
	AND is_ms_shipped = 0
	AND OBJECT_DEFINITION(object_id) LIKE @name
	
	SET @i += 1
END

;WITH CTE_proc
AS
(
	SELECT DB_NAME(st.dbid) AS DBName
		  --,OBJECT_SCHEMA_NAME(st.objectid,dbid) AS SchemaName
		  ,OBJECT_NAME(st.objectid,dbid) AS StoredProcedure
		  ,MAX(cp.usecounts) AS Execution_count
	FROM sys.dm_exec_cached_plans AS cp
	CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) AS st
	WHERE DB_NAME(st.dbid) is not null
	AND cp.objtype = ''proc''
	AND DB_NAME(st.dbid) <> ''msdb''
	AND DB_NAME(st.dbid) = ''' + @Main_DB_name + '''
	AND OBJECT_NAME(st.objectid,dbid) NOT LIKE ''FN_%''
	GROUP BY 
		cp.plan_handle, 
		DB_NAME(st.dbid),
		OBJECT_SCHEMA_NAME(objectid,st.dbid),
		OBJECT_NAME(objectid,st.dbid)
)
SELECT 
	--''' + @Main_DB_name + ''' AS DBName,
	A.proc_name,
	A.ticket_table_name,
	STUFF(C.Ref_T,1,3,'''') AS Ref_Table,
	A.script
FROM #Result AS A
LEFT JOIN CTE_proc AS B ON A.proc_name = B.StoredProcedure
LEFT JOIN #Result_T AS C ON A.proc_name = C.proc_name
WHERE C.Ref_T <> ''''
AND Execution_count IS NULL
ORDER BY A.proc_name ASC
'

--PRINT @SQL

EXEC sp_executesql @SQL,N'
@Tck_DB_name	VARCHAR(30),
@Main_DB_name	VARCHAR(30),
@Ref_Table_list	NVARCHAR(MAX),
@name			VARCHAR(50), 
@proc_name		VARCHAR(30),
@i				INT,
@q				INT,
@w				INT',
@Tck_DB_name,	
@Main_DB_name,	
@Ref_Table_list,	
@name,			
@proc_name,		
@i,				
@q,			
@w				