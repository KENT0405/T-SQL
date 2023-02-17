--1
DECLARE @SQL NVARCHAR(MAX), @user_id VARCHAR(10)

SET @user_id = 'idramadhanu@-'

SET @SQL = '
SELECT COUNT(*) AS cnt
FROM dbo..user_currency WITH (NOLOCK) AS a
WHERE a.user_id = @user_id'

EXEC sp_executesql @SQL,'@user_id VARCHAR(10)',@user_id
GO

--9
DECLARE @SQL VARCHAR(MAX), @user_id VARCHAR(10)s

SET @user_id = 'ictest003@'

SET @SQL = '
SET NOCOUNT ON

WITH A
AS
(
	SELECT *
	FROM dbo.user_currency a WITH (NOLOCK)
	WHERE user_id = @user_id
)
SELECT
	user_id,
	curr_id,
	merchent_id
FROM A JOIN [dbo].[user_currency_archive] h WITH (NOLOCK)
ON a.user_id = h.user_id
AND a.curr_id = a.curr_id
AND a.merchant_id = a.merchant_id'

EXEC sp_executesql @SQL,N'@user_id VARCHAR(10)',@user_id
GO

---------------------------------------ANS--------------------------------------

--1 SELECT * FROM dbo.user_currency
DECLARE @SQL NVARCHAR(MAX), @user_id VARCHAR(100)

SET @user_id = 'idramadhanu@-'

SET @SQL = '
SELECT COUNT(*) AS cnt
FROM dbo.user_currency AS a WITH (NOLOCK) 
WHERE a.user_id = @user_id'

--N 代表存入資料庫時以 Unicode 格式儲存
EXEC sp_executesql @SQL,N'@user_id VARCHAR(100)',@user_id
GO

--9 SELECT * FROM user_currency_archive
DECLARE @SQL NVARCHAR(MAX), @user_id VARCHAR(100) = 'ictest003@'

SET @SQL = N'
SET NOCOUNT ON

;WITH A
AS
(
	SELECT *
	FROM dbo.user_currency
	WHERE user_id = @user_id
)

SELECT 	A.*
FROM A JOIN user_currency_archive AS h
	ON A.user_id = h.user_id
	AND A.curr_id = h.curr_id
	AND A.merchant_id = h.merchant_id
SET NOCOUNT OFF;
'
EXEC sp_executesql @SQL, N'@user_id VARCHAR(100)',@user_id