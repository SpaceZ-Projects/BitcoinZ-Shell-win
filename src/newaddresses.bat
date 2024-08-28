

:GENERATEADDRESSES

setlocal enabledelayedexpansion

cls

type "%BTCZ_ANS_DIR%\btcz_logo.ans"
type "%BTCZ_ANS_DIR%\bitcoinz_txt.ans"
echo.
echo ================================================================================
echo                              Generate Addresses
echo ================================================================================
echo.

if exist "%JSON_DATA_FILE%" del "%JSON_DATA_FILE%"

rem
if "%ADDRESS_TYPE%"=="transparent" (
    start "" /B "%BITCOINZCLI_FILE%" getnewaddress > "%JSON_DATA_FILE%"
    set "ADDRESS_COLOR=%YELLOW_FG%"
) else if "%ADDRESS_TYPE%"=="private" (
    start "" /B "%BITCOINZCLI_FILE%" z_getnewaddress > "%JSON_DATA_FILE%"
    set "ADDRESS_COLOR=%CYAN_FG%"
)

rem
timeout /t 1 /nobreak >nul
echo.

REM
set "NEWADDRESS_INPUT="
for /f "delims=" %%A in (%JSON_DATA_FILE%) do (
    set "NEWADDRESS_INPUT=%%A"
)

echo ^| %GREEN_FG%New Address :%RESET%
echo.
echo  %ADDRESS_COLOR%%NEWADDRESS_INPUT%%RESET%
echo.
echo ================================================================================

del "%JSON_DATA_FILE%"

pause
goto :eof