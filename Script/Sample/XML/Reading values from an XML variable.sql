--Reading values from an XML variable
DECLARE @x XML
SELECT @x =
'<Peoples>
  <People Name="tudou" Sex="女" />
  <People Name="choushuigou" Sex="女"/>
  <People Name="dongsheng" Sex="男" />
</Peoples>'
SELECT
  v.value('@Name[1]','VARCHAR(20)') AS Name,
  v.value('@Sex[1]','VARCHAR(20)') AS Sex
FROM @x.nodes('/Peoples/People') x(v)