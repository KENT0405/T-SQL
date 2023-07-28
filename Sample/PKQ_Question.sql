--Function
CREATE OR ALTER FUNCTION fntb_GetTable
(
	@str1 VARCHAR(MAX),
	@str2 VARCHAR(MAX),
	@bit INT
)
RETURNS @tablestr TABLE
(
   str_value VARCHAR(500)
)
AS
BEGIN
	IF (@bit = 0)
	BEGIN --1,2
		INSERT INTO @tablestr
		SELECT [value]
		FROM
		(
			SELECT A.*
			FROM
			(
				SELECT * FROM STRING_SPLIT(@str1,',')
			) A
			JOIN
			(
				SELECT * FROM STRING_SPLIT(@str2,',')
			) B ON A.[value] = B.[value]
		) q
	END
	ELSE
	BEGIN --3,4
		INSERT INTO @tablestr
		SELECT [value]
		FROM STRING_SPLIT(@str1,',')
		WHERE [value] NOT IN
		(
			SELECT A.* --3,4
			FROM
			(
				SELECT * FROM STRING_SPLIT(@str1,',')
			) A
			JOIN
			(
				SELECT * FROM STRING_SPLIT(@str2,',')
			) B ON A.[value] = B.[value]
		)
	END

	RETURN
END
GO

--procedure
CREATE OR ALTER PROCEDURE PROC_GetTable
	@str1 VARCHAR(MAX),
	@str2 VARCHAR(MAX),
	@bit INT
AS
BEGIN
	SET NOCOUNT, ARITHABORT ON;

	DECLARE @SQL NVARCHAR(MAX) = ''

	SELECT @SQL = STUFF(
	(
		SELECT ',' + QUOTENAME(str_value,'''')
		FROM fntb_GetTable(@str1,@str2,@bit)
		FOR XML PATH('')
	),1,1,'')

	EXEC (N'SELECT ' + @SQL)

	SET NOCOUNT, ARITHABORT OFF;
END

EXEC PROC_GetTable '1,2,3,4','3,4,5,6',1