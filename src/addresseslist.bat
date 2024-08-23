

:ADDRESSESLIST

cls
type %BTCZ_ANS_DIR%\btcz_logo.ans
type %BTCZ_ANS_DIR%\bitcoinz_txt.ans
echo.
echo ================================================================================
echo                                  Addresses List
echo ================================================================================
echo.

if exist "%JSON_DATA_FILE%" del "%JSON_DATA_FILE%"

if "%ADDRESS_TYPE%"=="transparent" (
    rem
    start "" /B "%BITCOINZCLI_FILE%" getaddressesbyaccount "" > "%JSON_DATA_FILE%"
    set "ADDRESS_COLOR=%YELLOW_FG%"
)

if "%ADDRESS_TYPE%"=="private" (
    rem
    start "" /B "%BITCOINZCLI_FILE%" z_listaddresses > "%JSON_DATA_FILE%"
    set "ADDRESS_COLOR=%CYAN_FG%"
)

timeout /t 1 /nobreak >nul
call results\getaddresseslist.bat :GETADDRESSESLIST

pause

goto :eof
