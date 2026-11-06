# 07 · Claude Code

**Tempo:** 2 dias · **Saída:** você usa um agente de código no terminal **com critério**. Isso significa dar contexto, pedir plano, revisar o diff e ensinar o projeto ao agente com `CLAUDE.md`, MCP e skills.

!!! warning "Requisito de conta"
    O Claude Code exige um plano pago do Claude (Pro, Max, Team ou Enterprise) ou uma conta no Console com chave de API. O plano gratuito não dá acesso. Sem acesso, combine uma alternativa com seu mentor (veja o [cronograma](../cronograma.md)).

## Você consegue...

- [ ] instalar o Claude Code no Ubuntu e autenticar
- [ ] escrever um prompt com contexto, tarefa e critério de aceite
- [ ] usar o modo plano antes de deixar o agente editar
- [ ] revisar e rejeitar mudanças que você não entende
- [ ] criar um `CLAUDE.md` útil para o projeto
- [ ] configurar um servidor MCP e criar uma skill

## 1. Instalar

Instale **dentro do Ubuntu**, e não no PowerShell:

```bash
curl -fsSL https://claude.ai/install.sh | bash
claude --version
cd ~/dev/trilha-terminal
claude              # na primeira vez, faz o login pelo navegador
```

Documentação oficial: [code.claude.com/docs](https://code.claude.com/docs/en/overview).

## 2. A regra mais importante

> **Você é responsável por todo código que commita, inclusive o que o agente escreveu.**

Um agente de código é rápido e confiante, mesmo quando está errado. O seu trabalho muda de "digitar código" para "especificar bem, revisar com atenção e testar". Se você não entende o diff, não aceite. Pergunte ao próprio Claude: *"explique linha por linha o que você mudou e por quê"*.

## 3. Prompt bem feito

Prompt ruim:

```text
faz a rota sobre
```

Prompt bom, com a mesma estrutura de uma boa issue do Jira:

```text
Contexto: projeto/src/server.js é uma API HTTP em Node puro, sem framework. As rotas
ficam no objeto `routes`, com chave "MÉTODO /caminho".

Tarefa: adicione GET /sobre retornando JSON com autor (meu nome: Fulano),
modulos (número de módulos da trilha, que está em ./trilha) e versao (a mesma
de /health).

Restrições: não adicione dependências. Siga o estilo das rotas existentes.

Critério de aceite:
- curl localhost:3000/sobre responde 200 com os 3 campos
- ./trilha check 07 passa na seção "Feature: GET /sobre"
- nenhuma outra rota muda de comportamento

Antes de editar, me mostre o plano.
```

Os ingredientes são **contexto** (onde e como é o código), **tarefa**, **restrições**, **critério de aceite verificável** e **pedir plano primeiro**.

## 4. Modos e controle

- **`Shift+Tab`** alterna entre os modos de permissão. O modo **plan** só lê e propõe, sem editar nada. Use em toda tarefa que mexa em mais de um arquivo.
- As versões recentes podem iniciar num modo mais autônomo. Confira o modo atual no rodapé do terminal e, enquanto está aprendendo, prefira o modo em que **você aprova cada edição**.
- `Esc` interrompe o agente. `/clear` limpa o contexto: use ao trocar de assunto, porque contexto sujo piora as respostas.
- Revise sempre com `git diff` antes de commitar. O agente não faz commit por você, a menos que você peça.

## 5. CLAUDE.md: a memória do projeto

O `CLAUDE.md` na raiz do repo é lido no início de toda sessão. É onde você ensina o projeto ao agente: o que é cada pasta, como rodar, como testar e quais são as convenções.

```bash
claude
> /init          # gera um rascunho analisando o repositório
```

O rascunho é um ponto de partida: **edite**. Um bom `CLAUDE.md` tem:

- o que é o projeto, em 2 linhas
- a estrutura de pastas que importa
- os comandos: rodar (`npm start`, `docker compose up`), validar (`./trilha check NN`) e o deploy no k3s (build → import → apply)
- convenções: Conventional Commits, chave do Jira em branch e commit, nada de dependência sem perguntar
- o que **não** fazer, por exemplo "nunca editar `exercicios/`"

Curto e específico ganha de longo e genérico.

## 6. MCP: dando ferramentas ao agente

O MCP (Model Context Protocol) conecta o Claude a sistemas externos: Jira, GitHub, bancos, documentação. Servidores com escopo de projeto ficam em `.mcp.json` na raiz e vão para o git, para o time todo usar.

**Opção A, recomendada: Jira.** Conecte o servidor MCP remoto da Atlassian. Pegue a URL atual na documentação da Atlassian, procurando por "Atlassian Remote MCP Server". Depois:

```bash
claude mcp add --transport http atlassian --scope project <URL-DA-ATLASSIAN>
claude mcp list
```

Na sessão, peça: *"liste as issues abertas do projeto TRI"*. A autenticação acontece pelo navegador, e o token não vai para o arquivo.

**Opção B: qualquer outro servidor** que faça sentido para você. O formato do `.mcp.json`:

```json
{
  "mcpServers": {
    "nome-do-servidor": {
      "type": "http",
      "url": "https://exemplo.com/mcp"
    }
  }
}
```

!!! danger "Segredo não vai no `.mcp.json`"
    Ele é commitado. Se o servidor precisar de token, use variável de ambiente: `"env": { "API_TOKEN": "${API_TOKEN}" }`. O check reprova token em texto puro.

## 7. Skills: ensinando um procedimento

Uma skill é uma pasta com um `SKILL.md`, contendo instruções que o Claude carrega quando a tarefa combina com a descrição. Uma skill de projeto fica em `.claude/skills/<nome>/SKILL.md`.

```markdown
---
name: novo-checkpoint
description: Use quando eu pedir para fechar o checkpoint de um módulo da trilha.
---

1. Pergunte qual é o módulo (NN) se eu não disser.
2. Rode ./trilha check NN e mostre só os itens com ✘ e as dicas.
3. Para cada ✘, explique a causa provável, mas NÃO corrija sem eu pedir.
4. Quando estiver tudo verde, proponha a mensagem de commit no padrão
   "feat: CHAVE-N conclui checkpoint NN" e pergunte a chave do Jira.
...
```

A `description` é o que faz a skill ser usada: escreva **quando** ela se aplica. Você também pode chamar a skill direto pelo nome: `/novo-checkpoint`.

## Checkpoint

Crie uma issue no Jira para este módulo e trabalhe na branch dela.

1. **`CLAUDE.md`** na raiz, com pelo menos 20 linhas. Ele precisa citar `docker compose`, `./trilha check` e a convenção de commits.
2. **`.mcp.json`** com pelo menos 1 servidor, sem segredo em texto puro.
3. **Uma skill** em `.claude/skills/<nome>/SKILL.md`, com `description` e pelo menos 10 linhas de instruções. Escolha um procedimento que **você** repete, como o build → import → apply do k3s.
4. **Feature `GET /sobre`** implementada **com o Claude Code**, retornando `{"autor": "...", "modulos": 9, "versao": "<APP_VERSION>"}`.
5. **`checkpoints/07-claude-code/prompts.md`** com os **3 principais prompts** que você usou (cada um em `## Prompt N`, com Contexto / Tarefa / Critério de aceite) e uma seção final `## O que precisei corrigir`, contando o que o agente errou ou o que você rejeitou e por quê.

```bash
./trilha check 07
```

<div class="checkpoint" markdown>
**Checkpoint 07:** projeto com contexto para agentes (`CLAUDE.md`, MCP, skill) e uma feature entregue com prompt bem feito e diff revisado.
</div>
