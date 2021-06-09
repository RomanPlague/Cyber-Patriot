@echo off
title Enabling Firewall
echo Enabling Firewall...
NetSh Advfirewall set allprofiles state on
pause