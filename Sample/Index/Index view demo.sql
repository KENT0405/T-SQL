--�إߴ��ո�Ʈw
DROP DATABASE IF EXISTS RockDB;
CREATE DATABASE ROCKDB
GO

USE ROCKDB
GO

--�إ߸�ƪ�SORE�A�ñNHY HT STUNO���]���O������
DROP TABLE IF EXISTS SCORE;
CREATE TABLE SCORE
(
	HY CHAR(3),
	HT CHAR(1),
	STUNO VARCHAR(9),
	SCRO TINYINT
);
GO
CREATE CLUSTERED INDEX CIX_SCORE ON SCORE(HY,HT,STUNO);
GO

--�إ߸�ƪ�STU�A�ñNHY HT STUNO���]���O�����ޡA�`�N:��i��ƪ���HY HT��ƫ��A���P
DROP TABLE IF EXISTS STU;
CREATE TABLE STU
(
	HY TINYINT,
	HT TINYINT,
	STUNO VARCHAR(9),
	NAME VARCHAR(10)
);
GO
CREATE CLUSTERED INDEX CIX_STU ON STU(HY,HT,STUNO);
GO

--STU��ƪ��HNAME���h�إߤ@��INDEX�sIX_NAME
CREATE INDEX IX_NAME ON STU(NAME);
GO

--���ƨ��i��ƪ���
DECLARE @I INT = 1;
WHILE @I<10001
BEGIN
	INSERT INTO SCORE VALUES('104','1',@I,100);
	INSERT INTO STU VALUES(104,1,@I,'ROCK' + CAST(@I AS VARCHAR));
	SET @I += 1;
END
GO

--------------------TEST----------------------

SET STATISTICS IO ON;

SELECT A.* 
FROM SCORE AS A
INNER JOIN STU B 
ON  A.HY = B.HY 
AND A.HT = B.HT 
AND A.STUNO = B.STUNO
WHERE B.NAME = 'ROCK5000';

SET STATISTICS IO OFF;
GO

----------------------------------------------

--�إ�View
CREATE OR ALTER VIEW VWSCORES WITH SCHEMABINDING
AS
SELECT A.[HY]
      ,A.[HT]
      ,A.[STUNO]
      ,A.[SCRO]
	  ,B.[NAME]
FROM DBO.SCORE A
INNER JOIN DBO.STU B ON A.HY=B.HY AND A.HT=B.HT AND A.STUNO=B.STUNO;
GO

--��VIEW�إ߰ߤ@�O������
CREATE UNIQUE CLUSTERED INDEX CIX_VWSCORE ON VWSCORES(HY,HT,STUNO);
GO

--�w��ǥͩm�W�A�ؤ@INDEX IX_STUNAME
CREATE INDEX IX_STUNAME ON VWSCORES(NAME) INCLUDE(HY,HT,STUNO,SCRO);
GO

--------------------TEST---------------------

SET STATISTICS IO ON;

SELECT A.* 
FROM SCORE AS A
INNER JOIN STU B 
ON  A.HY = B.HY 
AND A.HT = B.HT 
AND A.STUNO = B.STUNO
WHERE B.NAME = 'ROCK5000';

SET STATISTICS IO OFF;
GO

----------------------------------------------