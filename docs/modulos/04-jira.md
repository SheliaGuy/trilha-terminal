# 04 · Jira e o fluxo issue → branch → PR

**Tempo:** 2 dias · **Saída:** todo trabalho seu nasce numa issue, anda num board e termina num PR ligado a ela. A partir daqui, a trilha inteira roda assim.

## Você consegue...

- [ ] explicar a diferença entre épico, história, tarefa, bug e subtarefa
- [ ] criar e mover issues no board
- [ ] escrever uma issue que outra pessoa consegue executar sem te perguntar nada
- [ ] usar JQL para achar "minhas issues abertas atualizadas na última semana"
- [ ] ligar commits e PRs à issue pela chave

## 1. Prepare o ambiente

Se a sua empresa já usa Jira e o seu mentor liberou um projeto para você, use ele. Senão:

1. Crie um site gratuito em [atlassian.com/software/jira/free](https://www.atlassian.com/software/jira/free). Ele fica em `https://SEU-SITE.atlassian.net`.
2. Crie um projeto do tipo **Kanban** (software), chamado `Trilha` e com a chave **`TRI`**.

!!! info "A chave é o que importa"
    A **chave** (`TRI`) prefixa todas as issues: `TRI-1`, `TRI-2`… É ela que liga o Jira ao git. Escolha uma curta, porque você vai digitar ela muitas vezes.

## 2. Os tipos de issue

| Tipo | Tamanho | Exemplo |
|---|---|---|
| **Épico** | semanas; agrupa várias issues | "Capstone: notas da equipe" |
| **História** | dias; entrega valor para alguém | "Como usuário, quero salvar uma nota" |
| **Tarefa** | horas a dias; trabalho técnico | "Criar Dockerfile da app" |
| **Bug** | algo que deveria funcionar e não funciona | "/visitas retorna 500 sem banco" |
| **Subtarefa** | um pedaço de uma issue | "Escrever teste do POST" |

## 3. Uma issue bem escrita

```text
Título: Criar Dockerfile da trilha-app

Contexto
A app hoje só roda com node local. Precisamos de imagem para o compose e o k3s.

O que fazer
- Dockerfile com base node:24-alpine, rodando como usuário não-root
- .dockerignore ignorando node_modules

Critério de aceite
- [ ] docker build -t trilha-app:0.1.0 projeto/ funciona
- [ ] docker run -p 3000:3000 trilha-app:0.1.0 responde em /health
- [ ] ./trilha check 05 passa nos itens de Dockerfile
```

**Contexto, o que fazer e critério de aceite.** O critério de aceite é o mais importante: é como todo mundo sabe que a issue terminou. Você vai reaproveitar esse formato no módulo 07, para escrever prompts.

## 4. Board e workflow

Um board Kanban tem colunas de status, por exemplo **A fazer → Em andamento → Em revisão → Concluído**.

- Mova a issue para **Em andamento** quando **começar**, e não quando terminar.
- Limite o trabalho em andamento: no máximo 2 issues suas em andamento ao mesmo tempo.
- **Em revisão** = PR aberto esperando revisão.

## 5. JQL: busca no Jira

JQL é a "SQL do Jira". Ela fica em *Filtros → Busca avançada*.

```sql
project = TRI AND status != Done
assignee = currentUser() AND resolution = Unresolved ORDER BY priority DESC
project = TRI AND type = Bug AND created >= -14d
project = TRI AND text ~ "docker"
"Epic Link" = TRI-30          -- em sites novos: parent = TRI-30
```

| Elemento | Exemplos |
|---|---|
| Operadores | `=`, `!=`, `IN (...)`, `NOT IN`, `~` (contém), `>=`, `IS EMPTY` |
| Datas relativas | `-7d`, `-2w`, `startOfWeek()` |
| Ordenação | `ORDER BY updated DESC` |

Salve como filtro o que você usa todo dia.

## 6. Ligando o Jira ao git

A regra é simples: **a chave da issue aparece em tudo.**

```bash
git switch -c TRI-7-dockerfile                       # branch: CHAVE-descricao-curta
git commit -m "feat: TRI-7 adiciona Dockerfile da app"
# título do PR: "TRI-7 Dockerfile da app"
```

Instale no seu site Jira o app oficial de integração com o GitHub, disponível no Atlassian Marketplace, e conecte a sua conta ou organização do GitHub. A partir daí, branches, commits e PRs com a chave aparecem dentro da issue, no painel **Development**.

??? note "Smart commits (opcional)"
    Com a integração ativa, comandos no commit agem na issue. Por exemplo, `TRI-7 #comment Dockerfile pronto, falta compose` comenta na issue. Também é possível mudar o status pelo nome da transição, como `#done`. O e-mail do commit precisa ser o mesmo do usuário Jira.

## Checkpoint

1. Crie o épico **"Trilha: containers e cluster"** e, dentro dele, uma issue para cada módulo restante: 05, 06, 07 e 08.
2. Crie mais duas issues: **"Documentar board"** e **"Documentar JQL"**.
3. Na branch `TRI-N-board` (N é o número da issue "Documentar board"), crie `checkpoints/04-jira/board.md`:

    ```markdown
    Board: https://SEU-SITE.atlassian.net/jira/software/projects/TRI/boards/1
    Chave do projeto: TRI
    ```

    Commite com a chave, abra o PR e faça o merge pelo botão **Create a merge commit**, e não por squash: o check procura esse merge commit.

4. Atualize a main (`git switch main && git pull`, para trazer o merge do passo 3) e crie a branch `TRI-M-jql` (M é o número da issue "Documentar JQL"). Nela, crie `checkpoints/04-jira/jql.md` com 4 consultas que você **rodou de verdade** e funcionaram, cada uma com uma linha explicando o resultado:
    - as suas issues não resolvidas, ordenadas por última atualização
    - as issues do projeto que **não** estão concluídas
    - as issues criadas nos últimos 7 dias
    - qualquer outra que você ache útil
5. A partir de agora, **todo commit leva a chave**. O check exige pelo menos 3 commits com chave e 1 merge de branch com chave, que é o do passo 3.

```bash
./trilha check 04
```

<div class="checkpoint" markdown>
**Checkpoint 04:** board e JQL documentados, épico com as issues dos próximos módulos, e commits ligados às issues.
</div>
