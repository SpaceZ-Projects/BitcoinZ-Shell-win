
:NODEINFOS

cls
type %BTCZ_ANS_DIR%\btcz_logo.ans
type %BTCZ_ANS_DIR%\bitcoinz_txt.ans
echo.
echo ====================================================
echo                     Node Infos
echo ====================================================
echo.
if exist "%JSON_DATA_FILE%" del "%JSON_DATA_FILE%"
timeout /t 1 /nobreak >nul
rem
start "" /B "%BITCOINZCLI_FILE%" getinfo > "%JSON_DATA_FILE%"
call results\getinfo.bat :GETINFO

del "%JSON_DATA_FILE%"

pause
goto :eof