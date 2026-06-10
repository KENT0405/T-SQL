SELECT
    name,
    'DENY CONNECT SQL TO [' + name + '];ALTER LOGIN [' + name + '] DISABLE;' as DENY_str,
    'GRANT CONNECT SQL TO [' + name + '];ALTER LOGIN [' + name + '] ENABLE;' as GRANT_str
FROM sys.sql_logins
WHERE name NOT IN ('dbadmin','Db_user','repl_admin','##MS_PolicyTsqlExecutionLogin##','##MS_PolicyEventProcessingLogin##','gino','jacky','kent')


/*
--如果對方有datareader的權限，卻還是看不見procedure，執行以下語法
GRANT VIEW DEFINITION TO hx

--給 user 在某一張表的 alter 權限
Grant alter on merchant_archive to fs_egame_user

--給 hx EXECUTE的權限
GRANT EXECUTE TO hx

--給 hx 執行某一支procedure的權限
GRANT EXECUTE ON procedure_name TO hx;
*/