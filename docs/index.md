# Trilha Terminal

Curso prático para quem está começando no dia a dia de desenvolvimento e ainda trava no terminal. Em **4 semanas** você sai do Git Bash no Windows para operar com segurança:

- **Linux** via WSL 2 + Ubuntu
- **shell**: navegar, filtrar logs e combinar comandos
- **vim**, o suficiente para nunca mais ficar preso nele
- **git** do dia a dia, com conflito, PR e "como desfaço isso?"
- **Jira** e o fluxo issue → branch → commit → PR
- **Docker** e Docker Compose
- **Kubernetes** com k3s, incluindo debug de pod quebrado
- **Claude Code**: prompt, `CLAUDE.md`, MCP e skills

## Como funciona

Este curso não se completa só lendo. Cada módulo termina num **checkpoint**: uma tarefa real, conferida por um script.

```text
lê o módulo → faz no terminal → ./trilha check NN → abre PR → CI verde → merge
```

1. Você cria **o seu próprio repositório** a partir deste template. Seu progresso fica nele.
2. Os exercícios usam um projeto só: uma API Node pequena. Você versiona, edita, dockeriza e sobe no cluster.
3. `./trilha check NN` valida o checkpoint e marca o módulo no seu `PROGRESSO.md`.
4. No PR, o GitHub Actions revalida tudo o que pode ser conferido fora da sua máquina.

[Começar :material-arrow-right:](como-usar.md){ .md-button .md-button--primary }
[Ver cronograma](cronograma.md){ .md-button }

## Pra quem é

Para quem já programa um pouco, mas nunca precisou viver no terminal. Também serve para quem só usa o terminal decorando comandos. Não precisa saber Linux.

Mentores e tech leads podem usar a trilha com pessoas do time. Veja [Para mentores](mentores.md).

## O que você precisa

| Item | Observação |
|---|---|
| Windows 10 (22H2) ou 11 com virtualização ativa | macOS e Linux funcionam também (pule a parte de WSL) |
| 16 GB de RAM recomendados | k3s + Docker + VS Code ao mesmo tempo pesam |
| Conta no GitHub | gratuita |
| Conta no Jira Cloud | plano gratuito serve |
| Assinatura do Claude (Pro ou superior) ou chave de API | **só** para o módulo 07, que é opcional para quem não tiver |
| ~3–4 horas por dia útil | para caber em 4 semanas |

## Fora do escopo

Bash scripting avançado, tmux e dotfiles, CI/CD além do usado aqui, Helm, cloud (EKS/AKS/GKE) e administração de Jira. Essa base vem antes disso tudo.
