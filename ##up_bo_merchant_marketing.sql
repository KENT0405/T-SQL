-- =================================================================================
-- Author:		<wq.huang>
-- Create date: <2022-02-23>
-- Description:	<merchant >
--
-- ==================================================================================
--exec [up_bo_merchant_marketing] 'BBIN','','Marketing ABB'
CREATE OR ALTER PROCEDURE [dbo].[##up_bo_merchant_marketing]
	@ServerCode		VARCHAR(10) = '',
	@MerchantCode	VARCHAR(MAX) = '',
	@Marketing		VARCHAR(150) = ''
AS
BEGIN
	SET NOCOUNT, ARITHABORT ON;

	SELECT
		mr.sub_merchant_code,
		mr.server_code,
		ISNULL(marketing,'-') AS marketing,
		upline,
		ISNULL(marketing_history,'-') AS marketing_history
	FROM merchant_relation mr WITH (NOLOCK)
	LEFT JOIN marketing_setting ms WITH (NOLOCK)
	ON mr.sub_merchant_code = ms.merchant_code
	AND mr.server_code = ms.server_code
	WHERE mr.merchant_code <> '-'
	AND (mr.merchant_code IN (SELECT * FROM FN_StrToTable (REPLACE(REPLACE(@MerchantCode,'[',''),']',''))) OR @MerchantCode = '')
	AND (mr.server_code = @ServerCode OR @ServerCode = '')
	AND (ms.marketing IN (@Marketing,'-') OR @Marketing = '')
	GROUP BY
		sub_merchant_code,
		mr.server_code,
		upline,marketing,
		marketing_history
	ORDER BY mr.sub_merchant_code

 	SET NOCOUNT, ARITHABORT OFF;
END