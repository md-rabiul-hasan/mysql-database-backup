@echo off

 set dbUser=root
 set dbPassword=
 set databaseName=sbac_remittance
 set backupDir="E:\XAMPP_5.6\htdocs\db-backup"
 set mysqldump="E:\XAMPP_5.6\mysql\bin\mysqldump.exe"
 set mysqlDataDir="E:\XAMPP_5.6\mysql\data"
 set zip="C:\Program Files\7-Zip\7z.exe"


FOR /F "skip=1" %%A IN ('WMIC OS GET LOCALDATETIME') DO (SET "t=%%A" & GOTO break_1)
:break_1

SET "m=%t:~10,2%" & SET "h=%t:~8,2%" & SET "dd=%t:~6,2%" & SET "mm=%t:~4,2%" & SET "yy=%t:~0,4%"



 :: get time
 for /F "tokens=5-8 delims=:. " %%i in ('echo.^| time ^| find "current" ') do (
      set hh=%%i
      set min=%%j
 )

 set dirName=%yy%%mon%%dd%_%hh%%min%
 
 :: switch to the "data" folder
 pushd %mysqlDataDir%

 :: iterate over the folder structure in the "data" folder to get the databases
 :: for /d %%f in (*) do (

 if not exist %backupDir%\%dirName%\ (
      mkdir %backupDir%\%dirName%
 )

 %mysqldump% --host="localhost" --user=%dbUser% --password=%dbPassword% --single-transaction --add-drop-table --databases %databaseName% > %backupDir%\%dirName%\%databaseName%.sql

 %zip% a -tgzip %backupDir%\%dirName%\%databaseName%.sql.gz %backupDir%\%dirName%\%databaseName%.sql
 del %backupDir%\%dirName%\%databaseName%.sql
 :: )
 popd