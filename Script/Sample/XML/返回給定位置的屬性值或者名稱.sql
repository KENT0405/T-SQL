--返回給定位置的屬性值或者名稱
DECLARE @x XML
SELECT @x = '
<Employees dept="IT">
  <Employee NAME="dongsheng" SEX="男" QQ="5454545454"/>
  <Employee NAME="土豆" SEX="女" QQ="5345454554" TEL="13954697895"/>
</Employees>'
--返回第一個Employee節點的第一個位置的屬性值
SELECT  @x.value('(/Employees/Employee[1]/@*[position()=1])[1]','VARCHAR(20)') AS AttValue
/*
AttValue
--------------------
dongsheng
*/

--返回第二個Employee節點的第四個位置的屬性值
SELECT  @x.value('(/Employees/Employee[2]/@*[position()=4])[1]','VARCHAR(20)') AS AttValue
/*
AttValue
--------------------
13954697895
*/

--返回第一個元素的第三個屬性值
SELECT  @x.value('local-name((/Employees/Employee[1]/@*[position()=3])[1])','VARCHAR(20)') AS AttName
/*
AttName
--------------------
QQ
*/

--返回第二個元素的第四個屬性值
SELECT  @x.value('local-name((/Employees/Employee[2]/@*[position()=4])[1])','VARCHAR(20)') AS AttName
/*
AttName
--------------------
TEL
*/

--通過變量傳遞位置返回屬性值
DECLARE @Elepos INT,@Attpos INT
SELECT @Elepos=2,@Attpos = 3
SELECT  @x.value('local-name((/Employees/Employee[sql:variable("@Elepos")]/@*[position()=sql:variable("@Attpos")])[1])','VARCHAR(20)') AS AttName
/*
AttName
--------------------
QQ
*/