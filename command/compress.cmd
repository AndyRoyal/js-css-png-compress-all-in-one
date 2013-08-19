@echo off
SETLOCAL ENABLEEXTENSIONS
echo.
echo =====================================
echo     JS/CSS Compress Script
echo    fisker(lionkay@gmail.com)
echo       2012-3-21
echo =====================================
echo.



REM �ж��ļ�����
set FILE_TYPE=%~x1
if "%FILE_TYPE%" NEQ ".js" (
    if "%FILE_TYPE%" NEQ ".css" (
        echo.
        echo !! ��ѡ�� CSS �� JS �ļ� !!
        echo.
        goto End
    )
)

REM ��� Java ����
if "%JAVA_HOME%" == "" goto NoJavaHome
if not exist "%JAVA_HOME%\bin\java.exe" goto NoJavaHome

REM ����ѹ������ļ���������Ϊ��
REM 1. �ļ����� .dev ʱ: filename.dev.js -> filename.js
REM 2. ���������filename.js -> filename.min.js
set RESULT_FILE=%~n1.min%~x1
dir /b "%~f1" | find ".dev." > nul
if %ERRORLEVEL% == 0 (
    for %%a in ("%~n1") do (
        set RESULT_FILE=%%~na%~x1
    )
)

set SOURCE_MAP_FILE=%RESULT_FILE%.map

REM ���� yuicompressor ѹ��CSS�ļ�
if "%FILE_TYPE%" == ".css" (
    "%JAVA_HOME%\bin\java.exe" -jar "%~dp0..\yuicompressor\yuicompressor-2.4.7.jar" --charset UTF-8 "%~nx1" -o "%RESULT_FILE%"
)
REM ���� compiler ѹ���ļ�
if "%FILE_TYPE%" == ".js" (
    "%JAVA_HOME%\bin\java.exe" -jar "%~dp0..\compiler\compiler.jar"  --charset UTF-8 --js "%~nx1" --js_output_file "%RESULT_FILE%" --source_map_format=V3 --create_source_map "%SOURCE_MAP_FILE%"
    echo //# sourceMappingURL=%SOURCE_MAP_FILE% >> "%RESULT_FILE%"
)


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
    echo **** �ļ� %~nx1 �����﷨��������ϸ���
    echo.
	goto End
)
goto End

:NoJavaHome
echo.
echo **** ���Ȱ�װ JDK ������ JAVA_HOME ��������
echo.

:End
ENDLOCAL
pause
