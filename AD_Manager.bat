@echo off
:: ===================================================================
::  AD MANAGER - LAUNCHER
::  Eleva via UAC e dispara o GUI em processo separado, depois fecha.
::  Nao deixa cmd aberto - o GUI fica desanexado e independente.
:: ===================================================================

:: --- Auto-elevacao ---
net session >nul 2>&1
if %errorLevel% neq 0 (
    powershell -NoProfile -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

:: --- Dispara o PS1 desanexado, oculto, e fecha o cmd imediatamente ---
::  start ""  -> cria processo independente (nao morre quando o cmd sai)
::  -WindowStyle Hidden -> nao mostra console do PowerShell
start "" powershell.exe -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "%~dp0AD_Manager.ps1"
exit
