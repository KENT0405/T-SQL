### --TKT自動查詢Src_types相關procedure
```
DECLARE
	@Src_types VARCHAR(20) = 'VIEW_DAY', -- TABLE / VIEW_DAY / VIEW_MONTH
	@SQL NVARCHAR(MAX) = ''

;WITH CTE
AS
(
	SELECT
		Src_types,
		Tkt_db_name
	FROM idc_repl..vw_sys_jobs_setting
	WHERE provider_id IN ('agc','bgs','btl')
	AND Src_types = @Src_types
)
SELECT @SQL = '
SELECT
	''' + Tkt_db_name + ''' AS Tkt_db_name,
	name AS procedure_name,
	sm.definition + CHAR(10) + ''GO'' AS definition
FROM ' + Tkt_db_name + '.sys.procedures p
JOIN ' + Tkt_db_name + '.sys.sql_modules sm ON p.object_id = sm.object_id
WHERE EXISTS
(
    SELECT 1
    FROM (
        VALUES
			(''TABLE'', ''PROC_JobChangedata''),
			(''TABLE'', ''PROC_JobCreate4SwitchTable''),
			(''TABLE'', ''PROC_JobSwitchTable''),
			(''TABLE'', ''PROC_JobKeepData''),
			(''TABLE'', ''PROC_JobModifyPartition''),
			(''TABLE'', ''sys_error_log''),
			(''VIEW_DAY'', ''PROC_JobChangedata''),
            (''VIEW_DAY'', ''PROC_JobCreateFilegroup''),
            (''VIEW_DAY'', ''PROC_JobCreateNextMonthTB''),
			(''VIEW_DAY'', ''PROC_JobModifyRangeView''),
			(''VIEW_DAY'', ''PROC_JobShrinkLaterMonthTB''),
			(''VIEW_DAY'', ''PROC_JobCleanSub''),
			(''VIEW_DAY'', ''PROC_JobModifyPartition''),
			(''VIEW_DAY'', ''PROC_JobTruncateFilegroup''),
			(''VIEW_DAY'', ''sys_error_log''),
			(''VIEW_MONTH'', ''PROC_JobChangedata''),
            (''VIEW_MONTH'', ''PROC_JobCreateFilegroup''),
			(''VIEW_MONTH'', ''PROC_JobCreateNextMonthTB_By_Month''),
			(''VIEW_MONTH'', ''PROC_JobModifyRangeView_By_Month''),
			(''VIEW_MONTH'', ''PROC_JobShrinkLaterMonthTB_By_Month''),
			(''VIEW_MONTH'', ''PROC_JobCleanSub''),
			(''VIEW_MONTH'', ''PROC_JobModifyPartition''),
            (''VIEW_MONTH'', ''PROC_JobTruncateFilegroup''),
			(''VIEW_MONTH'', ''sys_error_log'')
    ) v(src_types, name)
    WHERE v.src_types = ''' + @Src_types + '''
      AND v.name = p.name
)
ORDER BY procedure_name DESC
'
FROM CTE

--SELECT @SQL
EXEC(@SQL)
```