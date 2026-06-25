### TKT自動查詢Src_types相關procedure
```
DECLARE
	@Src_types VARCHAR(20) = 'VIEW_MONTH', -- TABLE / VIEW_DAY / VIEW_MONTH
	@SQL NVARCHAR(MAX) = ''

;WITH CTE
AS
(
	SELECT
		ROW_NUMBER() OVER(PARTITION BY Src_types ORDER BY sn) id,
		Src_types,
		Tkt_db_name
	FROM idc_repl..vw_sys_jobs_setting
)
SELECT @SQL = '
SELECT
	''' + Tkt_db_name + ''' AS Tkt_db_name,
	name AS procedure_name,
	sm.definition
FROM ' + Tkt_db_name + '.sys.procedures p
JOIN ' + Tkt_db_name + '.sys.sql_modules sm ON p.object_id = sm.object_id
WHERE EXISTS
(
    SELECT 1
    FROM (
        VALUES
			(''TABLE'', ''PROC_JobCreate4SwitchTable''),
			(''TABLE'', ''PROC_JobSwitchTable''),
			(''TABLE'', ''PROC_JobKeepData''),
			(''TABLE'', ''PROC_JobModifyPartition''),
            (''VIEW_DAY'', ''PROC_JobCreateFilegroup''),
            (''VIEW_DAY'', ''PROC_JobCreateNextMonthTB''),
			(''VIEW_DAY'', ''PROC_JobModifyRangeView''),
			(''VIEW_DAY'', ''PROC_JobShrinkLaterMonthTB''),
			(''VIEW_DAY'', ''PROC_JobCleanSub''),
			(''VIEW_DAY'', ''PROC_JobModifyPartition''),
			(''VIEW_DAY'', ''PROC_JobTruncateFilegroup''),
            (''VIEW_MONTH'', ''PROC_JobCreateFilegroup''),
			(''VIEW_MONTH'', ''PROC_JobCreateNextMonthTB_By_Month''),
			(''VIEW_MONTH'', ''PROC_JobModifyRangeView_By_Month''),
			(''VIEW_MONTH'', ''PROC_JobShrinkLaterMonthTB_By_Month''),
			(''VIEW_MONTH'', ''PROC_JobCleanSub''),
			(''VIEW_MONTH'', ''PROC_JobModifyPartition''),
            (''VIEW_MONTH'', ''PROC_JobTruncateFilegroup'')
    ) v(src_types, name)
    WHERE v.src_types = ''' + @Src_types + '''
      AND v.name = p.name
)
'
FROM CTE
WHERE id = 1
AND Src_types = @Src_types

--SELECT @SQL
EXEC(@SQL)
```