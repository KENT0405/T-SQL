/* Find all Triggers information */
SELECT 
     y.name AS trigger_name 
    ,USER_NAME(y.uid) AS trigger_owner 
    ,s.name AS table_schema 
    ,OBJECT_NAME(parent_obj) AS table_name 
    ,OBJECTPROPERTY( y.id, 'ExecIsUpdateTrigger') AS isupdate 
    ,OBJECTPROPERTY( y.id, 'ExecIsDeleteTrigger') AS isdelete 
    ,OBJECTPROPERTY( y.id, 'ExecIsInsertTrigger') AS isinsert 
    ,OBJECTPROPERTY( y.id, 'ExecIsAfterTrigger') AS isafter 
    ,OBJECTPROPERTY( y.id, 'ExecIsInsteadOfTrigger') AS isinsteadof 
    ,OBJECTPROPERTY(y.id, 'ExecIsTriggerDisabled') AS [disabled]
	,c.Text AS SqlConten
FROM sysobjects AS y
INNER JOIN sys.tables t ON y.parent_obj = t.object_id 
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id 
INNER JOIN sysComments c ON y.ID = c.ID
WHERE y.type = 'TR'