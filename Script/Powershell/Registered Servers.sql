SET NOCOUNT ON;

DROP TABLE IF EXISTS #connections;

CREATE TABLE #connections
(
    CustomerName	 VARCHAR(100),
    Environment		 VARCHAR(20),
    InstanceName	 VARCHAR(100),
    ConnectionString VARCHAR(255)  -- See demo code for examples
)

-- INSERT DEMO CODE -----------------------------------------------------------------------------------------
-- This inserts some demo data in de #connections table.
-- An option would be to insert data based an a CMDB or some instance registration (spreadsheet, DB)
INSERT INTO #connections
VALUES
('Customer01', 'Production',    'MSSQLP01',     '"Server=MSSQLP01; User Id=RRunner01; Password=MeepMeep"'),
('Customer01', 'Production',    'MSSQLP02',     '"Server=MSSQLP02; User Id=RRunner01; Password=MeepMeep"'),
('Customer01', 'Test',          'MSSQLT01',     '"Server=MSSQLT01; User Id=RRunner01; Password=MeepMeep"'),
('Customer01', 'Test',          'MSSQLT02',     '"Server=MSSQLT02; User Id=RRunner01; Password=MeepMeep"'),
('Customer01', 'Development',   'MSSQLD01',     '"Server=MSSQLD01; Integrated security=true"'),
('Customer01', 'Development',   'MSSQLD02',     '"Server=MSSQLD01; Integrated security=true"'),
('Customer02', 'Production',    'CUS02SQLP01',  '"Server=CUS02SQLP01; User Id=RRunner01; Password=MeepMeep"'),
('Customer02', 'Production',    'CUS02SQLO02',  '"Server=CUS02SQLP02; User Id=RRunner01; Password=MeepMeep"'),
('Customer02', 'Test',          'CUS02SQLT01',  '"Server=CUS02SQLT01; User Id=RRunner01; Password=MeepMeep"'),
('Customer02', 'Test',          'CUS02SQLT02',  '"Server=CUS02SQLT02; User Id=RRunner01; Password=MeepMeep"');
-- END DEMO CODE --------------------------------------------------------------------------------------------

WITH PS_Tree AS
(
    SELECT DISTINCT
		1				AS SortOrder,
		CustomerName	AS Customer,
		''				AS Environment,
		''				AS RegServer,
		''				AS ConnectionString
    FROM #connections
    UNION ALL
    SELECT DISTINCT
		2,
		CustomerName,
		Environment,
		'',
		''
    FROM #connections
    UNION ALL
    SELECT
		3,
		CustomerName,
		Environment,
		InstanceName,
		ConnectionString
    FROM #connections
)
SELECT
	CASE SortOrder
    WHEN 1 THEN
		   CASE WHEN ROW_NUMBER() OVER (ORDER BY Customer, Environment, SortOrder, RegServer) = 1
		   THEN 'Set-Location "SQLServer:\SqlRegistration\Database Engine Server Group"' + CHAR(13) + CHAR(10) +
		        'dir -Recurse | Remove-Item -force; #clean up everything' + CHAR(13) + CHAR(10)
		   ELSE '' END +
                'Set-Location "SQLServer:\SqlRegistration\Database Engine Server Group"' + CHAR(13) + CHAR(10) +
                'new-item "' + Customer + '"' + CHAR(13) + CHAR(10)
    WHEN 2 THEN
           'CD "SQLSERVER:\sqlregistration\Database Engine Server Group\' + Customer + '\"' + CHAR(13) + CHAR(10) +
           'new-item "' + Environment + '"' + CHAR(13) + CHAR(10) +
           'CD "SQLSERVER:\sqlregistration\Database Engine Server Group\' + Customer + '\' + Environment + '\"'
    WHEN 3 THEN
           'New-Item $(Encode-Sqlname "'+ RegServer + '") -itemtype registration -Value ' + ConnectionString
    END
FROM PS_Tree
ORDER BY
	Customer,
	Environment,
	SortOrder,
	RegServer

SET NOCOUNT OFF;