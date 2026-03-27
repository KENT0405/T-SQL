--使用通配符讀取元素值

--讀取根元素的值
DECLARE @x1 XML
SELECT @x1 = '<People>dongsheng</People>'
SELECT @x1.value('(/*/text())[1]','VARCHAR(20)') AS People --星號*代表一個元素
/*
People
--------------------
dongsheng
*/

--讀取第二層元素的值
DECLARE  @x XML
SELECT @x = '
 <People>
   <NAME>dongsheng</NAME>
   <SEX>男</SEX>
   <QQ>423545</QQ>
 </People>'
SELECT
  @x.value('(/*/*/text())[1]','VARCHAR(20)') AS NAME
/*
NAME
--------------------
dongsheng
*/


--讀取第二個子元素的值
DECLARE  @x XML
SELECT @x = '
 <People>
   <NAME>dongsheng</NAME>
   <SEX>男</SEX>
   <QQ>423545</QQ>
 </People>'
SELECT
  @x.value('(/*/*/text())[2]','VARCHAR(20)') AS SEX
/*
SEX
--------------------
男
*/

--讀取所有第二層子元素值
DECLARE  @x XML
SELECT @x = '
 <People>
   <NAME>dongsheng</NAME>
   <SEX>男</SEX>
   <QQ>423545</QQ>
 </People>'
SELECT
  C.value('.','VARCHAR(20)') AS value
FROM @x.nodes('/*/*') T(C)
/*
value
--------------------
dongsheng
男
423545
*/