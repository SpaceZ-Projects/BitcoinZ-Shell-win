@echo off
setlocal enabledelayedexpansion

title BitcoinZ Full Node : Shell interface
mode con: cols=120 lines=55

rem
set "BTCZ_ANS_DIR=ans"
set "BTCZ_FILES_DIR=node"
set "BTCZ_BLOCKS_DIR=%APPDATA%\BitcoinZ"
set "BTCZ_ZKSNARK_DIR=%APPDATA%\ZcashParams"
set "BTCZ_TOOLS_DIR=tools"
set "BTCZ_TEMP_DIR=temp"

rem
for %%d in ("%BTCZ_FILES_DIR%" "%BTCZ_BLOCKS_DIR%" "%BTCZ_ZKSNARK_DIR%" "%BTCZ_TOOLS_DIR%" "%BTCZ_TEMP_DIR%") do (
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

set "BTCZ_DOWNLOAD_LINK=https://github.com/btcz/bitcoinz/releases/download/2.0.9-rc2/"
set "NODE_FILE_NAME=bitcoinz-2.0.9-RC2-win64.zip"

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
echo                   %YELLOW_FG%BitcoinZ Full Node : Shell Interface%RESET% %CYAN_BG%%BLACK_FG%v0.1%RESET%
echo ================================================================================
echo.
echo  [%CYAN_FG%1%RESET%] ^| ^Start BitcoinZ
echo  [%CYAN_FG%2%RESET%] ^| Manage Node
echo  [%CYAN_FG%3%RESET%] ^| Join BTCZ Community
echo.
echo  [%RED_FG%0%RESET%] ^| %WHITE_FG%%RED_BG%Stop/Exit%RESET%
echo.
echo ========================
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
)

if "%choice%"=="2" (
    if /i "%BTCZ_STATUS%"=="false" (
        echo.
        echo  %BLACK_FG%%RED_BG% BitcoinZ server is offline... %RESET%
        timeout /t 2 /nobreak >nul
        goto MAINMENU
    ) else (
        goto NODEPANEL
    )
)

if "%choice%"=="3" goto SOCIALLINKS

if "%choice%"=="0" goto END

echo Invalid choice. Please select a valid option.
timeout /t 2 /nobreak >nul
goto MAINMENU


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
    echo Downloading %NODE_FILE_NAME%...
    echo.
    "%CURL_TOOL%" -L -o %BTCZ_FILES_DIR%\%NODE_FILE_NAME% "%BTCZ_DOWNLOAD_LINK%%NODE_FILE_NAME%"
    echo Downloading Completed...
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
endlocal
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
            echo Downloading %%f...
            timeout /t 1 /nobreak >nul
            "%CURL_TOOL%" --progress-bar -o "!paramsFile!" "%ZK_DOWNLOAD_LINK%%%f"
        )
    )
    echo.
    echo Download completed. Please check the files.
    endlocal
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
    echo ========================
    set /p choice="| %BLACK_FG%%YELLOW_BG% Enter your choice %RESET% : "

    set "choice=%choice: =%"

    if /i "%choice%"=="y" (
        echo Creating bitcoinz.conf file...
        call src\config.bat :MAKECONFIG
        goto MAINMENU
    ) else (
        echo Cancelled....
        timeout /t 2 /nobreak >nul
        goto MAINMENU
    )
)
endlocal


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
echo                                  Node Status
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
echo.
call results\getinfo.bat :GETINFO
del "%JSON_DATA_FILE%"
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
echo ========================
set /p choice="| %BLACK_FG%%YELLOW_BG% Enter your choice %RESET% : "

set "choice=%choice: =%"

if "%choice%"=="1" (
    goto CONTROLPANEL
)

if "%choice%"=="2" (
    goto WALLETPANEL
)

if "%choice%"=="0" (
    goto MAINMENU
)


timeout /t 1 /nobreak >nul
goto NODEPANEL




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
echo ========================
set /p choice="| %BLACK_FG%%YELLOW_BG% Enter your choice %RESET% : "

set "choice=%choice: =%"

if "%choice%"=="1" (
    call src\nodeinfos.bat :NODEINFOS
)

if "%choice%"=="2" (
    call src\blockchaininfo.bat :GETBLOCKCHAININFO
)

if "%choice%"=="0" (
    goto NODEPANEL
)

timeout /t 1 /nobreak >nul
goto CONTROLPANEL



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
echo  [%CYAN_FG%2%RESET%] ^| Generate New Address
echo.
echo  [%RED_FG%0%RESET%] ^| Back
echo.
echo ========================
set /p choice="| %BLACK_FG%%YELLOW_BG% Enter your choice %RESET% : "

set "choice=%choice: =%"

if "%choice%"=="1" (
    call src\balances.bat :BALANCES
)

if "%choice%"=="2" (
    goto NEWADDRESSES
)

if "%choice%"=="0" (
    goto NODEPANEL
)

timeout /t 1 /nobreak >nul
goto WALLETPANEL


:NEWADDRESSES 
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
echo ========================
set /p choice="| %BLACK_FG%%YELLOW_BG% Enter your choice %RESET% : "

set "choice=%choice: =%"

if "%choice%"=="1" (
    set "ADDRESS_TYPE=transparent"
    call src\newaddresses.bat :GENERATEADDRESSES
)

if "%choice%"=="2" (
    set "ADDRESS_TYPE=private"
    call src\newaddresses.bat :GENERATEADDRESSES
)

if "%choice%"=="0" (
    goto WALLETPANEL
)

timeout /t 1 /nobreak >nul
goto NEWADDRESSES




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
echo ========================
set /p choice="| %BLACK_FG%%YELLOW_BG% Enter your choice %RESET% : "

set "choice=%choice: =%"

if "%choice%"=="1" (
    echo Opening your default web browser...
    start "" "https://getbtcz.com"
    timeout /t 2 /nobreak >nul
    goto SOCIALLINKS
)

if "%choice%"=="2" (
    echo Opening your default web browser...
    start "" "https://discord.gg/bitcoinz"
    timeout /t 2 /nobreak >nul
    goto SOCIALLINKS
)

if "%choice%"=="3" (
    echo Opening your default web browser...
    start "" "https://t.me/btczofficialgroup"
    timeout /t 2 /nobreak >nul
    goto SOCIALLINKS
)

if "%choice%"=="4" (
    echo Opening your default web browser...
    start "" "https://twitter.com/BTCZOfficial"
    timeout /t 2 /nobreak >nul
    goto SOCIALLINKS
)

if "%choice%"=="5" (
    echo Opening your default web browser...
    start "" "https://reddit.com/r/BTCZCommunity"
    timeout /t 2 /nobreak >nul
    goto SOCIALLINKS
)

if "%choice%"=="0" goto MAINMENU

echo Invalid choice. Please select a valid option.
timeout /t 2 /nobreak >nul
goto SOCIALLINKS



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
