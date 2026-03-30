---------------------------------------------------------------------------------------------------------
-----------------------------------------方法一----------------------------------------------------------
---------------------------------------------------------------------------------------------------------

CREATE OR ALTER VIEW vw_rand
AS
SELECT ROUND(RAND()*1000000,0)
AS VALUE
GO

CREATE OR ALTER FUNCTION fn_rand_range
(
	@LowerBand INT,
	@UperBand INT 
)
RETURNS INT
BEGIN
	DECLARE @num INT
	
	WHILE (1 = 1)
	BEGIN
		SET @num = (SELECT VALUE FROM vw_rand)

		IF @num >= @LowerBand AND @num <= @UperBand
			BREAK;
	END

	RETURN @num
END
GO

SELECT dbo.fn_rand_range(10,100)

---------------------------------------------------------------------------------------------------------
--------------------------------------方法二-------------------------------------------------------------
---------------------------------------------------------------------------------------------------------

CREATE OR ALTER VIEW rndView
AS
SELECT RAND() AS [rndResult]
GO

CREATE OR ALTER FUNCTION [fn_random]
(
	@ran_BEGIN INT
   ,@ran_END   INT
)
RETURNS INT
AS
BEGIN
    DECLARE @ran_number INT
    SELECT @ran_number = FLOOR([rndResult]*(@ran_BEGIN-@ran_END+1)+@ran_END)
	FROM rndView
	RETURN @ran_number

END
GO

SELECT dbo.fn_random (10,100)
GO
---------------------------------------------------------------------------------------------------------
--------------------------------------方法三-------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
SELECT ABS(CHECKSUM(NEWID()) % 90) + 10