--DDL Trigger FOR DB_Level
--[create_?]、[drop_?]、[alter_?]、[grant]、[deny]、[revoke]、[update statistics]

/*
USE [Test]
GO

DROP TABLE IF EXISTS DB_Trigger_Log;
CREATE TABLE DB_Trigger_Log
(
	EventType		VARCHAR(50) NULL,
	DatabaseName	VARCHAR(50) NULL,
	ObjectName		VARCHAR(50) NULL,
	LoginName		VARCHAR(50) NULL,
	HostName		VARCHAR(50) NULL,
	LogTime			DATETIME NULL,
	QueryText		NVARCHAR(MAX) NULL
)

SELECT * FROM Test.dbo.DB_Trigger_Log
*/

--可以參考 sys.trigger_event_types

CREATE OR ALTER TRIGGER TR_AllServerLog
ON DATABASE --可以是 ALL SERVER (CREATE_DATABASE、CREATE_LOGIN............)
FOR
	CREATE_TABLE, --CREATE_VIEW, CREATE_PROCEDURE,............
	DROP_TABLE, --DROP_VIEW, DROP_PROCEDURE,............
	ALTER_TABLE --ALTER_VIEW, ALTER_PROCEDURE,............
AS
BEGIN
    IF (ORIGINAL_LOGIN() <> 'DBA-KENT\kent.lin')
    BEGIN
		DECLARE
			@Event		XML = EVENTDATA(),
			@EventType	VARCHAR(50),
			@ObjectName VARCHAR(50),
			@QueryText	NVARCHAR(MAX)

		ROLLBACK;

		SET @EventType = @Event.value('(/EVENT_INSTANCE/EventType)[1]', 'NVARCHAR(100)')
		SET @ObjectName = @Event.value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(100)')
		SET @QueryText = @Event.value('(/EVENT_INSTANCE/TSQLCommand/CommandText)[1]', 'NVARCHAR(MAX)')

        INSERT INTO Test.dbo.DB_Trigger_Log (EventType, DatabaseName, ObjectName, LoginName, HostName, LogTime, QueryText)
        VALUES (@EventType, DB_NAME(), @ObjectName, ORIGINAL_LOGIN(), HOST_NAME(), GETDATE(), @QueryText)
    END
END