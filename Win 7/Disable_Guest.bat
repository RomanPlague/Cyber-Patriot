@echo off
title Disable Guest Account
net user guest /active:no
net user administrator /active:no
if %ERRORLEVEL EQU 0(
	Echo Guest account is Disabled
)
pause