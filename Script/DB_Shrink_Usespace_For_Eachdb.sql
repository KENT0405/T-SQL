DECLARE
	@Before2Month VARCHAR(5) = 5,
	@SQL NVARCHAR(MAX) = ''

DROP TABLE IF EXISTS #Temp_shrink;
CREATE TABLE #Temp_shrink
(
    FileGroup VARCHAR(100),
    FileName VARCHAR(100),
    FilePath VARCHAR(100),
	[Currently_Space(MB)] DECIMAL(15,0),
	[Space_Used(MB)] DECIMAL(15,0),
    [Available_Space(MB)] DECIMAL(15,0),
    Rate DECIMAL(5,2),
    shrinkstr VARCHAR(MAX)
)

SELECT @SQL += '
USE ' + name + ';
;WITH shink
AS
(
	SELECT
		ISNULL(b.groupname,'''') AS [FileGroup],
		Name,
		[Filename] AS [File_path],
		CONVERT (DECIMAL(15,0),ROUND(a.Size/128.000,2)) [Currently_Space(MB)],
		CONVERT (DECIMAL(15,0),ROUND(FILEPROPERTY(a.Name,''SpaceUsed'')/128.000,2)) AS [Space_Used(MB)],
		CONVERT (DECIMAL(15,0),ROUND((a.Size-FILEPROPERTY(a.Name,''SpaceUsed''))/128.000,2)) AS [Available_Space(MB)]
	FROM ' + name + '.dbo.sysfiles a
	LEFT JOIN ' + name + '..sysfilegroups b
	ON a.groupid = b.groupid
)
INSERT INTO #Temp_shrink
SELECT
	*
	,CONVERT(DECIMAL(5,2),[Space_Used(MB)] / [Currently_Space(MB)]) AS Rate
	,''USE ' + name + '; DBCC SHRINKFILE (N'''''' + Name + '''''' , 8) WITH NO_INFOMSGS;'' AS shrinkstr
FROM shink
WHERE 1 = 1
AND [FileGroup] LIKE ''%' + @Before2Month + '''
ORDER BY 1
'
FROM sys.databases
WHERE database_id > 4
AND name LIKE '%all'

--SELECT @SQL
EXEC (@SQL)

SELECT *
FROM #Temp_shrink