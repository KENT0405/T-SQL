--從XML變量中刪除元素
DECLARE @x XML
SELECT @x = '
<Peoples>
 <People>
   <NAME>土豆</NAME>
   <SEX>男</SEX>
   <QQ>5345454554</QQ>
 </People>
</Peoples>'
SET @x.modify('
  delete (/Peoples/People/SEX)[1]'
 )
SELECT @x
/*
<Peoples>
 <People>
  <NAME>土豆</NAME>
  <QQ>5345454554</QQ>
 </People>
</Peoples>
*/