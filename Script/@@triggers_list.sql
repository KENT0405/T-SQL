/* Find all Triggers information */
DROP TABLE IF EXISTS ##ALL_TRIGGER_LIST;
--DB 、 TB Level
WITH CTE
AS
(
	SELECT
		object_id,
		STUFF((SELECT ', ' + type_desc
			  FROM sys.trigger_events AS te2
			  WHERE te2.object_id = te.object_id
			  FOR XML PATH('')), 1, 2, '') AS type_desc
	FROM sys.trigger_events AS te
	GROUP BY object_id
)
SELECT
    t.name AS TriggerName,
    OBJECT_NAME(t.parent_id) AS ObjectName,
	t.parent_class_desc,
	te.type_desc,
	t.is_disabled,
	CASE t.is_instead_of_trigger WHEN 0 THEN 'ALTER TRIGGER' ELSE 'INSTEAD OF TRIGGER' END AS is_instead_of_trigger,
    OBJECT_DEFINITION(t.object_id) AS TriggerDefinition
INTO ##ALL_TRIGGER_LIST
FROM sys.triggers AS t
JOIN CTE AS te ON te.object_id = t.object_id
WHERE t.type = 'TR'

IF (SELECT COUNT(1) FROM sys.server_triggers) <> 0
BEGIN
	ALTER TABLE ##ALL_TRIGGER_LIST ALTER COLUMN is_instead_of_trigger VARCHAR(20) NULL;

	--Server Level
	EXEC
	('
	USE [master]

	INSERT INTO ##ALL_TRIGGER_LIST
	SELECT
		st.name,
		NULL,
		st.parent_class_desc,
		ste.type_desc,
		st.is_disabled,
		NULL,
		OBJECT_DEFINITION(st.object_id)
	FROM sys.server_triggers AS st
	JOIN
	(
		SELECT
			object_id,
			STUFF((SELECT '', '' + type_desc
				  FROM sys.server_trigger_events AS ste2
				  WHERE ste2.object_id = ste.object_id
				  FOR XML PATH('''')), 1, 2, '''') AS type_desc
		FROM sys.server_trigger_events AS ste
		GROUP BY object_id
	) AS ste ON st.object_id = ste.object_id
	')
END

SELECT *
FROM ##ALL_TRIGGER_LIST
WHERE 1 = 1
--AND ObjectName = 'TableName'
ORDER BY 2,1