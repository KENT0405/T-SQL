DECLARE 
	@paramStr		VARCHAR(MAX) = 'createLuckyFreeSpin,5,,1,5,6,8,9,10,,,wer,;getGames,2,,1,3,8,1,2,3,,dfg,,',
	@SQL			NVARCHAR(MAX) = '',
	@SQL_temp		NVARCHAR(MAX) = '',
	@split_value	NVARCHAR(MAX),
	@temp			NVARCHAR(MAX) = '',
	@count			INT,
	@ID				INT = 1

DROP TABLE IF EXISTS ##temp;

DECLARE @TB TABLE
(
	id INT IDENTITY(1,1),
	split_value VARCHAR(MAX)
)

INSERT INTO @TB SELECT value
FROM STRING_SPLIT(REPLACE(@paramStr, ' ', ''), ';')

WHILE(1 = 1)
BEGIN
	SELECT @split_value = split_value
	FROM @TB 
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