# shellcheck shell=bash
# Helpers para subir o projeto com Docker Compose durante um check.
COMPOSE_FILE="$TRILHA_ROOT/projeto/compose.yaml"
COMPOSE_PROJECT="trilha-check"
APP_URL="http://localhost:3000"

dc() { docker compose -p "$COMPOSE_PROJECT" -f "$COMPOSE_FILE" "$@"; }

compose_up() {
  dc down -v --remove-orphans >/dev/null 2>&1 || true
  if ! dc up -d --build --wait --wait-timeout 120 >/tmp/trilha-compose.log 2>&1; then
    tail -20 /tmp/trilha-compose.log
    return 1
  fi
  # Dá até 30s para a app responder
  local _
  for _ in $(seq 1 30); do
    curl -fsS "$APP_URL/health" >/dev/null 2>&1 && return 0
    sleep 1
  done
  dc logs app | tail -20
  return 1
}

compose_down() { dc down -v --remove-orphans >/dev/null 2>&1 || true; }

json_get() { node -e 'let d="";process.stdin.on("data",c=>d+=c).on("end",()=>{const v=process.argv[1].split(".").reduce((o,k)=>o==null?o:o[k],JSON.parse(d));console.log(typeof v==="object"?JSON.stringify(v):v)})' "$1"; }
export -f json_get
