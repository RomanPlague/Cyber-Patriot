@echo off
title Disabling FTP Services
net stop msftpsvc
if %ERRORLEVEL EQU 0(
	Echo FTP Services are Disabled
)
pause