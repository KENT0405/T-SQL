SELECT 
	 q.execution_count
	,q.last_execution_time
	,s.text
	--,p.query_plan
	,'DBCC FREEPROCCACHE (' , q.plan_handle , ')'
FROM sys.dm_exec_query_stats q
CROSS APPLY sys.dm_exec_sql_text(q.plan_handle) s
--CROSS APPLY sys.dm_exec_query_plan(q.plan_handle) p
WHERE s.text LIKE '%up_api_bet_history_ticket%'