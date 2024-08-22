

:GETINFO
rem
setlocal enabledelayedexpansion

rem
for /f "tokens=1,* delims=:" %%A in ('findstr /r /c:"\"version\":" "%JSON_DATA_FILE%"') do (
    set "NODEVERSION=%%B"
    set "NODEVERSION=!NODEVERSION:~1,-1!"
)
rem
for /f "tokens=1,* delims=:" %%A in ('findstr /r /c:"\"protocolversion\":" "%JSON_DATA_FILE%"') do (
    set "NODEPROTOCOLVERSION=%%B"
    set "NODEPROTOCOLVERSION=!NODEPROTOCOLVERSION:~1,-1!"
)
rem
for /f "tokens=1,* delims=:" %%A in ('findstr /r /c:"\"walletversion\":" "%JSON_DATA_FILE%"') do (
    set "WALLETVERSION=%%B"
    set "WALLETVERSION=!WALLETVERSION:~1,-1!"
)
rem
for /f "tokens=1,* delims=:" %%A in ('findstr /r /c:"\"balance\":" "%JSON_DATA_FILE%"') do (
    set "NODEBALANCE=%%B"
    set "NODEBALANCE=!NODEBALANCE:~1,-1!"
)
rem
for /f "tokens=1,* delims=:" %%A in ('findstr /r /c:"\"blocks\":" "%JSON_DATA_FILE%"') do (
    set "NODEBLOCKS=%%B"
    set "NODEBLOCKS=!NODEBLOCKS:~1,-1!"
)
rem
for /f "tokens=1,* delims=:" %%A in ('findstr /r /c:"\"timeoffset\":" "%JSON_DATA_FILE%"') do (
    set "NODETIMEOFFSET=%%B"
    set "NODETIMEOFFSET=!NODETIMEOFFSET:~1,-1!"
)
rem
for /f "tokens=1,* delims=:" %%A in ('findstr /r /c:"\"connections\":" "%JSON_DATA_FILE%"') do (
    set "NODECONNECTIONS=%%B"
    set "NODECONNECTIONS=!NODECONNECTIONS:~1,-1!"
)
rem
for /f "tokens=1,* delims=:" %%A in ('findstr /r /c:"\"proxy\":" "%JSON_DATA_FILE%"') do (
    set "NODEPROXY=%%B"
    set "NODEPROXY=!NODEPROXY:~1,-1!"
)
rem
for /f "tokens=1,* delims=:" %%A in ('findstr /r /c:"\"difficulty\":" "%JSON_DATA_FILE%"') do (
    set "DIFFICULTY=%%B"
    set "DIFFICULTY=!DIFFICULTY:~1,-1!"
)
rem
for /f "tokens=1,* delims=:" %%A in ('findstr /r /c:"\"testnet\":" "%JSON_DATA_FILE%"') do (
    set "NODETESTNET=%%B"
    set "NODETESTNET=!NODETESTNET:~1,-1!"
)
rem
for /f "tokens=1,* delims=:" %%A in ('findstr /r /c:"\"keypoololdest\":" "%JSON_DATA_FILE%"') do (
    set "KEYPOOLOLDEST=%%B"
    set "KEYPOOLOLDEST=!KEYPOOLOLDEST:~1,-1!"
)
rem
for /f "tokens=1,* delims=:" %%A in ('findstr /r /c:"\"keypoolsize\":" "%JSON_DATA_FILE%"') do (
    set "KEYPOOLSIZE=%%B"
    set "KEYPOOLSIZE=!KEYPOOLSIZE:~1,-1!"
)
rem
for /f "tokens=1,* delims=:" %%A in ('findstr /r /c:"\"paytxfee\":" "%JSON_DATA_FILE%"') do (
    set "PAYTXFEE=%%B"
    set "PAYTXFEE=!PAYTXFEE:~1,-1!"
)
rem
for /f "tokens=1,* delims=:" %%A in ('findstr /r /c:"\"relayfee\":" "%JSON_DATA_FILE%"') do (
    set "RELAYFEE=%%B"
    set "RELAYFEE=!RELAYFEE:~1,-1!"
)
rem
for /f "tokens=1,* delims=:" %%A in ('findstr /r /c:"\"errors\":" "%JSON_DATA_FILE%"') do (
    set "NODEERRORS=%%B"
    set "NODEERRORS=!NODEERRORS:~1,-1!"
)

rem
echo    ^| %WHITE_FG%%BLUE_BG% Version         %RESET% ^| %NODEVERSION%
echo    ^| %WHITE_FG%%BLUE_BG% ProtocolVersion %RESET% ^| %NODEPROTOCOLVERSION%
echo    ^| %WHITE_FG%%BLUE_BG% WalletVersion   %RESET% ^| %WALLETVERSION%
echo    ^| %WHITE_FG%%BLUE_BG% Balance         %RESET% ^| %NODEBALANCE%
echo    ^| %WHITE_FG%%BLUE_BG% Blocks          %RESET% ^| %NODEBLOCKS%
echo    ^| %WHITE_FG%%BLUE_BG% Timeoffset      %RESET% ^| %NODETIMEOFFSET%
echo    ^| %WHITE_FG%%BLUE_BG% Connections     %RESET% ^| %NODECONNECTIONS%
echo    ^| %WHITE_FG%%BLUE_BG% Proxy           %RESET% ^| %NODEPROXY%
echo    ^| %WHITE_FG%%BLUE_BG% Difficulty      %RESET% ^| %DIFFICULTY%
echo    ^| %WHITE_FG%%BLUE_BG% Testnet         %RESET% ^| %NODETESTNET%
echo    ^| %WHITE_FG%%BLUE_BG% Keypoololdest   %RESET% ^| %KEYPOOLOLDEST%
echo    ^| %WHITE_FG%%BLUE_BG% Keypoolsize     %RESET% ^| %KEYPOOLSIZE%
echo    ^| %WHITE_FG%%BLUE_BG% Paytxfee        %RESET% ^| %PAYTXFEE%
echo    ^| %WHITE_FG%%BLUE_BG% Relayfee        %RESET% ^| %RELAYFEE%
echo    ^| %WHITE_FG%%BLUE_BG% Error           %RESET% ^| %NODEERRORS%
echo.
echo ================================================================================


endlocal
goto :eof