@echo off
setlocal
cd /d "%~dp0"
chcp 65001 >nul

if not exist "%~dp0venv\Scripts\python.exe" (
    echo [INFO] venv not found, creating virtual environment...
    where py >nul 2>nul
    if %errorlevel%==0 (
        py -3 -m venv "%~dp0venv"
    ) else (
        python -m venv "%~dp0venv"
    )
    if errorlevel 1 (
        echo [ERROR] Failed to create venv. Please install Python 3 first.
        pause
        exit /b 1
    )
)

echo [INFO] Installing dependencies and PyInstaller...
"%~dp0venv\Scripts\python.exe" -m pip install --upgrade pip
"%~dp0venv\Scripts\python.exe" -m pip install -r "%~dp0requirements.txt" pyinstaller
if errorlevel 1 (
    echo [ERROR] Failed to install dependencies.
    pause
    exit /b 1
)

echo [INFO] Building verify_one.exe...
"%~dp0venv\Scripts\python.exe" -m PyInstaller --noconfirm --clean --onefile --console --name verify_one "%~dp0verify_one.py"
if errorlevel 1 (
    echo [ERROR] Build failed.
    pause
    exit /b 1
)

echo.
echo [SUCCESS] Build finished: %~dp0dist\verify_one.exe
pause
