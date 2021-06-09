@echo off
title Deleting File Type
set file=%1
echo Deleting All %file% Files
del /s/q \*%file%>"E:\Cyber Files\Scripts\Temp Files\'%file%'_Ext_Del.txt"

pause