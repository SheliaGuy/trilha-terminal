# shellcheck shell=bash
# Checkpoint 08 — Capstone
# shellcheck source=lib/compose.sh
source "$TRILHA_ROOT/lib/compose.sh"
D="$TRILHA_ROOT/checkpoints/08-capstone"
R="$D/README.md"

section "Pré-requisitos"
_feitos=$(grep -c '^- \[x\] 0[0-7]-' "$TRILHA_ROOT/PROGRESSO.md" 2>/dev/null || true)
check "módulos 00 a 07 concluídos ($_feitos/8)" "./trilha status mostra o que falta" test "${_feitos:-0}" -ge 8

section "Documentação da entrega"
check "README.md do capstone existe" "crie checkpoints/08-capstone/README.md com o modelo da página" test -f "$R"
for s in "Épico" "O que foi entregue" "Como rodar" "Decisões" "O que eu faria diferente"; do
  check "seção '## $s'" "use exatamente os títulos do modelo" file_has "$R" "^## $s"
done
check "README cita a chave do épico no Jira" "ex.: Épico: TRI-30" file_has "$R" '[A-Z][A-Z0-9]+-[0-9]+'

section "Versão"
check "tag v1.0.0 no repositório" "git tag -a v1.0.0 -m 'capstone' && git push origin v1.0.0" \
  bash -c "git -C '$TRILHA_ROOT' rev-parse -q --verify 'refs/tags/v1.0.0'"
check "package.json na versão 1.0.0" "\"version\": \"1.0.0\" em projeto/package.json" \
  file_has "$TRILHA_ROOT/projeto/package.json" '"version": *"1\.0\.0"'

section "Feature /notas (via Docker Compose)"
if ! has_cmd docker || ! docker info >/dev/null 2>&1; then
  fail "docker disponível" "o Docker precisa estar rodando para este checkpoint"
elif compose_up; then
  ok "compose up --build --wait"
  check "/health mostra versao 1.0.0" "APP_VERSION: 1.0.0 no compose.yaml" \
    bash -c "[[ \$(curl -fsS '$APP_URL/health' | json_get versao) == 1.0.0 ]]"
  _c=$(curl -sS -o /dev/null -w '%{http_code}' -X POST -H 'content-type: application/json' -d '{"texto":"primeira nota"}' "$APP_URL/notas")
  check "POST /notas com texto → 201 (veio $_c)" "leia o corpo da requisição, grave no postgres e devolva 201" test "$_c" = 201
  _c=$(curl -sS -o /dev/null -w '%{http_code}' -X POST -H 'content-type: application/json' -d '{}' "$APP_URL/notas")
  check "POST /notas sem texto → 400 (veio $_c)" "valide a entrada antes de gravar" test "$_c" = 400
  _c=$(curl -sS -o /dev/null -w '%{http_code}' -X POST -H 'content-type: application/json' -d 'isso não é json' "$APP_URL/notas")
  check "POST /notas com JSON inválido → 400 (veio $_c)" "trate o erro do JSON.parse" test "$_c" = 400
  check "GET /notas lista a nota criada" "devolva um array com {id, texto, criada_em}" \
    bash -c "curl -fsS '$APP_URL/notas' | node -e 'let d=\"\";process.stdin.on(\"data\",c=>d+=c).on(\"end\",()=>{const a=JSON.parse(d);process.exit(Array.isArray(a)&&a.some(n=>n.texto===\"primeira nota\"&&n.id)?0:1)})'"
  compose_down
else
  fail "compose up --build --wait" "rode 'docker compose up --build' dentro de projeto/ e leia o erro"
  compose_down
fi

section "No cluster"
local_only "deployment app rodando a imagem 1.0.0" "importe a imagem nova no k3s e atualize o manifest" \
  bash -c "[[ \$(kubectl -n trilha get deploy app -o jsonpath='{.spec.template.spec.containers[0].image}') == *:1.0.0 ]] && [[ \$(kubectl -n trilha get deploy app -o jsonpath='{.status.readyReplicas}') -ge 2 ]]"
local_only "GET /notas responde no cluster" "kubectl -n trilha port-forward svc/app 8080:80" bash -c '
  kubectl -n trilha port-forward svc/app 18081:80 >/dev/null 2>&1 & pf=$!
  for _ in $(seq 1 15); do curl -fsS localhost:18081/notas >/dev/null 2>&1 && { kill $pf; exit 0; }; sleep 1; done
  kill $pf; exit 1'

require_local_evidence "$D"
