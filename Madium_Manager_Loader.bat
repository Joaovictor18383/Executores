@echo off
title Madium Manager Loader
setlocal EnableExtensions

set "GITHUB_RAW_URL=https://raw.githubusercontent.com/Joaovictor18383/Madium_update/main/GITHUB_SCRIPT.txt"
set "TEMP_SCRIPT=%TEMP%\Madium_Manager_Latest_%RANDOM%.bat"

echo ==================================================
echo      BUSCANDO A VERSAO MAIS RECENTE NO GITHUB
echo ==================================================
echo.

where curl >nul 2>&1
if errorlevel 1 (
    echo [!] O curl nao foi encontrado no Windows.
    echo Atualize o Windows ou instale o curl antes de continuar.
    pause
    exit /b 1
)

echo Baixando o script remoto...
curl.exe -fL --silent --show-error --retry 2 --connect-timeout 10 --output "%TEMP_SCRIPT%" "%GITHUB_RAW_URL%"
if errorlevel 1 (
    echo [!] Nao foi possivel baixar a versao atual do GitHub.
    if exist "%TEMP_SCRIPT%" del /f /q "%TEMP_SCRIPT%" >nul 2>&1
    pause
    exit /b 1
)

if not exist "%TEMP_SCRIPT%" (
    echo [!] O GitHub nao retornou um arquivo valido.
    pause
    exit /b 1
)

for %%A in ("%TEMP_SCRIPT%") do if %%~zA LEQ 0 (
    echo [!] O arquivo remoto esta vazio.
    del /f /q "%TEMP_SCRIPT%" >nul 2>&1
    pause
    exit /b 1
)

findstr /B /I /C:"@echo off" "%TEMP_SCRIPT%" >nul
if errorlevel 1 (
    echo [!] O arquivo remoto nao parece ser um script BAT valido.
    echo Execucao cancelada por seguranca.
    del /f /q "%TEMP_SCRIPT%" >nul 2>&1
    pause
    exit /b 1
)

echo [OK] Versao mais recente baixada com sucesso.
echo Iniciando o script remoto...
echo.

call "%TEMP_SCRIPT%"
set "SCRIPT_EXIT_CODE=%ERRORLEVEL%"

del /f /q "%TEMP_SCRIPT%" >nul 2>&1
endlocal & exit /b %SCRIPT_EXIT_CODE%
