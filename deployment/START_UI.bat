@echo off
:: ═══════════════════════════════════════════════════════════════
::  AI Agent Skills Workforce Platform — One-Click Deploy (Windows)
::  Starts all 5 Claude Agent Skills + Orchestrator, opens UI
:: ═══════════════════════════════════════════════════════════════

title AI Agent Skills Workforce Platform
color 0B
cd /d "%~dp0\.."

echo.
echo  ╔══════════════════════════════════════════════════╗
echo  ║   AI Agent Skills Workforce Platform             ║
echo  ║   Claude Agent Skills (Anthropic, Oct 2025^)     ║
echo  ╚══════════════════════════════════════════════════╝
echo.

:: ── Check .env ─────────────────────────────────────────────────
if not exist "config\.env" (
    echo  [ERROR] config\.env not found.
    echo  Run:  copy config\.env.example config\.env
    echo  Then fill in your Azure + Anthropic keys.
    pause & exit /b 1
)

:: Load .env variables
for /f "usebackq tokens=1,* delims==" %%A in ("config\.env") do (
    if not "%%A"=="" if not "%%A:~0,1%"=="#" set "%%A=%%B"
)
echo  [OK] Environment loaded from config\.env

:: ── Check Python ───────────────────────────────────────────────
python --version >nul 2>&1
if errorlevel 1 (
    echo  [ERROR] Python not found. Install Python 3.11+ from python.org
    pause & exit /b 1
)
echo  [OK] Python detected

:: ── Install dependencies ───────────────────────────────────────
echo.
echo  Installing dependencies...
pip install -r requirements.txt -q
echo  [OK] Dependencies installed

:: ── Kill existing processes on ports ──────────────────────────
for %%P in (8000 8001 8002 8003 8004 8005) do (
    for /f "tokens=5" %%a in ('netstat -aon 2^>nul ^| findstr ":%%P "') do (
        taskkill /F /PID %%a >nul 2>&1
    )
)

:: ── Create logs folder ─────────────────────────────────────────
if not exist "logs" mkdir logs

:: ── Start all services ─────────────────────────────────────────
echo.
echo  Starting Claude Agent Skills...
echo.

start "Orchestrator :8000"        /min cmd /c "set PYTHONPATH=. && python -m uvicorn orchestration.coordinator:app --host 0.0.0.0 --port 8000 --log-level warning > logs\8000.log 2>&1"
timeout /t 1 /nobreak >nul
echo  [^>]  Orchestrator          ^-^> http://localhost:8000

start "Nova :8001"                /min cmd /c "set PYTHONPATH=. && python -m uvicorn skills.nova.scripts.nova_service:app --host 0.0.0.0 --port 8001 --log-level warning > logs\8001.log 2>&1"
timeout /t 1 /nobreak >nul
echo  [^>]  Nova  (Infrastructure) ^-^> http://localhost:8001

start "Axiom :8002"               /min cmd /c "set PYTHONPATH=. && python -m uvicorn skills.axiom.scripts.axiom_service:app --host 0.0.0.0 --port 8002 --log-level warning > logs\8002.log 2>&1"
timeout /t 1 /nobreak >nul
echo  [^>]  Axiom (Data Pipelines) ^-^> http://localhost:8002

start "Sentinel :8003"            /min cmd /c "set PYTHONPATH=. && python -m uvicorn skills.sentinel.scripts.sentinel_service:app --host 0.0.0.0 --port 8003 --log-level warning > logs\8003.log 2>&1"
timeout /t 1 /nobreak >nul
echo  [^>]  Sentinel (Testing)    ^-^> http://localhost:8003

start "Nexus :8004"               /min cmd /c "set PYTHONPATH=. && python -m uvicorn skills.nexus.scripts.nexus_service:app --host 0.0.0.0 --port 8004 --log-level warning > logs\8004.log 2>&1"
timeout /t 1 /nobreak >nul
echo  [^>]  Nexus (Documentation) ^-^> http://localhost:8004

start "Prometheus :8005"          /min cmd /c "set PYTHONPATH=. && python -m uvicorn skills.prometheus.scripts.prometheus_service:app --host 0.0.0.0 --port 8005 --log-level warning > logs\8005.log 2>&1"
timeout /t 1 /nobreak >nul
echo  [^>]  Prometheus (FinOps)   ^-^> http://localhost:8005

:: ── Wait and open browser ──────────────────────────────────────
echo.
echo  Waiting for services to start...
timeout /t 4 /nobreak >nul

echo.
echo  [OK] Platform running! Opening dashboard...
start "" "%~dp0\..\docs\index.html"

echo.
echo  ════════════════════════════════════════════════
echo   All 5 Claude Agent Skills are running.
echo   Close this window to stop all services.
echo  ════════════════════════════════════════════════
echo.
pause
