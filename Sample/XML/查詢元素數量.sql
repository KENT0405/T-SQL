--查詢元素數量
--如下Peoples根節點下有個People子節點。
DECLARE @x XML
SELECT @x = '
<Peoples>
 <People>
   <NAME>dongsheng</NAME>
   <SEX>男</SEX>
 </People>
 <People>
   <NAME>土豆</NAME>
   <SEX>男</SEX>
 </People>
 <People>
   <NAME>choushuigou</NAME>
   <SEX>女</SEX>
 </People>
</Peoples>
'
SELECT  @x.value('count(/Peoples/People)','INT') AS Children
/*
Children
-----------
3
*/

--如下Peoples根節點下第一個子節點People下子節點的數量
SELECT  @x.value('count(/Peoples/People[1]/*)','INT') AS Children
/*
Children
-----------
2
*/

--某些時候我們可能不知道根節點和子節點的名稱，可以用通配符來代替。
SELECT  @x.value('count(/*/*)','INT') AS ChildrenOfRoot,
     @x.value('count(/*/*[1]/*)','INT') AS ChildrenOfFirstChildElement
/*
ChildrenOfRoot ChildrenOfFirstChildElement
-------------- ---------------------------
3       2
*/