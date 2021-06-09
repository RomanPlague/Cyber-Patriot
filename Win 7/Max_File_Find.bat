rem @echo off
title Major File Find
set extension=mp3
set total=0
(for %%a in (%extension%) do (
	dir /s/b \*.%%a>"E:\Cyber Files\Scripts\Temp Files\%%a.txt"
))
(for %%a in (%extension%) do (
	set dir="E:\Cyber Files\Scripts\Temp Files\%%a.txt"
	call :CheckEmpty %dir%
	if %size% lss 0(
		%dir%
	)else(
		echo %%a is Empty
	)
))
goto :eof

:CheckEmpty
setlocal
set size=%~z1
endlocal & echo %size%
goto :eof