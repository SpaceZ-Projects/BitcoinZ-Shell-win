

:IMPORTPRIVATEKEY

setlocal enabledelayedexpansion

cls
type "%BTCZ_ANS_DIR%\btcz_logo.ans"
type "%BTCZ_ANS_DIR%\bitcoinz_txt.ans"
echo.
echo ================================================================================
echo                                  Import Key
echo ================================================================================
echo.
echo  %BLACK_FG%%WHITE_BG% This process will disable the Node client until it is complete. It will take a few minutes %RESET%
echo.
echo  [%CYAN_FG%1%RESET%] ^| Transparent (%YELLOW_FG%T%RESET%)
echo  [%CYAN_FG%2%RESET%] ^| Private (%CYAN_FG%Z%RESET%)
echo.
echo  [%RED_FG%0%RESET%] ^| Back
echo ==========================
set /p "choice=| %BLACK_FG%%YELLOW_BG% Enter your choice %RESET% : "

set "choice=%choice: =%"

if "%choice%"=="1" (
    set "KEY_TYPE=transparent"
    goto IMPORTOPERATION
) else if "%choice%"=="2" (
    set "KEY_TYPE=private"
    goto IMPORTOPERATION
) else if "%choice%"=="0" (
    endlocal
    goto :eof
) else (
    echo.
    echo Invalid selection. Please enter a valid number.
    timeout /t 2 /nobreak >nul
    goto MANAGEADDRESS
)


:IMPORTOPERATION

cls
type "%BTCZ_ANS_DIR%\btcz_logo.ans"
type "%BTCZ_ANS_DIR%\bitcoinz_txt.ans"
echo.
echo ================================================================================
echo                                  Import Key
echo ================================================================================
echo.
echo Paste your private key :
echo ==========================
set /p "privatekey=| %BLACK_FG%%YELLOW_BG% Key %RESET% : "

rem
if "%KEY_TYPE%"=="transparent" (
    start "" /B "%BITCOINZCLI_FILE%" importprivkey "%privatekey%"
) else if "%KEY_TYPE%"=="private" (
    start "" /B "%BITCOINZCLI_FILE%" z_importkey "%privatekey%"
)

timeout /t 1 /nobreak >nul

set "privatekey="

pause
goto IMPORTPRIVATEKEY