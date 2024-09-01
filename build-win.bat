@echo off
setlocal

where python >nul 2>nul
if %ERRORLEVEL% neq 0 (
    echo Python is not installed. Please install Python and try again.
    pause
    exit /b 1
)

echo Creating a virtual environment
python -m venv env

echo Activating the virtual environment
call env\Scripts\activate.bat

echo Installing PyInstaller
pip install PyInstaller

echo Building excutable file...
pyinstaller main.spec

echo Deactivating the virtual environment
call env\Scripts\deactivate.bat

echo Cleaning...
powershell -Command "Remove-Item -Recurse -Force .\env"
powershell -Command "Remove-Item -Recurse -Force .\build"

move .\dist\*.exe .\

powershell -Command "Remove-Item -Recurse -Force .\dist"

echo Done!
endlocal
pause
