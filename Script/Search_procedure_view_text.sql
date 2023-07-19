SELECT DISTINCT
	o.name,
	c.*
FROM syscomments c
INNER JOIN sysobjects o ON c.id=o.id
WHERE(o.xtype = 'P' OR	o.xtype = 'V')
And
(
		o.name LIKE '%特定文字%'	--查SP或View名稱
	OR	c.text LIKE '%特定文字%'	--查SP或View內含文字
)