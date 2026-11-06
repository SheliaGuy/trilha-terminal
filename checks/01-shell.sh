# shellcheck shell=bash
# Checkpoint 01 — Shell
D="$TRILHA_ROOT/checkpoints/01-shell"
LOGS="$TRILHA_ROOT/exercicios/shell"

# Normaliza espaços (o check aceita a saída do uniq -c com ou sem alinhamento)
_norm() { sed -E 's/^[[:space:]]+//; s/[[:space:]]+/ /g; s/ $//' | sha256sum | cut -c1-16; }

# script | log | hash esperado
_esperado=(
  "erros-por-rota|app|0461f03eff1f7dcb"
  "erros-por-rota|app-2|ec6d44cde77b2d7a"
  "top-ips|app|b6580ac71ae2461f"
  "top-ips|app-2|37e9abbde868867f"
  "lentas|app|017242aed0751adb"
  "lentas|app-2|690e07064753123c"
)

section "Arquivos"
for s in erros-por-rota top-ips lentas; do
  f="$D/$s.sh"
  check "$s.sh existe" "crie checkpoints/01-shell/$s.sh" test -f "$f"
  check "$s.sh é executável" "chmod +x $f" test -x "$f"
  check "$s.sh começa com shebang" "primeira linha: #!/usr/bin/env bash" \
    bash -c "head -1 '$f' | grep -q '^#!'"
done

section "Resultados (rodando contra app.log e app-2.log)"
for item in "${_esperado[@]}"; do
  IFS='|' read -r s log hash <<<"$item"
  f="$D/$s.sh"
  if [[ -x "$f" ]]; then
    got=$("$f" "$LOGS/$log.log" 2>/dev/null | _norm)
    if [[ "$got" == "$hash" ]]; then
      ok "$s.sh $log.log"
    else
      fail "$s.sh $log.log: saída diferente do esperado" \
        "rode '$f exercicios/shell/$log.log' e compare com o formato pedido na página do módulo. O script deve usar \$1, não um caminho fixo"
    fi
  else
    fail "$s.sh $log.log" "o script precisa existir e ser executável"
  fi
done
