-----------------------------------------測試結構-----------------------------------------
--Table
CREATE TABLE [dbo].[Products](
	[ProductID]			[int] IDENTITY(1,1) NOT NULL,
	[ProductName]		[nvarchar](40) NOT NULL,
	[SupplierID]		[int] NOT NULL,
	[CategoryID]		[int] NULL,
	[QuantityPerUnit]	[nvarchar](20) NULL,
	[UnitPrice]			[money] NULL,
	[UnitsInStock]		[smallint] NULL,
	[UnitsOnOrder]		[smallint] NULL,
	[ReorderLevel]		[smallint] NULL,
	[Discontinued]		[bit] NOT NULL,
)
--PK
ALTER TABLE [dbo].[Products] ADD CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED 
(
	ProductID ASC,
    SupplierID ASC
)
--NonClustered Index
CREATE NONCLUSTERED INDEX [IX_Products_CategoryID] ON [dbo].[Products] 
(
	CategoryID ASC
)

-------------------------------------------------------------------------------------------
--測試 1 
select SupplierID from products where ProductID=999				-->叢集索引搜尋
select * from products where ProductID=999						-->叢集索引搜尋
select * from products where ProductID=999 AND SupplierID=12	-->叢集索引搜尋
select * from products where SupplierID=12 AND ProductID=999	-->叢集索引搜尋
--WHERE條件皆有叢集索引鍵中的第一個欄位，所以會採取 Seek 搜尋方式

-------------------------------------------------------------------------------------------
--測試 2 
select SupplierID from products where SupplierID=12							-->索引掃描
select ProductID,SupplierID from products where SupplierID=12				-->索引掃描
select ProductID,SupplierID,ProductName from products where SupplierID=12	-->叢集索引掃描
--若不是使用叢集索引鍵中的第一個欄位，則會使用【索引掃描】
--行３因為SELECT欄位包含非索引欄位，所以僅能進行【叢集索引掃描】。

-------------------------------------------------------------------------------------------
--測試 3
select SupplierID,CategoryID from products where CategoryID=8										-->索引搜尋
select SupplierID,CategoryID from products where CategoryID=8 AND SupplierID=12						-->索引搜尋
select SupplierID,CategoryID from products where CategoryID=8 AND SupplierID=12 AND UnitPrice=10	-->叢集索引掃描
select SupplierID,CategoryID,ProductName from products where CategoryID=8							-->叢集索引掃描
--行１行２因為WHERE條件皆為索引鍵中的欄位，所以會採取【索引搜尋】搜尋方式。
--行３因為WHERE條件包含非索引欄位，所以僅能進行【叢集索引掃描】。
--行４因為SELECT欄位包含非索引欄位，所以僅能進行【叢集索引掃描】。
/*
行３會引起下面的「遺漏索引」
CREATE NONCLUSTERED INDEX [IndexName] ON [dbo].[Products] ([SupplierID],[CategoryID],[UnitPrice])

行４會引起下面的「遺漏索引」
CREATE NONCLUSTERED INDEX [IndexName]　ON [dbo].[Products] ([CategoryID])
INCLUDE ([ProductName],[SupplierID])
*/

-------------------------------------------------------------------------------------------
--測試 4
CREATE NONCLUSTERED INDEX [IX_Products_ProductName] ON [dbo].[Products] (
	[ProductName] ASC
)

SELECT ProductID,SupplierID,ProductName from products where ProductName='Schoggi Schokolade' -->索引搜尋

-------------------------------------------------------------------------------------------
--測試 5 
select ProductID,SupplierID,ProductName,UnitPrice from products where ProductName='Schoggi Schokolade' -->叢集索引掃描
/*
這個例子，因為SELECT欄位包含非索引欄位，所以自然是【叢集索引掃描】。
我們常會 SELECT 很多欄位，難道要所有欄位都要加入索引才會使用【索引搜尋】嗎？
當然不必的，因為 NonClustered Index 裡頭除了有索引鍵外，也可以外包一些欄位，用來應付所有的查詢欄位。 
這些外包欄位，不會建立索引，一般稱為 Nonkey ，必須使用 INCLUDE 子句來建立。
通常我們會將常用來搜尋的欄位當成 Nonclutered Index 鍵值，而其他欄位都可以加成 Nonkey 欄位。
*/
CREATE NONCLUSTERED INDEX [IX_Products_ProductName] ON [dbo].[Products] (
	[ProductName] ASC
)
INCLUDE (UnitPrice,UnitsInStock)
--如此查詢最佳化工具才會改用【索引搜尋】

-------------------------------------------------------------------------------------------
--測試 6
CREATE NONCLUSTERED INDEX [IX_Products] ON [dbo].[Products] 
(
	[SupplierID] ASC,
	[CategoryID] ASC
)

select ProductID from products where  SupplierID=12 					--索引搜尋
select ProductID from products where  CategoryID=5						--索引掃描
select ProductID from products where  SupplierID=12 and CategoryID=5	--索引搜尋
--複合索引的第一個欄位選擇非常重要，因為它是唯一一個會經過排序的欄位

--若 SELECT 條件還包含非 PK 的欄位，則結果將全部變成【叢集索引掃描】
select ProductID,ProductName from products where  SupplierID=12 and CategoryID=5

--必須將 SELECT 欄位設成索引的 Nonkey 欄位，才會使用【索引搜尋】
CREATE NONCLUSTERED INDEX [IX_Products] ON [dbo].[Products] 
(
	[SupplierID] ASC,
	[CategoryID] ASC
)
INCLUDE ( [ProductName])  

select ProductID,ProductName from products where  SupplierID=12 and CategoryID=5