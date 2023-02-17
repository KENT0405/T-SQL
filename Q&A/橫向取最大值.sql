DECLARE @TB TABLE (sn int identity(1,1),a INT,	b INT,	c INT,	d INT,	e INT)

INSERT INTO @TB
SELECT TOP 10 dbo.fn_random (10,1000),	dbo.fn_random (10,1000),	dbo.fn_random (10,1000),	dbo.fn_random (10,1000),	dbo.fn_random (10,1000)
FROM sys.objects o , sys.objects s

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------方法 1----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

SELECT *,
	(
		SELECT MAX(max_rand)
		FROM (VALUES (a),(b),(c),(d),(e)) AS max_randVALUES (max_rand)) AS max_value
FROM @TB

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------方法 2----------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

DECLARE @TB2 TABLE (sn int,max_value INT)

DECLARE @TB1 TABLE (num INT )

DECLARE @i INT = 1

WHILE ( @i < (SELECT COUNT(*) FROM @TB))
BEGIN
	INSERT INTO @TB1 
	SELECT a FROM @TB WHERE sn = @i 
	UNION ALL SELECT b FROM @TB WHERE sn = @i 
	UNION ALL SELECT c FROM @TB WHERE sn = @i 
	UNION ALL SELECT d FROM @TB WHERE sn = @i 
	UNION ALL SELECT e FROM @TB WHERE sn = @i 
	
	INSERT INTO @TB2(sn, max_value)
	SELECT @i,MAX(num) FROM @TB1

	DELETE FROM @TB1

	SET @i += 1
END


SELECT A.a,A.b,A.c,A.d,A.e,B.max_value
FROM @TB AS A JOIN @TB2 AS B
ON A.sn = B.sn

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------方法 3 (純量值 FUNCTION)---------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR ALTER FUNCTION [fn_MaxRan_kent]
(
 @ran_A INT 
,@ran_B INT
,@ran_C INT
,@ran_D INT
,@ran_E INT
)
RETURNS INT
AS
BEGIN
	
	DECLARE @maxval INT
	DECLARE @TB1 TABLE (num INT )

	INSERT INTO @TB1 
	VALUES (@ran_A),(@ran_B),(@ran_C),(@ran_D),(@ran_E)

	SELECT @maxval = MAX(num) FROM @TB1

	RETURN @maxval

END
GO

DECLARE @TB TABLE (sn int identity(1,1), a INT,	b INT,	c INT,	d INT,	e INT)

INSERT INTO @TB
SELECT TOP 10 dbo.fn_random (10,1000),	dbo.fn_random (10,1000),	dbo.fn_random (10,1000),	dbo.fn_random (10,1000),	dbo.fn_random (10,1000)
FROM sys.objects AS o , sys.objects AS s

SELECT *,dbo.fn_MaxRan_kent(a,b,c,d,e) AS max_value
FROM @TB

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------方法 4 (TABLE FUNCTION)----------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR ALTER FUNCTION [fn_MaxRan_kent2]
(
 @ran_A INT 
,@ran_B INT
,@ran_C INT
,@ran_D INT
,@ran_E INT
)
RETURNS TABLE
AS
RETURN
	SELECT MAX(max_rand) AS max_value
	FROM 
		(
			VALUES (@ran_A),(@ran_B),(@ran_C),(@ran_D),(@ran_E)
		) AS max_value (max_rand)
GO

DECLARE @TB TABLE (sn int identity(1,1), a INT,	b INT,	c INT,	d INT,	e INT)

INSERT INTO @TB
SELECT TOP 10 dbo.fn_random (10,1000),	dbo.fn_random (10,1000),	dbo.fn_random (10,1000),	dbo.fn_random (10,1000),	dbo.fn_random (10,1000)
FROM sys.objects AS o , sys.objects AS s

SELECT *
FROM @TB CROSS APPLY dbo.fn_MaxRan_kent2(a,b,c,d,e)

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------方法 5 (TABLE FUNCTION)----------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

CREATE OR ALTER FUNCTION [fn_MaxRan_kent3]
(
 @ran_A INT 
,@ran_B INT
,@ran_C INT
,@ran_D INT
,@ran_E INT
)
RETURNS @TB1 TABLE
(
	max_val INT
)
AS
BEGIN	
	DECLARE @TB2 TABLE (num INT)

	INSERT INTO @TB2 VALUES 
	(@ran_A),(@ran_B),(@ran_C),(@ran_D),(@ran_E)

	INSERT INTO @TB1
	SELECT MAX(num) FROM @TB2

	RETURN
END
GO

DECLARE @TB TABLE (sn int identity(1,1), a INT,	b INT,	c INT,	d INT,	e INT)

INSERT INTO @TB
SELECT TOP 10 dbo.fn_random (10,1000),	dbo.fn_random (10,1000),	dbo.fn_random (10,1000),	dbo.fn_random (10,1000),	dbo.fn_random (10,1000)
FROM sys.objects AS o , sys.objects AS s

SELECT *
FROM @TB CROSS APPLY dbo.fn_MaxRan_kent3(a,b,c,d,e)

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------

