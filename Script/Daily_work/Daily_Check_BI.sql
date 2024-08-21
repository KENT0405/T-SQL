;WITH CTE AS
(
    SELECT
        sub_module,
        MAX(split_time) AS split_time,
        ByMinuteTime = DATEADD(MINUTE, -(DATEPART(MINUTE, GETDATE()) % 5), FORMAT(GETDATE(),'yyyy-MM-dd HH:mm:00.000')),
        ByHourTime = DATEADD(HOUR, DATEDIFF(HOUR, 0, GETDATE()), 0),
        ByWeekTime = DATEADD(WEEK, DATEDIFF(WEEK, 0, GETDATE()), 0),
        ByMonthTime = DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0),
        ByDayTime = CAST(CAST(GETDATE() AS DATE) AS DATETIME)
    FROM bi_facade_send_log WITH (NOLOCK)
    GROUP BY sub_module
)
SELECT
    sub_module,
	split_time,
    CASE
		--ByMinute
        WHEN sub_module LIKE '%ByToday%' OR sub_module IN ('BonusRedeemedByHour','StakeByHour','RiskMemberGainLoss')
        THEN IIF(split_time = ByMinuteTime, 'Correct', 'Error')

		--ByHour
        WHEN sub_module LIKE '%ByHour%' AND sub_module NOT IN ('BonusRedeemedByHour','StakeByHour')
        THEN IIF(split_time = ByHourTime, 'Correct', 'Error')

		--ByWeek
        WHEN sub_module LIKE '%ByWeek%'
        THEN IIF(split_time = ByWeekTime, 'Correct', 'Error')

		--ByMonth
        WHEN sub_module LIKE '%ByMonth%'
        THEN IIF(split_time = ByMonthTime, 'Correct', 'Error')

		--ByDay
        ELSE IIF(split_time = ByDayTime, 'Correct', 'Error')
    END AS result,
	CASE
		WHEN sub_module = 'BonusMaxPayoutByToday' THEN 'up_sys_data_sum_bi_bonus'
		WHEN sub_module = 'BonusRedeemedByHour' THEN 'up_sys_data_sum_bi_bonus'
		WHEN sub_module = 'MemberByToday' THEN 'PROC_BI_get_acct_monitor'
		WHEN sub_module = 'MemberProductByToday' THEN 'up_sys_data_sum_bi_member'
		WHEN sub_module = 'RiskMemberGainLoss' THEN 'PROC_risk_list'
		WHEN sub_module = 'SessionActiveLoginByToday' THEN 'up_sys_data_sum_bi_session'
		WHEN sub_module = 'SessionChannelByToday' THEN 'up_sys_data_sum_bi_session'
		WHEN sub_module = 'SessionTopBrowserByToday' THEN 'up_sys_data_sum_bi_session'
		WHEN sub_module = 'StakeByHour' THEN 'up_sys_data_sum_bi_stake'
		WHEN sub_module = 'StakeTopMemberByToday' THEN 'up_sys_data_sum_bi_stake'
		WHEN sub_module = 'MemberByHour' THEN 'up_sys_data_sum_bi_by_hour_member'
		WHEN sub_module = 'MemberProductByHour' THEN 'MemberProductByHour'
		WHEN sub_module = 'SessionActiveLoginByHour' THEN 'up_sys_data_sum_bi_by_hour_session'
		WHEN sub_module = 'SessionChannelByHour' THEN 'up_sys_data_sum_bi_by_hour_session'

		WHEN sub_module = 'SessionTopBrowserByHour' THEN 'up_sys_data_sum_bi_bonus'
		WHEN sub_module = 'StakeTopMemberByHour' THEN 'up_sys_data_sum_bi_bonus'
		WHEN sub_module = 'BonusInfo' THEN 'up_sys_data_sum_bi_bonus'
		WHEN sub_module = 'CurrencyInfo' THEN 'up_sys_data_sum_bi_bonus'
		WHEN sub_module = 'MerchantInfo' THEN 'up_sys_data_sum_bi_bonus'
		WHEN sub_module = 'ProductCategoryInfo' THEN 'up_sys_data_sum_bi_bonus'
		WHEN sub_module = 'ProductInfo' THEN 'up_sys_data_sum_bi_bonus'
		WHEN sub_module = 'StakeByDay' THEN 'up_sys_data_sum_bi_bonus'
		WHEN sub_module = 'StakeFeatureByDay' THEN 'up_sys_data_sum_bi_bonus'
		WHEN sub_module = 'StakeFeatureGroupByDay' THEN 'up_sys_data_sum_bi_bonus'
		WHEN sub_module = 'StakeGroup' THEN 'up_sys_data_sum_bi_bonus'
		WHEN sub_module = 'StakeGroupByDay' THEN 'up_sys_data_sum_bi_bonus'
		WHEN sub_module = 'StakeMemberDurationByDay' THEN 'up_sys_data_sum_bi_bonus'
		WHEN sub_module = 'StakeMerchantByDay' THEN 'up_sys_data_sum_bi_bonus'
		WHEN sub_module = 'StakeMerchantTopMemberByDay' THEN 'up_sys_data_sum_bi_bonus'
		WHEN sub_module = 'StakeMerchantTopMemberByPast' THEN 'up_sys_data_sum_bi_bonus'
		WHEN sub_module = 'StakeTopMemberByDay' THEN 'up_sys_data_sum_bi_bonus'
		WHEN sub_module = 'StakeTopMemberByPast' THEN 'up_sys_data_sum_bi_bonus'
		WHEN sub_module = 'StakeTransactionOfTimeByDay' THEN 'up_sys_data_sum_bi_bonus'
		WHEN sub_module = 'StakeMerchantTopMemberByWeek' THEN 'up_sys_data_sum_bi_bonus'
		WHEN sub_module = 'StakeTopMemberByWeek' THEN 'up_sys_data_sum_bi_bonus'
		WHEN sub_module = 'StakeMerchantTopMemberByMonth' THEN 'up_sys_data_sum_bi_bonus'
		WHEN sub_module = 'StakeTopMemberByMonth' THEN 'up_sys_data_sum_bi_bonus'
	END AS ProcedureName
FROM CTE
ORDER BY split_time DESC, sub_module;







































































