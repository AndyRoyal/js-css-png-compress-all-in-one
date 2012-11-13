@echo off
SETLOCAL ENABLEEXTENSIONS
echo.
echo =====================================
echo     JS Compress Script with UglifyJS2
echo    fisker(lionkay@gmail.com)
echo       2012-11-13
echo =====================================
echo.



REM �ж��ļ�����
set FILE_TYPE=%~x1
if "%FILE_TYPE%" NEQ ".js" (
    echo.
    echo !! ��ѡ�� JS �ļ� !!
    echo.
    goto End
)

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

REM �ж�x64 x86
set NODE_EXE=%~dp0..\nodejs\node.x64.exe
if "%PROCESSOR_ARCHITECTURE%"=="x86" (
    set NODE_EXE=%~dp0..\nodejs\node.x86.exe
)

REM ���� UglifyJS2 ѹ���ļ�
REM ��ǰ�汾��windows�»�����ȴ�UglifyJS2�°���
if "%FILE_TYPE%" == ".js" (
    "%NODE_EXE%" "%~dp0..\UglifyJS2\bin\uglifyjs2" "%~nx1" --output "%RESULT_FILE%" --compress warnings=false --prefix 3 --mangle
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

:End
ENDLOCAL
pause
