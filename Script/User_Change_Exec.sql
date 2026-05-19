/*
轉換USER，模擬該USER使用的情境
*/

EXECUTE AS USER = 'NewUser';

SELECT USER_NAME();

--------------------------------
--do something.............
SELECT * FROM TB;

--------------------------------

REVERT;  --revert--EXECUTE AS USER = 'NewUser'�o���