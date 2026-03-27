DROP TABLE Del_test
GO

CREATE TABLE Del_test
(
	id int , num int , name VARCHAR(10)
)
GO


INSERT INTO Del_test VALUES(4,1020,'xxx')
INSERT INTO Del_test VALUES(4,1020,'xxx')
INSERT INTO Del_test VALUES(1,10,'www')
INSERT INTO Del_test VALUES(1,10,'www')
INSERT INTO Del_test VALUES(5,543,'qqq')


--SELECT * FROM Del_test

;WITH A
AS
(
	SELECT ROW_NUMBER() OVER (PARTITION BY id,num,name ORDER BY name DESC ) AS R,*
	FROM Del_test
)
SELECT * FROM A
WHERE R =2
