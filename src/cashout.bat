

:CASHOUTOPERATION

setlocal enabledelayedexpansion

cls
type "%BTCZ_ANS_DIR%\btcz_logo.ans"
type "%BTCZ_ANS_DIR%\bitcoinz_txt.ans"
echo.
echo ^| %BLACK_FG%%YELLOW_BG% CashOut %RESET% ^|
echo.
echo ================================================================================
echo                                     CashOut
echo ================================================================================
echo.

rem
if "%SEND_FROM%"=="main_account" (
    goto SENDFROMACCOUNT
) else if "%SEND_FROM%"=="transparent" (
    set "ADDRESS_TYPE=transparent"
    goto SENDFROMADDRESS
) else if "%SEND_FROM%"=="private" (
    set "ADDRESS_TYPE=private"
    goto SENDFROMADDRESS
)



:SENDFROMACCOUNT
cls
type "%BTCZ_ANS_DIR%\btcz_logo.ans"
type "%BTCZ_ANS_DIR%\bitcoinz_txt.ans"
echo.
echo ^| %BLACK_FG%%YELLOW_BG% CashOut %RESET% ^|
echo.
echo ================================================================================
echo                             Sending From Main Account
echo ================================================================================
echo.

if exist "%JSON_DATA_FILE%" del "%JSON_DATA_FILE%"

rem
start "" /B "%BITCOINZCLI_FILE%" getbalance > "%JSON_DATA_FILE%"

timeout /t 1 /nobreak >nul

rem
for /f "usebackq tokens=*" %%i in ("%JSON_DATA_FILE%") do (
    set "BALANCE=%%i"
)

rem
if "%BALANCE%"=="0.00000000" (
    echo  %RED_FG%Insufficient Balance !%RESET%
    timeout /t 2 /nobreak >nul
    goto SENDFROMADDRESS
)


echo  Enter the address you want to send to
echo.
echo ==========================
set /p "sendtoaddress=| %BLACK_FG%%YELLOW_BG% Enter transparent (T) address %RESET% : "

rem
if "!sendtoaddress!"=="" (
    echo.
    echo  %RED_FG%Address not set !%RESET%
    timeout /t 2 /nobreak >nul
    goto :eof
) else (
    set "TOADDRESS=!sendtoaddress!"
    set "ADDRESS_TYPE=transparent"
    goto VALIDATEADDRESS
)



:SENDFROMADDRESS

cls
type "%BTCZ_ANS_DIR%\btcz_logo.ans"
type "%BTCZ_ANS_DIR%\bitcoinz_txt.ans"
echo.
echo ^| %BLACK_FG%%YELLOW_BG% CashOut %RESET% ^|
echo.
echo ================================================================================
echo                               Sending From Address
echo ================================================================================
echo.

if exist "%JSON_DATA_FILE%" del "%JSON_DATA_FILE%"

rem
if "%ADDRESS_TYPE%"=="transparent" (
    start "" /B "%BITCOINZCLI_FILE%" getaddressesbyaccount "" > "%JSON_DATA_FILE%"
    set "ADDRESS_COLOR=%YELLOW_FG%"
) else if "%ADDRESS_TYPE%"=="private" (
    start "" /B "%BITCOINZCLI_FILE%" z_listaddresses > "%JSON_DATA_FILE%"
    set "ADDRESS_COLOR=%CYAN_FG%"
)

timeout /t 1 /nobreak >nul

set /a counter=1

rem
for /f "tokens=* delims=" %%A in ('powershell -command "Get-Content %JSON_DATA_FILE% | ConvertFrom-Json | ForEach-Object { $_ }"') do (
    echo  [%CYAN_FG%!counter!%RESET%] ^| %ADDRESS_COLOR%%%A%RESET%
    set "address[!counter!]=%%A"
    set /a counter+=1
)

echo.
echo  [%RED_FG%0%RESET%] ^| Back
echo.
echo ==========================
set /p "choice=| %BLACK_FG%%YELLOW_BG% Enter your choice %RESET% : "

rem
set "choice=%choice: =%"

if "%choice%"=="0" (
    del "%JSON_DATA_FILE%"
    goto :eof
)

if not defined address[%choice%] (
    echo.
    echo Invalid selection. Please enter a valid number.
    timeout /t 2 /nobreak >nul
    goto SENDFROMADDRESS
)

set "SELECTED_ADDRESS=!address[%choice%]!"


goto SENDTOADDRESS




:SENDTOADDRESS

cls
type "%BTCZ_ANS_DIR%\btcz_logo.ans"
type "%BTCZ_ANS_DIR%\bitcoinz_txt.ans"
echo.
echo ^| %BLACK_FG%%YELLOW_BG% CashOut %RESET% ^|
echo.
echo ================================================================================
echo  Selected Address : %ADDRESS_COLOR%%SELECTED_ADDRESS%%RESET%
echo ================================================================================
echo.

if exist "%JSON_DATA_FILE%" del "%JSON_DATA_FILE%"

rem
start "" /B "%BITCOINZCLI_FILE%" z_getbalance "%SELECTED_ADDRESS%" 0 > "%JSON_DATA_FILE%"

timeout /t 1 /nobreak >nul

rem
for /f "usebackq tokens=*" %%i in ("%JSON_DATA_FILE%") do (
    set "BALANCE=%%i"
)

rem
if "%BALANCE%"=="0.00000000" (
    echo  %RED_FG%Insufficient Balance !%RESET%
    timeout /t 2 /nobreak >nul
    goto SENDFROMADDRESS
)

echo    Balance Available : %ADDRESS_COLOR%%BALANCE%%RESET% BTCZ
echo.
echo  Enter the address you want to send to
echo.
echo ==========================
set /p "sendtoaddress=| %BLACK_FG%%YELLOW_BG% Enter transparent (T) or (Z) address %RESET% : "

set "TOADDRESS=!sendtoaddress!"

rem
if "!sendtoaddress!"=="" (
    echo.
    echo  %RED_FG%Address not set !%RESET%
    timeout /t 2 /nobreak >nul
    goto :eof
) else if /i "!TOADDRESS:~0,1!"=="t" (
    set "ADDRESS_TYPE=transparent"
) else if /i "!TOADDRESS:~0,1!"=="z" (
    set "ADDRESS_TYPE=private"
)

goto VALIDATEADDRESS




:VALIDATEADDRESS

echo.
echo ^| %YELLOW_FG%Verify address...%RESET%
echo ^| %TOADDRESS%

if exist "%JSON_DATA_FILE%" del "%JSON_DATA_FILE%"

rem
if "%ADDRESS_TYPE%"=="transparent" (
    start "" /B "%BITCOINZCLI_FILE%" validateaddress "%sendtoaddress%" > "%JSON_DATA_FILE%"
) else if "%ADDRESS_TYPE%"=="private" (
    start "" /B "%BITCOINZCLI_FILE%" z_validateaddress "%sendtoaddress%" > "%JSON_DATA_FILE%"
)

timeout /t 1 /nobreak >nul

rem
for /f "tokens=1,* delims=:" %%A in ('findstr /r /c:"\"isvalid\":" "%JSON_DATA_FILE%"') do (
    set "IS_VALID=%%B"
    set "IS_VALID=!IS_VALID:~1,-1!"
)

if "%IS_VALID%"=="true" (
    goto AMOUTTOSEND
) else (
    echo  %RED_FG%Address not valid !%RESET%
    timeout /t 2 /nobreak >nul
    goto :eof
)



:AMOUTTOSEND

cls
type "%BTCZ_ANS_DIR%\btcz_logo.ans"
type "%BTCZ_ANS_DIR%\bitcoinz_txt.ans"
echo.
echo ^| %BLACK_FG%%YELLOW_BG% CashOut %RESET% ^|
echo.
echo ================================================================================
echo                                      Amount
echo ================================================================================
echo.
echo  Balance : %BALANCE%

echo.
echo ==========================
set /p "amounttosend=| %BLACK_FG%%YELLOW_BG% Enter amount %RESET% : "

set "BTCZ_AMOUNT=!amounttosend!"

goto CONFIRMTRANSACTION




:CONFIRMTRANSACTION

cls
type "%BTCZ_ANS_DIR%\btcz_logo.ans"
type "%BTCZ_ANS_DIR%\bitcoinz_txt.ans"
echo.
echo ^| %BLACK_FG%%YELLOW_BG% CashOut %RESET% ^|
echo.
echo ================================================================================
echo                                 Transaction Review
echo ================================================================================
echo.

if "%SEND_FROM%"=="main_account" (
    echo ^| Sending from : %BLACK_FG%%WHITE_BG% Main Account %RESET%
) else (
    echo ^| Sending from : %ADDRESS_COLOR%%SELECTED_ADDRESS%%RESET%
)

echo ^| Destination : %GREEN_FG%%TOADDRESS%%RESET%
echo ^| Amount : %BTCZ_AMOUNT% BTCZ
echo.

echo ^| Do you want to confirm ? (y/n)
echo ==========================
set /p choice="| %BLACK_FG%%YELLOW_BG% Enter your choice %RESET% : "

set "choice=%choice: =%"

if /i "%choice%"=="y" (
    echo.
    echo  Proccessing...
    timeout /t 2 /nobreak >nul
    goto NEWOPERATION
) else if /i "%choice%"=="n" (
    echo.
    echo  Cancelled...
    timeout /t 2 /nobreak >nul
    goto :eof
) else (
    echo.
    echo  Invalid choice !
    timeout /t 2 /nobreak >nul
    goto CONFIRMTRANSACTION
)




:NEWOPERATION

setlocal enabledelayedexpansion

cls
type "%BTCZ_ANS_DIR%\btcz_logo.ans"
type "%BTCZ_ANS_DIR%\bitcoinz_txt.ans"
echo.
echo ^| %BLACK_FG%%YELLOW_BG% CashOut %RESET% ^|
echo.
echo ================================================================================
echo                                 Transaction Result
echo ================================================================================
echo.

rem
if "%SEND_FROM%"=="main_account" (
    start "" /B "%BITCOINZCLI_FILE%" sendtoaddress "%TOADDRESS%" %BTCZ_AMOUNT% > "%JSON_DATA_FILE%"

    timeout /t 2 /nobreak >nul

    for /f "usebackq tokens=*" %%i in ("%JSON_DATA_FILE%") do (
        set "RESULT_TXID=%%i"
    )

    goto DISPLAYRESULT
) else (
    start "" /B "%BITCOINZCLI_FILE%" z_sendmany "%SELECTED_ADDRESS%" "[{{\\"address\\": \\"%TOADDRESS%\\", \\"amount\\": %BTCZ_AMOUNT%}}]" 1 > "%JSON_DATA_FILE%"

    timeout /t 2 /nobreak >nul

    for /f "usebackq tokens=*" %%i in ("%JSON_DATA_FILE%") do (
        set "OPERATION_RESULT=%%i"
    )

    echo  Operration : %OPERATION_RESULT%
    echo.
    pause
    goto :eof
)




:DISPLAYRESULT

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

echo ^| Amount Sent : %RESULT_AMOUNT% BTCZ
echo ^| Confirmations : %RESULT_CONFIRMATIONS%
echo ^| Transaction ID : %RESULT_TXID%

pause
endlocal
goto :eof