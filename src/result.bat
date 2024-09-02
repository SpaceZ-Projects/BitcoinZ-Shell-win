
@echo off

mode con: cols=90 lines=20

:DISPLAYRESULT

setlocal enabledelayedexpansion

cls
echo.
echo ^| %BLACK_FG%%YELLOW_BG% CashOut %RESET% ^|
echo.
echo ================================================================================
echo                                 Transaction Result
echo ================================================================================
echo.

rem
start "" /B "%BITCOINZCLI_FILE%" gettransaction "%RESULT_TXID%" > "%JSON_DATA_FILE%"

timeout /t 1 /nobreak >nul
    
rem
for /f "tokens=1,* delims=:" %%A in ('findstr /r /c:"\"amount\":" "%JSON_DATA_FILE%"') do (
    set "RESULT_AMOUNT=%%B"
    set "RESULT_AMOUNT=!RESULT_AMOUNT:~1,-1!"
)

rem
for /f "tokens=1,* delims=:" %%A in ('findstr /r /c:"\"confirmations\":" "%JSON_DATA_FILE%"') do (
    set "RESULT_CONFIRMATIONS=%%B"
    set "RESULT_CONFIRMATIONS=!RESULT_CONFIRMATIONS:~1,-1!"
)

rem
for /f "tokens=1,* delims=:" %%A in ('findstr /r /c:"\"fee\":" "%JSON_DATA_FILE%"') do (
    set "RESULT_FEE=%%B"
    set "RESULT_FEE=!RESULT_FEE:~1,-1!"
)

rem
for /f "tokens=1,* delims=:" %%A in ('findstr /r /c:"\"status\":" "%JSON_DATA_FILE%"') do (
    set "RESULT_STATUS=%%B"
    set "RESULT_STATUS=!RESULT_STATUS:~1,-1!"
)

rem
for /f "tokens=1,* delims=:" %%A in ('findstr /r /c:"\"timereceived\":" "%JSON_DATA_FILE%"') do (
    set "RESULT_TIMERECEIVED=%%B"
    set "RESULT_TIMERECEIVED=!RESULT_TIMERECEIVED:~1,-1!"
)


for /f "delims=" %%i in ('powershell -Command "([System.DateTimeOffset]::FromUnixTimeSeconds(%RESULT_TIMERECEIVED%)).ToLocalTime().DateTime.ToString('yyyy-MM-dd HH:mm:ss')"') do set RESULT_DATE=%%i


if "%RESULT_CONFIRMATIONS%"=="0" (
    set "CONFIRM_COLOR=%WHITE_FG%%RED_BG%"
) else (
    set "CONFIRM_COLOR=%BLACK_FG%%GREEN_BG%"
)


echo ^| Amount Sent    : %RESULT_AMOUNT% BTCZ
echo.
echo ^| Confirmations  : %CONFIRM_COLOR% %RESULT_CONFIRMATIONS% %RESET%
echo ^| Fee            : %RESULT_FEE%
echo ^| Status         : %RESULT_STATUS%
echo ^| ^Time Received  : %RESULT_DATE%
echo.
echo ^| Transaction ID : %RESULT_TXID%
echo.
echo ================================================================================
echo  auto-update in "10" seconds...

del %JSON_DATA_FILE%

timeout /t 10 /nobreak >nul

endlocal
goto DISPLAYRESULT