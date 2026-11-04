SELECT
    @@SERVERNAME AS SourceServer,
    s.name AS LinkedServerName,
    s.provider AS Provider,
    s.data_source AS TargetDataSource,
    s.is_data_access_enabled AS DataAccessEnabled, -- 1 : select / update / insert / delete
    s.is_rpc_out_enabled AS RPCOutEnabled, -- 1 : store procedure
    CASE
        WHEN ll.local_principal_id = 0
            THEN N'everyone can use'
        ELSE sp.name
    END AS LocalLogin,
    CASE
        WHEN ll.uses_self_credential = 1 THEN N'傳遞身分'
        ELSE N'使用指定帳號或預設'
    END AS ImpersonateStatus,
    ll.remote_name AS RemoteLogin,
    CASE
        WHEN ll.local_principal_id = 0 AND ll.uses_self_credential = 1
            THEN N'本機使用者必須以自己的真實身分連到遠端，且遠端必須賦予該帳號相應的資料存取權限'
        WHEN ll.local_principal_id = 0 AND ll.uses_self_credential = 0 AND ll.remote_name IS NULL
            THEN N'以未登入的身分（或公用身分）連過去'
        WHEN ll.local_principal_id = 0 AND ll.uses_self_credential = 0 AND ll.remote_name IS NOT NULL
            THEN N'使用固定帳號 [' + ll.remote_name + ']'
        ELSE N'個別指定帳號對應'
    END AS DefaultConnectionBehavior
FROM sys.servers AS s
LEFT JOIN sys.linked_logins AS ll ON s.server_id = ll.server_id
LEFT JOIN sys.server_principals AS sp ON ll.local_principal_id = sp.principal_id
WHERE s.is_linked = 1
ORDER BY s.name, ll.local_principal_id