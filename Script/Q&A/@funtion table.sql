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
	INSERT INTO @TB1 VALUES 
	(@ran_A),(@ran_B),(@ran_C),(@ran_D),(@ran_E)

	SELECT @maxval = MAX(num) FROM @TB1

	RETURN @maxval

END
GO

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
SELECT MAX(max_rand) AS maxval
FROM 
(
	VALUES (@ran_A),(@ran_B),(@ran_C),(@ran_D),(@ran_E)
) AS max_value (max_rand)
GO

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

DECLARE @TB TABLE (sn int identity(1,1),a INT,	b INT,	c INT,	d INT,	e INT)

INSERT INTO @TB
SELECT TOP 10 
	dbo.fn_random (10,1000),
	dbo.fn_random (10,1000),
	dbo.fn_random (10,1000),
	dbo.fn_random (10,1000),
	dbo.fn_random (10,1000)
FROM sys.objects o , sys.objects s

SELECT *,dbo.fn_MaxRan_kent(a,b,c,d,e)
FROM @TB

SELECT *
FROM @TB CROSS APPLY dbo.fn_MaxRan_kent2(a,b,c,d,e)

SELECT *
FROM @TB CROSS APPLY dbo.fn_MaxRan_kent3(a,b,c,d,e)

