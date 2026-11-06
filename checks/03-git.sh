# shellcheck shell=bash
# Checkpoint 03 — Git
D="$TRILHA_ROOT/checkpoints/03-git"
F="$D/equipe.md"
_git() { git -C "$TRILHA_ROOT" "$@"; }

section "Repositório"
check "histórico completo disponível" "no CI, o checkout precisa de fetch-depth: 0" \
  bash -c "[[ \$(git -C '$TRILHA_ROOT' rev-parse --is-shallow-repository) == false ]]"

section "Conflito resolvido"
_b=$(_git log --all --format='%H %s' 2>/dev/null | awk '/\[trilha-b\]/{print $1; exit}')
_a=$(_git log --all --format='%H %s' 2>/dev/null | awk '/\[trilha-a\]/{print $1; exit}')
check "exercício preparado (commits [trilha-a] e [trilha-b] existem)" "./trilha exercicio 03" \
  test -n "$_a" -a -n "$_b"
if [[ -n "$_a" && -n "$_b" ]]; then
  check "conflito-a está no seu histórico" "git merge exercicio/conflito-a" _git merge-base --is-ancestor "$_a" HEAD
  check "conflito-b entrou por um merge commit" "git merge exercicio/conflito-b e resolva o conflito" \
    bash -c "git -C '$TRILHA_ROOT' log --merges --format=%P HEAD | grep -q '$_b'"
fi
check "equipe.md sem marcadores de conflito" "procure por <<<<<<<, ======= e >>>>>>> e apague-os" \
  bash -c "[[ -f '$F' ]] && ! grep -Eq '^(<<<<<<<|=======|>>>>>>>)' '$F'"
check "linha final: | Tech lead | Ana, Bruno |" "a resolução combina os dois lados: Ana, Bruno" \
  grep -Eq '^\| Tech lead \| Ana, Bruno \|$' "$F"
check "seu nome na linha Dev (em um commit seu)" "edite a linha '| Dev | (definir) |' e commite" \
  bash -c "grep -Eq '^\| Dev \| [^(].* \|$' '$F'"

section "Seus commits"
_meus=$(_git log --no-merges --format='%ae|%s' HEAD -- checkpoints/03-git .gitignore | grep -v '^bot@trilha.local|' || true)
_n=$(printf '%s' "$_meus" | grep -c . || true)
check "pelo menos 3 commits seus no módulo (tem $_n)" "commits pequenos: um por mudança" test "$_n" -ge 3
_fora=$(printf '%s\n' "$_meus" | grep . | cut -d'|' -f2- | grep -Evc '^(feat|fix|docs|chore|refactor|test|style)(\([a-z0-9-]+\))?!?: .+' || true)
check "mensagens no padrão Conventional Commits ($_fora fora do padrão)" \
  "formato: 'tipo: descrição', ex.: 'docs: resolve conflito da equipe'. Corrija com git commit --amend ou rebase -i" \
  test "$_fora" -eq 0

section ".gitignore"
check ".env do projeto é ignorado" "adicione a linha .env no .gitignore da raiz" \
  bash -c "cd '$TRILHA_ROOT' && git check-ignore -q projeto/.env"
check "nenhum .env commitado" "git rm --cached projeto/.env" \
  bash -c "! git -C '$TRILHA_ROOT' ls-files | grep -Eq '(^|/)\.env$'"

section "Desfazendo coisas"
check "desfazer.md existe" "crie checkpoints/03-git/desfazer.md (veja os 4 cenários na página)" test -f "$D/desfazer.md"
for c in "git restore" "git reset --soft" "git revert" "git stash"; do
  check "desfazer.md cita '$c'" "responda o cenário correspondente na página do módulo" file_has "$D/desfazer.md" "$c"
done
