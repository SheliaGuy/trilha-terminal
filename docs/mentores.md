# Para mentores

A trilha foi desenhada para ser feita **sozinha**, com validação automática. O seu papel é destravar e revisar, e não corrigir exercício.

## Acompanhando o progresso

- Peça o link do repo da pessoa: ela cria a partir do template, com `Use this template`. Se for privado, peça acesso de leitura.
- O `PROGRESSO.md` mostra os módulos concluídos e as datas.
- A aba **Actions → checkpoint** mostra, em cada PR, o resumo do que foi revalidado no CI.
- Para receber os PRs por e-mail, use **Watch → All activity** no repo da pessoa.

## O que o CI garante e o que não garante

| Módulo | CI revalida de verdade | Depende da evidência local (`.check`) |
|---|---|---|
| 00 Setup | — | tudo (WSL, ferramentas, SSH) |
| 01 Shell | scripts rodando contra os logs | — |
| 02 Vim | o arquivo corrigido | `.vimrc` |
| 03 Git | histórico, merge do conflito, commits | — |
| 04 Jira | arquivos, chaves nos commits, merge | o board em si (abra o link) |
| 05 Docker | build, compose, rotas, persistência | — |
| 06 k3s | manifests (estrutura + kubeconform), diagnóstico | o cluster rodando |
| 07 Claude Code | `CLAUDE.md`, skill, `.mcp.json`, feature `/sobre` | instalação do `claude` |
| 08 Capstone | rotas, validações, versão, tag | a imagem 1.0.0 no k3s |

A evidência local pode ser forjada por quem quiser. A trilha parte de boa-fé. O capstone com revisão humana é onde isso aparece.

## Pontos de conversa sugeridos

Uma conversa curta (15 a 20 min) no fim de cada semana rende mais do que tirar dúvida pontual:

- **Semana 1:** "Me mostra como você achou os IPs do top 3. Por que precisa do `sort` antes do `uniq`?"
- **Semana 2:** "Faz um conflito ao vivo aqui. Quando você usaria `revert` em vez de `reset`?"
- **Semana 3:** "Por que o `COPY package*.json` vem antes do código? O que acontece com os dados do Postgres no k3s se o pod morrer?"
- **Semana 4:** revisão do capstone (abaixo).

## Revisando o capstone

Revise o PR final e o `checkpoints/08-capstone/README.md`:

- [ ] O épico no Jira conta a história da entrega e as issues foram fechadas pelos PRs
- [ ] Query parametrizada no `INSERT` (sem concatenar string)
- [ ] Erros tratados: JSON inválido não derruba a app
- [ ] Commits pequenos e com significado, e não um "wip" gigante
- [ ] "Decisões" mostra raciocínio, não descrição
- [ ] "O que eu faria diferente" é honesto

## Adaptando para o seu time

O repo é um template e a licença é aberta. Faça um template próprio e ajuste:

- a chave do Jira e o site da sua empresa
- o projeto fio-condutor (troque a app Node pela stack do time; os checks em `checks/` usam `curl` e são fáceis de adaptar)
- o módulo 07, conforme a política de IA da sua empresa
