@echo off
title Godot Watchdog Loop

:loop
echo [%time%] Starting Godot project...

:: Launches Godot in a separate process and waits for it to close
start "" /wait "c:\Users\avril\Desktop\Godot_v4.7.1-stable_win64.exe" --editor --project godot/project.godot

goto loop
