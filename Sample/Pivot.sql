DROP TABLE IF EXISTS tb_daily_tran
GO

CREATE TABLE tb_daily_tran
(
	tran_date DATE,
	server_code VARCHAR(10),
	amt DECIMAL(18,6)
)
GO

INSERT INTO tb_daily_tran VALUES ('2022-11-01','SG',2)
INSERT INTO tb_daily_tran VALUES ('2022-11-01','IM',2)
INSERT INTO tb_daily_tran VALUES ('2022-11-01','SGPRO',2)
INSERT INTO tb_daily_tran VALUES ('2022-11-01','IM',2)
INSERT INTO tb_daily_tran VALUES ('2022-11-01','IC',2)
INSERT INTO tb_daily_tran VALUES ('2022-11-01','PGR',2)

INSERT INTO tb_daily_tran
SELECT '2022-11-02',server_code,3
FROM tb_daily_tran
WHERE tran_date = '2022-11-01'

INSERT INTO tb_daily_tran
SELECT '2022-11-03',server_code,4
FROM tb_daily_tran
WHERE tran_date = '2022-11-01'

INSERT INTO tb_daily_tran
SELECT '2022-11-04',server_code,5
FROM tb_daily_tran
WHERE tran_date = '2022-11-01'

INSERT INTO tb_daily_tran
SELECT '2022-11-05',server_code,6
FROM tb_daily_tran
WHERE tran_date = '2022-11-01'
GO

SELECT * 
FROM [tb_daily_tran] AS t
PIVOT
(
	SUM(amt)
	FOR server_code IN ([SG],[IM],[SGPRO],[IC],[PGR])
) AS pvt


SELECT *
FROM [tb_daily_tran] AS t
PIVOT
(
	SUM(amt)
	FOR tran_date IN ([2022-11-01],[2022-11-02],[2022-11-03],[2022-11-04],[2022-11-05])
) AS pvt

