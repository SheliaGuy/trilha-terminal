# 00 · Setup: WSL 2 + Ubuntu

**Tempo:** 2 dias · **Saída:** um Ubuntu de verdade rodando no Windows, com git, Node, Docker e yq. Também o seu repositório da trilha clonado dentro dele.

## Por que sair do Git Bash

O Git Bash é um "Linux de mentira": serve para rodar git, mas os servidores, os containers e o Kubernetes rodam Linux de verdade. O **WSL 2** roda um kernel Linux real dentro do Windows. Com ele, o que você aprende aqui é exatamente o que vai usar num servidor.

Depois deste módulo, o Git Bash pode ser desinstalado.

## Você consegue...

- [ ] abrir o Ubuntu no Windows Terminal
- [ ] explicar a diferença entre `~` (Linux) e `/mnt/c` (Windows)
- [ ] abrir uma pasta do Linux no VS Code com `code .`
- [ ] rodar `docker run hello-world` sem `sudo`
- [ ] fazer `git clone` via SSH

## 1. Instalar WSL 2 e Ubuntu

Abra o **PowerShell como Administrador** e rode:

```powershell
wsl --install -d Ubuntu-24.04
```

Reinicie o Windows quando pedir. Ao abrir o Ubuntu pela primeira vez, ele pede um **usuário e senha do Linux**. Esse usuário não precisa ser igual ao do Windows. Anote a senha: ela é a do `sudo`.

Confira se está na versão 2:

```powershell
wsl -l -v
```

A coluna `VERSION` precisa mostrar `2`. Se mostrar `1`, rode `wsl --set-version Ubuntu-24.04 2`.

!!! failure "Erro de virtualização"
    Mensagens como `0x80370102` ou "Please enable the Virtual Machine Platform" significam virtualização desligada na BIOS/UEFI (Intel VT-x / AMD-V). Em máquina da empresa, peça para o TI. Isso não se resolve por software.

## 2. Windows Terminal e VS Code

- Instale o **Windows Terminal** pela Microsoft Store, se ainda não tiver. Em *Configurações → Inicialização → Perfil padrão*, escolha **Ubuntu-24.04**.
- Instale o **VS Code no Windows**, e não dentro do Ubuntu. Depois instale a extensão **WSL** (da Microsoft).
- No Ubuntu, rode `code .`. Na primeira vez, ele instala o servidor do VS Code no Linux. O canto inferior esquerdo deve mostrar `WSL: Ubuntu-24.04`.

## 3. Onde ficam os arquivos (o erro nº 1)

| Caminho | O que é | Use para |
|---|---|---|
| `/home/voce` (ou `~`) | disco do Linux | **todo código e todo repo** |
| `/mnt/c/Users/voce` | o seu C: do Windows, visto pelo Linux | pegar um arquivo pontual |
| `\\wsl$\Ubuntu-24.04\home\voce` | o Linux visto pelo Explorer do Windows | abrir arquivos no Explorer |

!!! danger "Nunca trabalhe em /mnt/c"
    Repositório em `/mnt/c` fica **várias vezes mais lento** (git, npm, docker build). Também quebra permissões de arquivo (`chmod` não funciona direito) e o file watching. O check do módulo falha se o seu repo estiver lá.

## 4. Atualizar o Ubuntu e instalar o básico

```bash
sudo apt update && sudo apt upgrade -y
sudo apt install -y git curl wget vim build-essential unzip jq ca-certificates
```

`apt` é o gerenciador de pacotes do Ubuntu. `sudo` roda o comando como administrador e pede a senha que você criou no passo 1.

## 5. Ligar o systemd (o k3s precisa)

```bash
ps -p 1 -o comm=
```

Se a saída for `systemd`, pule este passo. Se for `init`, edite o arquivo de configuração do WSL:

```bash
sudo vim /etc/wsl.conf
```

Ainda não sabe vim? Aperte `i`, cole o conteúdo abaixo, aperte `Esc`, digite `:wq` e `Enter`.

```ini
[boot]
systemd=true
```

Depois, no **PowerShell**, rode `wsl --shutdown`, e abra o Ubuntu de novo.

## 6. Git

```bash
git config --global user.name "Seu Nome"
git config --global user.email "voce@exemplo.com"   # o mesmo e-mail da sua conta GitHub
git config --global init.defaultBranch main
git config --global core.autocrlf input
git config --global core.editor vim
git config --global pull.rebase false
```

!!! info "Por que `core.autocrlf input`"
    O Windows termina linhas com `CRLF` e o Linux com `LF`. Com `input`, o git converte para `LF` ao commitar e não mexe ao fazer checkout. Sem isso, scripts quebram com o erro `/usr/bin/env: 'bash\r': No such file or directory`.

## 7. Chave SSH no GitHub

```bash
ssh-keygen -t ed25519 -C "voce@exemplo.com"   # Enter em tudo; uma senha é opcional
cat ~/.ssh/id_ed25519.pub
```

Copie a linha inteira que começa com `ssh-ed25519`. No GitHub, vá em **Settings → SSH and GPG keys → New SSH key**, cole e salve. Depois teste:

```bash
ssh -T git@github.com
# Hi SEU-USUARIO! You've successfully authenticated...
```

A chave **privada** (`id_ed25519`, sem `.pub`) nunca sai da sua máquina. Não cole em lugar nenhum.

## 8. Node.js (via nvm)

O `nvm` instala o Node no seu usuário e permite trocar de versão sem `sudo`. Copie o comando de instalação do README em [github.com/nvm-sh/nvm](https://github.com/nvm-sh/nvm#installing-and-updating), feche e abra o terminal, e rode:

```bash
nvm install --lts
node -v && npm -v
```

## 9. Docker Engine dentro do Ubuntu

Vamos usar o Docker Engine instalado **dentro do WSL**, sem o Docker Desktop:

```bash
curl -fsSL https://get.docker.com | sudo sh
sudo usermod -aG docker "$USER"
```

Feche o terminal, abra de novo e teste:

```bash
docker run --rm hello-world
docker compose version
```

??? question "E o Docker Desktop?"
    Também funciona, com o backend WSL 2 e a integração com a distro Ubuntu ligada. Mas não instale os dois juntos. O Docker Desktop tem licença paga para empresas acima de um certo porte. Verifique a política da sua empresa.

## 10. yq

O `yq` lê e edita YAML na linha de comando, e os checks dos módulos 06 e 08 usam ele.

!!! warning "Não use o yq do apt nem do pip"
    O `yq` do `apt` e do `pip` é outro programa, com sintaxe diferente. Instale o da mikefarah, que é o que o resto do mundo usa.

```bash
sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
sudo chmod +x /usr/local/bin/yq
yq --version   # deve mencionar mikefarah
```

## 11. Crie seu repositório e rode o checkpoint

Siga o passo 2 de [Como usar](../como-usar.md) para criar o seu repo pelo template e cloná-lo em `~/dev`. Então:

```bash
cd ~/dev/trilha-terminal
./trilha check 00
```

<div class="checkpoint" markdown>
**Checkpoint 00:** `./trilha check 00` todo verde. Commite `checkpoints/00-setup/.check` e o `PROGRESSO.md` numa branch e abra o seu primeiro PR. Se o PR ainda parece mágica, tudo bem: o módulo 03 explica.

Usa Linux nativo ou macOS? Rode `TRILHA_SEM_WSL=1 ./trilha check 00`.
</div>

## Erros comuns

| Sintoma | Causa provável | Correção |
|---|---|---|
| `permission denied while trying to connect to the Docker daemon socket` | Usuário fora do grupo `docker`, ou terminal antigo | `sudo usermod -aG docker $USER` e abrir um terminal **novo** |
| `code: command not found` | Extensão WSL não instalada, ou VS Code instalado dentro do Ubuntu | Instale o VS Code no Windows + extensão WSL |
| `bash\r: No such file or directory` | Arquivo com CRLF | `git config --global core.autocrlf input` e clone de novo |
| Tudo lento | Repo em `/mnt/c` | Mova para `~/dev` |
| WSL comendo toda a RAM | Sem limite configurado | Crie `C:\Users\voce\.wslconfig` com `[wsl2]` e `memory=8GB`, e rode `wsl --shutdown` |
