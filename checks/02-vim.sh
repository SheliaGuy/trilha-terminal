# shellcheck shell=bash
# Checkpoint 02 — Vim
F="$TRILHA_ROOT/checkpoints/02-vim/config.yaml"

section "Arquivo"
check "checkpoints/02-vim/config.yaml existe" \
  "cp exercicios/vim/config-quebrado.yaml checkpoints/02-vim/config.yaml && vim checkpoints/02-vim/config.yaml" \
  test -f "$F"

# Conteúdo sem comentários, sem espaços no fim e sem linhas em branco
_limpo() { sed -E 's/(^|[[:space:]])#.*$//; s/[[:space:]]+$//' "$F" | grep -v '^$'; }

if [[ -f "$F" ]]; then
  section "Correções"
  check "TODO 1: versão 1.0.0" "use cw sobre o 0.0.9" bash -c "grep -Eq '^  versao: 1\.0\.0$' <(sed -E 's/[[:space:]]+$//' '$F')"
  check "TODO 2: log_nivel indentado com 2 espaços" "vá ao início da linha com 0 e apague 2 espaços com 2x (ou use << se seu .vimrc tiver shiftwidth=2)" \
    bash -c "grep -Eq '^  log_nivel: info' '$F'"
  check "TODO 3: nenhum trilha-stg sobrou" ":%s/trilha-stg/trilha-prd/g" bash -c "! grep -v '^[[:space:]]*#' '$F' | grep -q 'trilha-stg'"
  check "TODO 3: trilha-prd aparece 3 vezes" ":%s/trilha-stg/trilha-prd/g" bash -c "[[ \$(grep -v '^[[:space:]]*#' '$F' | grep -o 'trilha-prd' | wc -l) -eq 3 ]]"
  check "TODO 4: bloco legado removido" "posicione na linha 'legado:' e use 3dd" bash -c "! grep -Eq 'legado:|velho\.interno|ativo: true' '$F'"
  check "TODO 5: rota /sobre logo abaixo de /visitas" "na linha '- /visitas': yyp, depois cw ou R" \
    bash -c "grep -v '^[[:space:]]*#' '$F' | grep -A1 -- '- /visitas' | grep -q -- '^  - /sobre'"
  check "TODO 6: timeout_ms corrigido" "/timout, n, e depois i para inserir o 'e'" bash -c "grep -q 'timeout_ms: 5000' '$F' && ! grep -q 'timout' <(grep -v '^[[:space:]]*#' '$F')"

  section "Resultado final"
  got=$(_limpo | sha256sum | cut -c1-16)
  if [[ "$got" == "566fd290c50644a4" ]]; then
    ok "arquivo idêntico ao esperado (ignorando comentários)"
  else
    fail "o arquivo ainda difere do esperado" "confira indentação (2 espaços por nível) e se não sobrou nenhuma linha extra"
  fi
fi

section "Seu vim"
local_only "~/.vimrc existe com 'set number'" "crie ~/.vimrc com as linhas sugeridas na página do módulo" \
  bash -c "grep -Eq '^[[:space:]]*set (nu|number)' ~/.vimrc"
