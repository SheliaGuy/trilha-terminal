# Quando dá errado

Antes de perguntar, faça três coisas: leia a mensagem de erro **inteira**, procure aqui e rode o `./trilha check` do módulo para ver a dica.

## Ao pedir ajuda, mande

```text
O que eu queria fazer:
Comando que rodei:
Saída completa (copiada, não print):
O que eu já tentei:
```

Metade das vezes você descobre a resposta enquanto escreve.

## WSL e sistema

| Sintoma | Correção |
|---|---|
| `0x80370102` / virtualização | Ligar VT-x / AMD-V na BIOS. Em máquina corporativa, falar com o TI |
| `bash\r: No such file or directory` | Arquivo com CRLF: `git config --global core.autocrlf input`, depois clone de novo ou rode `sed -i 's/\r$//' arquivo` |
| Tudo lento no git / npm | Repo em `/mnt/c`. Mova para `~/dev` |
| WSL ocupando muita RAM | `C:\Users\voce\.wslconfig` com `[wsl2]` e `memory=8GB`, depois `wsl --shutdown` |
| Relógio do WSL errado (erros de TLS ou de certificado) | `sudo hwclock -s` ou `wsl --shutdown` |
| `sudo: unable to resolve host` | Hostname ausente em `/etc/hosts`: adicione `127.0.1.1 seu-hostname` |
| DNS não resolve dentro do WSL (VPN corporativa) | Ative o `networkingMode=mirrored` no `.wslconfig` (Windows 11) ou fale com o TI |

## Git

| Sintoma | Correção |
|---|---|
| `Permission denied (publickey)` | Chave SSH não cadastrada no GitHub, ou remote em HTTPS. Teste `ssh -T git@github.com` e veja `git remote -v` |
| `rejected ... (fetch first)` | O remoto tem commits que você não tem: `git pull` (ou rebase) e depois `push` |
| Commitei na branch errada | `git reset --soft HEAD~1`, `git stash`, `git switch certa`, `git stash pop` |
| Abri o vim no commit e travei | `Esc`, `:wq` para confirmar a mensagem, ou `:q!` para cancelar |
| `detached HEAD` | Você fez checkout de um commit, não de uma branch: `git switch -c nova-branch` para salvar o que fez |

## Docker

| Sintoma | Correção |
|---|---|
| `permission denied ... docker.sock` | `sudo usermod -aG docker $USER` e abra um terminal novo |
| `Cannot connect to the Docker daemon` | O serviço está parado: `sudo systemctl start docker` |
| `port is already allocated` | Outro container ou processo usa a porta: `docker ps`, `sudo ss -ltnp \| grep PORTA` |
| `npm ci` falha no build | Falta o `package-lock.json`: rode `npm install` em `projeto/` e commite o lock |
| App não conecta no banco no compose | Use o host `db` (o nome do serviço), não `localhost` |

## Kubernetes / k3s

| Sintoma | Correção |
|---|---|
| `The connection to the server ... was refused` | k3s parado (`sudo systemctl start k3s`) ou `~/.kube/config` desatualizado |
| `ErrImagePull` em imagem sua | Faltou importar: `docker save img:tag \| sudo k3s ctr images import -` |
| `CreateContainerConfigError` | ConfigMap ou Secret com nome ou chave errados. Veja o `describe pod` |
| Pod `Running` mas `0/1` | `readinessProbe` falhando. Confira path e porta e teste com `kubectl exec ... -- wget -qO- localhost:3000/health` |
| `port-forward` cai sozinho | Normal quando o pod reinicia. Rode de novo |
| k3s não sobe no WSL | systemd desligado (módulo 00, passo 5) |
