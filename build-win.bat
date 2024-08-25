@echo off


echo Creating a virtual environment
python -m venv env

echo Activating the virtual environment
call env\Scripts\activate.bat

echo Installing PyInstaller
pip install PyInstaller

echo Building excutable file...
pyinstaller main.spec

echo Deactivating the virtual environment
deactivate

echo Done!
pause
