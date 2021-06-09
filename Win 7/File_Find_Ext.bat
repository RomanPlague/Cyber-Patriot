@echo off
title Find File Type
set file=%1
echo Searching For %file%
dir /s/b \*%file%>"E:\Cyber Files\Scripts\Temp Files\'%file%'_Ext.txt"

pause