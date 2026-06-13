@echo off
title Godot Watchdog Loop

:loop
echo [%time%] Starting Godot project...

:: Launches Godot in a separate process and waits for it to close
start "" /wait "c:\Users\avril\Desktop\Godot_v4.6.2-stable_win64.exe" --project godot/project.godot

goto loop
