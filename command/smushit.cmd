@echo off
SETLOCAL ENABLEEXTENSIONS
echo.
echo =====================================
echo   Image Compress Script (Smush.it)
echo    fisker(lionkay@gmail.com)
echo       2012-5-15
echo =====================================
echo.

echo !!this script runs very slow should be patient.

REM ��� Java ����
if "%JAVA_HOME%" == "" goto NoJavaHome
if not exist "%JAVA_HOME%\bin\java.exe" goto NoJavaHome

REM �ж��ļ�����
set FILE_TYPE=%~x1
for %%i in (.png .gif .jpg) do (if "%FILE_TYPE%"=="%%i" goto COMPRESS)


:COMPRESS
REM ����ѹ������ļ���������Ϊ��
REM 1. �ļ����� .dev ʱ: filename.dev.png -> filename.png
REM 2. ���������filename.png -> filename.min.png
set RESULT_FILE=%~n1.min%.png
dir /b "%~f1" | find ".dev." > nul
if %ERRORLEVEL% == 0 (
    for %%a in ("%~n1") do (
        set RESULT_FILE=%%~na.png
    )
)

set TEMP_FILE=.\_smushit_fisker_temp\1.png
RMDIR /Q /S ".\_smushit_fisker_temp\"
mkdir ".\_smushit_fisker_temp\"
copy "%~nx1" "%TEMP_FILE%"
"%JAVA_HOME%\bin\java.exe" -jar "%~dp0..\smushit\smushit.jar"  -imageDir=.\_smushit_fisker_temp -verbose=true -dryRun=false -imgExtensions=gif,png,jpeg,jpg
echo.
echo start looking for the right file
echo.
REM Ԥ�ȸ���һ�� ��ֹ�ļ�����ѹ��
copy "%~nx1" "%RESULT_FILE%"
cd _smushit_fisker_temp
for /f "delims=" %%a in ('dir/b/s/a-d *.*') do (
    if %%~za lss %~z1 (
echo.
echo find %%a is smaller than %~nx1
echo.
        copy %%a "smallone"
    )
)
cd ..
copy _smushit_fisker_temp\smallone "%RESULT_FILE%"
RMDIR /Q /S ".\_smushit_fisker_temp\"

REM ��ʾѹ�����
if %ERRORLEVEL% == 0 (
    echo.
    echo ѹ���ļ� %~nx1 �� %RESULT_FILE%
    for %%a in ("%RESULT_FILE%") do (
        echo �ļ���С�� %~z1 bytes ѹ���� %%~za bytes
    )
    echo.
) else (
    echo.
    echo **** �ļ� %~nx1 ѹ��ʧ��,����δ��ѹ������С�ߴ�
    echo **** �Ѹ���Դ�ļ� %~nx1 �� %RESULT_FILE%
    echo.
    goto End
)
goto End

:End
ENDLOCAL
pause
