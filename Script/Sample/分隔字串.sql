----------------------------有分隔符號
DECLARE
	@str VARCHAR(20) = 'SG,LEBO,IM',
	@i INT = 0

DECLARE @T TABLE
(
	strtable VARCHAR(20)
)

WHILE(1 = 1)
BEGIN
	SELECT @i = CHARINDEX(',',@str,@i)

	IF(@i = 0)
	BEGIN
		INSERT INTO @T(strtable) SELECT @str
	END
	ELSE
	BEGIN
		INSERT INTO @T(strtable) SELECT LEFT(@str,@i-1)
	END

	IF @i = 0
		BREAK;

	SELECT @str = STUFF(@str,1,@i,'')

	SET @i = 0
END

SELECT * FROM @T

--SELECT * FROM FN_StrToTable('SG,FS,IM')

/*------------------------------------------------------------------------------*/

-------------------------------無分隔符號
DECLARE @str2 VARCHAR(20) = 'hello world!'

DECLARE @T2 TABLE
(
	strtable VARCHAR(20)
)

WHILE(1=1)
BEGIN
	INSERT INTO @T2(strtable) SELECT LEFT(@str2,1)

	IF(LEN(@str2) = 1)
		BREAK;

	SELECT @str2 = STUFF(@str2,1,1,'')
END

SELECT * FROM @T2