@echo off

pushd "%~dp0"
rundll32 setupapi.dll,InstallHinfSection DefaultUnInstall 128 .\command\install.inf
popd

echo.
echo Successfully uninstalled.
echo.
pause
