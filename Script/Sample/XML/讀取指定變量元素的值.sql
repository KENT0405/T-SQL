--讀取指定變量元素的值
DECLARE @x XML
SELECT @x = '
<Peoples>
 <People>
   <NAME>dongsheng</NAME>
   <SEX>男</SEX>
   <QQ>423545</QQ>
 </People>
 <People>
   <NAME>土豆</NAME>
   <SEX>男</SEX>
   <QQ>123133</QQ>
 </People>
 <People>
   <NAME>choushuigou</NAME>
   <SEX>女</SEX>
   <QQ>54543545</QQ>
 </People>
</Peoples>
'
DECLARE @ElementName VARCHAR(20)
SELECT @ElementName = 'NAME'
SELECT c.value('.','VARCHAR(20)') AS NAME
FROM @x.nodes('/Peoples/People/*[local-name()=sql:variable("@ElementName")]') T(C)
/*
NAME
--------------------
dongsheng
土豆
choushuigou
*/