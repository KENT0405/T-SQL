CREATE OR ALTER PROCEDURE PROC_split_value
	@paramStr VARCHAR(MAX) = 'createLuckyFreeSpin,5,,,8,,10,,,wer,;getGames,2,,,3,,3,,dfg,,;sdfij,2,,,1,2,3,,dfg,,'
AS
BEGIN
	SET NOCOUNT, ARITHABORT ON;

	DECLARE
		@SQL			NVARCHAR(MAX) = '',
		@SQL_temp		NVARCHAR(MAX) = '',
		@split_value	NVARCHAR(MAX),
		@temp			NVARCHAR(MAX) = '',
		@count			INT,
		@ID				INT = 1

	DROP TABLE IF EXISTS ##temp;

	WHILE(1 = 1)
	BEGIN
		;WITH CTE
		AS
		(
			SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS id,value AS split_value
			FROM STRING_SPLIT(REPLACE(@paramStr, ' ', ''), ';')
		)
		SELECT @split_value = split_value
		FROM CTE
		WHERE id = @ID

		IF @@ROWCOUNT = 0
			BREAK;

		--確認欄位數
		SELECT @count = COUNT(1)
		FROM STRING_SPLIT(@split_value, ',')

		--欄位數-1, 因為第一個是api
		SET @count = @count - 1

		--CREATE TABLE
		IF (@ID = 1)--只有第一圈要craete table
		BEGIN
			WHILE(1 = 1)
			BEGIN
				IF(@count = 0)
					BREAK;

				SET @temp = 'cnt' + CAST(@count AS VARCHAR(100)) + ' VARCHAR(100),'

				SET @SQL_temp += @temp

				SET @count = @count - 1
			END

			SET @SQL_temp = '
			CREATE TABLE ##temp
			(
				api VARCHAR(100),
				' + STUFF(@SQL_temp,LEN(@SQL_temp),LEN(@SQL_temp),'') + '
			)'

			EXEC(@SQL_temp)
		END

		SELECT @SQL += ',' + CASE WHEN value = '' THEN '''''' + ' AS [1]' ELSE QUOTENAME(value,'''') + ' AS [1]' END
		FROM STRING_SPLIT(@split_value, ',')

		SET @SQL = 'INSERT INTO ##temp SELECT ' + STUFF(@SQL,1,1,'')

		EXEC(@SQL)

		SET @SQL = ''
		SET @ID += 1
	END

	SELECT * FROM ##temp

	SET NOCOUNT, ARITHABORT OFF;
END

