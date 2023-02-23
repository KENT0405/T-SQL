;WITH shink
AS
(
	SELECT 
		ISNULL(b.groupname,'') AS [FileGroup],
		Name,
		[Filename] AS [File_path],
		CONVERT (DECIMAL(15,0),ROUND(a.Size/128.000,2)) [Currently_Space(MB)],
		CONVERT (DECIMAL(15,0),ROUND(FILEPROPERTY(a.Name,'SpaceUsed')/128.000,2)) AS [Space_Used(MB)],
		CONVERT (DECIMAL(15,0),ROUND((a.Size-FILEPROPERTY(a.Name,'SpaceUsed'))/128.000,2)) AS [Available_Space(MB)]		
	FROM dbo.sysfiles a 
	LEFT JOIN sysfilegroups b 
	ON a.groupid = b.groupid
)
SELECT 
	*
	,CONVERT(DECIMAL(5,2),[Space_Used(MB)] / [Currently_Space(MB)]) AS Rate
	,'DBCC SHRINKFILE (N''' + Name + ''' , 8) WITH NO_INFOMSGS;' AS shrinkstr
	,'
	SET NOCOUNT ON;
	DECLARE @I INT = ' + CAST([Currently_Space(MB)] AS VARCHAR) + ' --目前檔案size

	WHILE (@I > ' + CAST([Space_Used(MB)] + 100 AS VARCHAR) + ') --目標size
	BEGIN

	DBCC SHRINKFILE (N''' + name + ''' , @I) WITH NO_INFOMSGS

	SET @I -= 100

	END
	'
FROM shink
WHERE 1 = 1
--AND [Space_Used(MB)] = 0
--AND [Currently_Space(MB)] <> 8
--AND NAME NOT LIKE '%base'
ORDER BY 1


--SET NOCOUNT ON;
--DECLARE @I INT = 20719 --目前檔案size

--WHILE (@I > 18649) --目標size
--BEGIN

--DBCC SHRINKFILE (N'i4_data' , @I) WITH NO_INFOMSGS

--SET @I -= 30

--END



