@echo off
title Enabling Auto Updates
net start wuauserv
sc config wuauserv start= auto
reg add "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\WindowsUpdates\Auto Update" /v AUOptions /t REG_DWORD /d 0 /f

pause