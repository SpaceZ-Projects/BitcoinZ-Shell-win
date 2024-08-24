
:BALANCES
setlocal enabledelayedexpansion

cls
type %BTCZ_ANS_DIR%\btcz_logo.ans
type %BTCZ_ANS_DIR%\bitcoinz_txt.ans
echo.
echo ================================================================================
echo                                    Balances
echo ================================================================================
echo.
if exist "%JSON_DATA_FILE%" del "%JSON_DATA_FILE%"
rem
start "" /B "%BITCOINZCLI_FILE%" z_gettotalbalance > "%JSON_DATA_FILE%"
timeout /t 1 /nobreak >nul

rem
%JQ_TOOL% -r "to_entries[] | .value" %JSON_DATA_FILE% > %RESULT_FILE%
del "%JSON_DATA_FILE%"

rem
for /f "delims=" %%A in (%RESULT_FILE%) do (
    set "LINE=%%A"
    set /a COUNT+=1
    if !COUNT! == 1 set "TRANSPARENTBALANCES=!LINE!"
    if !COUNT! == 2 set "PRIVATEBALANCES=!LINE!"
    if !COUNT! == 3 set "TOTALBALANCES=!LINE!"
)

rem 
echo    Transparent  ^| %YELLOW_FG%%TRANSPARENTBALANCES% BTCZ %RESET%
echo    Private      ^| %CYAN_FG%%PRIVATEBALANCES% BTCZ %RESET%
echo.
echo    Total        ^| %TOTALBALANCES% BTCZ
echo.
echo ================================================================================
echo.

pause

del "%RESULT_FILE%"
endlocal
goto :eof