# Cronograma — 4 semanas

Ritmo de **3 a 4 horas por dia útil**, num total de cerca de 70 horas. Atrasou um dia? Tudo bem, só não pule módulo. Cada um usa o anterior.

| Semana | Dia | Módulo | Meta do dia |
|---|---|---|---|
| **1 · Base** | 1 | [00 Setup](modulos/00-setup.md) | WSL 2, Ubuntu, Windows Terminal, VS Code + WSL |
| | 2 | [00 Setup](modulos/00-setup.md) | git, SSH no GitHub, Node, Docker, yq. Criar o repo pelo template. **Checkpoint 00** |
| | 3 | [01 Shell](modulos/01-shell.md) | Navegação, arquivos, permissões, variáveis, processos |
| | 4 | [01 Shell](modulos/01-shell.md) | Pipes, grep, awk, sort, uniq. **Checkpoint 01** |
| | 5 | [02 Vim](modulos/02-vim.md) | `vimtutor` inteiro + exercício. **Checkpoint 02** |
| **2 · Colaboração** | 6 | [03 Git](modulos/03-git.md) | Modelo mental, commit, log, diff, branch |
| | 7 | [03 Git](modulos/03-git.md) | Remote, PR, merge e conflito |
| | 8 | [03 Git](modulos/03-git.md) | Desfazer coisas, stash, rebase básico. **Checkpoint 03** |
| | 9 | [04 Jira](modulos/04-jira.md) | Projeto, board, issues, épico, workflow |
| | 10 | [04 Jira](modulos/04-jira.md) | JQL e integração com GitHub. **Checkpoint 04** |
| **3 · Containers** | 11 | [05 Docker](modulos/05-docker.md) | Imagem × container, run, logs, exec, portas |
| | 12 | [05 Docker](modulos/05-docker.md) | Dockerfile, cache de camadas, volumes |
| | 13 | [05 Docker](modulos/05-docker.md) | Docker Compose com Postgres. **Checkpoint 05** |
| | 14 | [06 k3s](modulos/06-k3s.md) | Instalar k3s, kubectl, Pod, Deployment, Service |
| | 15 | [06 k3s](modulos/06-k3s.md) | ConfigMap, Secret, probes, deploy do projeto |
| **4 · Entrega** | 16 | [06 k3s](modulos/06-k3s.md) | Debug do deployment quebrado. **Checkpoint 06** |
| | 17 | [07 Claude Code](modulos/07-claude-code.md) | Instalação, prompt bem feito, `CLAUDE.md` |
| | 18 | [07 Claude Code](modulos/07-claude-code.md) | MCP, skill e feature `/sobre`. **Checkpoint 07** |
| | 19 | [08 Capstone](modulos/08-capstone.md) | Épico no Jira, feature `/notas`, compose |
| | 20 | [08 Capstone](modulos/08-capstone.md) | Deploy 1.0.0 no k3s, tag, README. **Checkpoint 08** |

## Onde costuma atrasar

- **Dia 1–2:** virtualização desligada na BIOS e políticas de TI em máquina corporativa. Resolva isso **antes** do dia 1.
- **Dia 7:** o primeiro conflito de merge assusta. É normal.
- **Dia 14:** o k3s no WSL exige systemd ligado, e imagem buildada no Docker não aparece sozinha no k3s. As duas coisas estão explicadas no módulo, então leia com calma.

Sem acesso ao Claude Code? Troque os dias 17–18 por uma revisão de git e Docker. O módulo 07 é o único opcional, mas o capstone exige que o 07 esteja concluído. Nesse caso, combine uma alternativa com seu mentor.
