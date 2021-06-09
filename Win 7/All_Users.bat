@echo off
echo Administrators:     >> "E:\Cyber Files\Scripts\Temp Files\users.txt"
net localgroup Administrators >> "E:\Cyber Files\Scripts\Temp Files\users.txt"
echo _________________________ >> "E:\Cyber Files\Scripts\Temp Files\users.txt"
echo Users:     >> "E:\Cyber Files\Scripts\Temp Files\users.txt"
net localgroup Users >> "E:\Cyber Files\Scripts\Temp Files\users.txt"
echo _________________________ >> "E:\Cyber Files\Scripts\Temp Files\users.txt"
echo Guests:     >> "E:\Cyber Files\Scripts\Temp Files\users.txt"
net localgroup Guests >> "E:\Cyber Files\Scripts\Temp Files\users.txt"