# shellcheck shell=bash
# Sobe a app com node direto (sem banco) numa porta livre, para checks rápidos.
app_start() {
  APP_PORT=$((20000 + RANDOM % 20000))
  (cd "$TRILHA_ROOT/projeto" && PORT=$APP_PORT APP_VERSION="${1:-dev}" exec node src/server.js) >/tmp/trilha-app.log 2>&1 &
  APP_PID=$!
  local _
  for _ in $(seq 1 20); do
    curl -fsS "http://localhost:$APP_PORT/health" >/dev/null 2>&1 && return 0
    sleep 0.3
  done
  return 1
}
app_stop() { [[ -n "${APP_PID:-}" ]] && kill "$APP_PID" 2>/dev/null; wait "$APP_PID" 2>/dev/null || true; }
