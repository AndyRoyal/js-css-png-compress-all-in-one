@echo off
SETLOCAL ENABLEEXTENSIONS
echo.
echo =====================================
echo     JS Compress Script with UglifyJS2
echo    fisker(lionkay@gmail.com)
echo       2012-11-13
echo =====================================
echo.



REM 判断文件类型
set FILE_TYPE=%~x1
if "%FILE_TYPE%" NEQ ".js" (
    echo.
    echo !! 请选择 JS 文件 !!
    echo.
    goto End
)

REM 生成压缩后的文件名，规则为：
REM 1. 文件名有 .dev 时: filename.dev.js -> filename.js
REM 2. 其它情况：filename.js -> filename.min.js
set RESULT_FILE=%~n1.min%~x1
dir /b "%~f1" | find ".dev." > nul
if %ERRORLEVEL% == 0 (
    for %%a in ("%~n1") do (
        set RESULT_FILE=%%~na%~x1
    )
)

REM SOURCE MAP
set SOURCE_MAP_FILE=%RESULT_FILE%.map


REM 判断x64 x86
set NODE_EXE=%~dp0..\nodejs\node.x64.exe
if "%PROCESSOR_ARCHITECTURE%"=="x86" (
    set NODE_EXE=%~dp0..\nodejs\node.x86.exe
)

REM 调用 UglifyJS2 压缩文件
REM 请配置好NODE UglifyJS2后运行
REM 使用下面命令安装 UglifyJS2  ， npm install uglify-js -g
if "%FILE_TYPE%" == ".js" (
    REM "%NODE_EXE%" "%~dp0..\UglifyJS2\bin\uglifyjs" "%~nx1" --output "%RESULT_FILE%" --source-map "%SOURCE_MAP_FILE%" --compress --prefix 5 --mangle
    uglifyjs "%~nx1" --output "%RESULT_FILE%" --source-map "%SOURCE_MAP_FILE%" --compress --prefix 5 --mangle
)


REM 显示压缩结果
if %ERRORLEVEL% == 0 (
    echo.
    echo 压缩文件 %~nx1 到 %RESULT_FILE%
    for %%a in ("%RESULT_FILE%") do (
        echo 文件大小从 %~z1 bytes 压缩到 %%~za bytes
    )
    echo.
) else (
    echo.
    echo **** 文件 %~nx1 中有语法错误，请仔细检查
    echo.
	goto End
)
goto End

:End
ENDLOCAL
pause
