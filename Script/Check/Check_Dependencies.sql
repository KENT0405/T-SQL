SELECT
	OBJECT_NAME(referencing_id) AS referencing_entity_name,
    o.type_desc AS referencing_description,
    COALESCE(COL_NAME(referencing_id, referencing_minor_id), '(n/a)') AS referencing_minor_id,
    referencing_class_desc,
    referenced_server_name,
	referenced_database_name,
	referenced_schema_name,
    referenced_entity_name,
    COALESCE(COL_NAME(referenced_id, referenced_minor_id), '(n/a)') AS referenced_column_name,
    is_caller_dependent,
	is_ambiguous
FROM sys.sql_expression_dependencies AS sed
INNER JOIN sys.objects AS o ON sed.referencing_id = o.object_id
WHERE 1 = 1
--AND referencing_id = OBJECT_ID(N'syncobj_0x3143324641394145')
--AND o.type_desc = 'VIEW' --SQL_STORED_PROCEDURE, SQL_SCALAR_FUNCTION, SQL_TABLE_VALUED_FUNCTION, SQL_TRIGGER, USER_TABLE
--AND referenced_entity_name = 'game_pool' --Table name / Function name