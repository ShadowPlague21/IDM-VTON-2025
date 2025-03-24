@echo off
:: Setup script for IDM-VTON with Python 3.12.4 and CUDA 12.4 (Windows version)

echo Setting up IDM-VTON with Python 3.12.4 and CUDA 12.4...

:: Check Python version
python --version > temp.txt
set /p PYTHON_VERSION=<temp.txt
del temp.txt
echo Detected: %PYTHON_VERSION%

if not "%PYTHON_VERSION:3.12=%" == "%PYTHON_VERSION%" (
  echo Python 3.12 detected. Proceeding...
) else (
  echo Warning: You're not using Python 3.12. Some features may not work correctly.
  set /p CONTINUE="Continue? (y/n): "
  if /i not "%CONTINUE%" == "y" exit /b 1
)

:: Check CUDA availability
where nvcc >nul 2>&1
if %ERRORLEVEL% equ 0 (
  for /f "tokens=3" %%i in ('nvcc --version ^| findstr "release"') do set CUDA_VERSION=%%i
  echo Detected CUDA version: %CUDA_VERSION%
  
  if not "%CUDA_VERSION:12.4=%" == "%CUDA_VERSION%" (
    echo CUDA 12.4 detected. Proceeding...
  ) else (
    echo Warning: CUDA 12.4 is recommended. Using %CUDA_VERSION% may cause issues.
    set /p CONTINUE="Continue? (y/n): "
    if /i not "%CONTINUE%" == "y" exit /b 1
  )
) else (
  echo Warning: CUDA not detected. This project requires CUDA 12.4.
  set /p CONTINUE="Continue without CUDA? (y/n): "
  if /i not "%CONTINUE%" == "y" exit /b 1
)

:: Install Python dependencies
echo Installing Python dependencies...
pip install --upgrade pip
pip install -r requirements.txt

:: Apply compatibility fixes
echo Applying compatibility fixes...
python compatibility_fix.py

echo Setup complete! You can now run the following commands:
echo   - For training: python train_xl.py
echo   - For inference: python inference.py
echo   - For the demo: python app.py 