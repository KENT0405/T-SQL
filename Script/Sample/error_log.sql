SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

DROP TABLE IF EXISTS [sys_jobs_errormessage]
GO

CREATE TABLE [dbo].[sys_jobs_errormessage](
	[sn] [int] IDENTITY(1,1) NOT NULL,
	[ErrorNumber] [int] NULL,
	[ErrorSeverity] [int] NULL,
	[ErrorState] [int] NULL,
	[ErrorProcedure] [varchar](100) NULL,
	[ErrorLine] [int] NULL,
	[ErrorMessage] [nvarchar](500) NULL,
	[Error_date] [datetime] NULL,
	[ErrorDatabase] [varchar](30) NULL,
PRIMARY KEY CLUSTERED 
(
	[sn] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[sys_jobs_errormessage] ADD  DEFAULT (getdate()) FOR [Error_date]
GO

--寫入錯誤Log，任何PROC內TRY.CATCH皆可使用
CREATE OR ALTER PROC [dbo].[up_sys_error_log]
	@ErrorDatabase VARCHAR(30) = NULL
AS
BEGIN
	INSERT INTO [dbo].[sys_jobs_errormessage]
	(
		 [ErrorNumber]
		,[ErrorSeverity]
		,[ErrorState]
		,[ErrorProcedure]
		,[ErrorLine]
		,[ErrorMessage]
		,[ErrorDatabase]
	)
	SELECT
    ERROR_NUMBER() AS ErrorNumber,
    ERROR_SEVERITY() AS ErrorSeverity,
    ERROR_STATE() AS ErrorState,
    ERROR_PROCEDURE() AS ErrorProcedure,
    ERROR_LINE() AS ErrorLine,
    ERROR_MESSAGE() AS ErrorMessage,
	ISNULL(@ErrorDatabase,DB_NAME()) AS ErrorMessage
END
