# shellcheck shell=bash
# Checkpoint 04 — Jira
D="$TRILHA_ROOT/checkpoints/04-jira"
_key='[A-Z][A-Z0-9]+-[0-9]+'

section "Board"
check "board.md existe" "crie checkpoints/04-jira/board.md" test -f "$D/board.md"
check "board.md tem o link do seu board no Jira Cloud" "cole a URL do board (https://SEU-SITE.atlassian.net/...)" \
  file_has "$D/board.md" 'https://[a-z0-9-]+\.atlassian\.net/'
check "board.md lista a chave do projeto" "ex.: 'Chave do projeto: TRI'" file_has "$D/board.md" '[Cc]have[^:]*: *[A-Z][A-Z0-9]+'

section "JQL"
check "jql.md existe" "crie checkpoints/04-jira/jql.md com as consultas pedidas" test -f "$D/jql.md"
check "consulta com currentUser()" "minhas issues: assignee = currentUser()" file_has "$D/jql.md" 'currentUser\(\)'
check "consulta filtrando status" "ex.: status = \"In Progress\" ou status != Done" file_has "$D/jql.md" '[Ss]tatus *(=|!=|in|not in|IN|NOT IN)'
check "consulta com ORDER BY" "ex.: ORDER BY updated DESC" file_has "$D/jql.md" 'ORDER BY'
check "consulta por data relativa" "ex.: created >= -7d" file_has "$D/jql.md" '(created|updated|resolved) *>= *-[0-9]+[dwh]'

section "Rastreabilidade git ↔ Jira"
_n=$(git -C "$TRILHA_ROOT" log --no-merges --format='%ae|%s' HEAD | grep -v '^bot@trilha.local|' | grep -Ec "\|.*$_key" || true)
check "pelo menos 3 commits com a chave da issue (tem $_n)" "ex.: 'feat: TRI-12 adiciona rota /sobre' ou 'TRI-12 docs: ...'" test "$_n" -ge 3
check "pelo menos 1 merge/PR de uma branch com a chave da issue" "nomeie a branch como TRI-12-descricao e faça o merge via PR" \
  bash -c "git -C '$TRILHA_ROOT' log --merges --format='%s' HEAD | grep -Eq '$_key'"
