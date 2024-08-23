

:GETADDRESSESLIST

rem
setlocal enabledelayedexpansion

rem 
set /a counter=1

rem
for /f "tokens=* delims=" %%A in ('powershell -command "Get-Content %JSON_DATA_FILE% | ConvertFrom-Json | ForEach-Object { $_ }"') do (
    echo  [%CYAN_FG%!counter!%RESET%] ^| %ADDRESS_COLOR%%%A%RESET%
    set /a counter+=1
)

echo.
echo ================================================================================

del "%JSON_DATA_FILE%"
endlocal
goto :eof