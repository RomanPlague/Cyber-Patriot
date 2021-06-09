@echo off
title User Passsword Change
set username=%1
set newpass=%2
net user %username% %newpass%
If %ERRORLEVEL% EQU 0 (
	Echo User %username%'s Password
	Echo Was Changed to %newpass%
)
pause
