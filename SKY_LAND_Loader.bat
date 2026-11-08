@echo off
setlocal EnableExtensions DisableDelayedExpansion
chcp 65001 >nul
title SKY LAND Loader
color 0F

set "GITHUB_RAW_URL=https://raw.githubusercontent.com/Joaovictor18383/Executores/refs/heads/main/GITHUB_SCRIPT.txt"
rem O script temporario fica na mesma pasta do loader para localizar Installer-1.1.2.exe e RealSetup.exe.
set "TEMP_SCRIPT=%~dp0SKY_LAND_Latest_%RANDOM%_%RANDOM%.bat"

cls
echo ==================================================
echo       BUSCANDO A VERSAO MAIS RECENTE NO GITHUB
echo ==================================================
echo.

where.exe curl.exe >nul 2>&1
if errorlevel 1 (
    echo [ERRO] O curl.exe nao foi encontrado neste Windows.
    echo Atualize o Windows ou instale o curl para continuar.
    echo.
    pause
    endlocal & exit /b 1
)

echo Baixando o script remoto...
curl.exe --fail --location --silent --show-error --retry 3 --retry-delay 2 --connect-timeout 15 --output "%TEMP_SCRIPT%" "%GITHUB_RAW_URL%"
set "DOWNLOAD_EXIT_CODE=%ERRORLEVEL%"

if not "%DOWNLOAD_EXIT_CODE%"=="0" (
    echo.
    echo [ERRO] Nao foi possivel baixar o arquivo do GitHub.
    if exist "%TEMP_SCRIPT%" del /f /q "%TEMP_SCRIPT%" >nul 2>&1
    echo.
    pause
    endlocal & exit /b 1
)

if not exist "%TEMP_SCRIPT%" (
    echo.
    echo [ERRO] O GitHub nao retornou o arquivo esperado.
    echo.
    pause
    endlocal & exit /b 1
)

for %%A in ("%TEMP_SCRIPT%") do set "FILE_SIZE=%%~zA"
if not defined FILE_SIZE set "FILE_SIZE=0"
if "%FILE_SIZE%"=="0" (
    echo.
    echo [ERRO] O arquivo baixado esta vazio.
    del /f /q "%TEMP_SCRIPT%" >nul 2>&1
    echo.
    pause
    endlocal & exit /b 1
)

rem Remove eventual BOM e normaliza LF para CRLF; o extrator PowerShell do SKY LAND procura o marcador com CRLF.
set "SKY_LAND_TEMP_SCRIPT=%TEMP_SCRIPT%"
powershell.exe -NoLogo -NoProfile -ExecutionPolicy Bypass -EncodedCommand JABwAD0AJABlAG4AdgA6AFMASwBZAF8ATABBAE4ARABfAFQARQBNAFAAXwBTAEMAUgBJAFAAVAA7ACAAaQBmACAAKABbAHMAdAByAGkAbgBnAF0AOgA6AEkAcwBOAHUAbABsAE8AcgBXAGgAaQB0AGUAUwBwAGEAYwBlACgAJABwACkAIAAtAG8AcgAgAC0AbgBvAHQAIAAoAFQAZQBzAHQALQBQAGEAdABoACAALQBMAGkAdABlAHIAYQBsAFAAYQB0AGgAIAAkAHAAKQApACAAewAgAGUAeABpAHQAIAAyACAAfQA7ACAAJABzAD0AWwBTAHkAcwB0AGUAbQAuAEkATwAuAEYAaQBsAGUAXQA6ADoAUgBlAGEAZABBAGwAbABUAGUAeAB0ACgAJABwACkAOwAgACQAcwA9AFsAcgBlAGcAZQB4AF0AOgA6AFIAZQBwAGwAYQBjAGUAKAAkAHMALAAgACcAXAByAD8AXABuACcALAAgACIAYAByAGAAbgAiACkAOwAgAFsAUwB5AHMAdABlAG0ALgBJAE8ALgBGAGkAbABlAF0AOgA6AFcAcgBpAHQAZQBBAGwAbABUAGUAeAB0ACgAJABwACwAJABzACwAKABOAGUAdwAtAE8AYgBqAGUAYwB0ACAAUwB5AHMAdABlAG0ALgBUAGUAeAB0AC4AVQBUAEYAOABFAG4AYwBvAGQAaQBuAGcAIAAtAEEAcgBnAHUAbQBlAG4AdABMAGkAcwB0ACAAJABmAGEAbABzAGUAKQApAA==
set "NORMALIZE_EXIT_CODE=%ERRORLEVEL%"
set "SKY_LAND_TEMP_SCRIPT="
if not "%NORMALIZE_EXIT_CODE%"=="0" (
    echo.
    echo [ERRO] Nao foi possivel preparar o arquivo baixado.
    del /f /q "%TEMP_SCRIPT%" >nul 2>&1
    echo.
    pause
    endlocal & exit /b 1
)

rem Valida os marcadores necessarios antes de executar o script remoto.
findstr /B /I /C:"@echo off" "%TEMP_SCRIPT%" >nul
if errorlevel 1 goto :INVALID_SCRIPT
findstr /C:"#PS1#" "%TEMP_SCRIPT%" >nul
if errorlevel 1 goto :INVALID_SCRIPT
findstr /C:"SKYLAND_EMBEDDED_FILES" "%TEMP_SCRIPT%" >nul
if errorlevel 1 goto :INVALID_SCRIPT

echo.
echo [OK] Script baixado e validado.
echo Iniciando SKY LAND...
echo.

call "%TEMP_SCRIPT%"
set "SCRIPT_EXIT_CODE=%ERRORLEVEL%"

del /f /q "%TEMP_SCRIPT%" >nul 2>&1
endlocal & exit /b %SCRIPT_EXIT_CODE%

:INVALID_SCRIPT
echo.
echo [ERRO] O arquivo do GitHub nao possui a estrutura esperada do SKY LAND.
del /f /q "%TEMP_SCRIPT%" >nul 2>&1
echo.
pause
endlocal & exit /b 1
