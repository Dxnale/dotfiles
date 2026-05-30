@echo off
if exist PPPwn\__pycache__ rd /s/q PPPwn\__pycache__
if exist PPPwn\retry del PPPwn\retry>nul
if exist PPPwnUI.dat del PPPwnUI.dat>nul
if exist ResetNetwork.bat del ResetNetwork.bat>nul
if exist "USB Drive (GoldHEN_v2.4b17.3)\payload.bin" del "USB Drive (GoldHEN_v2.4b17.3)\payload.bin">nul

