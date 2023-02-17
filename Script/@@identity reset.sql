--MS SQL 自動編號(identity)歸零(reset)

--方法一

--語法格式
DBCC CHECKIDENT(dbo.table_name, RESEED, 0)

--範例
DBCC CHECKIDENT(MyTable, RESEED, 0)

 

--方法二

--語法格式
truncate table  dbo.table_name

--範例
truncate table  MyTable

 

--MyTable就是要將自動編號歸零重新計算的一個Table