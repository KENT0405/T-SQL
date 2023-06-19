DECLARE
	@MerchantCode VARCHAR(100) = 'SGDEMO',
	 @str VARCHAR(500)

SELECT
	 @str = LEFT(SUBSTRING(m.support_currency,2,LEN(m.support_currency)),LEN(m.support_currency)-2)
FROM
(
	SELECT sub_merchant_code
	FROM merchant_relation
	WHERE merchant_code = @MerchantCode
) mr
INNER JOIN merchant m
ON mr.sub_merchant_code = m.merchant_code

SELECT
	merchant_code,
	[value] AS support_currency
FROM string_split(@str,',')
CROSS APPLY merchant
WHERE merchant_code = @MerchantCode