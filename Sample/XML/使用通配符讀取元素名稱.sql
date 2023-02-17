--使用通配符讀取元素名稱
DECLARE @x XML
SELECT @x = '<People>dongsheng</People>'
SELECT
  @x.value('local-name(/*[1])','VARCHAR(20)') AS ElementName
/*
ElementName
--------------------
People
*/

--讀取根下第一個元素的名稱和值
DECLARE  @x XML
SELECT @x = '
 <People>
   <NAME>dongsheng</NAME>
   <SEX>男</SEX>
 </People>'
SELECT
  @x.value('local-name((/*/*)[1])','VARCHAR(20)') AS ElementName,
  @x.value('(/*/*/text())[1]','VARCHAR(20)') AS ElementValue
/*
ElementName     ElementValue
-------------------- --------------------
NAME         dongsheng
*/

--讀取根下第二個元素的名稱和值
DECLARE  @x XML
SELECT @x = '
 <People>
   <NAME>dongsheng</NAME>
   <SEX>男</SEX>
 </People>'
SELECT
  @x.value('local-name((/*/*)[2])','VARCHAR(20)') AS ElementName,
  @x.value('(/*/*/text())[2]','VARCHAR(20)') AS ElementValue
/*
ElementName     ElementValue
-------------------- --------------------
SEX         男
*/

--讀取根下所有的元素名稱和值
DECLARE  @x XML
SELECT @x = '
 <People>
   <NAME>dongsheng</NAME>
   <SEX>男</SEX>
 </People>'
SELECT
  C.value('local-name(.)','VARCHAR(20)') AS ElementName,
  C.value('.','VARCHAR(20)') AS ElementValue
FROM @x.nodes('/*/*') T(C)
/*
ElementName     ElementValue
-------------------- --------------------
NAME         dongsheng
SEX         男
*/