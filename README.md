# Trilha Terminal

Curso prático de terminal para devs iniciantes, em **4 semanas**: WSL 2 + Ubuntu, shell, vim, git, Jira, Docker, Kubernetes (k3s) e Claude Code.

📖 **Site do curso:** https://edi-labs-system.github.io/trilha-terminal/

Cada módulo termina num **checkpoint verificável**: um script confere se você realmente fez, e o GitHub Actions revalida no seu PR.

## Começar

1. Leia o [módulo 00](https://edi-labs-system.github.io/trilha-terminal/modulos/00-setup/) e prepare o WSL.
2. Clique em **Use this template → Create a new repository** (não faça fork).
3. Clone o **seu** repo dentro do Ubuntu e rode:

```bash
./trilha status
```

## Módulos

| # | Módulo | Checkpoint |
|---|---|---|
| 00 | Setup: WSL 2 + Ubuntu | ambiente completo, SSH no GitHub |
| 01 | Shell | 3 scripts que analisam um log de 2.000 linhas |
| 02 | Vim | corrigir um YAML só com vim |
| 03 | Git | conflito resolvido, commits no padrão, desfazer |
| 04 | Jira | board, JQL, commits ligados às issues |
| 05 | Docker | Dockerfile + compose com Postgres, dados persistentes |
| 06 | Kubernetes (k3s) | app com 2 réplicas no cluster + debug de pod quebrado |
| 07 | Claude Code | `CLAUDE.md`, MCP, skill e uma feature feita com agente |
| 08 | Capstone | feature ponta a ponta: Jira → código → compose → k3s → tag |

## Estrutura

```text
trilha                CLI: status, check, exercicio, verificar
checks/NN-*.sh        o que cada checkpoint confere
checkpoints/NN-*/     suas entregas (é aqui que você trabalha)
exercicios/           material dos exercícios (não edite)
projeto/              a app Node que atravessa o curso
docs/                 o site (MkDocs Material)
PROGRESSO.md          seu progresso, atualizado pelo ./trilha check
```

## Rodando o site localmente

```bash
pip install -r requirements.txt
mkdocs serve
```

## Licença

Conteúdo (`docs/`) sob [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/deed.pt_BR). Código e scripts sob MIT. Veja [LICENSE](LICENSE).

Encontrou erro ou tem sugestão? Abra uma issue neste repositório.
