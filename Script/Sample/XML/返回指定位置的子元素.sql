--返回指定位置的子元素
DECLARE @x XML
SELECT @x = '
<Employees dept="IT">
  <Employee NAME="dongsheng" SEX="男" QQ="5454545454"/>
  <Employee NAME="土豆" SEX="女" QQ="5345454554" TEL="13954697895"/>
</Employees>'
SELECT @x.query('(/Employees/Employee)[1]')
/*
<Employee NAME="dongsheng" SEX="男" QQ="5454545454" />
*/
SELECT @x.query('(/Employees/Employee)[position()=2]')
/*
<Employee NAME="土豆" SEX="女" QQ="5345454554" TEL="13954697895" />
*/
--通過變量獲取指定位置的子元素
DECLARE @i INT
SELECT @i = 2
SELECT @x.query('(/Employees/Employee)[sql:variable("@i")]')
--or
SELECT @x.query('(/Employees/Employee)[position()=sql:variable("@i")]')
/*
<Employee NAME="土豆" SEX="女" QQ="5345454554" TEL="13954697895" />
*/