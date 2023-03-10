/****************************************************/
/* Created by: SQL Server 2019 Profiler          */
/* Date: 2022/09/27  02:45:31 PM         */
/****************************************************/


CREATE OR ALTER PROC AutoTrace
AS
BEGIN
-- Create a Queue
declare @rc int
declare @TraceID int --可用來追蹤建立起來的trace
declare @maxfilesize bigint
set @maxfilesize = 5 --每個trace檔案限制為5MB

-- Please replace the text InsertFileNameHere, with an appropriate
-- filename prefixed by a path, e.g., c:\MyFolder\MyTrace. The .trc extension
-- will be appended to the filename automatically. If you are writing from
-- remote server to local drive, please use UNC path and make sure server has
-- write access to your network share

exec @rc = sp_trace_create @TraceID output, 0, N'InsertFileNameHere', @maxfilesize, NULL 
if (@rc != 0) goto error

-- Client side File and Table cannot be scripted

-- Set the events
declare @on bit
set @on = 1
exec sp_trace_setevent @TraceID, 10, 1, @on --第一個參數@TraceID，是步驟1所建立的Trace參考
exec sp_trace_setevent @TraceID, 10, 3, @on --第二個參數是event_id
exec sp_trace_setevent @TraceID, 10, 11, @on--第三個參數是column_id
exec sp_trace_setevent @TraceID, 10, 12, @on--第四個參數是開啟事件=1或關閉事件=0
exec sp_trace_setevent @TraceID, 10, 13, @on
exec sp_trace_setevent @TraceID, 10, 35, @on
exec sp_trace_setevent @TraceID, 45, 1, @on
exec sp_trace_setevent @TraceID, 45, 3, @on
exec sp_trace_setevent @TraceID, 45, 11, @on
exec sp_trace_setevent @TraceID, 45, 12, @on
exec sp_trace_setevent @TraceID, 45, 13, @on
exec sp_trace_setevent @TraceID, 45, 28, @on
exec sp_trace_setevent @TraceID, 45, 35, @on
exec sp_trace_setevent @TraceID, 12, 1, @on
exec sp_trace_setevent @TraceID, 12, 3, @on
exec sp_trace_setevent @TraceID, 12, 11, @on
exec sp_trace_setevent @TraceID, 12, 12, @on
exec sp_trace_setevent @TraceID, 12, 13, @on
exec sp_trace_setevent @TraceID, 12, 35, @on


-- Set the Filters(設定要濾掉的資訊，這個就看個人需求來做設定就可以。)
declare @intfilter int
declare @bigintfilter bigint

-- Set the trace status to start
-- 啟動Trace，透過呼叫sp_trace_setstatus，第二個參數是狀態，0=停止，1=啟動，2=關閉並刪除此Trace
exec sp_trace_setstatus @TraceID, 1

-- display trace id for future references
-- 如還有後續動作，可將@TraceID和@rc(0為無錯誤)回傳。 
select TraceID=@TraceID
goto finish

error: 
select ErrorCode=@rc

finish:

END


-- SELECT * FROM sys.traces
-- SELECT * FROM sys.procedures
-- SELECT  name, type_desc, is_auto_executed, create_date, modify_date  FROM sys.procedures

-- SELECT * FROM ::fn_trace_gettable('D:\TRC\Test.trc.trc',1) ##呈現出監控的表格