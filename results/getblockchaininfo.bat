

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
echo ====================================================
echo    Chain--------------^| %NODECHAIN%
echo    Blocks-------------^| %NODEBLOCKS%
echo    Headers------------^| %NODEHEADRES%
echo    Best Block---------^| %BESTBLOCKHASH%
echo    Difficulty---------^| %DIFFICULTY%
echo    Sync Progress------^| %SYNCPROGRESS%%%
echo    Chain Work---------^| %CHAINWORK%
echo    Pruned-------------^| %NODEPRUNED%
echo    Size on Disk-------^| %SIZEONDISK_CONVERTED% GB
echo    Commitments--------^| %COMMITMENTS%
echo ====================================================

del "%RESULT_FILE%"
endlocal
goto :eof