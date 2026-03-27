--循環遍歷元素的所有屬性
DECLARE  @x XML
SELECT @x = '<Employee NAME="土豆" SEX="女" QQ="5345454554" TEL="13954697895"/>'
DECLARE
  @cnt INT,
  @totCnt INT,
  @attName VARCHAR(30),
  @attValue VARCHAR(30)
SELECT
  @cnt = 1,
  @totCnt = @x.value('count(/Employee/@*)','INT')--獲得屬性總數量
-- loop
WHILE @cnt <= @totCnt BEGIN
  SELECT
    @attName = @x.value(
      'local-name((/Employee/@*[position()=sql:variable("@cnt")])[1])',
      'VARCHAR(30)'),
    @attValue = http://www.jb51.net/article/@x.value('(/Employee/@*[position()=sql:variable("@cnt")])[1]',
      'VARCHAR(30)')
  PRINT 'Attribute Position: ' + CAST(@cnt AS VARCHAR)
  PRINT 'Attribute Name: ' + @attName
  PRINT 'Attribute Value: ' + @attValue
  PRINT ''
  -- increment the counter variable
  SELECT @cnt = @cnt + 1
END
/*
Attribute Position: 1
Attribute Name: NAME
Attribute Value: 土豆
Attribute Position: 2
Attribute Name: SEX
Attribute Value: 女
Attribute Position: 3
Attribute Name: QQ
Attribute Value: 5345454554
Attribute Position: 4
Attribute Name: TEL
Attribute Value: 13954697895
*/