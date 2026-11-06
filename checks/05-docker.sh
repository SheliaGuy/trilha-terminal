# shellcheck shell=bash
# Checkpoint 05 — Docker
# shellcheck source=lib/compose.sh
source "$TRILHA_ROOT/lib/compose.sh"
P="$TRILHA_ROOT/projeto"
DF="$P/Dockerfile"

section "Dockerfile"
check "projeto/Dockerfile existe" "crie projeto/Dockerfile" test -f "$DF"
check "imagem base Node com tag fixa (não latest)" "ex.: FROM node:24-alpine" \
  bash -c "grep -Eiq '^FROM +node:[0-9][^ ]*' '$DF' && ! grep -Eiq '^FROM +node(:latest)?( |$)' '$DF'"
check "instala dependências com npm ci" "RUN npm ci --omit=dev" file_has "$DF" 'npm ci'
check "copia package*.json antes do código (cache de camadas)" \
  "COPY package*.json ./ → RUN npm ci → só depois COPY src ./src" \
  bash -c "a=\$(grep -n -E '^COPY .*package' '$DF' | head -1 | cut -d: -f1); b=\$(grep -n -E '^COPY .*(src|\. )' '$DF' | grep -v package | head -1 | cut -d: -f1); [[ -n \$a && -n \$b && \$a -lt \$b ]]"
check "roda como usuário não-root" "a imagem node já tem o usuário 'node': USER node" file_has "$DF" '^USER +[a-z]'
check "EXPOSE 3000" "EXPOSE 3000" file_has "$DF" '^EXPOSE +3000'
check "usa CMD em forma JSON (exec form)" 'CMD ["node", "src/server.js"]' file_has "$DF" '^CMD +\['
check ".dockerignore ignora node_modules" "crie projeto/.dockerignore com node_modules" file_has "$P/.dockerignore" '^/?node_modules'

section "compose.yaml"
C="$P/compose.yaml"
check "projeto/compose.yaml existe" "crie projeto/compose.yaml" test -f "$C"
check "serviço app e serviço db" "dois serviços: app e db" bash -c "grep -Eq '^  app:' '$C' && grep -Eq '^  db:' '$C'"
check "postgres com tag fixa" "image: postgres:17-alpine" file_has "$C" 'image: *postgres:[0-9]'
check "db tem healthcheck (pg_isready)" "healthcheck com pg_isready" file_has "$C" 'pg_isready'
check "app espera o db ficar saudável" "depends_on: db: condition: service_healthy" file_has "$C" 'service_healthy'
check "volume nomeado para os dados do postgres" "volumes: - dados:/var/lib/postgresql/data (e declare 'dados' em volumes: no fim)" \
  bash -c "grep -Eq '^volumes:' '$C' && grep -Eq '[a-z_-]+:/var/lib/postgresql' '$C'"
check "app publicada na porta 3000" "ports: - \"3000:3000\"" file_has "$C" '3000:3000'

section "Rodando de verdade"
if ! has_cmd docker || ! docker info >/dev/null 2>&1; then
  fail "docker disponível" "o Docker precisa estar rodando para este checkpoint"
elif compose_up; then
  ok "compose up --build --wait"
  _h=$(curl -fsS "$APP_URL/health")
  check "/health responde com banco ok" "confira o DATABASE_URL no compose" \
    bash -c "[[ \$(echo '$_h' | node -e 'let d=\"\";process.stdin.on(\"data\",c=>d+=c).on(\"end\",()=>console.log(JSON.parse(d).banco))') == ok ]]"
  _t1=$(curl -fsS -X POST "$APP_URL/visitas" | json_get total)
  _t2=$(curl -fsS -X POST "$APP_URL/visitas" | json_get total)
  check "POST /visitas incrementa ($_t1 → $_t2)" "veja os logs: docker compose logs app" test "$_t2" -eq $((_t1 + 1))
  check "app roda com UID diferente de 0" "USER node no Dockerfile" \
    bash -c "[[ \$(docker compose -p '$COMPOSE_PROJECT' -f '$C' exec -T app id -u) != 0 ]]"
  # Persistência: derruba sem -v e sobe de novo
  dc down >/dev/null 2>&1
  dc up -d --wait --wait-timeout 120 >/dev/null 2>&1
  for _ in $(seq 1 30); do curl -fsS "$APP_URL/health" >/dev/null 2>&1 && break; sleep 1; done
  _t3=$(curl -fsS "$APP_URL/visitas" | json_get total 2>/dev/null || echo 0)
  check "dados sobrevivem a down/up (total $_t3)" "o volume do postgres precisa ser nomeado, não anônimo" test "${_t3:-0}" -ge "$_t2"
  compose_down
else
  fail "compose up --build --wait" "rode 'docker compose up --build' dentro de projeto/ e leia o erro"
  compose_down
fi
