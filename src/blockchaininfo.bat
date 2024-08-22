
:BLOCKCHAININFOS

cls
type %BTCZ_ANS_DIR%\btcz_logo.ans
type %BTCZ_ANS_DIR%\bitcoinz_txt.ans
echo.
echo ====================================================
echo                   Blockchain Infos
echo ====================================================
echo.
if exist "%JSON_DATA_FILE%" del "%JSON_DATA_FILE%"
rem
start "" /B "%BITCOINZCLI_FILE%" getblockchaininfo > "%JSON_DATA_FILE%"
timeout /t 1 /nobreak >nul
call results\getblockchaininfo.bat :GETBLOCKCHAININFO

del "%JSON_DATA_FILE%"

pause
goto :eof