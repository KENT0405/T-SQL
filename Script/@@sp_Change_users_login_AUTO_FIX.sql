DECLARE @sp_change_users_login TABLE
(
	SN TINYINT IDENTITY(1,1),
	UserName SYSNAME,
	UserSID VARBINARY(85)
)

INSERT INTO @sp_change_users_login
EXEC sp_change_users_login 'REPORT'

SELECT *
FROM @sp_change_users_login

DECLARE 
	@SN TINYINT = 1,
	@UserName SYSNAME,
	@SQL NVARCHAR(100)

WHILE (1=1)
BEGIN
	SELECT 
		@UserName = UserName
	FROM @sp_change_users_login
	WHERE SN = @SN

	IF @@ROWCOUNT = 0
		BREAK;

	--只修復Login存在的帳號
	IF EXISTS (SELECT name FROM sys.sql_logins	WHERE name = @UserName)
	BEGIN
		SET @SQL = 'EXEC sp_change_users_login ''AUTO_FIX'',@UserName'
		
		PRINT CHAR(13) + @SQL + ' = ' + @UserName + CHAR(13)

		--自動修正
		EXEC sp_executesql @SQL,N'@UserName SYSNAME',@UserName
	END

	SET @SN += 1
END
GO

EXEC sp_change_users_login 'REPORT'
