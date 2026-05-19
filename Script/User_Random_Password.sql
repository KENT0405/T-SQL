SET NOCOUNT ON;

;WITH sp_a
AS
(
	SELECT x.sp
	FROM 
	(
		VALUES
		('a'),('b'),('c'),('d'),('e'),
		('f'),('g'),('h'),('i'),('j'),
		('k'),('l'),('m'),('n'),('o'),
		('p'),('q'),('r'),('s'),('t'),
		('u'),('v'),('w'),('x'),('y'),('z'),
		('A'),('B'),('C'),('D'),('E'),
		('F'),('G'),('H'),('I'),('J'),
		('K'),('L'),('M'),('N'),('O'),
		('P'),('Q'),('R'),('S'),('T'),
		('U'),('V'),('W'),('X'),('Y'),('Z'),
		('%'),('^'),('*'),('-'),('('),(')'),('+'),('!'),('#'),
		('0'),('1'),('2'),('3'),('4'),('5'),('6'),('7'),('8'),('9')
	) x (sp)
)
SELECT 
(
	  (SELECT TOP 1 sp FROM sp_a ORDER BY NEWID())	--1
	+ (SELECT TOP 1 sp FROM sp_a ORDER BY NEWID())	--2
	+ (SELECT TOP 1 sp FROM sp_a ORDER BY NEWID())	--3
	+ (SELECT TOP 1 sp FROM sp_a ORDER BY NEWID())	--4
	+ (SELECT TOP 1 sp FROM sp_a ORDER BY NEWID())	--5
	+ (SELECT TOP 1 sp FROM sp_a ORDER BY NEWID())	--6
	+ (SELECT TOP 1 sp FROM sp_a ORDER BY NEWID())	--7
	+ (SELECT TOP 1 sp FROM sp_a ORDER BY NEWID())	--8
	+ (SELECT TOP 1 sp FROM sp_a ORDER BY NEWID())	--9
	+ (SELECT TOP 1 sp FROM sp_a ORDER BY NEWID())	--10
	+ (SELECT TOP 1 sp FROM sp_a ORDER BY NEWID())	--11
	+ (SELECT TOP 1 sp FROM sp_a ORDER BY NEWID())	--12
	+ (SELECT TOP 1 sp FROM sp_a ORDER BY NEWID())	--13
	+ (SELECT TOP 1 sp FROM sp_a ORDER BY NEWID())	--14
	+ (SELECT TOP 1 sp FROM sp_a ORDER BY NEWID())	--15
	+ (SELECT TOP 1 sp FROM sp_a ORDER BY NEWID())	--16
	+ (SELECT TOP 1 sp FROM sp_a ORDER BY NEWID())	--17
	+ (SELECT TOP 1 sp FROM sp_a ORDER BY NEWID())	--18
	+ (SELECT TOP 1 sp FROM sp_a ORDER BY NEWID())	--19
	+ (SELECT TOP 1 sp FROM sp_a ORDER BY NEWID())	--20
)
GO 5