# Colas rápidas

Uma página para deixar aberta numa aba.

## Shell

| Preciso... | Comando |
|---|---|
| saber onde estou | `pwd` |
| listar tudo, inclusive ocultos | `ls -la` |
| ir para a home / voltar | `cd` / `cd -` |
| criar pastas aninhadas | `mkdir -p a/b/c` |
| copiar ou apagar uma pasta | `cp -r origem destino` / `rm -r pasta` |
| ver o fim de um log ao vivo | `tail -f arquivo.log` |
| buscar texto em arquivos | `grep -rn "texto" pasta/` |
| achar arquivos pelo nome | `find . -name "*.yaml"` |
| contar linhas | `wc -l arquivo` |
| ranking de ocorrências | `... \| sort \| uniq -c \| sort -nr` |
| pegar a coluna N | `awk '{print $N}'` |
| ver o espaço em disco | `df -h` / `du -sh pasta` |
| ver quem usa a porta 3000 | `sudo ss -ltnp \| grep 3000` |
| matar um processo | `kill PID` (só depois: `kill -9 PID`) |
| tornar um script executável | `chmod +x script.sh` |
| testar uma API | `curl -i localhost:3000/health` |
| enviar JSON | `curl -X POST -H 'content-type: application/json' -d '{"a":1}' URL` |
| formatar JSON | `... \| jq .` |

## Vim

| Preciso... | Teclas |
|---|---|
| sair sem salvar / salvar e sair | `Esc` `:q!` / `Esc` `:wq` |
| digitar | `i` (`Esc` volta) |
| apagar, copiar ou colar a linha | `dd` / `yy` / `p` |
| desfazer / refazer | `u` / `Ctrl+R` |
| buscar | `/texto` e depois `n` |
| trocar em todo o arquivo | `:%s/velho/novo/g` |
| ir para a linha 42 / início / fim | `:42` / `gg` / `G` |

## Git

| Preciso... | Comando |
|---|---|
| ver o estado | `git status` |
| ver o histórico como grafo | `git log --oneline --graph --all` |
| nova branch | `git switch -c nome` |
| commitar | `git add -p` e `git commit -m "tipo: msg"` |
| primeiro push da branch | `git push -u origin nome` |
| atualizar | `git pull` (ou `git fetch` + `git rebase origin/main`) |
| descartar a mudança num arquivo | `git restore arquivo` |
| tirar do staging | `git restore --staged arquivo` |
| corrigir o último commit (sem push) | `git commit --amend` |
| desfazer o último commit, mantendo as mudanças | `git reset --soft HEAD~1` |
| desfazer um commit já publicado | `git revert HASH` |
| guardar o trabalho pela metade | `git stash` / `git stash pop` |
| abortar um merge com conflito | `git merge --abort` |
| achar algo "perdido" | `git reflog` |

## Docker

| Preciso... | Comando |
|---|---|
| build com tag | `docker build -t nome:1.0.0 .` |
| rodar publicando a porta | `docker run -d -p 3000:3000 --name x nome:1.0.0` |
| ver os containers | `docker ps -a` |
| logs / entrar | `docker logs -f x` / `docker exec -it x sh` |
| parar e remover | `docker rm -f x` |
| subir / derrubar o compose | `docker compose up -d --build` / `docker compose down` |
| estado do compose | `docker compose ps` / `docker compose logs -f app` |
| liberar espaço | `docker system df` / `docker system prune` |

## kubectl

| Preciso... | Comando |
|---|---|
| ver tudo num namespace | `kubectl get all -n trilha` |
| por que o pod não sobe? | `kubectl describe pod NOME -n trilha` (leia os Events) |
| logs (do container que morreu) | `kubectl logs NOME -n trilha --previous` |
| entrar no pod | `kubectl exec -it NOME -n trilha -- sh` |
| aplicar / remover manifests | `kubectl apply -f pasta/` / `kubectl delete -f pasta/` |
| acessar um Service | `kubectl port-forward svc/app 8080:80 -n trilha` |
| acompanhar o rollout | `kubectl rollout status deploy/app -n trilha` |
| voltar a versão | `kubectl rollout undo deploy/app -n trilha` |
| trocar a imagem | `kubectl set image deploy/app app=img:tag -n trilha` |
| eventos recentes | `kubectl get events -n trilha --sort-by=.lastTimestamp` |
| imagem local → k3s | `docker save img:tag \| sudo k3s ctr images import -` |
| documentação de um campo | `kubectl explain deployment.spec` |

## Jira (JQL)

| Preciso... | JQL |
|---|---|
| minhas issues abertas | `assignee = currentUser() AND resolution = Unresolved` |
| o que não está concluído | `project = TRI AND status != Done` |
| criadas na última semana | `project = TRI AND created >= -7d` |
| ordenar | `... ORDER BY updated DESC` |
