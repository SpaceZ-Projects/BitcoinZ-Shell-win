

:GETBLOCKCHAININFO

rem
setlocal enabledelayedexpansion

%JQ_TOOL% -r "to_entries[] | .value" %JSON_DATA_FILE% > %RESULT_FILE%

rem
for /f "delims=" %%A in (%RESULT_FILE%) do (
    set "LINE=%%A"
    set /a COUNT+=1
    if !COUNT! == 1 set "NODECHAIN=!LINE!"
    if !COUNT! == 2 set "NODEBLOCKS=!LINE!"
    if !COUNT! == 3 set "NODEHEADRES=!LINE!"
    if !COUNT! == 4 set "BESTBLOCKHASH=!LINE!"
    if !COUNT! == 5 set "DIFFICULTY=!LINE!"
    if !COUNT! == 6 set "VERIFICATIONPROGRESS=!LINE!"
    if !COUNT! == 7 set "CHAINWORK=!LINE!"
    if !COUNT! == 8 set "NODEPRUNED=!LINE!"
    if !COUNT! == 9 set "SIZEONDISK=!LINE!"
    if !COUNT! == 10 set "COMMITMENTS=!LINE!"
)

rem 
for /f "tokens=* usebackq" %%A in (
    `powershell -Command "$value = [double]%VERIFICATIONPROGRESS%; $syncProgress = $value * 100; [math]::Round($syncProgress, 2)"`
) do set "SYNCPROGRESS=%%A"

rem Convert SIZEONDISK from bytes to gigabytes with decimal precision
for /f "tokens=* usebackq" %%A in (
    `powershell -Command "$sizeOnDisk = [double]%SIZEONDISK%; $sizeGB = $sizeOnDisk / 1GB; [math]::Round($sizeGB, 2)" `
) do set "SIZEONDISK_CONVERTED=%%A"


rem 
echo    ^| %WHITE_FG%%BLUE_BG% Chain         %RESET% ^| %NODECHAIN%
echo    ^| %WHITE_FG%%BLUE_BG% Blocks        %RESET% ^| %NODEBLOCKS%
echo    ^| %WHITE_FG%%BLUE_BG% Headers       %RESET% ^| %NODEHEADRES%
echo    ^| %WHITE_FG%%BLUE_BG% Best Block    %RESET% ^| %BESTBLOCKHASH%
echo    ^| %WHITE_FG%%BLUE_BG% Difficulty    %RESET% ^| %DIFFICULTY%
echo    ^| %WHITE_FG%%BLUE_BG% Sync Progress %RESET% ^| %SYNCPROGRESS%%%
echo    ^| %WHITE_FG%%BLUE_BG% Chain Work    %RESET% ^| %CHAINWORK%
echo    ^| %WHITE_FG%%BLUE_BG% Pruned        %RESET% ^| %NODEPRUNED%
echo    ^| %WHITE_FG%%BLUE_BG% Size on Disk  %RESET% ^| %SIZEONDISK_CONVERTED% GB
echo    ^| %WHITE_FG%%BLUE_BG% Commitments   %RESET% ^| %COMMITMENTS%
echo.
echo ================================================================================

del "%RESULT_FILE%"
endlocal
goto :eof