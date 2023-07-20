SELECT DISTINCT
	o.name,
	o.type,
	c.*
FROM syscomments c
INNER JOIN sysobjects o ON c.id=o.id
WHERE
(
		o.name LIKE '%特定文字%'	--查Procedure,View,Function名稱
	OR	c.text LIKE '%特定文字%'	--查Procedure,View,Function內含文字
)
--AND (o.xtype = 'P' OR o.xtype = 'V' OR o.type = 'FN' OR o.type = 'TF' OR o.type = 'IF')