/*找出有符合這個字串的 procedure、trigger、function*/
SELECT OBJECT_NAME(object_id)
FROM sys.sql_modules
WHERE definition LIKE '%ticket_all%'