# shellcheck shell=bash
# Checkpoint 00 — Setup
D="$TRILHA_ROOT/checkpoints/00-setup"

section "Sistema"
wsl_only "rodando dentro do WSL" "abra o terminal do Ubuntu, não o Git Bash nem o PowerShell" \
  grep -qi microsoft /proc/version
wsl_only "distribuição Ubuntu" "instale com: wsl --install -d Ubuntu-24.04" \
  grep -q '^ID=ubuntu' /etc/os-release
wsl_only "WSL versão 2 (kernel WSL2)" "no PowerShell: wsl --set-version Ubuntu-24.04 2" \
  bash -c "uname -r | grep -qi wsl2"
wsl_only "systemd ativo (o k3s precisa)" "adicione [boot] systemd=true em /etc/wsl.conf e rode 'wsl --shutdown' no PowerShell" \
  bash -c "[[ \$(ps -p 1 -o comm=) == systemd ]]"
local_only "repo dentro do Linux, não em /mnt/c" "clone o repo em ~/ (ex.: ~/dev/trilha-terminal). /mnt/c é lento e quebra permissões" \
  bash -c "[[ '$TRILHA_ROOT' != /mnt/* ]]"

section "Ferramentas"
for c in git curl vim node npm docker yq; do
  local_only "$c instalado" "veja a seção de instalação de $c na página do módulo 00" has_cmd "$c"
done
local_only "Node 20 ou superior" "instale via nvm: nvm install --lts" \
  bash -c "node -e 'process.exit(Number(process.versions.node.split(\".\")[0]) >= 20 ? 0 : 1)'"
local_only "yq é o da mikefarah (v4)" "o yq do apt/pip é outro programa; instale pelo link da página" \
  bash -c "yq --version | grep -q mikefarah"
local_only "docker roda sem sudo" "sudo usermod -aG docker \$USER e abra um terminal novo" \
  docker info
wsl_only "VS Code integrado ao WSL (comando 'code')" "instale o VS Code no Windows com a extensão WSL e rode 'code .' uma vez" \
  has_cmd code

section "Git"
local_only "user.name configurado" "git config --global user.name 'Seu Nome'" \
  bash -c "[[ -n \$(git config --global user.name) ]]"
local_only "user.email configurado" "git config --global user.email voce@exemplo.com" \
  bash -c "[[ -n \$(git config --global user.email) ]]"
local_only "core.autocrlf = input" "git config --global core.autocrlf input" \
  bash -c "[[ \$(git config --global core.autocrlf) == input ]]"
local_only "branch padrão = main" "git config --global init.defaultBranch main" \
  bash -c "[[ \$(git config --global init.defaultBranch) == main ]]"
local_only "chave SSH autenticando no GitHub" "ssh-keygen -t ed25519 e cadastre a chave pública no GitHub (veja a página)" \
  bash -c "ssh -T -o BatchMode=yes -o StrictHostKeyChecking=accept-new git@github.com 2>&1 | grep -q 'successfully authenticated'"

require_local_evidence "$D"
