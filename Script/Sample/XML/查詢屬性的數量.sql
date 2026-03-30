--查詢屬性的數量
DECLARE @x XML
SELECT @x = '
<Employees dept="IT">
  <Employee NAME="dongsheng" SEX="男" QQ="5454545454"/>
  <Employee NAME="土豆" SEX="女" QQ="5345454554" TEL="13954697895"/>
</Employees>'
--查詢跟節點的屬性數量
SELECT  @x.value('count(/Employees/@*)','INT') AS AttributeCountOfRoot
/*
AttributeCountOfRoot
--------------------
1
*/

--第一個Employee節點的屬性數量
SELECT  @x.value('count(/Employees/Employee[1]/@*)','INT') AS AttributeCountOfFirstElement
/*
AttributeCountOfFirstElement
----------------------------
3
*/

--第二個Employee節點的屬性數量
SELECT  @x.value('count(/Employees/Employee[2]/@*)','INT') AS AttributeCountOfSeconfElement
/*
AttributeCountOfSeconfElement
-----------------------------
4
*/

--如果不清楚節點名稱可以用*通配符代替
SELECT  @x.value('count(/*/@*)','INT') AS AttributeCountOfRoot
    ,@x.value('count(/*/*[1]/@*)','INT') AS AttributeCountOfFirstElement
    ,@x.value('count(/*/*[2]/@*)','INT') AS AttributeCountOfSeconfElement
/*
AttributeCountOfRoot AttributeCountOfFirstElement AttributeCountOfSeconfElement
-------------------- ---------------------------- -----------------------------
1          3              4
*/

--返回沒個節點的屬性值
SELECT  C.value('count(./@*)','INT') AS AttributeCount
FROM @x.nodes('/*/*') T(C)
/*
AttributeCount
--------------
3
4
*/