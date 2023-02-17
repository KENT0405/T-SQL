--方法一
SELECT *
FROM 
(
	SELECT DISTINCT curr_month 
	FROM sys_currency_log_new
) AS A CROSS APPLY 
(
	SELECT STUFF(
	(
		SELECT ','+[curr_id]
		FROM
		(
			SELECT DISTINCT curr_id
			FROM sys_currency_log_new AS n
			WHERE n.curr_month = A.curr_month
		)AS ID
		FOR XML PATH('')
	),1,1,'')AS ID
) AS B
GO


--方法二
;WITH CTE
AS
(
	SELECT DISTINCT curr_month 
	FROM sys_currency_log_new
)
SELECT *
FROM CTE CROSS APPLY 
(
	SELECT STUFF(
	(
		SELECT ',' + [curr_id]
		FROM
		(
			SELECT DISTINCT curr_id
			FROM sys_currency_log_new n
			WHERE n.curr_month = CTE.curr_month
		)AS ID
		FOR XML PATH('')
	),1,1,'')AS ID
) AS B


--方法三
DECLARE @TABLE TABLE 
(
	sn INT IDENTITY(1,1),curr_month VARCHAR(10)
)

INSERT INTO @TABLE 
SELECT DISTINCT curr_month 
FROM sys_currency_log_new

DECLARE @TABLE2 TABLE 
(
	sn INT IDENTITY(1,1),ID VARCHAR(100)
)

DECLARE @f INT =1,@sn INT

WHILE (1 = 1) 
BEGIN
	;WITH CTE
	AS
	(
		SELECT STUFF(
			(
				SELECT ',' + [curr_id]
				FROM
				(
					SELECT DISTINCT curr_id
					FROM sys_currency_log_new
					WHERE curr_month = '2022-0'+ CAST(@f AS varchar) 
				)AS ID
				FOR XML PATH('')
			),1,1,'') AS id
	)

	INSERT INTO @TABLE2
	SELECT id FROM CTE

	SELECT @sn = sn
	FROM @TABLE
	WHERE sn = @f

	IF @@ROWCOUNT = 0
	BREAK;

	SET @f += 1 

END

SELECT A.curr_month ,B.ID
FROM @TABLE AS A JOIN @TABLE2 AS B ON A.sn = B.sn


--方法四
SELECT [curr_month]
      ,STUFF(
       (
	    SELECT ',' + [A].[curr_id]
	      FROM [dbo].[sys_currency_log_new] AS [A]
		 WHERE [A].[curr_month] = [B].[curr_month]
	       FOR XML PATH('')
       ),1,1,'') AS curr_desc
 FROM [dbo].[sys_currency_log_new] AS [B] 
 GROUP BY curr_month
GO



--方法五
;WITH CTE
AS
(
	SELECT [curr_month]
	FROM [dbo].[sys_currency_log_new] AS [B] 
	GROUP BY curr_month
)
SELECT *
FROM CTE AS C CROSS APPLY 
(
	SELECT STUFF
	(
       (SELECT ',' + [curr_id]
	    FROM [dbo].[sys_currency_log_new] AS [A]
		WHERE [A].[curr_month] = c.[curr_month]
	    FOR XML PATH('')
       )
	 ,1,1,''
	) AS curr_list
) AS P