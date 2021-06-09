@echo off
title Create Admin
set  username=%1
Echo Creating Admin...
echo %username%
net localgroup "Administrators" "%username%" /delete
If %ERRORLEVEL% EQU 0 (
	Echo User '%username%' Is No longer an Admin
	
)
pause