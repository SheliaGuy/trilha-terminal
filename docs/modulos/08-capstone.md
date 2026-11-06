# 08 · Capstone: entrega ponta a ponta

**Tempo:** 2 dias · **Saída:** uma feature real sai do Jira e chega ao cluster, como acontece no trabalho: issue, branch, código, imagem, compose, k3s, PR e tag de versão.

## A feature: notas da equipe

A app ganha um mural de notas.

| Rota | Comportamento |
|---|---|
| `POST /notas` | corpo `{"texto": "..."}`. Grava no Postgres e responde **201** com `{"id", "texto", "criada_em"}` |
| `POST /notas` sem `texto`, com texto vazio ou com JSON inválido | responde **400** com `{"erro": "..."}` |
| `GET /notas` | responde **200** com um array das notas, da mais nova para a mais antiga |

E a versão da app passa a ser **1.0.0** em todo lugar: `package.json`, `APP_VERSION` no compose, ConfigMap, tag da imagem e tag do git.

## Regras

- **Comece pelo Jira.** Crie um épico "Capstone: notas da equipe" e quebre o trabalho em pelo menos 4 issues: API, Docker/compose, k3s e documentação.
- Uma branch e um PR por issue. Commits com a chave.
- Você pode usar o Claude Code, com os mesmos critérios do módulo 07: plano primeiro e diff revisado.
- Não adicione dependências além do `pg`. Ler o corpo de uma requisição em Node puro faz parte do exercício.

??? tip "Dica: ler o corpo da requisição em Node puro"
    O `req` é um *stream*. Junte os pedaços (`req.on("data")`), e no `end` faça o `JSON.parse` dentro de um `try/catch`. O `catch` é exatamente o caso do "JSON inválido → 400".

??? tip "Dica: a tabela"
    Crie a tabela `notas` no `ensureSchema()`, ao lado da `visitas`: `id SERIAL PRIMARY KEY, texto TEXT NOT NULL, criada_em TIMESTAMPTZ DEFAULT now()`. Use **sempre** query parametrizada: `pool.query("INSERT ... VALUES ($1)", [texto])`. Concatenar o texto na SQL abre a porta para SQL injection.

## Entrega no cluster

```bash
docker build -t trilha-app:1.0.0 projeto/
docker save trilha-app:1.0.0 | sudo k3s ctr images import -
# atualize a imagem e o APP_VERSION em projeto/k8s/ e:
kubectl apply -f projeto/k8s/
kubectl -n trilha rollout status deploy/app
```

## Versão e tag

Depois do último merge na `main`:

```bash
git switch main && git pull
git tag -a v1.0.0 -m "Capstone: notas da equipe"
git push origin v1.0.0
```

## README do capstone

Crie `checkpoints/08-capstone/README.md` com **exatamente** estas seções:

```markdown
# Capstone: notas da equipe

## Épico
TRI-NN, com o link para o épico no Jira e a lista das issues.

## O que foi entregue
Rotas, comportamento e um exemplo de curl para cada uma.

## Como rodar
Local com compose, e no k3s.

## Decisões
Pelo menos 3 decisões que você tomou e por quê (ex.: ordem das notas, validação, nomes).

## O que eu faria diferente
Com honestidade. Esta seção vale mais do que parece.
```

## Checkpoint

```bash
./trilha check 08
```

O check exige os módulos 00 a 07 concluídos, sobe o compose e testa as rotas (inclusive os casos de 400). Ele também confere a tag, a versão e, na sua máquina, a imagem `1.0.0` rodando no k3s.

<div class="checkpoint" markdown>
**Checkpoint 08:** ✅ Trilha completa. Mande o link do seu repo para o seu mentor revisar o capstone. A revisão humana é a última etapa.
</div>

## E depois?

Tópicos naturais para continuar:

- **CI/CD:** build e push da imagem para um registry no GitHub Actions
- **Helm** ou **Kustomize** para os manifests
- **Testes automatizados** da API, com `node --test`
- **Observabilidade:** logs estruturados, métricas e tracing
- **tmux** e dotfiles
