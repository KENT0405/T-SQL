---------------------------------------------------------------
------------------------Check_timeout--------------------------
---------------------------------------------------------------
SELECT
    --n.value('(@name)[1]', 'VARCHAR(50)') AS event_name,
    --n.value('(@package)[1]', 'VARCHAR(50)') AS package_name,
    DATEADD(HOUR,8,n.value('(@timestamp)[1]', 'DATETIME2')) AS [timestamp],
    n.value('(data[@name="duration"]/value)[1]', 'INT') AS duration,
    --n.value('(data[@name="cpu_time"]/value)[1]', 'INT') AS cpu,
    --n.value('(data[@name="physical_reads"]/value)[1]', 'INT') AS physical_reads,
    --n.value('(data[@name="logical_reads"]/value)[1]', 'INT') AS logical_reads,
    --n.value('(data[@name="writes"]/value)[1]', 'INT') AS writes,
    n.value('(data[@name="statement"]/value)[1]', 'NVARCHAR(MAX)') AS statement,
    n.value('(data[@name="row_count"]/value)[1]', 'INT') AS row_count,
    n.value('(action[@name="database_name"]/value)[1]', 'NVARCHAR(128)') AS database_name,
	n.value('(data[@name="result"]/value)[1]', 'VARCHAR(10)') AS result
FROM
(
	SELECT CAST(event_data AS XML) AS event_data
	FROM sys.fn_xe_file_target_read_file('D:\Events\T-SQL*.xel', null, null, null)
) ed
CROSS APPLY ed.event_data.nodes('event') AS q(n)
WHERE 1 = 1
--AND n.value('(data[@name="statement"]/value)[1]', 'NVARCHAR(MAX)') LIKE '%declare%'
AND n.value('(@timestamp)[1]', 'DATETIME2') >= CAST(GETDATE()-3 AS DATE)
AND n.value('(data[@name="result"]/value)[1]', 'VARCHAR(10)') = 2
ORDER BY n.value('(@timestamp)[1]', 'DATETIME2') DESC

/*
select cast(event_data as XML) as event_data
from sys.fn_xe_file_target_read_file('D:\Events\T-SQL Trace_0_133195357183830000.xel', null, null, null)
*/

---------------------------------------------------------------
-------------------------Check_Lock----------------------------
---------------------------------------------------------------
SELECT
	v.value('(@timestamp)[1]', 'DATETIME2') AS [timestamp],
	n.value('.', 'NVARCHAR(MAX)') AS [statement],
	ed.event_data AS [event_XML]
FROM
(
	SELECT CAST(event_data AS XML) AS event_data
	FROM sys.fn_xe_file_target_read_file('D:\Events\Lock*.xel', null, null, null)
) ed
CROSS APPLY ed.event_data.nodes('//executionStack/frame') AS q(n)
CROSS APPLY ed.event_data.nodes('event') AS e(v)
WHERE 1 = 1
AND v.value('(@name)[1]', 'VARCHAR(50)') = 'xml_deadlock_report'
AND v.value('(@timestamp)[1]', 'DATETIME') >= GETDATE() - 3
ORDER BY v.value('(@timestamp)[1]', 'DATETIME2') DESC