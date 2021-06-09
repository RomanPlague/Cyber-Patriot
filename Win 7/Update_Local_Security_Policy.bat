@echo off
secedit.exe /configure /db %windir%\security\local.sdb /cfg "E:\Cyber Files\Scripts\Win 7\CyberLocalSecurityPolicy10.inf"
if %ERRORLEVEL EQU 0(
	Echo Local Security Policy Updated

)
pause