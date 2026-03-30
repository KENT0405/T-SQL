--下面為多種方法從XML中讀取EMAIL
DECLARE @x XML
SELECT @x = '
<People>
  <dongsheng>
    <Info Name="Email">dongsheng@xxyy.com</Info>
    <Info Name="Phone">678945546</Info>
    <Info Name="qq">36575</Info>
  </dongsheng>
</People>'

-- 方法1
SELECT @x.value('data(/People/dongsheng/Info[@Name="Email"])[1]', 'varchar(30)'),
		@x.value('data(/People/dongsheng/Info[@Name="Phone"])[1]', 'varchar(30)')
		
-- 方法2
SELECT @x.value('(/People/dongsheng/Info[@Name="Email"])[1]', 'varchar(30)'),
		@x.value('(/People/dongsheng/Info[@Name="qq"])[1]', 'varchar(30)')
		
-- 方法3
SELECT
  C.value('.','varchar(30)')
FROM @x.nodes('/People/dongsheng/Info[@Name="Email"]') T(C)

-- 方法4
SELECT
  C.value('(Info[@Name="Email"])[1]','varchar(30)')
FROM @x.nodes('/People/dongsheng') T(C)

-- 方法5
SELECT
  C.value('(dongsheng/Info[@Name="Email"])[1]','varchar(30)')
FROM @x.nodes('/People') T(C)

-- 方法6
SELECT
  C.value('.','varchar(30)')
FROM @x.nodes('/People/dongsheng/Info') T(C)
WHERE C.value('(.[@Name="Email"])[1]','varchar(30)') IS NOT NULL

-- 方法7
SELECT
  C.value('.','varchar(30)')
FROM @x.nodes('/People/dongsheng/Info') T(C)
WHERE C.exist('(.[@Name="Email"])[1]') = 1