
:MAKECONFIG
cls
type %BTCZ_ANS_DIR%\btcz_logo.ans
type %BTCZ_ANS_DIR%\bitcoinz_txt.ans
echo.
echo ^| %BLACK_FG%%YELLOW_BG% Config Maker %RESET% ^|
echo.
echo ================================================================================
echo                               Config File Maker
echo ================================================================================
echo.

rem 
echo enter the RPC user
echo ==========================
set /p rpcuser="%BLACK_FG%%YELLOW_BG% rpcuser %RESET% : "

cls
type %BTCZ_ANS_DIR%\btcz_logo.ans
type %BTCZ_ANS_DIR%\bitcoinz_txt.ans
echo.
echo ^| %BLACK_FG%%YELLOW_BG% Config Maker %RESET% ^|
echo.
echo ================================================================================
echo                               Config File Maker
echo ================================================================================
echo.

rem 
echo enter the RPC password
echo ==========================
set /p rpcpassword="%BLACK_FG%%YELLOW_BG% rpcpassword %RESET% : "

cls
type %BTCZ_ANS_DIR%\btcz_logo.ans
type %BTCZ_ANS_DIR%\bitcoinz_txt.ans
echo.
echo ^| %BLACK_FG%%YELLOW_BG% Config Maker %RESET% ^|
echo.
echo ================================================================================
echo                               Config File Maker
echo ================================================================================
echo.

rem
echo enter the RPC port
echo ==========================
set /p rpcport="%BLACK_FG%%YELLOW_BG% rpcport %RESET% : "

rem
(
echo rpcuser=%rpcuser%
echo rpcpassword=%rpcpassword%
echo rpcport=%rpcport%
echo rpcallowip=127.0.0.1/0
echo txindex=1
echo sendfreetransactions=1
echo listen=1
echo server=1
echo deamon=1
echo addnode=74.208.91.217:8233
echo addnode=explorer.btcz.app:1989
echo addnode=explorer.btcz.rocks:1989
echo addnode=37.187.76.80:1989
echo addnode=198.100.154.162:1989
) > "%BTCZ_CONFIG_FILE%"

echo  %GREEN_FG%bitcoinz.conf has been created in %BTCZ_CONFIG_FILE% %RESET%
echo.
echo Return to Main Menu...
timeout /t 2 /nobreak >nul
goto :eof