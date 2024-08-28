@echo off
setlocal enabledelayedexpansion

title BitcoinZ Full Node : Shell Interface
mode con: cols=100 lines=55

rem
set "BASEDIR=%~dp0"
set "SOURCE_FILES=%BASEDIR%src"
set "BTCZ_ANS_DIR=%BASEDIR%ans"
set "BTCZ_FILES_DIR=%LOCALAPPDATA%\BTCZCommunity\BTCZ-Shell"
set "BTCZ_BLOCKS_DIR=%APPDATA%\BitcoinZ"
set "BTCZ_ZKSNARK_DIR=%APPDATA%\ZcashParams"
set "BTCZ_TOOLS_DIR=%BASEDIR%tools"
set "BTCZ_TEMP_DIR=%TEMP%\BTCZ-Temp"

rem
for %%d in ("%BTCZ_FILES_DIR%" "%BTCZ_BLOCKS_DIR%" "%BTCZ_ZKSNARK_DIR%" "%BTCZ_TEMP_DIR%") do (
    if not exist "%%d" (
        mkdir "%%d"
        if errorlevel 1 (
            echo Failed to create directory %%d
            exit /b 1
        )
    )
)

rem
set "UNZIP_TOOL=%BTCZ_TOOLS_DIR%\7zip.exe"
set "CURL_TOOL=%BTCZ_TOOLS_DIR%\curl.exe"
set "JQ_TOOL=%BTCZ_TOOLS_DIR%\jq.exe"

set "BTCZ_CONFIG_FILE=%BTCZ_BLOCKS_DIR%\bitcoinz.conf"
set "BITCOINZD_FILE=%BTCZ_FILES_DIR%\bitcoinzd.exe"
set "BITCOINZCLI_FILE=%BTCZ_FILES_DIR%\bitcoinz-cli.exe"
set "BITCOINZTX_FILE=%BTCZ_FILES_DIR%\bitcoinz-tx.exe"

set "JSON_DATA_FILE=%BTCZ_TEMP_DIR%\data.json"
set "RESULT_FILE=%BTCZ_TEMP_DIR%\result.json"

set "BTCZ_DOWNLOAD_LINK=https://github.com/btcz/bitcoinz/releases/download/2.0.10/"
set "NODE_FILE_NAME=bitcoinz-2.0.10-win64.zip"

set "ZK_DOWNLOAD_LINK=https://d.btcz.rocks/"

set "BTCZ_STATUS=false"

rem 
set "ESC="
set "BLACK_FG=%ESC%[30m"
set "RED_FG=%ESC%[31m"
set "GREEN_FG=%ESC%[32m"
set "YELLOW_FG=%ESC%[33m"
set "BLUE_FG=%ESC%[34m"
set "MAGENTA_FG=%ESC%[35m"
set "CYAN_FG=%ESC%[36m"
set "WHITE_FG=%ESC%[37m"

set "BLACK_BG=%ESC%[40m"
set "RED_BG=%ESC%[41m"
set "GREEN_BG=%ESC%[42m"
set "YELLOW_BG=%ESC%[43m"
set "BLUE_BG=%ESC%[44m"
set "MAGENTA_BG=%ESC%[45m"
set "CYAN_BG=%ESC%[46m"
set "WHITE_BG=%ESC%[47m"

set "RESET=%ESC%[0m"


:GETNODESTATUS
setlocal enabledelayedexpansion

type %BTCZ_ANS_DIR%\btcz_logo.ans
type %BTCZ_ANS_DIR%\bitcoinz_txt.ans
echo.
echo ================================================================================
echo  ^|%BLACK_FG%%YELLOW_BG% Checking node status... %RESET%

set "files=%BITCOINZD_FILE% %BITCOINZCLI_FILE% %BITCOINZTX_FILE%"
set "missingFiles=false"

rem
for %%F in (%files%) do (
    if not exist %%F (
        echo %%F file is missing.
        set "missingFiles=true"
    )
)
rem
if "%missingFiles%"=="true" (
    goto MAINMENU
)

timeout /t 1 /nobreak >nul
rem
start "" /B "%BITCOINZCLI_FILE%" getinfo > "%JSON_DATA_FILE%"

rem
timeout /t 1 /nobreak >nul
findstr /r /c:"." "%JSON_DATA_FILE%" >nul 2>&1
echo.
if errorlevel 1 (
    echo  ^| Status : %WHITE_FG%%RED_BG% Offline %RESET%
) else (
    set "BTCZ_STATUS=true"
    echo  ^| Status : %WHITE_FG%%GREEN_BG% Online %RESET%
)
echo ================================================================================
timeout /t 2 /nobreak >nul
del %JSON_DATA_FILE%
goto MAINMENU


:MAINMENU
setlocal enabledelayedexpansion
cls
type %BTCZ_ANS_DIR%\btcz_logo.ans
type %BTCZ_ANS_DIR%\bitcoinz_txt.ans
echo.
echo ^| %BLACK_FG%%YELLOW_BG% Main Menu %RESET% ^|
echo.
echo ================================================================================
echo                   %YELLOW_FG%BitcoinZ Full Node : Shell Interface%RESET% %CYAN_BG%%BLACK_FG%v0.2%RESET%
echo ================================================================================
echo.
echo  [%CYAN_FG%1%RESET%] ^| ^Start BitcoinZ
echo  [%CYAN_FG%2%RESET%] ^| Manage Node
echo  [%CYAN_FG%3%RESET%] ^| Join BTCZ Community
echo.
echo  [%RED_FG%0%RESET%] ^| %WHITE_FG%%RED_BG%Stop/Exit%RESET%
echo.
echo ==========================
set /p choice="| %BLACK_FG%%YELLOW_BG% Enter your choice %RESET% : "

set "choice=%choice: =%"

if "%choice%"=="1" (
    if /i "%BTCZ_STATUS%"=="false" (
        goto VERIFYNODE
    ) else (
        echo.
        echo  %BLACK_FG%%GREEN_BG% Node is already running... %RESET%
        timeout /t 2 /nobreak >nul
        goto MAINMENU
    )
) else if "%choice%"=="2" (
    if /i "%BTCZ_STATUS%"=="false" (
        echo.
        echo  %BLACK_FG%%RED_BG% BitcoinZ server is offline... %RESET%
        timeout /t 2 /nobreak >nul
        goto MAINMENU
    ) else (
        goto NODEPANEL
    )
) else if "%choice%"=="3" ( 
    goto SOCIALLINKS
) else if "%choice%"=="0" (
    goto END
) else (
    echo.
    echo Invalid selection. Please enter a valid number.
    timeout /t 2 /nobreak >nul
    goto MAINMENU
)


:VERIFYNODE
setlocal enabledelayedexpansion
cls
type %BTCZ_ANS_DIR%\btcz_logo.ans
type %BTCZ_ANS_DIR%\bitcoinz_txt.ans
echo.
echo ^| %BLACK_FG%%YELLOW_BG% Verify Node Files... %RESET%
echo.

set "NODE_ZIP_FILE=%BTCZ_FILES_DIR%\%NODE_FILE_NAME%"

if exist "%NODE_ZIP_FILE%" (
    echo Extarting file...
    "%UNZIP_TOOL%" x "%BTCZ_FILES_DIR%\%NODE_FILE_NAME%" -o"%BTCZ_FILES_DIR%" -y
    echo Done !
    del "%BTCZ_FILES_DIR%\%NODE_FILE_NAME%"
    timeout /t 2 /nobreak >nul
    goto VERIFYNODE
)

set "files=%BITCOINZD_FILE% %BITCOINZCLI_FILE% %BITCOINZTX_FILE%"

set "missingFiles=false"

rem
for %%F in (%files%) do (
    if not exist %%F (
        echo %%F file is missing.
        set "missingFiles=true"
    )
)

rem
if "%missingFiles%"=="true" (
    timeout /t 1 /nobreak >nul
    echo.
    echo Downloading %GREEN_FG%%NODE_FILE_NAME%%RESET%...
    echo.
    "%CURL_TOOL%" -L -o %BTCZ_FILES_DIR%\%NODE_FILE_NAME% "%BTCZ_DOWNLOAD_LINK%%NODE_FILE_NAME%"
    echo Download completed.
    timeout /t 1 /nobreak >nul
    echo Extarting file...
    echo.
    "%UNZIP_TOOL%" x "%BTCZ_FILES_DIR%\%NODE_FILE_NAME%" -o"%BTCZ_FILES_DIR%" -y
    echo Done !
    del "%BTCZ_FILES_DIR%\%NODE_FILE_NAME%"
    timeout /t 2 /nobreak >nul
    goto VERIFYNODE
)

timeout /t 1 /nobreak >nul
goto VERIFYPARAMS


:VERIFYPARAMS
setlocal enabledelayedexpansion
cls
type %BTCZ_ANS_DIR%\btcz_logo.ans
type %BTCZ_ANS_DIR%\bitcoinz_txt.ans
echo.
echo ^| %BLACK_FG%%YELLOW_BG% Verify Params Files... %RESET%
echo.
set "paramsMissing="
set "files=sapling-output.params sapling-spend.params sprout-groth16.params sprout-proving.key sprout-verifying.key"

if not exist "%BTCZ_ZKSNARK_DIR%" mkdir "%BTCZ_ZKSNARK_DIR%"

rem
for %%f in (%files%) do (
    set "paramsFile=%BTCZ_ZKSNARK_DIR%\%%f"
    if not exist "!paramsFile!" (
        echo Error: %%f file is missing.
        set "paramsMissing=true"
    )
)

rem
if "%paramsMissing%"=="true" (
    echo.
    for %%f in (%files%) do (
        set "paramsFile=%BTCZ_ZKSNARK_DIR%\%%f"
        if not exist "!paramsFile!" (
            echo Downloading %CYAN_FG%%%f%RESET%...
            timeout /t 1 /nobreak >nul
            "%CURL_TOOL%" --progress-bar -o "!paramsFile!" "%ZK_DOWNLOAD_LINK%%%f"
        )
    )
    echo.
    echo Download completed.
    timeout /t 3 /nobreak >nul
    goto MAINMENU
) else (
    timeout /t 1 /nobreak >nul
    goto VERIFYCONFIG
)


:VERIFYCONFIG
setlocal enabledelayedexpansion
cls
type %BTCZ_ANS_DIR%\btcz_logo.ans
type %BTCZ_ANS_DIR%\bitcoinz_txt.ans
echo.
echo ^| %BLACK_FG%%YELLOW_BG% Verify bitcoinz.conf... %RESET%
echo.
set "configMissing="

if not exist "%BTCZ_BLOCKS_DIR%" mkdir "%BTCZ_BLOCKS_DIR%"

if exist "%BTCZ_CONFIG_FILE%" (
    timeout /t 1 /nobreak >nul
    goto STARTNODE
) else (
    echo  %RED_FG%Error: bitcoinz.conf file is missing in %BTCZ_BLOCKS_DIR%. %RESET%
    echo.
    echo ^| Do you want to create bitcoinz.conf file ? (y/n)
    echo ==========================
    set /p choice="| %BLACK_FG%%YELLOW_BG% Enter your choice %RESET% : "

    set "choice=%choice: =%"

    if /i "%choice%"=="y" (
        echo Creating bitcoinz.conf file...
        call %SOURCE_FILES%\config.bat :MAKECONFIG
        goto MAINMENU
    ) else (
        echo Cancelled....
        timeout /t 2 /nobreak >nul
        goto MAINMENU
    )
)


:STARTNODE
setlocal enabledelayedexpansion
cls
type %BTCZ_ANS_DIR%\btcz_logo.ans
type %BTCZ_ANS_DIR%\bitcoinz_txt.ans
echo.
echo ^| %BLACK_FG%%YELLOW_BG% Starting Node... %RESET%
echo.
start "" /B "%BITCOINZD_FILE%"
timeout /t 5 /nobreak >nul

goto NODESTATUS


:NODESTATUS
setlocal enabledelayedexpansion
cls
type %BTCZ_ANS_DIR%\btcz_logo.ans
type %BTCZ_ANS_DIR%\bitcoinz_txt.ans
echo.
echo ================================================================================
echo                                   Node Status
echo ================================================================================

if not exist "%BTCZ_TEMP_DIR%" mkdir "%BTCZ_TEMP_DIR%"
if exist "%JSON_DATA_FILE%" del "%JSON_DATA_FILE%"

timeout /t 1 /nobreak >nul
rem
start "" /B "%BITCOINZCLI_FILE%" getinfo > "%JSON_DATA_FILE%"

rem
timeout /t 1 /nobreak >nul
findstr /r /c:"." "%JSON_DATA_FILE%" >nul 2>&1
if errorlevel 1 (
    echo.
    echo %YELLOW_FG%Please Wait...%RESET%
    timeout /t 3 /nobreak >nul
    goto NODESTATUS
)

set "BTCZ_STATUS=true"

call %SOURCE_FILES%\nodeinfos.bat :NODEINFOS

echo.
echo  %WHITE_FG%%GREEN_BG% BitcoinZ node is running now... %RESET%
echo.

timeout /t 5 /nobreak >nul
goto MAINMENU



:NODEPANEL
setlocal enabledelayedexpansion
cls
type %BTCZ_ANS_DIR%\btcz_logo.ans
type %BTCZ_ANS_DIR%\bitcoinz_txt.ans
echo.
echo ^| %BLACK_FG%%YELLOW_BG% Manage Node %RESET% ^|
echo.
echo ================================================================================
echo                                   Manage Node
echo ================================================================================
echo.
echo  [%CYAN_FG%1%RESET%] ^| Control
echo  [%CYAN_FG%2%RESET%] ^| Wallet
echo  [%CYAN_FG%3%RESET%] ^| CashOut
echo.
echo  [%RED_FG%0%RESET%] ^| Return to Main Menu
echo.
echo ==========================
set /p choice="| %BLACK_FG%%YELLOW_BG% Enter your choice %RESET% : "

set "choice=%choice: =%"

if "%choice%"=="1" (
    goto CONTROLPANEL
) else if "%choice%"=="2" (
    goto WALLETPANEL
) else if "%choice%"=="3" (
    goto CASHOUTPANEL
) else if "%choice%"=="0" (
    goto MAINMENU
) else (
    echo.
    echo Invalid selection. Please enter a valid number.
    timeout /t 2 /nobreak >nul
    goto NODEPANEL
)




:CONTROLPANEL

setlocal enabledelayedexpansion
cls
type %BTCZ_ANS_DIR%\btcz_logo.ans
type %BTCZ_ANS_DIR%\bitcoinz_txt.ans
echo.
echo ^| %BLACK_FG%%YELLOW_BG% Control %RESET% ^|
echo.
echo ================================================================================
echo                                     Control
echo ================================================================================
echo.
echo  [%CYAN_FG%1%RESET%] ^| Node Infos
echo  [%CYAN_FG%2%RESET%] ^| Blockchain Infos
echo.
echo  [%RED_FG%0%RESET%] ^| Back
echo.
echo ==========================
set /p choice="| %BLACK_FG%%YELLOW_BG% Enter your choice %RESET% : "

set "choice=%choice: =%"

if "%choice%"=="1" (
    call %SOURCE_FILES%\nodeinfos.bat :NODEINFOS
    pause
) else if "%choice%"=="2" (
    call %SOURCE_FILES%\blockchaininfos.bat :GETBLOCKCHAININFO
) else if "%choice%"=="0" (
    goto NODEPANEL
) else (
    echo.
    echo Invalid selection. Please enter a valid number.
    timeout /t 2 /nobreak >nul
    goto CONTROLPANEL
)

goto CONTROLPANEL




:CASHOUTPANEL

setlocal enabledelayedexpansion
cls
type %BTCZ_ANS_DIR%\btcz_logo.ans
type %BTCZ_ANS_DIR%\bitcoinz_txt.ans
echo.
echo ^| %BLACK_FG%%YELLOW_BG% CashOut %RESET% ^|
echo.
echo ================================================================================
echo                                     CashOut
echo ================================================================================
echo.

echo  [%CYAN_FG%1%RESET%] ^| Send From Main Account
echo  [%CYAN_FG%2%RESET%] ^| Send From T Addresses
echo  [%CYAN_FG%3%RESET%] ^| Send From Z Addresses
echo.
echo  [%RED_FG%0%RESET%] ^| Back
echo.
echo ==========================
set /p choice="| %BLACK_FG%%YELLOW_BG% Enter your choice %RESET% : "

set "choice=%choice: =%"

if "%choice%"=="1" (
    set "SEND_FROM=main_account"
) else if "%choice%"=="2" (
    set "SEND_FROM=transparent"
) else if "%choice%"=="3" (
    set "SEND_FROM=private"
) else if "%choice%"=="0" (
    goto NODEPANEL
) else (
    echo.
    echo Invalid selection. Please enter a valid number.
    timeout /t 2 /nobreak >nul
    goto CASHOUTPANEL
)

call %SOURCE_FILES%\cashout.bat :CASHOUTOPERATION

goto CASHOUTPANEL





:WALLETPANEL
setlocal enabledelayedexpansion
cls
type %BTCZ_ANS_DIR%\btcz_logo.ans
type %BTCZ_ANS_DIR%\bitcoinz_txt.ans
echo.
echo ^| %BLACK_FG%%YELLOW_BG% Manage Wallet %RESET% ^|
echo.
echo ================================================================================
echo                                      Wallet
echo ================================================================================
echo.
echo  [%CYAN_FG%1%RESET%] ^| Total Balances
echo  [%CYAN_FG%2%RESET%] ^| Addresses List
echo  [%CYAN_FG%3%RESET%] ^| Generate New Address
echo  [%CYAN_FG%4%RESET%] ^| Import Key
echo.
echo  [%RED_FG%0%RESET%] ^| Back
echo.
echo ==========================
set /p choice="| %BLACK_FG%%YELLOW_BG% Enter your choice %RESET% : "

set "choice=%choice: =%"

if "%choice%"=="1" (
    call %SOURCE_FILES%\balances.bat :BALANCES
) else if "%choice%"=="2" (
    goto ADDRESSESLISTPANEL
) else if "%choice%"=="3" (
    goto NEWADDRESSESPANEL
) else if "%choice%"=="4" (
    call %SOURCE_FILES%\importkey.bat
) else if "%choice%"=="0" (
    goto NODEPANEL
) else (
    echo.
    echo Invalid selection. Please enter a valid number.
    timeout /t 2 /nobreak >nul
    goto WALLETPANEL
)

goto WALLETPANEL



:ADDRESSESLISTPANEL

setlocal enabledelayedexpansion
cls
type %BTCZ_ANS_DIR%\btcz_logo.ans
type %BTCZ_ANS_DIR%\bitcoinz_txt.ans
echo.
echo ^| %BLACK_FG%%YELLOW_BG% Manage Wallet %RESET% ^|
echo.
echo ================================================================================
echo                                  Addresses List
echo ================================================================================
echo.
echo  [%CYAN_FG%1%RESET%] ^| Transparent Addresses (%YELLOW_FG%T%RESET%)
echo  [%CYAN_FG%2%RESET%] ^| Private Addresses (%CYAN_FG%Z%RESET%)
echo.
echo  [%RED_FG%0%RESET%] ^| Back
echo.
echo ==========================
set /p choice="| %BLACK_FG%%YELLOW_BG% Enter your choice %RESET% : "

set "choice=%choice: =%"

if "%choice%"=="1" (
    set "ADDRESS_TYPE=transparent"
    call %SOURCE_FILES%\addresseslist.bat :ADDRESSESLIST
) else if "%choice%"=="2" (
    set "ADDRESS_TYPE=private"
    call %SOURCE_FILES%\addresseslist.bat :ADDRESSESLIST
) else if "%choice%"=="0" (
    goto WALLETPANEL
) else (
    echo.
    echo Invalid selection. Please enter a valid number.
    timeout /t 2 /nobreak >nul
    goto ADDRESSESLISTPANEL
)

goto ADDRESSESLISTPANEL




:NEWADDRESSESPANEL 

setlocal enabledelayedexpansion
cls
type %BTCZ_ANS_DIR%\btcz_logo.ans
type %BTCZ_ANS_DIR%\bitcoinz_txt.ans
echo.
echo ^| %BLACK_FG%%YELLOW_BG% Manage Wallet %RESET% ^|
echo.
echo ================================================================================
echo                               Generate Addresses
echo ================================================================================
echo.
echo  [%CYAN_FG%1%RESET%] ^| Transparent Address (%YELLOW_FG%T%RESET%)
echo  [%CYAN_FG%2%RESET%] ^| Private Address (%CYAN_FG%Z%RESET%)
echo.
echo  [%RED_FG%0%RESET%] ^| Back
echo.
echo ==========================
set /p choice="| %BLACK_FG%%YELLOW_BG% Enter your choice %RESET% : "

set "choice=%choice: =%"

if "%choice%"=="1" (
    set "ADDRESS_TYPE=transparent"
    call %SOURCE_FILES%\newaddresses.bat :GENERATEADDRESSES
) else if "%choice%"=="2" (
    set "ADDRESS_TYPE=private"
    call %SOURCE_FILES%\newaddresses.bat :GENERATEADDRESSES
) else if "%choice%"=="0" (
    goto WALLETPANEL
) else (
    echo.
    echo Invalid selection. Please enter a valid number.
    timeout /t 2 /nobreak >nul
    goto NEWADDRESSESPANEL
)

goto NEWADDRESSESPANEL



:SOCIALLINKS
setlocal enabledelayedexpansion
cls
type %BTCZ_ANS_DIR%\btcz_logo.ans
type %BTCZ_ANS_DIR%\bitcoinz_txt.ans
echo.
echo ^| %BLACK_FG%%YELLOW_BG% Social Links %RESET% ^|
echo.
echo ================================================================================
echo                                  Official Links
echo ================================================================================
echo.
echo  [%CYAN_FG%1%RESET%] ^| Website
echo  [%CYAN_FG%2%RESET%] ^| Discord
echo  [%CYAN_FG%3%RESET%] ^| Telegram
echo  [%CYAN_FG%4%RESET%] ^| Twitter
echo  [%CYAN_FG%5%RESET%] ^| Reddit
echo.
echo  [%RED_FG%0%RESET%] ^| Return to Main Menu
echo.
echo ==========================
set /p choice="| %BLACK_FG%%YELLOW_BG% Enter your choice %RESET% : "

set "choice=%choice: =%"

if "%choice%"=="1" (
    echo Opening your default web browser...
    start "" "https://getbtcz.com"
    timeout /t 2 /nobreak >nul
    goto SOCIALLINKS
) else if "%choice%"=="2" (
    echo Opening your default web browser...
    start "" "https://discord.gg/bitcoinz"
    timeout /t 2 /nobreak >nul
    goto SOCIALLINKS
) else if "%choice%"=="3" (
    echo Opening your default web browser...
    start "" "https://t.me/btczofficialgroup"
    timeout /t 2 /nobreak >nul
    goto SOCIALLINKS
) else if "%choice%"=="4" (
    echo Opening your default web browser...
    start "" "https://twitter.com/BTCZOfficial"
    timeout /t 2 /nobreak >nul
    goto SOCIALLINKS
) else if "%choice%"=="5" (
    echo Opening your default web browser...
    start "" "https://reddit.com/r/BTCZCommunity"
    timeout /t 2 /nobreak >nul
    goto SOCIALLINKS
) else if "%choice%"=="0" (
    goto MAINMENU
) else (
    echo Invalid choice. Please select a valid option.
    timeout /t 2 /nobreak >nul
    goto SOCIALLINKS
)



:END

rem
if /i "%BTCZ_STATUS%"=="true" (
    echo.
    start "" /B "%BITCOINZCLI_FILE%" stop
    timeout /t 5 /nobreak >nul
    set "BTCZ_STATUS=false" 
)

echo.
echo Exiting...
timeout /t 2 /nobreak >nul
endlocal
exit
