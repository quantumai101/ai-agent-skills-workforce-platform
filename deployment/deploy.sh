#!/bin/bash
# ═══════════════════════════════════════════════════════════════
#  AI Agent Skills Workforce Platform — One-Click Deploy
#  Starts all 5 Claude Agent Skills + Orchestrator, opens UI
# ═══════════════════════════════════════════════════════════════

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
cd "$ROOT_DIR"

# ── Colours ──────────────────────────────────────────────────────
CYAN='\033[0;36m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'
RED='\033[0;31m'; BOLD='\033[1m'; NC='\033[0m'

echo -e "${CYAN}${BOLD}"
echo "  ╔══════════════════════════════════════════════════╗"
echo "  ║   AI Agent Skills Workforce Platform             ║"
echo "  ║   Claude Agent Skills (Anthropic, Oct 2025)      ║"
echo "  ╚══════════════════════════════════════════════════╝"
echo -e "${NC}"

# ── Check .env ────────────────────────────────────────────────────
if [ ! -f "config/.env" ]; then
  echo -e "${RED}✗ config/.env not found.${NC}"
  echo -e "  Run: ${YELLOW}cp config/.env.example config/.env${NC} and fill in your keys."
  exit 1
fi
export $(grep -v '^#' config/.env | xargs)
echo -e "${GREEN}✓ Environment loaded from config/.env${NC}"

# ── Check Python ──────────────────────────────────────────────────
if ! command -v python3 &>/dev/null; then
  echo -e "${RED}✗ Python 3 not found. Please install Python 3.11+${NC}"; exit 1
fi
echo -e "${GREEN}✓ Python $(python3 --version | cut -d' ' -f2) detected${NC}"

# ── Install dependencies ──────────────────────────────────────────
echo -e "\n${YELLOW}Installing dependencies...${NC}"
pip install -r requirements.txt -q
echo -e "${GREEN}✓ Dependencies installed${NC}"

# ── Kill any existing processes on our ports ──────────────────────
for PORT in 8000 8001 8002 8003 8004 8005; do
  lsof -ti:$PORT | xargs kill -9 2>/dev/null || true
done

# ── Start services ────────────────────────────────────────────────
echo -e "\n${YELLOW}Starting Claude Agent Skills...${NC}\n"

SERVICES=(
  "Orchestrator|orchestration.coordinator|8000"
  "Nova (Infrastructure)|skills.nova.scripts.nova_service|8001"
  "Axiom (Data Pipelines)|skills.axiom.scripts.axiom_service|8002"
  "Sentinel (Testing)|skills.sentinel.scripts.sentinel_service|8003"
  "Nexus (Documentation)|skills.nexus.scripts.nexus_service|8004"
  "Prometheus (Optimisation)|skills.prometheus.scripts.prometheus_service|8005"
)

PIDS=()
for SVC in "${SERVICES[@]}"; do
  IFS='|' read -r NAME MODULE PORT <<< "$SVC"
  PYTHONPATH=. python3 -m uvicorn "${MODULE}:app" \
    --host 0.0.0.0 --port "$PORT" \
    --log-level warning \
    > "logs/${PORT}.log" 2>&1 &
  PIDS+=($!)
  echo -e "  ${GREEN}▶${NC}  ${BOLD}${NAME}${NC} → http://localhost:${PORT}"
  sleep 0.5
done

mkdir -p logs

# ── Wait for orchestrator to be ready ────────────────────────────
echo -e "\n${YELLOW}Waiting for services to be ready...${NC}"
for i in {1..20}; do
  if curl -sf http://localhost:8000/health > /dev/null 2>&1; then
    echo -e "${GREEN}✓ All services healthy${NC}"; break
  fi
  sleep 1
done

# ── Open browser ──────────────────────────────────────────────────
echo -e "\n${GREEN}${BOLD}✓ Platform running! Opening browser...${NC}"
sleep 1

if command -v xdg-open &>/dev/null; then
  xdg-open "docs/index.html"
elif command -v open &>/dev/null; then
  open "docs/index.html"
else
  echo -e "${YELLOW}Open this file in your browser:${NC} docs/index.html"
fi

echo -e "\n${CYAN}Press Ctrl+C to stop all services.${NC}\n"

# ── Trap cleanup ──────────────────────────────────────────────────
cleanup() {
  echo -e "\n${YELLOW}Shutting down all skills...${NC}"
  for PID in "${PIDS[@]}"; do kill "$PID" 2>/dev/null || true; done
  echo -e "${GREEN}✓ All services stopped.${NC}"
}
trap cleanup EXIT INT TERM

wait
