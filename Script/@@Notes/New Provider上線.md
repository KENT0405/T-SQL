<table><td bgcolor=#008080><font size=6 color=#ffffff>New Provider上線</font></td></table>

[TOC]
- - -
### <font color=#FF95CA>一、DEV上線</font>
#### <font color=#afeeee>(一)、建立 ticket db 需求</font>
```
1. CREATE new_provider folder
2. CREATE DATABASE script --產出模板腳本    --agc、bgs、btl
3. 腳本更改成new_provider名字(注意大小寫)後建立
4. DB owner改成db_user
5. GRANT USER(rd_user=4, IC_QA=1, qa_user=1, qard_user=2, read_ac=1)
6. 建立MT_JOB在使用的PROCEDURE
7. 建立TABLE : sys_job_errormessage
```

#### <font color=#afeeee>(二)、設定 source db partition table及大小表同步作業</font>
```
※需求訊息:
    小表Database：source_data_casino
    大表Database：source_data_casino_all
    1. 小表為: TB_SourceDataYBC_Main
    2. 小表資料每小時做切割
    3. 大表資料以 1 個月做切割
    4. 小表資料定時 insert 至大表中

※作業步驟:
    1. 檢查小db中是否有該table >> 有少回報給RD
    2. 檢查大db中是否有該table >> 有少就手動建立
    3. 檢查table是否都有切partition(小db按分鐘切，大db按月切) >> 沒切就手動切
    4. 檢查source_job中設定表是否已加入該張table的大小表移除設定 >> 沒有就手動加上
    5. 設定複寫
        -加入對應發行集 (目前都是放到 slot、casino、other 三大分類中)
        -若有新增新的發行集，需開啟allow_partition_switch
```

#### <font color=#afeeee>(三)、設定 ticket db 的 partition view</font>
```
※需求訊息:
    設定 TicketDB 的 Partition View
    1. Table 為 TB_ProviderTicketYBC_Main
    2. View 請命名為 TB_ProviderTicketYBC，Partition View 以【月】為切割單位，存放時間為三個月

※作業步驟:
    1. 手動建立含四個月資料的TABLE (2個舊月份 + 當月 + 下個月)
        -by day : 每天一張table
        -by month : 每月一張table
        -by none : partition table
    2. 檢查是否有子表 (有子表要切 partition)
    3. 建立 view，並確認schema是否正確
```

- - -
### <font color=#FF95CA>二、Staging上線 (DB單)</font>
#### <font color=#afeeee>(一)、ticket db 前置作業</font>
```
1. DEV backup後，直接複製到本機並上傳owncloud
2. 從staging的GATE機下載下來後複製到staging OS環境
3. 建立db資料夾後 RESTORE DATABASE
4. DB owner改成db_user
5. 刪除原本dev在使用的所有user(rd_user、IC_QA、qa_user、qard_user、read_ac)
6. GRANT USER(tkt_ac=2, rd_user=1)
7. 確認partition view時間區間正確
```

#### <font color=#afeeee>(二)、source db 前置作業</font>
```
1. 產出DEV環境中該provider所有table的完整語法(包含compression參數及partition參數)
2. 在staging環境執行前述語法
```

#### <font color=#afeeee>(三)、執行DB單</font>
```
DB單中會包含四組REPLICATION的抄寫
    -bo >>> tkt/pmt
    -pmt >>> aff (nonrealtime repl : need to create table)
    -src >>> src
```

- - -
### <font color=#FF95CA>三、Prod上線 (DB單)</font>
#### <font color=#afeeee>(一)、ticket db 前置作業</font>
```
1. Staging OS環境 DB backup
2. backup檔丟到 Prod OS
3. 建立db資料夾後 RESTORE DATABASE
4. DB owner改成db_user
5. 刪除原本staging在使用的所有user(tkt_ac、rd_user)
6. GRANT USER(tkt_ac=2, rd_user=1, read_ac=1)
7. 確認partition view時間區間正確
```

#### <font color=#afeeee>(二)、source db 前置作業</font>
```
1. 產出Staging環境中該provider所有table的完整語法(包含compression參數及partition參數)
2. 在prod環境執行前述語法
```

#### <font color=#afeeee>(三)、執行DB單</font>
```
DB單中會包含四組REPLICATION的抄寫
    -bo >>> dis >>> tkt/pmt
    -pmt >>> dis >>> bi
    -pmt >>> aff (nonrealtime repl : need to create table)
    -src >>> src
```
