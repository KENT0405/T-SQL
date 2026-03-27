--多屬性過濾
DECLARE @x XML
SELECT @x = '
<Employees>
 <Employee id="1234" dept="IT" type="合同工">
  <Info NAME="dongsheng" SEX="男" QQ="5454545454"/>
 </Employee>
 <Employee id="5656" dept="IT" type="臨時工">
  <Info NAME="土豆" SEX="女" QQ="5345454554"/>
 </Employee>
 <Employee id="3242" dept="市場" type="合同工">
  <Info NAME="choushuigou" SEX="女" QQ="54543545"/>
 </Employee>
</Employees>'
--查詢dept為IT的人員信息

  --方法1
  SELECT
    C.value('@NAME[1]','VARCHAR(10)') AS NAME,
    C.value('@SEX[1]','VARCHAR(10)') AS SEX,
    C.value('@QQ[1]','VARCHAR(20)') AS QQ
  FROM @x.nodes('/Employees/Employee[@dept="IT"]/Info') T(C)
  /*
  NAME   SEX    QQ
  ---------- ---------- --------------------
  dongsheng 男     5454545454
  土豆   女     5345454554
  */
  
  --方法2
  SELECT
    C.value('@NAME[1]','VARCHAR(10)') AS NAME,
    C.value('@SEX[1]','VARCHAR(10)') AS SEX,
    C.value('@QQ[1]','VARCHAR(20)') AS QQ
  FROM @x.nodes('//Employee[@dept="IT"]/*') T(C)
  /*
  NAME   SEX    QQ
  ---------- ---------- --------------------
  dongsheng 男     5454545454
  土豆   女     5345454554
  */
  
--查詢出IT部門type為Permanent的員工
SELECT
  C.value('@NAME[1]','VARCHAR(10)') AS NAME,
  C.value('@SEX[1]','VARCHAR(10)') AS SEX,
  C.value('@QQ[1]','VARCHAR(20)') AS QQ
FROM @x.nodes('//Employee[@dept="IT"][@type="合同工"]/*') T(C)
/*
  NAME   SEX    QQ
  ---------- ---------- --------------------
  dongsheng 男     5454545454
*/