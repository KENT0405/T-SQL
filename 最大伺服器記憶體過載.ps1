/**最大記憶體改的太小SQLserver開不起來**/

STEP1 : 以管理員執行powershell
[NET START MSSQLSERVER /f /mSQLCMD]

STEP2 : 再以管理員開一個powershell
[sqlcmd -S . -E]
[sp_configure 'max server memory',102400]
[GO]
[RECONFIGURE]
[GO]

STEP3 : 回到STEP1的視窗
[NET STOP MSSQLSERVER]

STEP4 : 重啟SQL server