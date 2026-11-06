# shellcheck shell=bash
# Checkpoint 07 — Claude Code
# shellcheck source=lib/app.sh
source "$TRILHA_ROOT/lib/app.sh"
# shellcheck source=lib/compose.sh
source "$TRILHA_ROOT/lib/compose.sh"
D="$TRILHA_ROOT/checkpoints/07-claude-code"

section "Ferramenta"
local_only "claude instalado" "curl -fsSL https://claude.ai/install.sh | bash (dentro do Ubuntu)" has_cmd claude

section "Contexto do projeto"
M="$TRILHA_ROOT/CLAUDE.md"
check "CLAUDE.md na raiz do repo" "rode /init dentro do claude e depois edite o resultado" test -f "$M"
check "CLAUDE.md tem pelo menos 20 linhas" "um CLAUDE.md útil explica estrutura, comandos e convenções" \
  bash -c "[[ \$(grep -c . '$M') -ge 20 ]]"
check "CLAUDE.md explica como rodar e testar" "inclua os comandos: npm start, docker compose up, ./trilha check" \
  bash -c "grep -q 'docker compose' '$M' && grep -q 'trilha check' '$M'"
check "CLAUDE.md registra as convenções de commit" "cite Conventional Commits e a chave do Jira" file_has "$M" '([Cc]onventional|feat:|chave)'

section "Skill"
_skill=$(ls "$TRILHA_ROOT"/.claude/skills/*/SKILL.md 2>/dev/null | head -1)
check "existe .claude/skills/<nome>/SKILL.md" "crie a pasta da skill e o SKILL.md (veja a página)" test -n "$_skill"
if [[ -n "$_skill" ]]; then
  check "SKILL.md tem frontmatter com description" "comece o arquivo com --- / description: ... / ---" \
    bash -c "head -1 '$_skill' | grep -q '^---$' && sed -n '2,/^---$/p' '$_skill' | grep -q '^description: *[^ ]'"
  check "SKILL.md tem instruções (10+ linhas depois do frontmatter)" "descreva os passos que o Claude deve seguir" \
    bash -c "[[ \$(awk 'c>=2{print} /^---$/{c++}' '$_skill' | grep -c .) -ge 10 ]]"
fi

section "MCP"
J="$TRILHA_ROOT/.mcp.json"
check ".mcp.json na raiz" "claude mcp add --scope project ... cria esse arquivo" test -f "$J"
check ".mcp.json é JSON válido com pelo menos 1 servidor" "confira vírgulas e chaves; deve ter mcpServers" \
  node -e 'const j=require(process.argv[1]); if(!j.mcpServers||!Object.keys(j.mcpServers).length) process.exit(1)' "$J"
check ".mcp.json não tem segredo em texto puro" "use \${VARIAVEL} em vez do token direto" \
  bash -c "! grep -Eiq '\"[^\"]*(token|key|password|secret)[^\"]*\" *: *\"[^\$][^\"]{8,}\"' '$J'"

section "Prompts"
P="$D/prompts.md"
check "prompts.md existe" "crie checkpoints/07-claude-code/prompts.md" test -f "$P"
check "pelo menos 3 prompts registrados" "um '## Prompt N' para cada" bash -c "[[ \$(grep -c '^## ' '$P') -ge 3 ]]"
check "cada prompt tem contexto e critério de aceite" "use o modelo da página: Contexto / Tarefa / Critério de aceite" \
  bash -c "[[ \$(grep -ci 'contexto' '$P') -ge 3 && \$(grep -Eci 'crit(e|é)rio' '$P') -ge 3 ]]"
check "prompts.md tem uma reflexão sobre o que o Claude errou" "seção '## O que precisei corrigir'" file_has "$P" '[Cc]orrigir'

section "Feature: GET /sobre"
if app_start; then
  _s=$(curl -fsS "http://localhost:$APP_PORT/sobre" 2>/dev/null || true)
  check "GET /sobre responde 200 com JSON" "implemente a rota em projeto/src/server.js" test -n "$_s"
  check "/sobre traz 'autor' preenchido" '{"autor": "Seu Nome", ...}' bash -c "[[ -n \$(echo '$_s' | json_get autor 2>/dev/null) && \$(echo '$_s' | json_get autor) != undefined ]]"
  check "/sobre traz modulos = 9" '{"modulos": 9, ...}' bash -c "[[ \$(echo '$_s' | json_get modulos 2>/dev/null) == 9 ]]"
  check "/sobre traz a versão da app" '{"versao": "<APP_VERSION>", ...}' bash -c "[[ \$(echo '$_s' | json_get versao 2>/dev/null) == dev ]]"
  app_stop
else
  fail "a app sobe com 'node src/server.js'" "rode cd projeto && npm start e leia o erro"
fi
