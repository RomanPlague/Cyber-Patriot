@echo off
title Disabling C Drive Sharing
net share C$ /DELETE
If %ERRORLEVEL% EQU 0 (
	Echo C Drive Sharing is Disabled
)
pause