DECLARE @function_id INT

SELECT @function_id = function_id
FROM sys.partition_functions
WHERE [name] = 'Pfn_datetime_tck'
OR	  [name] = 'Pfn_datetime_owt'

SELECT 
	ISNULL(b.groupname,'') AS [FileGroup],
	Name AS File_name,
	[Filename] AS [File_path],
	CONVERT (DECIMAL(15,0),ROUND(a.Size/128.000,2)) [Currently_Space(MB)],
	CONVERT (DECIMAL(15,0),ROUND(FILEPROPERTY(a.Name,'SpaceUsed')/128.000,2)) AS [Space_Used(MB)],
	CONVERT (DECIMAL(15,0),ROUND((a.Size-FILEPROPERTY(a.Name,'SpaceUsed'))/128.000,2)) AS [Available_Space(MB)]	,
	c.[value] AS Up_bound,
	d.[value] AS Low_bound
FROM dbo.sysfiles AS a 
LEFT JOIN sysfilegroups AS b ON a.groupid = b.groupid
CROSS JOIN (SELECT TOP 1 [value] FROM sys.partition_range_values WHERE function_id = @function_id ORDER BY [value] ASC) AS c 
CROSS JOIN (SELECT TOP 1 [value] FROM sys.partition_range_values WHERE function_id = @function_id ORDER BY [value] DESC) AS d 
WHERE 1=1
AND [name]		NOT LIKE '%BASE%' 
AND [name]		NOT LIKE '%log%'
AND [name]		NOT LIKE '%TODAY%'
AND [groupname] NOT LIKE '%PRIMARY%'
ORDER BY [name] ASC