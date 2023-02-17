--循環遍歷獲得所有子元素
DECLARE @x XML
SELECT @x = '
<Employees dept="IT">
  <Employee NAME="dongsheng" SEX="男" QQ="5454545454"/>
  <Employee NAME="土豆" SEX="女" QQ="5345454554" TEL="13954697895"/>
</Employees>'
DECLARE
  @cnt INT,
  @totCnt INT,
  @child XML
-- counter variables
SELECT
  @cnt = 1,
  @totCnt = @x.value('count(/Employees/Employee)','INT')
-- loop
WHILE @cnt <= @totCnt BEGIN
  SELECT
    @child = @x.query('/Employees/Employee[position()=sql:variable("@cnt")]')
  PRINT 'Processing Child Element: ' + CAST(@cnt AS VARCHAR)
  PRINT 'Child element: ' + CAST(@child AS VARCHAR(100))
  PRINT ''
  -- incremet the counter variable
  SELECT @cnt = @cnt + 1
END
/*
Processing Child Element: 1
Child element: <Employee NAME="dongsheng" SEX="男" QQ="5454545454"/>
Processing Child Element: 2
Child element: <Employee NAME="土豆" SEX="女" QQ="5345454554" TEL="13954697895"/>