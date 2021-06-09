@echo off
title Delete User
set username=%1 %2
echo Deleting %username%'s Account
net user "%username%" /delete
If %ERRORLEVEL% EQU 0 (
	Echo User '%username%' Was Deleted
)
pause
