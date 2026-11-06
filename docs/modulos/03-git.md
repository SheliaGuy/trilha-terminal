# 03 · Git do dia a dia

**Tempo:** 3 dias · **Saída:** você trabalha em branch, abre PR, resolve conflito sem medo e sabe desfazer as besteiras mais comuns.

## Você consegue...

- [ ] explicar working tree, staging e commit sem olhar a página
- [ ] ler `git status` e saber o próximo comando
- [ ] criar uma branch, commitar, dar push e abrir um PR
- [ ] resolver um conflito de merge na mão
- [ ] desfazer: mudança não commitada, último commit, commit já publicado
- [ ] guardar trabalho pela metade com `stash`

## 1. O modelo mental

```text
 working tree  ──git add──►  staging (index)  ──git commit──►  repositório local  ──git push──►  remoto (GitHub)
 (seus arquivos)             (o que vai no                    (histórico)                     (origin)
                              próximo commit)
                                                               ◄───────── git fetch / git pull ──────────
```

- Um **commit** é uma foto do projeto inteiro, com autor, data, mensagem e um ponteiro para o commit anterior.
- Uma **branch** é só um ponteiro móvel para um commit.
- `HEAD` aponta para onde você está agora.

Entendeu isso, entendeu o git.

## 2. Ciclo básico

```bash
git status                     # SEMPRE. Antes e depois de tudo.
git diff                       # o que mudou e ainda não está no staging
git add arquivo.txt            # coloca no staging (git add -p escolhe pedaço por pedaço)
git diff --staged              # o que vai entrar no commit
git commit -m "docs: explica como rodar o projeto"
git log --oneline --graph --all   # o histórico como um grafo
git show HEAD                  # detalhes do último commit
```

!!! tip "Alias que vale ouro"
    `git config --global alias.lg "log --oneline --graph --all --decorate"`, e depois é só usar `git lg`.

### Mensagens de commit: Conventional Commits

```text
tipo: descrição curta no imperativo, sem ponto final
```

| Tipo | Quando usar |
|---|---|
| `feat` | funcionalidade nova |
| `fix` | correção de bug |
| `docs` | só documentação |
| `refactor` | muda o código sem mudar o comportamento |
| `test` | testes |
| `chore` | manutenção (deps, config, build) |

O check deste módulo **reprova** commits fora desse padrão.

## 3. Branches

```bash
git switch -c feat/minha-coisa     # cria e entra na branch
git switch main                    # volta para a main
git branch                         # lista as locais (-a inclui as remotas)
git branch -d feat/minha-coisa     # apaga uma branch já mergeada
```

`git checkout` faz tudo isso também, mas mistura coisas demais. Prefira `switch` (para branches) e `restore` (para arquivos).

## 4. Remoto, push e PR

```bash
git remote -v                         # para onde 'origin' aponta
git push -u origin feat/minha-coisa   # o primeiro push da branch (-u liga a local à remota)
git push                              # os próximos pushes
git fetch                             # baixa as novidades sem mexer nos seus arquivos
git pull                              # fetch + merge na branch atual
```

Depois do push, o GitHub mostra o botão **Compare & pull request**. Um bom PR tem:

- título no mesmo padrão do commit
- descrição dizendo **o que** mudou, **por quê** e **como testar**
- o tamanho certo: um PR com mais de ~400 linhas ninguém revisa de verdade

## 5. Merge e conflito

Conflito acontece quando duas branches mudam **a mesma linha**. O git não adivinha qual versão vale e pede para você decidir. Não é erro, é o git perguntando.

```text
<<<<<<< HEAD
| Tech lead | Ana |
=======
| Tech lead | Bruno |
>>>>>>> exercicio/conflito-b
```

Para resolver:

1. Edite o arquivo e deixe o conteúdo final certo, **sem** as linhas `<<<<<<<`, `=======` e `>>>>>>>`.
2. Rode `git add arquivo`.
3. Rode `git commit` (sem `-m`: o git já sugere a mensagem do merge; salve com `:wq`).

Errou no meio? `git merge --abort` volta para antes do merge.

## 6. Desfazendo coisas

| Situação | Comando | Reescreve o histórico? |
|---|---|---|
| Mudei um arquivo e quero voltar ao último commit | `git restore arquivo` | não (mas **perde** a mudança) |
| Dei `git add` sem querer | `git restore --staged arquivo` | não |
| Errei a mensagem do último commit (ainda sem push) | `git commit --amend` | sim |
| Quero desfazer o último commit, mas manter as mudanças | `git reset --soft HEAD~1` | sim |
| Quero jogar fora o último commit e as mudanças | `git reset --hard HEAD~1` | sim (**perigoso**) |
| O commit **já foi para o remoto** e preciso desfazer | `git revert <hash>` | não: cria um commit novo que desfaz |
| Preciso trocar de branch mas estou no meio de algo | `git stash` → … → `git stash pop` | não |

!!! danger "Regra de ouro"
    Nunca reescreva o histórico (`reset`, `amend`, `rebase`) de algo que **outras pessoas já puxaram**. Se o commit já está no remoto compartilhado, use `revert`.

**Se perdeu algo, não entre em pânico:** `git reflog` lista todos os lugares por onde o `HEAD` passou, e dá para voltar com `git reset --hard <hash-do-reflog>`.

## 7. Rebase, só o básico

```bash
git switch feat/minha-coisa
git fetch
git rebase origin/main     # reaplica os seus commits em cima da main mais nova
```

O resultado é um histórico linear, sem o commit "Merge branch main into...". Se der conflito, resolva, rode `git add` e depois `git rebase --continue` (ou `--abort`). Na sua branch pessoal, use à vontade. Em branch compartilhada, veja a regra de ouro.

## Checkpoint

**Parte A: conflito**

```bash
git switch main && git pull
./trilha exercicio 03            # cria exercicio/conflito-a e exercicio/conflito-b
git switch -c feat/03-git
git merge exercicio/conflito-a   # entra sem conflito
git merge exercicio/conflito-b   # CONFLITO, e é esse o objetivo
```

Resolva o conflito deixando a linha **exatamente** assim, com os dois nomes:

```text
| Tech lead | Ana, Bruno |
```

Finalize o merge. Depois, num **commit seu**, troque `| Dev | (definir) |` pelo seu nome.

**Parte B: .gitignore**

Adicione `.env` ao `.gitignore` da raiz. Teste com `touch projeto/.env` e `git status`: o arquivo não pode aparecer.

**Parte C: desfazer**

Crie `checkpoints/03-git/desfazer.md` respondendo, com o comando e uma frase de explicação para cada:

1. Editei `projeto/src/server.js`, não gostei e quero voltar como estava.
2. Fiz um commit, ainda não dei push, e esqueci de incluir um arquivo.
3. Um commit com bug já está na `main` do remoto e o time já puxou.
4. Estou no meio de uma alteração e preciso corrigir algo urgente em outra branch.

Teste cada comando de verdade no seu repo antes de escrever.

**Finalizando**

```bash
./trilha check 03
git push -u origin feat/03-git    # abra o PR e faça o merge quando o CI ficar verde
```

<div class="checkpoint" markdown>
**Checkpoint 03:** conflito resolvido via merge commit, pelo menos 3 commits seus no padrão Conventional Commits, `.env` ignorado e `desfazer.md` completo.
</div>
