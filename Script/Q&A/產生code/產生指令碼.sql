DECLARE @SQL NVARCHAR(MAX) = '',                  
		@SQL_total NVARCHAR(MAX) = '',			
		@SQL_par NVARCHAR(MAX) = '',			
		@SQL_par_t NVARCHAR(MAX) = '',			
		@SQL_add NVARCHAR(MAX) = '',			
		@SQL_pk NVARCHAR(MAX) = '',			
		@SQL_col_uni NVARCHAR(MAX) = '',	
		@SQL_idx NVARCHAR(MAX) = '',  			
		@fill_factor VARCHAR(10),	
		@DB_name VARCHAR(10),
		@TB_scheme VARCHAR(10),			
		@Col_name_uni VARCHAR(20),			
		@Col_name VARCHAR(20),
		@idx_col_name VARCHAR(20),
		@is_descending_key VARCHAR(10),
		@Type VARCHAR(50),			
		@Len VARCHAR(50),			
		@object_id VARCHAR(100),
		@index_name VARCHAR(50),
		@TBname VARCHAR(50),			
		@FG_name VARCHAR(50),			
		@NUM_PRECISION VARCHAR(10),				
		@NUM_SCALE VARCHAR(10),					
		@DATETIME_PRE VARCHAR(10),				
		@IS_NULLABLE VARCHAR(10),				
		@IDENT_INCR VARCHAR(10),				
		@IDENT_SEED VARCHAR(10),				
		@i INT = 1,	
		@j INT = 1,
		@ID INT = 1								

-----------------------------------------------------------------------/ DB level /------------------------------------------------------------------------
--WHILE(1 = 1)
--BEGIN
--	;WITH CTE_DB
--	AS
--	(
--	SELECT ROW_NUMBER() OVER(ORDER BY dbid ASC) AS ID,name FROM master.dbo.sysdatabases 
--	WHERE name <> 'master' AND name <> 'tempdb' AND name <> 'model' AND name <> 'msdb'
--	)
--	SELECT @DB_name = CTE_DB.name 
--	FROM CTE_DB
--	WHERE CTE_DB.ID = @j

--	DROP TABLE IF EXISTS ##T
--	EXEC ('USE ' + @DB_name + ' SELECT ''' + @DB_name + ''' AS DB_name,* INTO ##t FROM sys.tables')
	------------------------------------------------------------------/ TABLE level /-----------------------------------------------------------------------
WHILE(1 = 1)
BEGIN
	IF @ID > ( SELECT COUNT(name) FROM sys.tables)
		BREAK;	
	------------------------------------------------------------------/ COLUMN level /----------------------------------------------------------------------
	WHILE(1 = 1)
	BEGIN
		;WITH CTE
		AS
		(
			SELECT  ROW_NUMBER() OVER (ORDER BY TABLE_CATALOG) AS i,
					B.object_id,
					D.TABLE_CATALOG AS DBname,
					D.TABLE_SCHEMA AS TB_scheme,
					D.TABLE_NAME AS TBname,
					D.COLUMN_NAME AS Col_name,
					D.DATA_TYPE AS Type,
					D.CHARACTER_MAXIMUM_LENGTH AS Len,
					D.NUMERIC_PRECISION,
					D.NUMERIC_SCALE,
					D.DATETIME_PRECISION,
					D.IS_NULLABLE,
					B.fill_factor,
					A.name AS filegroup,
					CAST(E.seed_value AS VARCHAR(10)) AS seed_value,
					CAST(E.increment_value AS VARCHAR(10)) AS increment_value
			FROM sys.data_spaces AS A 
				 JOIN sys.indexes AS B ON A.data_space_id = B.data_space_id
				 JOIN ( SELECT ROW_NUMBER() OVER ( ORDER BY name ) AS ID,name,object_id FROM sys.TABLES ) AS C ON B.object_id = C.object_id 
				 JOIN INFORMATION_SCHEMA.COLUMNS AS D ON D.TABLE_NAME = C.name
				 LEFT JOIN sys.identity_columns AS E ON E.object_id = C.object_id
			WHERE C.ID = 1 AND B.type < 2
		)

		SELECT 	@object_id = CTE.object_id,
				@TB_scheme = CTE.TB_scheme,
				@TBname = CTE.TBname,
				@Col_name = CTE.Col_name,
				@Type = CTE.Type,
				@Len = CTE.Len,
				@fill_factor = CTE.fill_factor,
				@NUM_PRECISION = CTE.NUMERIC_PRECISION,
				@NUM_SCALE = CTE.NUMERIC_SCALE,
				@DATETIME_PRE = CTE.DATETIME_PRECISION,
				@IS_NULLABLE = CTE.IS_NULLABLE,
				@FG_name = CTE.filegroup,
				@IDENT_SEED = CTE.seed_value,
				@IDENT_INCR = CTE.increment_value
		FROM CTE
		WHERE i = @i	--1,2........
	
		SET @SQL_par = N'[' + @Col_name + '] [' + @Type + ']' + 
			CASE WHEN @Col_name = ( SELECT name FROM sys.identity_columns WHERE object_id = @object_id ) 
				 THEN ' IDENTITY(' + @IDENT_SEED + ',' + @IDENT_INCR + ')' ELSE '' END + 
			CASE WHEN @Len IS NULL THEN '' 
				 WHEN @Len = '-1' THEN '(MAX)' 
				 WHEN CAST(@Len AS INT) > 8000 THEN '' ELSE '(' + @Len + ')' END +	
			CASE @Type WHEN 'decimal'   THEN '(' + @NUM_PRECISION + ',' + @NUM_SCALE + ')'
					   WHEN 'numeric'   THEN '(' + @NUM_PRECISION + ',' + @NUM_SCALE + ')' 
					   WHEN 'datetime2' THEN '(' + @DATETIME_PRE + ')'
					   WHEN 'time'		THEN '(' + @DATETIME_PRE + ')' ELSE '' END + 
			CASE @IS_NULLABLE WHEN 'YES' THEN ' NULL' ELSE ' NOT NULL' END +
			CASE @i WHEN ( SELECT COUNT(1) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @TBname ) THEN '' ELSE ', 
				' END --判斷要不要加逗點
			
		SET @SQL_add += @SQL_par

		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		--------------------------------------------------------------------------/ PK /---------------------------------------------------------------------------
		-----------------------------------------------------------------------------------------------------------------------------------------------------------
		IF @i = (SELECT COUNT(1) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @TBname)
		BEGIN
			SET @i = 1 --重複用 @i，將 @i 初始化
			WHILE(1 = 1) --檢查有無 Key
			BEGIN
				SELECT @Col_name = A.COLUMN_NAME --index column
				FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS A JOIN sys.indexes AS B ON A.CONSTRAINT_NAME = B.name
				WHERE A.TABLE_NAME = @TBname AND B.is_primary_key = 1 AND A.ORDINAL_POSITION = @i

				SET @SQL_par = N'[' + @Col_name + '] ' +  --重複用 @SQL_par
					CASE WHEN (SELECT TOP(1) A.is_descending_key FROM sys.index_columns AS A JOIN sys.indexes AS B ON A.object_id = B.object_id WHERE A.object_id = @object_id AND B.is_primary_key = 1 AND A.index_column_id = @i) = 1 
						THEN 'DESC' ELSE 'ASC' END +
					CASE WHEN @i = (SELECT COUNT(1) FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS A JOIN sys.indexes AS B ON A.CONSTRAINT_NAME = B.name WHERE TABLE_NAME = @TBname AND B.is_primary_key = 1)
						THEN '' ELSE ',
				' END

				SET @SQL_par_t += @SQL_par

				IF @i = (SELECT COUNT(1) FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS A JOIN sys.indexes AS B ON A.CONSTRAINT_NAME = B.name WHERE TABLE_NAME = @TBname AND B.is_primary_key = 1) --繞完Col_name
						OR (SELECT COUNT(1) FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS A JOIN sys.indexes AS B ON A.CONSTRAINT_NAME = B.name WHERE TABLE_NAME = @TBname AND B.is_primary_key = 1) < 1 --原本就沒有
					BREAK;				
	
				SET @i += 1 
			END

			SELECT  @Col_name = c.name --partition column
			FROM sys.tables			   AS t 
				JOIN sys.indexes	   AS i  ON t.object_id = i.object_id AND i.type < 2 -- clustered index or a heap    
				JOIN sys.index_columns AS ic ON ic.object_id = i.object_id AND ic.index_id = i.index_id AND ic.partition_ordinal >= 1 -- because 0 = non-partitioning column   
				JOIN sys.columns	   AS c  ON t.object_id = c.object_id AND ic.column_id = c.column_id   
			WHERE t.name = @TBname

			SET @SQL_pk = 
			CASE WHEN (SELECT TOP(1) is_system_named FROM sys.key_constraints AS A JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS B ON A.name = B.CONSTRAINT_NAME WHERE B.TABLE_NAME = @TBname ) = 1
				THEN '' ELSE 'CONSTRAINT [' + (SELECT name FROM sys.indexes WHERE object_id = @object_id AND is_primary_key = 1) + '] ' END + N'PRIMARY KEY ' + 
			CASE WHEN (SELECT type_desc FROM sys.indexes WHERE object_id = @object_id AND is_primary_key = 1) = 'NONCLUSTERED' THEN 'NONCLUSTERED' ELSE 'CLUSTERED' END + '
			(
				' + @SQL_par_t + ' 
			)WITH (' +  
			CASE WHEN (SELECT is_padded FROM sys.indexes WHERE object_id = @object_id AND is_primary_key = 1) = 0 THEN 'PAD_INDEX = OFF,' ELSE 'PAD_INDEX = ON,' END + 
			CASE WHEN (SELECT no_recompute FROM sys.stats WHERE object_id = @object_id AND stats_id = 1) = 0 THEN ' STATISTICS_NORECOMPUTE = OFF,' ELSE ' STATISTICS_NORECOMPUTE = ON,' END +
			CASE WHEN (SELECT ignore_dup_key FROM sys.indexes WHERE  object_id = @object_id AND is_primary_key = 1) = 0 THEN ' IGNORE_DUP_KEY = OFF,' ELSE ' IGNORE_DUP_KEY = ON,' END +
			CASE WHEN (SELECT allow_row_locks FROM sys.indexes WHERE object_id = @object_id AND is_primary_key = 1) = 0 THEN ' ALLOW_ROW_LOCKS = OFF,' ELSE ' ALLOW_ROW_LOCKS = ON,' END +
			CASE WHEN (SELECT allow_page_locks FROM sys.indexes WHERE object_id = @object_id AND is_primary_key = 1) = 0 THEN ' ALLOW_PAGE_LOCKS = OFF' ELSE ' ALLOW_PAGE_LOCKS = ON' END +
			CASE WHEN (SELECT fill_factor FROM sys.indexes WHERE object_id = @object_id AND is_primary_key = 1) = 0 THEN '' ELSE ', FILLFACTOR = '+ @fill_factor END + ') ON [' + @FG_name + ']' +
			CASE WHEN (SELECT COUNT(1) FROM sys.tables AS t JOIN sys.indexes AS i ON t.[object_id] = i.[object_id] JOIN sys.partition_schemes ps ON i.data_space_id = ps.data_space_id WHERE t.name = @TBname) <> 0 --partition table
				 THEN '([' + @Col_name + '])' ELSE '' END 
				 
			------------------------------------------------------------------------------------------------------------------------------------------------------------
			------------------------------------------------------------------/ Column UNIQUE /-------------------------------------------------------------------------	
			------------------------------------------------------------------------------------------------------------------------------------------------------------
			SET @i = 1 --重製、清空參數
			SET @SQL_par = '' --重製、清空參數

			IF (SELECT COUNT(1) FROM sys.indexes WHERE object_id = @object_id AND is_unique_constraint = 1) > 0 --開關
			BEGIN

			WHILE(1 = 1)  
			BEGIN
				;WITH CTE2
				AS
				(
				SELECT ROW_NUMBER() OVER(ORDER BY A.COLUMN_NAME) AS ID,A.COLUMN_NAME ,A.CONSTRAINT_NAME,B.fill_factor,A.TABLE_NAME
				FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS A JOIN sys.indexes AS B ON A.CONSTRAINT_NAME = B.name
				WHERE B.type = 2 AND B.is_unique_constraint = 1 AND A.TABLE_NAME = @TBname
				)
				SELECT  @Col_name_uni = COLUMN_NAME,
						@index_name	  = CONSTRAINT_NAME,
						@fill_factor  = fill_factor
				FROM CTE2
				WHERE CTE2.ID = @i

				SET @SQL_par = N',

			UNIQUE NONCLUSTERED 
			(
				[' + @Col_name_uni + '] ' + 
				CASE WHEN (SELECT TOP(1) is_descending_key FROM sys.indexes AS A
							JOIN (SELECT * FROM sys.index_columns WHERE object_id = @object_id AND index_id <> 1) AS B ON A.object_id = B.object_id WHERE A.name = @index_name) = 0
					THEN 'ASC' ELSE 'DESC' END + '
			)WITH (' + 
				CASE WHEN (SELECT is_padded FROM sys.indexes WHERE name = @index_name ) = 0 THEN 'PAD_INDEX = OFF,' ELSE 'PAD_INDEX = ON,' END +
				CASE WHEN (SELECT no_recompute FROM sys.stats WHERE name = @index_name) = 0 THEN ' STATISTICS_NORECOMPUTE = OFF,' ELSE ' STATISTICS_NORECOMPUTE = ON,' END +
				CASE WHEN (SELECT ignore_dup_key FROM sys.indexes WHERE name = @index_name ) = 0 THEN ' IGNORE_DUP_KEY = OFF,' ELSE ' IGNORE_DUP_KEY = ON,' END +
				CASE WHEN (SELECT allow_row_locks FROM sys.indexes WHERE name = @index_name ) = 0 THEN ' ALLOW_ROW_LOCKS = OFF,' ELSE ' ALLOW_ROW_LOCKS = ON,' END +
				CASE WHEN (SELECT allow_page_locks FROM sys.indexes WHERE name = @index_name ) = 0 THEN ' ALLOW_PAGE_LOCKS = OFF' ELSE ' ALLOW_PAGE_LOCKS = ON' END +
				CASE WHEN (SELECT fill_factor FROM sys.indexes WHERE name = @index_name ) = 0 THEN '' ELSE ', FILLFACTOR = '+ @fill_factor END + ') ON [' + @FG_name + ']'

				SET @SQL_col_uni += @SQL_par

				IF @i = (SELECT COUNT(*) FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS A JOIN sys.indexes AS B ON A.CONSTRAINT_NAME = B.name WHERE B.type = 2 AND B.is_unique_constraint = 1)--繞完
					OR (SELECT COUNT(*) FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS A JOIN sys.indexes AS B ON A.CONSTRAINT_NAME = B.name WHERE B.type = 2 AND B.is_unique_constraint = 1) = 0 --原本就沒有
					BREAK;

				SET @i += 1

			END
			END
			------------------------------------------------------------------------------------------------------------------------------------------------------------
			--------------------------------------------------------/ (Cluster \ Noncluster) INDEX /--------------------------------------------------------------------
			------------------------------------------------------------------------------------------------------------------------------------------------------------
			SET @i = 1 --重製、清空參數
			SET @SQL_par = '' --重製、清空參數

			IF (SELECT COUNT(1) FROM sys.indexes WHERE object_id = @object_id AND is_primary_key <> 1 AND is_unique_constraint <> 1) > 0 --開關
			BEGIN

			WHILE(1 = 1) --繞所有的index_name
			BEGIN	
				SELECT @index_name = A.name
				FROM 
				(
					SELECT ROW_NUMBER() OVER (ORDER BY index_id ASC) AS ID ,name
					FROM sys.indexes
					WHERE object_id = @object_id AND is_primary_key <>1 AND is_unique_constraint <> 1
				) AS A
				WHERE ID = @i

				SET @SQL_par = '' 
				SET @j = 1

				WHILE(1 = 1) --繞所有index_name中的columns
				BEGIN
	
					;WITH CTE_idx_col
					AS
					(
					SELECT ROW_NUMBER() OVER (PARTITION BY A.name ORDER BY A.index_id ASC) AS ID, A.name AS index_name, C.name AS idx_col_name, B.is_descending_key, A.type_desc 
					FROM sys.indexes AS A 
						JOIN sys.index_columns AS B ON A.object_id = B.object_id AND A.index_id = B.index_id
						JOIN sys.columns AS C ON C.column_id = b.column_id AND C.object_id = B.object_id
					WHERE A.object_id = @object_id AND A.name = @index_name AND B.is_included_column = 0 AND A.is_primary_key <> 1 AND A.is_unique_constraint <> 1
					)
					SELECT  @idx_col_name = CTE_idx_col.idx_col_name,
							@is_descending_key = CTE_idx_col.is_descending_key,
							@Type = CTE_idx_col.type_desc 
					FROM CTE_idx_col
					WHERE CTE_idx_col.ID = @j AND index_name = @index_name
	
					IF @@ROWCOUNT = 0
						BREAK;

					SET @SQL_par += N'[' + @idx_col_name + '] ' +  
					CASE WHEN @is_descending_key = 1 THEN 'DESC' ELSE 'ASC' END +
					CASE WHEN @j = (SELECT COUNT(1) FROM sys.indexes AS A JOIN sys.index_columns AS B ON A.object_id = B.object_id AND A.index_id = B.index_id 
										WHERE A.name = @index_name AND A.is_primary_key <> 1 AND A.is_unique_constraint <> 1) THEN '' ELSE ',
				' END
	
					SET @j += 1
				END

					SET @SQL_idx += N'
			CREATE ' + CASE WHEN (SELECT is_unique FROM sys.indexes WHERE name = @index_name ) = 1 THEN 'UNIQUE' ELSE '' END 
				+ @Type + ' INDEX [' + @index_name + '] ON [' + @TB_scheme + '].[' + @TBname + ']
			(
				' + @SQL_par + '
			)
			'

				IF (SELECT COUNT(1) FROM sys.indexes WHERE object_id = @object_id AND is_primary_key <> 1 AND is_unique_constraint <> 1) = @i
					BREAK;

				SET @i += 1
			END
			END

			------------------------------------------------------------------------------------------------------------------------------------------------------------

			SET @SQL = N'
			SET ANSI_NULLS ON
			SET QUOTED_IDENTIFIER ON
			CREATE TABLE [' + @TB_scheme + '].[' + @TBname + ']( 
				' + @SQL_add 
				+ CASE WHEN (SELECT COUNT(1)FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE WHERE TABLE_NAME = @TBname) <> 0 THEN ',
			' + @SQL_pk ELSE '' END + @SQL_col_uni + '
			) ON [' + @FG_name + ']' + 
			CASE WHEN (SELECT COUNT(1) FROM sys.tables AS t JOIN sys.indexes AS i ON t.[object_id] = i.[object_id] JOIN sys.partition_schemes ps ON i.data_space_id = ps.data_space_id WHERE t.name = @TBname) <> 0
				 THEN '([' + @Col_name + '])' ELSE '' END + '
			GO
			' + @SQL_idx + '
			' --合併
			SET @i = 1  --重製計數
			SET @SQL_add = '' --重製內參數
			SET @SQL_par_t = '' --重製內參數
			SET @SQL_col_uni = '' --重製內參數
			BREAK;	--繞完分組後的TBname就跳出
		END
		--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		SET @i += 1
	END 

	SET @SQL_total += @SQL
	SET @ID += 1
END

PRINT @SQL_total
--SELECT @SQL_total


