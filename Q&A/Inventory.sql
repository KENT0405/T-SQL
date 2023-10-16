DROP TABLE IF EXISTS product_view;
CREATE TABLE product_view
(
	product VARCHAR(3),
	price INT,
	cnt INT
)

INSERT INTO product_view VALUES('P01',40,5)
INSERT INTO product_view VALUES('P02',43,4)
INSERT INTO product_view VALUES('P03',48,2)
INSERT INTO product_view VALUES('P04',37,3)

------------------------------------------------------------------------------
------------------------------------------------------------------------------

DECLARE @cnt INT = 6

DROP TABLE IF EXISTS #temp;

;WITH CTE
AS
(
	SELECT
		*,
		@cnt - SUM(cnt) OVER(ORDER BY price) cntt
	FROM product_view
)
SELECT
	product,
	price,
	cnt AS pre_inventory,
	CASE
		WHEN cntt > 0 THEN 0
		ELSE
			CASE
				WHEN cntt < 0 AND cnt > ABS(cntt) THEN ABS(cntt-@cnt) - @cnt
				WHEN cntt = 0 THEN 0
				ELSE cnt
			END
	END AS inventory
INTO #temp
FROM CTE

--all
SELECT *
FROM #temp

--total / average
SELECT
	SUM(
	CASE
		WHEN pre_inventory <> inventory	AND inventory = 0 THEN price * pre_inventory
		WHEN pre_inventory = inventory THEN 0
		ELSE price * (pre_inventory - inventory)
	END) total,
	SUM(
	CASE
		WHEN pre_inventory <> inventory	AND inventory = 0 THEN price * pre_inventory
		WHEN pre_inventory = inventory THEN 0
		ELSE price * (pre_inventory - inventory)
	END) / CAST(@cnt AS DECIMAL(10,4)) avg
FROM #temp
