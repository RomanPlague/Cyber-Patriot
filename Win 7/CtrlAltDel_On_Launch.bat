@echo off
title Enabling Ctrl+Alt+Del
Echo Enabling Ctrl Alt Del...
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\WindowsNT\CurrentVersion\Winlogon" /v "DisableCAD" /t REG_DWORD /d 0 /f"
if %ERRORLEVEL EQU 0(
	Echo Ctrl Alt Del is Enabled
)
pause