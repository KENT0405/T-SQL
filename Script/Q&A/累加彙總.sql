--方法一(SUM函數)--------------------------------------------------------------------------------------------
SELECT *,
	SUM(bet_amt) OVER(PARTITION BY acct_id ORDER BY sum_date,bet_amt ASC) AS TOTAL
FROM acct_sum
ORDER BY acct_id,sum_date

--方法二(self join)--------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #T

SELECT *,
	ROW_NUMBER() OVER(PARTITION BY acct_id ORDER BY sum_date ASC) AS ID
INTO #T
FROM acct_sum
ORDER BY acct_id,sum_date

SELECT
	A.ID,
	A.acct_id,
	A.sum_date,
	A.bet_amt,
	SUM(B.bet_amt) AS SUM
FROM #T AS A 
JOIN #T AS B
ON A.ID >= B.ID 
AND A.acct_id = B.acct_id 
GROUP BY 	
	A.ID,
	A.acct_id,
	A.sum_date,
	A.bet_amt
ORDER BY acct_id,sum_date

--方法三(left join)--------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #tb

CREATE TABLE #tb
(
ID INT,
acct_id VARCHAR(20),
sum_date DATETIME,
bet_amt decimal(18,2)
)

INSERT INTO #tb
SELECT 
	ROW_NUMBER() OVER (PARTITION BY acct_id ORDER BY sum_date),
	*
FROM acct_sum

SELECT 
	a.acct_id,
	a.sum_date,
	a.bet_amt,
	CASE WHEN a.ID = 1 THEN a.bet_amt ELSE SUM(b.bet_amt)+ a.bet_amt END AS bet_amt_daily_sum
FROM #tb a
LEFT JOIN #tb b
ON a.ID >= b.ID + 1
AND a.acct_id = b.acct_id
GROUP BY a.ID, a.acct_id, a.sum_date, a.bet_amt
ORDER BY a.acct_id

--方法四(雙槽式迴圈)--------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #T;
DROP TABLE IF EXISTS #Ta;
DROP TABLE IF EXISTS #Tb;

CREATE TABLE #T
(
	ID INT IDENTITY(1,1),
	Total DECIMAL(10,2)
)
GO

SELECT
	ROW_NUMBER() OVER(ORDER BY acct_id) AS ID,
	A.acct_id
INTO #Ta
FROM( SELECT DISTINCT acct_id FROM acct_sum ) AS A

SELECT 
	ROW_NUMBER() OVER(ORDER BY acct_id) AS ID,
	*
INTO #Tb
FROM acct_sum

DECLARE 
	@acct_id VARCHAR(10),
	@sum DECIMAL(10,2),
	@i INT = 1,
	@j INT = 1

WHILE(1 = 1)
BEGIN
	SELECT @acct_id = acct_id
	FROM #Ta
	WHERE ID = @i

	IF @@ROWCOUNT = 0
		BREAK;
	
	SET @sum = 0

	WHILE(1 = 1)
	BEGIN
		SELECT @sum += bet_amt
		FROM #Tb
		WHERE acct_id = @acct_id 
		AND ID = @j
		
		IF @@ROWCOUNT = 0
			BREAK;

		INSERT INTO #T(Total)
		SELECT @sum

		SET @j += 1
	END

	SET @i += 1
END

SELECT 
	A.acct_id,
	A.sum_date,
	A.bet_amt,
	B.Total 
FROM #Tb AS A 
JOIN #T AS B 
ON A.ID = B.ID

--方法四(單槽式迴圈)--------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS #sum;
DROP TABLE IF EXISTS #T;

CREATE TABLE #sum
(
	ID INT IDENTITY(1,1),
	Total DECIMAL(10,2)
)
GO

DECLARE 
	@sum DECIMAL(10,2) = 0,
	@before_acctid VARCHAR(10) = '',
	@after_acctid VARCHAR(10) = '',
	@i INT = 1

SELECT 
	ROW_NUMBER() OVER(ORDER BY acct_id, sum_date) AS ID,
	*
INTO #T
FROM acct_sum


WHILE(1 = 1)
BEGIN
	SELECT 
		@sum += bet_amt,
		@after_acctid = acct_id
	FROM #T
	WHERE ID = @i

	IF @@ROWCOUNT = 0
		BREAK;

	SELECT @before_acctid = acct_id
	FROM #T
	WHERE ID = @i-1

	IF(@after_acctid <> @before_acctid)
	BEGIN
		SELECT @sum = bet_amt
		FROM #T
		WHERE ID = @i
	END

	INSERT INTO #sum(Total)
	SELECT @sum

	SET @i += 1
END

SELECT A.*,B.Total
FROM #T AS A 
JOIN #sum AS B
ON A.ID = B.ID



-----------------------------------------------DATA------------------------------------------------
/****** Object:  Table [dbo].[acct_sum]    Script Date: 2023/2/4 下午 05:42:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[acct_sum](
	[acct_id] [varchar](30) NOT NULL,
	[sum_date] [date] NOT NULL,
	[bet_amt] [decimal](18, 2) NULL
) ON [PRIMARY]
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113154', CAST(N'2022-09-01' AS Date), CAST(23.15 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113154', CAST(N'2022-09-01' AS Date), CAST(437.43 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113154', CAST(N'2022-09-02' AS Date), CAST(47.37 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113154', CAST(N'2022-09-02' AS Date), CAST(28.60 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113154', CAST(N'2022-09-03' AS Date), CAST(22.95 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113154', CAST(N'2022-09-04' AS Date), CAST(45.55 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113154', CAST(N'2022-09-05' AS Date), CAST(41.15 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113154', CAST(N'2022-09-05' AS Date), CAST(31.70 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113154', CAST(N'2022-09-06' AS Date), CAST(51.15 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113154', CAST(N'2022-09-07' AS Date), CAST(36.44 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113154', CAST(N'2022-09-07' AS Date), CAST(32.40 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113154', CAST(N'2022-09-08' AS Date), CAST(17.50 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113154', CAST(N'2022-09-09' AS Date), CAST(41.21 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113154', CAST(N'2022-09-09' AS Date), CAST(27.80 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113154', CAST(N'2022-09-10' AS Date), CAST(25.93 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113154', CAST(N'2022-09-11' AS Date), CAST(29.75 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113154', CAST(N'2022-09-12' AS Date), CAST(39.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113154', CAST(N'2022-09-12' AS Date), CAST(17.70 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113154', CAST(N'2022-09-13' AS Date), CAST(43.89 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113154', CAST(N'2022-09-14' AS Date), CAST(22.10 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113154', CAST(N'2022-09-14' AS Date), CAST(14.80 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113154', CAST(N'2022-09-15' AS Date), CAST(49.50 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113856', CAST(N'2022-09-01' AS Date), CAST(589.35 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113856', CAST(N'2022-09-02' AS Date), CAST(43.60 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113856', CAST(N'2022-09-05' AS Date), CAST(48.22 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113856', CAST(N'2022-09-07' AS Date), CAST(4.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113856', CAST(N'2022-09-07' AS Date), CAST(24.50 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113856', CAST(N'2022-09-14' AS Date), CAST(10.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113882', CAST(N'2022-09-01' AS Date), CAST(22.60 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113882', CAST(N'2022-09-03' AS Date), CAST(20.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113882', CAST(N'2022-09-04' AS Date), CAST(21.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113882', CAST(N'2022-09-05' AS Date), CAST(26.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113882', CAST(N'2022-09-07' AS Date), CAST(28.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113882', CAST(N'2022-09-08' AS Date), CAST(10.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113882', CAST(N'2022-09-09' AS Date), CAST(4.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113882', CAST(N'2022-09-10' AS Date), CAST(20.60 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113882', CAST(N'2022-09-11' AS Date), CAST(29.60 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113882', CAST(N'2022-09-12' AS Date), CAST(40.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113882', CAST(N'2022-09-14' AS Date), CAST(33.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113892', CAST(N'2022-09-01' AS Date), CAST(328.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113892', CAST(N'2022-09-02' AS Date), CAST(47.10 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113892', CAST(N'2022-09-05' AS Date), CAST(16.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113892', CAST(N'2022-09-07' AS Date), CAST(149.10 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113892', CAST(N'2022-09-09' AS Date), CAST(97.69 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113892', CAST(N'2022-09-12' AS Date), CAST(128.40 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'N1113892', CAST(N'2022-09-14' AS Date), CAST(105.30 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NA124A18', CAST(N'2022-09-01' AS Date), CAST(14.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NA124A18', CAST(N'2022-09-01' AS Date), CAST(27.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NA124A18', CAST(N'2022-09-02' AS Date), CAST(4.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NA124A18', CAST(N'2022-09-03' AS Date), CAST(6.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NA124A18', CAST(N'2022-09-04' AS Date), CAST(4.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NA124A18', CAST(N'2022-09-07' AS Date), CAST(2.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NA127011', CAST(N'2022-09-01' AS Date), CAST(18.40 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NA127011', CAST(N'2022-09-03' AS Date), CAST(16.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NA127011', CAST(N'2022-09-04' AS Date), CAST(22.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NA127011', CAST(N'2022-09-05' AS Date), CAST(14.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NA127011', CAST(N'2022-09-05' AS Date), CAST(8.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NA127011', CAST(N'2022-09-06' AS Date), CAST(19.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NA127011', CAST(N'2022-09-07' AS Date), CAST(20.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NA127011', CAST(N'2022-09-07' AS Date), CAST(6.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NA127011', CAST(N'2022-09-08' AS Date), CAST(22.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NA127011', CAST(N'2022-09-09' AS Date), CAST(12.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NA127011', CAST(N'2022-09-09' AS Date), CAST(6.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NA127011', CAST(N'2022-09-10' AS Date), CAST(17.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NA127011', CAST(N'2022-09-11' AS Date), CAST(14.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NA127011', CAST(N'2022-09-12' AS Date), CAST(8.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NA127011', CAST(N'2022-09-13' AS Date), CAST(21.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NA127011', CAST(N'2022-09-14' AS Date), CAST(12.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NA127011', CAST(N'2022-09-14' AS Date), CAST(6.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NA127011', CAST(N'2022-09-15' AS Date), CAST(25.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NE201003', CAST(N'2022-09-01' AS Date), CAST(1353.28 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NE201003', CAST(N'2022-09-02' AS Date), CAST(70.50 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NE201003', CAST(N'2022-09-07' AS Date), CAST(48.50 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NE201003', CAST(N'2022-09-09' AS Date), CAST(80.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NE201003', CAST(N'2022-09-12' AS Date), CAST(54.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NE201003', CAST(N'2022-09-14' AS Date), CAST(55.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NH322322', CAST(N'2022-09-01' AS Date), CAST(12.20 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NH322322', CAST(N'2022-09-01' AS Date), CAST(2034.47 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NH322322', CAST(N'2022-09-02' AS Date), CAST(10.80 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NH322322', CAST(N'2022-09-02' AS Date), CAST(17.60 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NH322322', CAST(N'2022-09-05' AS Date), CAST(32.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NH322322', CAST(N'2022-09-05' AS Date), CAST(18.20 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NH322322', CAST(N'2022-09-07' AS Date), CAST(12.90 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NH322322', CAST(N'2022-09-08' AS Date), CAST(46.40 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NH322322', CAST(N'2022-09-09' AS Date), CAST(26.90 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NH322322', CAST(N'2022-09-09' AS Date), CAST(9.60 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NH322322', CAST(N'2022-09-11' AS Date), CAST(43.10 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NH322322', CAST(N'2022-09-13' AS Date), CAST(43.20 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NH322322', CAST(N'2022-09-14' AS Date), CAST(26.60 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NH322322', CAST(N'2022-09-15' AS Date), CAST(23.90 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602000', CAST(N'2022-09-01' AS Date), CAST(83.60 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602000', CAST(N'2022-09-02' AS Date), CAST(4.60 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602000', CAST(N'2022-09-05' AS Date), CAST(4.30 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602000', CAST(N'2022-09-07' AS Date), CAST(6.30 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602000', CAST(N'2022-09-09' AS Date), CAST(4.35 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602000', CAST(N'2022-09-12' AS Date), CAST(6.50 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602000', CAST(N'2022-09-14' AS Date), CAST(3.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602002', CAST(N'2022-09-01' AS Date), CAST(706.50 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602002', CAST(N'2022-09-02' AS Date), CAST(10.80 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602002', CAST(N'2022-09-05' AS Date), CAST(11.40 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602002', CAST(N'2022-09-06' AS Date), CAST(6.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602002', CAST(N'2022-09-07' AS Date), CAST(17.80 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602002', CAST(N'2022-09-09' AS Date), CAST(20.60 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602002', CAST(N'2022-09-12' AS Date), CAST(24.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602002', CAST(N'2022-09-14' AS Date), CAST(9.40 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602009', CAST(N'2022-09-01' AS Date), CAST(305.10 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602009', CAST(N'2022-09-02' AS Date), CAST(1.80 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602009', CAST(N'2022-09-04' AS Date), CAST(0.40 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602009', CAST(N'2022-09-05' AS Date), CAST(4.80 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602009', CAST(N'2022-09-14' AS Date), CAST(3.20 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602012', CAST(N'2022-09-05' AS Date), CAST(10.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602012', CAST(N'2022-09-05' AS Date), CAST(5.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602012', CAST(N'2022-09-07' AS Date), CAST(8.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602012', CAST(N'2022-09-09' AS Date), CAST(3.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602012', CAST(N'2022-09-09' AS Date), CAST(12.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602012', CAST(N'2022-09-10' AS Date), CAST(7.50 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602012', CAST(N'2022-09-11' AS Date), CAST(3.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602012', CAST(N'2022-09-12' AS Date), CAST(1.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602012', CAST(N'2022-09-12' AS Date), CAST(12.40 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602012', CAST(N'2022-09-13' AS Date), CAST(1.50 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602012', CAST(N'2022-09-14' AS Date), CAST(4.50 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602012', CAST(N'2022-09-15' AS Date), CAST(1.50 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602456', CAST(N'2022-09-01' AS Date), CAST(6.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602456', CAST(N'2022-09-01' AS Date), CAST(245.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602456', CAST(N'2022-09-02' AS Date), CAST(2.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602456', CAST(N'2022-09-02' AS Date), CAST(30.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602456', CAST(N'2022-09-03' AS Date), CAST(16.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602456', CAST(N'2022-09-04' AS Date), CAST(16.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602456', CAST(N'2022-09-05' AS Date), CAST(23.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602456', CAST(N'2022-09-05' AS Date), CAST(23.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602456', CAST(N'2022-09-06' AS Date), CAST(44.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602456', CAST(N'2022-09-07' AS Date), CAST(30.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602456', CAST(N'2022-09-07' AS Date), CAST(30.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602456', CAST(N'2022-09-08' AS Date), CAST(56.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602456', CAST(N'2022-09-09' AS Date), CAST(2.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602456', CAST(N'2022-09-10' AS Date), CAST(2.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602456', CAST(N'2022-09-11' AS Date), CAST(37.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602456', CAST(N'2022-09-12' AS Date), CAST(37.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602456', CAST(N'2022-09-12' AS Date), CAST(37.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602456', CAST(N'2022-09-13' AS Date), CAST(54.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602456', CAST(N'2022-09-14' AS Date), CAST(47.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602456', CAST(N'2022-09-14' AS Date), CAST(37.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'NT602456', CAST(N'2022-09-15' AS Date), CAST(24.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'RBZ11TT1', CAST(N'2022-09-01' AS Date), CAST(201.14 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'RBZ11TT1', CAST(N'2022-09-02' AS Date), CAST(10.80 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'RBZ11TT1', CAST(N'2022-09-05' AS Date), CAST(17.50 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'RBZ11TT1', CAST(N'2022-09-07' AS Date), CAST(22.60 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'RBZ11TT1', CAST(N'2022-09-09' AS Date), CAST(28.90 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'RBZ11TT1', CAST(N'2022-09-12' AS Date), CAST(43.80 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'RBZ11TT1', CAST(N'2022-09-14' AS Date), CAST(26.80 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'T8888006', CAST(N'2022-09-01' AS Date), CAST(551.20 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'T8888006', CAST(N'2022-09-02' AS Date), CAST(60.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'T8888006', CAST(N'2022-09-05' AS Date), CAST(41.50 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'T8888006', CAST(N'2022-09-07' AS Date), CAST(40.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'T8888006', CAST(N'2022-09-12' AS Date), CAST(70.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'T8888006', CAST(N'2022-09-14' AS Date), CAST(44.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'TAOTE003', CAST(N'2022-09-01' AS Date), CAST(48.60 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'TAOTE003', CAST(N'2022-09-04' AS Date), CAST(27.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'TAOTE003', CAST(N'2022-09-11' AS Date), CAST(10.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'TAOTE003', CAST(N'2022-09-12' AS Date), CAST(10.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'TAOTE003', CAST(N'2022-09-13' AS Date), CAST(12.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'TAOTE003', CAST(N'2022-09-14' AS Date), CAST(8.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'TAOTE003', CAST(N'2022-09-14' AS Date), CAST(12.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'TAWWW018', CAST(N'2022-09-01' AS Date), CAST(339.40 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'TAWWW018', CAST(N'2022-09-02' AS Date), CAST(47.65 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'TAWWW018', CAST(N'2022-09-05' AS Date), CAST(32.45 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'TAWWW018', CAST(N'2022-09-07' AS Date), CAST(45.35 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'TAWWW018', CAST(N'2022-09-09' AS Date), CAST(44.45 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'TAWWW018', CAST(N'2022-09-12' AS Date), CAST(45.85 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'TAWWW018', CAST(N'2022-09-14' AS Date), CAST(9.65 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'TMC00005', CAST(N'2022-09-01' AS Date), CAST(7.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'TMC00005', CAST(N'2022-09-01' AS Date), CAST(608.74 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'TMC00005', CAST(N'2022-09-05' AS Date), CAST(14.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'TMC00005', CAST(N'2022-09-09' AS Date), CAST(10.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'TMC00005', CAST(N'2022-09-14' AS Date), CAST(14.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'TMCV0001', CAST(N'2022-09-01' AS Date), CAST(369.90 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'TMCV0001', CAST(N'2022-09-06' AS Date), CAST(36.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'TMCV0001', CAST(N'2022-09-07' AS Date), CAST(2.40 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'TMCV0001', CAST(N'2022-09-07' AS Date), CAST(1.35 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'TMCV0001', CAST(N'2022-09-09' AS Date), CAST(15.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'TMCV0001', CAST(N'2022-09-14' AS Date), CAST(1.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'TMN11032', CAST(N'2022-09-01' AS Date), CAST(41.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'TMN11032', CAST(N'2022-09-02' AS Date), CAST(2.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'TMN11032', CAST(N'2022-09-04' AS Date), CAST(4.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'TMN11032', CAST(N'2022-09-05' AS Date), CAST(2.40 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'TMN11032', CAST(N'2022-09-05' AS Date), CAST(3.60 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'TMN11032', CAST(N'2022-09-06' AS Date), CAST(4.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'TMN11032', CAST(N'2022-09-07' AS Date), CAST(6.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'TMN11032', CAST(N'2022-09-08' AS Date), CAST(4.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'TMN11032', CAST(N'2022-09-09' AS Date), CAST(4.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'TMN11032', CAST(N'2022-09-10' AS Date), CAST(5.60 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'TMN11032', CAST(N'2022-09-12' AS Date), CAST(7.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'TMN11032', CAST(N'2022-09-14' AS Date), CAST(2.40 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'TMN11032', CAST(N'2022-09-14' AS Date), CAST(4.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'V1500001', CAST(N'2022-09-01' AS Date), CAST(4131.73 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'V1500001', CAST(N'2022-09-02' AS Date), CAST(94.79 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'V1500001', CAST(N'2022-09-05' AS Date), CAST(109.58 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'V1500001', CAST(N'2022-09-07' AS Date), CAST(48.44 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'V1500001', CAST(N'2022-09-09' AS Date), CAST(70.60 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'V1500001', CAST(N'2022-09-12' AS Date), CAST(98.50 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'V1500001', CAST(N'2022-09-14' AS Date), CAST(52.48 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'V7701002', CAST(N'2022-09-01' AS Date), CAST(318.68 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'V7701002', CAST(N'2022-09-02' AS Date), CAST(63.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'V7701002', CAST(N'2022-09-07' AS Date), CAST(30.30 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'V7701002', CAST(N'2022-09-08' AS Date), CAST(74.30 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'V7701002', CAST(N'2022-09-14' AS Date), CAST(9.50 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'V7701002', CAST(N'2022-09-15' AS Date), CAST(15.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VAM89111', CAST(N'2022-09-02' AS Date), CAST(29.40 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VAM89111', CAST(N'2022-09-05' AS Date), CAST(3.30 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VAM89111', CAST(N'2022-09-07' AS Date), CAST(9.50 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VAM89111', CAST(N'2022-09-09' AS Date), CAST(6.70 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VAM89111', CAST(N'2022-09-14' AS Date), CAST(8.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101001', CAST(N'2022-09-01' AS Date), CAST(6.70 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101001', CAST(N'2022-09-01' AS Date), CAST(172.95 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101001', CAST(N'2022-09-02' AS Date), CAST(10.30 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101001', CAST(N'2022-09-02' AS Date), CAST(23.20 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101001', CAST(N'2022-09-05' AS Date), CAST(10.76 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101001', CAST(N'2022-09-07' AS Date), CAST(1.70 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101001', CAST(N'2022-09-07' AS Date), CAST(14.84 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101001', CAST(N'2022-09-08' AS Date), CAST(6.42 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101001', CAST(N'2022-09-09' AS Date), CAST(7.20 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101001', CAST(N'2022-09-09' AS Date), CAST(17.50 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101001', CAST(N'2022-09-10' AS Date), CAST(2.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101001', CAST(N'2022-09-12' AS Date), CAST(9.68 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101001', CAST(N'2022-09-12' AS Date), CAST(17.20 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101001', CAST(N'2022-09-13' AS Date), CAST(7.96 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101002', CAST(N'2022-09-01' AS Date), CAST(15.75 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101002', CAST(N'2022-09-01' AS Date), CAST(239.18 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101002', CAST(N'2022-09-02' AS Date), CAST(46.82 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101002', CAST(N'2022-09-02' AS Date), CAST(57.92 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101002', CAST(N'2022-09-03' AS Date), CAST(10.90 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101002', CAST(N'2022-09-04' AS Date), CAST(9.06 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101002', CAST(N'2022-09-05' AS Date), CAST(6.06 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101002', CAST(N'2022-09-05' AS Date), CAST(90.96 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101002', CAST(N'2022-09-06' AS Date), CAST(9.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101002', CAST(N'2022-09-07' AS Date), CAST(6.42 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101002', CAST(N'2022-09-07' AS Date), CAST(43.33 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101002', CAST(N'2022-09-08' AS Date), CAST(9.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101002', CAST(N'2022-09-09' AS Date), CAST(4.40 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101002', CAST(N'2022-09-09' AS Date), CAST(58.36 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101002', CAST(N'2022-09-10' AS Date), CAST(10.87 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101002', CAST(N'2022-09-11' AS Date), CAST(29.15 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101002', CAST(N'2022-09-12' AS Date), CAST(12.82 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101002', CAST(N'2022-09-12' AS Date), CAST(99.39 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101002', CAST(N'2022-09-13' AS Date), CAST(9.70 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101002', CAST(N'2022-09-14' AS Date), CAST(17.65 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101002', CAST(N'2022-09-14' AS Date), CAST(101.42 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101002', CAST(N'2022-09-15' AS Date), CAST(11.90 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101003', CAST(N'2022-09-01' AS Date), CAST(15.80 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101003', CAST(N'2022-09-05' AS Date), CAST(23.42 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101003', CAST(N'2022-09-06' AS Date), CAST(8.56 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101003', CAST(N'2022-09-07' AS Date), CAST(10.72 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101003', CAST(N'2022-09-08' AS Date), CAST(1.20 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101003', CAST(N'2022-09-09' AS Date), CAST(0.80 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101003', CAST(N'2022-09-09' AS Date), CAST(8.24 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101003', CAST(N'2022-09-12' AS Date), CAST(0.80 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101003', CAST(N'2022-09-14' AS Date), CAST(4.40 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101004', CAST(N'2022-09-01' AS Date), CAST(28.53 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101004', CAST(N'2022-09-01' AS Date), CAST(78.83 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101004', CAST(N'2022-09-02' AS Date), CAST(46.48 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101004', CAST(N'2022-09-02' AS Date), CAST(66.57 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101004', CAST(N'2022-09-03' AS Date), CAST(32.30 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101004', CAST(N'2022-09-04' AS Date), CAST(80.70 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101004', CAST(N'2022-09-05' AS Date), CAST(15.44 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101004', CAST(N'2022-09-05' AS Date), CAST(65.70 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101004', CAST(N'2022-09-06' AS Date), CAST(36.92 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101004', CAST(N'2022-09-07' AS Date), CAST(51.10 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101004', CAST(N'2022-09-07' AS Date), CAST(78.30 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101004', CAST(N'2022-09-08' AS Date), CAST(57.52 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101004', CAST(N'2022-09-09' AS Date), CAST(36.30 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101004', CAST(N'2022-09-09' AS Date), CAST(60.67 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101004', CAST(N'2022-09-10' AS Date), CAST(29.80 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101004', CAST(N'2022-09-11' AS Date), CAST(76.22 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101004', CAST(N'2022-09-12' AS Date), CAST(49.16 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101004', CAST(N'2022-09-12' AS Date), CAST(66.72 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101004', CAST(N'2022-09-13' AS Date), CAST(52.60 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101004', CAST(N'2022-09-14' AS Date), CAST(64.84 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101004', CAST(N'2022-09-14' AS Date), CAST(69.19 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE101004', CAST(N'2022-09-15' AS Date), CAST(34.80 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE102222', CAST(N'2022-09-01' AS Date), CAST(1230.16 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE102222', CAST(N'2022-09-02' AS Date), CAST(1.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE102222', CAST(N'2022-09-05' AS Date), CAST(5.50 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE102222', CAST(N'2022-09-07' AS Date), CAST(3.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE102222', CAST(N'2022-09-09' AS Date), CAST(1.60 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE102222', CAST(N'2022-09-12' AS Date), CAST(4.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE102222', CAST(N'2022-09-14' AS Date), CAST(2.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE819A12', CAST(N'2022-09-01' AS Date), CAST(24.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE819A12', CAST(N'2022-09-01' AS Date), CAST(87.60 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE819A12', CAST(N'2022-09-02' AS Date), CAST(52.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE819A12', CAST(N'2022-09-02' AS Date), CAST(45.30 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE819A12', CAST(N'2022-09-04' AS Date), CAST(108.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE819A12', CAST(N'2022-09-05' AS Date), CAST(22.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE819A12', CAST(N'2022-09-05' AS Date), CAST(33.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE819A12', CAST(N'2022-09-07' AS Date), CAST(8.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE819A12', CAST(N'2022-09-07' AS Date), CAST(36.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE819A12', CAST(N'2022-09-08' AS Date), CAST(8.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE819A12', CAST(N'2022-09-09' AS Date), CAST(12.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE819A12', CAST(N'2022-09-09' AS Date), CAST(112.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE819A12', CAST(N'2022-09-12' AS Date), CAST(46.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE819A12', CAST(N'2022-09-14' AS Date), CAST(8.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VE819A12', CAST(N'2022-09-14' AS Date), CAST(27.20 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VJ916003', CAST(N'2022-09-01' AS Date), CAST(1.50 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VJ916003', CAST(N'2022-09-01' AS Date), CAST(1789.98 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VJ916003', CAST(N'2022-09-02' AS Date), CAST(14.50 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VJ916003', CAST(N'2022-09-05' AS Date), CAST(8.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VJ916003', CAST(N'2022-09-07' AS Date), CAST(31.50 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VJ916003', CAST(N'2022-09-09' AS Date), CAST(16.50 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VJ916003', CAST(N'2022-09-12' AS Date), CAST(34.80 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VJ916003', CAST(N'2022-09-14' AS Date), CAST(19.50 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL888047', CAST(N'2022-09-01' AS Date), CAST(35.50 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL888047', CAST(N'2022-09-01' AS Date), CAST(523.60 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL888047', CAST(N'2022-09-02' AS Date), CAST(48.10 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL888047', CAST(N'2022-09-02' AS Date), CAST(13.50 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL888047', CAST(N'2022-09-03' AS Date), CAST(48.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL888047', CAST(N'2022-09-04' AS Date), CAST(64.30 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL888047', CAST(N'2022-09-05' AS Date), CAST(32.30 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL888047', CAST(N'2022-09-05' AS Date), CAST(35.70 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL888047', CAST(N'2022-09-06' AS Date), CAST(53.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL888047', CAST(N'2022-09-07' AS Date), CAST(42.60 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL888047', CAST(N'2022-09-07' AS Date), CAST(31.20 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL888047', CAST(N'2022-09-08' AS Date), CAST(48.50 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL888047', CAST(N'2022-09-09' AS Date), CAST(35.30 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL888047', CAST(N'2022-09-09' AS Date), CAST(29.10 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL888047', CAST(N'2022-09-10' AS Date), CAST(42.50 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL888047', CAST(N'2022-09-11' AS Date), CAST(51.90 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL888047', CAST(N'2022-09-12' AS Date), CAST(53.90 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL888047', CAST(N'2022-09-12' AS Date), CAST(23.50 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL888047', CAST(N'2022-09-13' AS Date), CAST(56.20 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL888047', CAST(N'2022-09-14' AS Date), CAST(57.70 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL888047', CAST(N'2022-09-14' AS Date), CAST(20.70 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL888047', CAST(N'2022-09-15' AS Date), CAST(46.40 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8FF777', CAST(N'2022-09-01' AS Date), CAST(242.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8FF777', CAST(N'2022-09-01' AS Date), CAST(90.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8FF777', CAST(N'2022-09-02' AS Date), CAST(238.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8FF777', CAST(N'2022-09-02' AS Date), CAST(223.92 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8FF777', CAST(N'2022-09-03' AS Date), CAST(216.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8FF777', CAST(N'2022-09-05' AS Date), CAST(36.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8FF777', CAST(N'2022-09-05' AS Date), CAST(185.35 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8FF777', CAST(N'2022-09-07' AS Date), CAST(177.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8FF777', CAST(N'2022-09-09' AS Date), CAST(363.50 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8FF777', CAST(N'2022-09-10' AS Date), CAST(12.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8FF777', CAST(N'2022-09-11' AS Date), CAST(15.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8FF777', CAST(N'2022-09-12' AS Date), CAST(437.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8FF777', CAST(N'2022-09-13' AS Date), CAST(309.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8FF777', CAST(N'2022-09-14' AS Date), CAST(248.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8FF928', CAST(N'2022-09-01' AS Date), CAST(7.84 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8FF928', CAST(N'2022-09-01' AS Date), CAST(605.77 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8FF928', CAST(N'2022-09-02' AS Date), CAST(4.66 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8FF928', CAST(N'2022-09-02' AS Date), CAST(12.88 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8FF928', CAST(N'2022-09-03' AS Date), CAST(8.35 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8FF928', CAST(N'2022-09-04' AS Date), CAST(5.25 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8FF928', CAST(N'2022-09-05' AS Date), CAST(0.40 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8FF928', CAST(N'2022-09-05' AS Date), CAST(38.85 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8FF928', CAST(N'2022-09-06' AS Date), CAST(0.40 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8FF928', CAST(N'2022-09-07' AS Date), CAST(6.04 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8FF928', CAST(N'2022-09-07' AS Date), CAST(8.36 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8FF928', CAST(N'2022-09-08' AS Date), CAST(3.46 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8FF928', CAST(N'2022-09-09' AS Date), CAST(12.54 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8FF928', CAST(N'2022-09-09' AS Date), CAST(30.59 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8FF928', CAST(N'2022-09-10' AS Date), CAST(5.75 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8FF928', CAST(N'2022-09-11' AS Date), CAST(13.56 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8FF928', CAST(N'2022-09-12' AS Date), CAST(0.40 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8FF928', CAST(N'2022-09-12' AS Date), CAST(19.20 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8FF928', CAST(N'2022-09-13' AS Date), CAST(8.30 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8FF928', CAST(N'2022-09-14' AS Date), CAST(0.80 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8FF928', CAST(N'2022-09-14' AS Date), CAST(19.74 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8FF928', CAST(N'2022-09-15' AS Date), CAST(3.02 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8ZE012', CAST(N'2022-09-01' AS Date), CAST(5224.03 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8ZE012', CAST(N'2022-09-05' AS Date), CAST(91.90 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8ZE012', CAST(N'2022-09-09' AS Date), CAST(62.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8ZE012', CAST(N'2022-09-12' AS Date), CAST(88.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VL8ZE012', CAST(N'2022-09-14' AS Date), CAST(58.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VLF77004', CAST(N'2022-09-01' AS Date), CAST(4.47 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VLF77004', CAST(N'2022-09-02' AS Date), CAST(5.47 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VLF77004', CAST(N'2022-09-03' AS Date), CAST(4.47 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VLF77004', CAST(N'2022-09-04' AS Date), CAST(5.47 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VLF77004', CAST(N'2022-09-05' AS Date), CAST(5.47 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VLF77004', CAST(N'2022-09-06' AS Date), CAST(10.91 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VLF77004', CAST(N'2022-09-07' AS Date), CAST(3.94 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VLF77004', CAST(N'2022-09-08' AS Date), CAST(4.47 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VLF77004', CAST(N'2022-09-09' AS Date), CAST(6.47 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VLF77004', CAST(N'2022-09-10' AS Date), CAST(6.47 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VLF77004', CAST(N'2022-09-11' AS Date), CAST(6.47 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VLF77004', CAST(N'2022-09-12' AS Date), CAST(6.97 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VLF77004', CAST(N'2022-09-13' AS Date), CAST(5.47 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VLF77004', CAST(N'2022-09-14' AS Date), CAST(5.47 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VLF77004', CAST(N'2022-09-15' AS Date), CAST(5.47 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VLP05001', CAST(N'2022-09-01' AS Date), CAST(64.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VLP05001', CAST(N'2022-09-02' AS Date), CAST(60.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VLP05001', CAST(N'2022-09-02' AS Date), CAST(40.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VLP05001', CAST(N'2022-09-03' AS Date), CAST(52.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VLP05001', CAST(N'2022-09-05' AS Date), CAST(44.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VLP05001', CAST(N'2022-09-05' AS Date), CAST(48.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VLP05001', CAST(N'2022-09-06' AS Date), CAST(58.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VLP05001', CAST(N'2022-09-07' AS Date), CAST(38.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VLP05001', CAST(N'2022-09-07' AS Date), CAST(72.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VLP05001', CAST(N'2022-09-08' AS Date), CAST(68.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VLP05001', CAST(N'2022-09-09' AS Date), CAST(32.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VLP05001', CAST(N'2022-09-09' AS Date), CAST(56.00 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VLZ88123', CAST(N'2022-09-01' AS Date), CAST(153.80 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VLZ88123', CAST(N'2022-09-02' AS Date), CAST(11.50 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VLZ88123', CAST(N'2022-09-05' AS Date), CAST(17.50 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VLZ88123', CAST(N'2022-09-07' AS Date), CAST(21.75 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VLZ88123', CAST(N'2022-09-09' AS Date), CAST(28.70 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VLZ88123', CAST(N'2022-09-12' AS Date), CAST(41.70 AS Decimal(18, 2)))
GO
INSERT [dbo].[acct_sum] ([acct_id], [sum_date], [bet_amt]) VALUES (N'VLZ88123', CAST(N'2022-09-14' AS Date), CAST(32.05 AS Decimal(18, 2)))
GO
