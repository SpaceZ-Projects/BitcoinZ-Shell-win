

:GENERATEADDRESSES

cls

type "%BTCZ_ANS_DIR%\btcz_logo.ans"
type "%BTCZ_ANS_DIR%\bitcoinz_txt.ans"
echo.
echo ====================================================
echo                 Generate Addresses
echo ====================================================
echo.

if exist "%JSON_DATA_FILE%" del "%JSON_DATA_FILE%"

if "%AddressType%"=="transparent" (
    rem
    start "" /B "%BITCOINZCLI_FILE%" getnewaddress > "%JSON_DATA_FILE%"
)

if "%AddressType%"=="private" (
    rem
    start "" /B "%BITCOINZCLI_FILE%" z_getnewaddress > "%JSON_DATA_FILE%"
)
timeout /t 1 /nobreak >nul
echo.
echo New Address :
type "%JSON_DATA_FILE%"
echo ====================================================
echo.
del "%JSON_DATA_FILE%"

pause
goto :eof