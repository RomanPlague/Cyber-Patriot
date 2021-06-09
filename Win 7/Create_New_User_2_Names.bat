@Echo Off
title Create User
set  username=%1 %2
set  newpass=%3
Echo Creating User...
echo %username%
net user "%username%" %newpass% /add
If %ERRORLEVEL% EQU 0 (
	Echo User '%username%' Was Created
	Echo Password: %newpass%
	echo Ctrl + M, select local users and groups, 
	echo add, open users and select %usernm%,
	echo then select first check box
	mmc
)
pause