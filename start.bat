@echo off
setlocal

title BitcoinZ Full Node : Shell interface
mode con: cols=120 lines=55

set "BTCZ_ANS_DIR=ans"

set "BTCZ_FILES_DIR=node"
set "BTCZ_BLOCKS_DIR=%APPDATA%\BitcoinZ"
set "BTCZ_ZKSNARK_DIR=%APPDATA%\ZcashParams"
set "BTCZ_TOOLS_DIR=tools"
set "BTCZ_TEMP_DIR=temp"
for %%d in ("%BTCZ_FILES_DIR%" "%BTCZ_BLOCKS_DIR%" "%BTCZ_ZKSNARK_DIR%" "%BTCZ_TOOLS_DIR%" "%BTCZ_TEMP_DIR%") do (
    if not exist "%%d" (
        mkdir "%%d"
        if errorlevel 1 (
            echo Failed to create directory %%d
            exit /b 1
        )
    )
)

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


:GETNODESTATUS

type %BTCZ_ANS_DIR%\btcz_logo.ans
type %BTCZ_ANS_DIR%\bitcoinz_txt.ans
echo.
echo Checking node status...

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
if errorlevel 1 (
    echo Status : Offline
    timeout /t 2 /nobreak >nul
    del %JSON_DATA_FILE%
    goto MAINMENU
)
echo Status : Online
set "BTCZ_STATUS=true"
timeout /t 2 /nobreak >nul
del %JSON_DATA_FILE%
goto MAINMENU


:MAINMENU
cls
type %BTCZ_ANS_DIR%\btcz_logo.ans
type %BTCZ_ANS_DIR%\bitcoinz_txt.ans
echo.
echo ^|==[Main Menu]
echo.
echo ====================================================
echo         BitcoinZ Full Node : Shell interface
echo ====================================================
echo.
echo -[1]- Start BitcoinZ
echo -[2]- Manage BitcoinZ
echo -[3]- Join BTCZ Community
echo.
echo -[0]- Exit
echo.
echo =====================
set /p choice="Enter your choice: "
set "choice=%choice: =%"
if "%choice%"=="1" (
    if /i "%BTCZ_STATUS%"=="false" (
        goto VERIFYNODE
    ) else (
        echo.
        echo Node is already running !
        timeout /t 2 /nobreak >nul
        goto MAINMENU
    )
)
if "%choice%"=="2" (
    if /i "%BTCZ_STATUS%"=="false" (
        echo.
        echo BitcoinZ server is offline...
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
echo Verify Node Files...
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
echo Verify Params Files...
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
cls
type %BTCZ_ANS_DIR%\btcz_logo.ans
type %BTCZ_ANS_DIR%\bitcoinz_txt.ans
echo.
echo Verify bitcoinz.conf...
echo.
set "configMissing="

if not exist "%BTCZ_BLOCKS_DIR%" mkdir "%BTCZ_BLOCKS_DIR%"

if exist "%BTCZ_CONFIG_FILE%" (
    timeout /t 1 /nobreak >nul
    goto STARTNODE
) else (
    echo Error: %BTCZ_CONFIG_FILE% file is missing in %BTCZ_BLOCKS_DIR%.
    echo.
    echo - Do you want to create bitcoinz.conf file? (y/n)
    echo =======================
    set /p choice="Enter your choice: "
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
cls
type %BTCZ_ANS_DIR%\btcz_logo.ans
type %BTCZ_ANS_DIR%\bitcoinz_txt.ans
echo.
echo Starting Node...
echo.
start "" /B "%BITCOINZD_FILE%"
timeout /t 5 /nobreak >nul

goto NODESTATUS


:NODESTATUS
cls
type %BTCZ_ANS_DIR%\btcz_logo.ans
type %BTCZ_ANS_DIR%\bitcoinz_txt.ans
echo.
echo ====================================================
echo                     Node Status
echo ====================================================

if not exist "%BTCZ_TEMP_DIR%" mkdir "%BTCZ_TEMP_DIR%"
if exist "%JSON_DATA_FILE%" del "%JSON_DATA_FILE%"

timeout /t 1 /nobreak >nul
rem
start "" /B "%BITCOINZCLI_FILE%" getinfo > "%JSON_DATA_FILE%"

rem
timeout /t 1 /nobreak >nul
findstr /r /c:"." "%JSON_DATA_FILE%" >nul 2>&1
if errorlevel 1 (
    echo Please Wait...
    timeout /t 3 /nobreak >nul
    goto NODESTATUS
)
set "BTCZ_STATUS=true"
call results\getinfo.bat :GETINFO
del "%JSON_DATA_FILE%"
echo.
echo BitcoinZ node is running now...
echo.
timeout /t 5 /nobreak >nul
goto MAINMENU



:NODEPANEL
cls
type %BTCZ_ANS_DIR%\btcz_logo.ans
type %BTCZ_ANS_DIR%\bitcoinz_txt.ans
echo.
echo ====================================================
echo                     Manage Node
echo ====================================================
echo.
echo -[1]- Control
echo -[2]- Wallet
echo -[3]- CashOut
echo.
echo -[0]- Return to Main Menu
echo.
echo =====================
set /p choice="Enter your choice: "

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
cls
type %BTCZ_ANS_DIR%\btcz_logo.ans
type %BTCZ_ANS_DIR%\bitcoinz_txt.ans
echo.
echo ====================================================
echo                       Control
echo ====================================================
echo.
echo -[1]- Node Infos
echo -[2]- Blockchain Infos
echo.
echo -[0]- Back
echo.
echo =====================
set /p choice="Enter your choice: "

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
cls
type %BTCZ_ANS_DIR%\btcz_logo.ans
type %BTCZ_ANS_DIR%\bitcoinz_txt.ans
echo.
echo ====================================================
echo                        Wallet
echo ====================================================
echo.
echo -[1]- Total Balances
echo.
echo -[0]- Back
echo.
echo =====================
set /p choice="Enter your choice: "

if "%choice%"=="1" (
    call src\balances.bat :BALANCES
)
if "%choice%"=="0" (
    goto NODEPANEL
)

timeout /t 1 /nobreak >nul
goto WALLETPANEL



:SOCIALLINKS
cls
type %BTCZ_ANS_DIR%\btcz_logo.ans
type %BTCZ_ANS_DIR%\bitcoinz_txt.ans
echo.
echo ^|==[Social Links]
echo.
echo ====================================================
echo                    Official Links
echo ====================================================
echo.
echo -[1]- Website
echo -[2]- Discord
echo -[3]- Telegram
echo -[4]- Twitter
echo -[5]- Reddit
echo.
echo -[0]- Return to Main Menu
echo.
echo =====================
set /p choice="Enter your choice: "

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
