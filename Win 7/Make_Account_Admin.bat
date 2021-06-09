@echo off
title Create Admin
set username=%1
Echo Creating Admin...
echo %username%
net localgroup "Administrators" "%username%" /add
If %ERRORLEVEL% EQU 0 (
	Echo User '%username%' Is Now and Admin
	
)
pause