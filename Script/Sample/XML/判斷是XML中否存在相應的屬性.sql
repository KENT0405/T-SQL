--判斷是XML中是否存在相應的屬性
DECLARE  @x XML
SELECT @x = '<Employee NAME="土豆" SEX="女" QQ="5345454554" TEL="13954697895"/>'
IF @x.exist('/Employee/@NAME') = 1
  SELECT 'Exists' AS Result
ELSE
  SELECT 'Does not exist' AS Result
/*
Result
------
Exists
*/
--傳遞變量判斷是否存在
DECLARE  @x XML
SELECT @x = '<Employee NAME="土豆" SEX="女" QQ="5345454554" TEL="13954697895"/>'
DECLARE @att VARCHAR(20)
SELECT @att = 'QQ'
IF @x.exist('/Employee/@*[local-name()=sql:variable("@att")]') = 1
  SELECT 'Exists' AS Result
ELSE
  SELECT 'Does not exist' AS Result
/*
Result
------
Exists
*/