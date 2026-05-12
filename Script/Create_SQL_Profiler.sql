
DECLARE
	@Profiler_Path VARCHAR(MAX) = N'D:\ProfilerTrace\ProfilerTrace',
	@TraceID INT

EXEC sp_trace_create @TraceID OUTPUT, 0, @Profiler_Path, 1024, NULL

-- Set the events
EXEC sp_trace_setevent @TraceID, 14, 1, 1
EXEC sp_trace_setevent @TraceID, 14, 9, 1
EXEC sp_trace_setevent @TraceID, 14, 10, 1
EXEC sp_trace_setevent @TraceID, 14, 11, 1
EXEC sp_trace_setevent @TraceID, 14, 6, 1
EXEC sp_trace_setevent @TraceID, 14, 12, 1

-- Set the Filters
declare @intfilter int
declare @bigintfilter bigint

exec sp_trace_setfilter @TraceID, 10, 0, 7, N'SQL Server Profiler - 28dde5ad-c69c-438b-b7b1-eded752afbe6'

-- Set the trace status to start
exec sp_trace_setstatus @TraceID, 1

EXEC xp_cmdshell '
del D:\ProfilerTrace\ProfilerTrace.trc
'
