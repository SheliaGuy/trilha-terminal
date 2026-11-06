# shellcheck shell=bash
# Funções compartilhadas pelos checks. Não execute direto: é carregado por ./trilha.

: "${TRILHA_CI:=0}"
: "${TRILHA_ROOT:?TRILHA_ROOT não definido}"

PASS=0
FAIL=0
SKIP=0

if [[ -t 1 && "${NO_COLOR:-}" == "" ]]; then
  C_OK=$'\e[32m'; C_FAIL=$'\e[31m'; C_SKIP=$'\e[33m'; C_DIM=$'\e[2m'; C_RST=$'\e[0m'
else
  C_OK=""; C_FAIL=""; C_SKIP=""; C_DIM=""; C_RST=""
fi

ok()   { PASS=$((PASS + 1)); printf '  %s✔%s %s\n' "$C_OK" "$C_RST" "$1"; }
fail() {
  FAIL=$((FAIL + 1))
  printf '  %s✘%s %s\n' "$C_FAIL" "$C_RST" "$1"
  [[ -n "${2:-}" ]] && printf '    %sdica: %s%s\n' "$C_DIM" "$2" "$C_RST"
  return 0
}
skip() { SKIP=$((SKIP + 1)); printf '  %s–%s %s %s(pulado: %s)%s\n' "$C_SKIP" "$C_RST" "$1" "$C_DIM" "$2" "$C_RST"; }

# check "descrição" "dica se falhar" comando args...
check() {
  local desc="$1" hint="$2"
  shift 2
  if "$@" >/dev/null 2>&1; then ok "$desc"; else fail "$desc" "$hint"; fi
}

# Itens que só fazem sentido na máquina do aluno (WSL, k3s...).
# No CI eles são pulados e o CI confere a evidência gravada pelo check local.
local_only() {
  local desc="$1" hint="$2"
  shift 2
  if [[ "$TRILHA_CI" == "1" ]]; then
    skip "$desc" "só roda na sua máquina"
  else
    check "$desc" "$hint" "$@"
  fi
}

# Itens específicos do WSL. Quem usa Linux nativo ou macOS pode pular com TRILHA_SEM_WSL=1.
wsl_only() {
  if [[ "${TRILHA_SEM_WSL:-0}" == "1" ]]; then
    skip "$1" "TRILHA_SEM_WSL=1"
  else
    local_only "$@"
  fi
}

in_ci() { [[ "$TRILHA_CI" == "1" ]]; }

has_cmd() { command -v "$1" >/dev/null 2>&1; }

file_has() { [[ -f "$1" ]] && grep -Eq -- "$2" "$1"; }

sha_of() { sha256sum "$1" | cut -d' ' -f1; }

# No CI, módulos que dependem do ambiente local exigem a evidência do check local.
require_local_evidence() {
  local dir="$1"
  if in_ci; then
    check "evidência do check local em $dir/.check" \
      "rode './trilha check' na sua máquina e commite o arquivo .check" \
      grep -q '^RESULTADO: OK' "$dir/.check"
  fi
}

section() { printf '\n%s%s%s\n' "$C_DIM" "$1" "$C_RST"; }
