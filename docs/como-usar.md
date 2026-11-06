# Como usar

## 1. Faça o módulo 00 primeiro

O seu repositório precisa morar **dentro do Ubuntu (WSL)**, e não no Windows. Por isso o primeiro passo é o [módulo 00](modulos/00-setup.md): instalar WSL, Ubuntu, git e criar a chave SSH. Só depois você cria o repo.

## 2. Crie o seu repositório a partir do template

1. Na página do repositório no GitHub, clique em **Use this template → Create a new repository**.
2. Dono: a sua conta. Nome: `trilha-terminal`. Visibilidade: **pública** (para o mentor acompanhar) ou privada (adicione o mentor como colaborador).
3. No terminal do Ubuntu:

```bash
mkdir -p ~/dev && cd ~/dev
git clone git@github.com:SEU-USUARIO/trilha-terminal.git
cd trilha-terminal
./trilha status
```

!!! warning "Use o template, não o fork"
    Fork mantém vínculo com o repo original, e os seus PRs podem acabar abertos contra ele por engano. O template cria um repo independente, que é só seu.

## 3. O ciclo de cada módulo

```bash
git switch main && git pull
git switch -c modulo/01-shell        # uma branch por módulo
# ... lê a página, faz os exercícios ...
./trilha check 01                    # repete até ficar tudo ✔
git add checkpoints/01-shell PROGRESSO.md
git commit -m "feat: conclui checkpoint 01-shell"
git push -u origin modulo/01-shell
```

Depois:

1. Abra o PR **no seu repositório** (base: `main` do seu repo).
2. Espere o check **checkpoint** ficar verde.
3. Faça o merge.

A partir do módulo 04, o nome da branch e os commits passam a levar a chave da issue do Jira (ex.: `TRI-7-docker`).

## 4. O que o `./trilha` faz

| Comando | Para quê |
|---|---|
| `./trilha status` | Mostra o que está feito e qual é o próximo módulo |
| `./trilha check 03` | Valida o checkpoint do módulo 03 e, se passar, marca no `PROGRESSO.md` |
| `./trilha exercicio 03` | Prepara o exercício do módulo, se ele tiver um (03 e 06) |
| `./trilha verificar` | Revalida todos os módulos concluídos, em modo CI. É o que o GitHub Actions roda |

Quando um item falha, o check mostra uma **dica**. Leia a dica antes de pedir ajuda.

!!! note "Por que o CI pula alguns itens?"
    O GitHub Actions não tem o seu WSL nem o seu k3s. Para esses itens, o check local grava uma evidência em `checkpoints/NN-*/.check`, e o CI confere essa evidência. Ou seja: o CI não substitui rodar `./trilha check` na sua máquina.

## 5. Regras do jogo

- **Digite os comandos.** Não copie e cole na primeira vez. A memória muscular é metade do curso.
- **Leia a mensagem de erro inteira** antes de pesquisar. Quase sempre ela diz o que está errado.
- **Travou por mais de 30 minutos?** Escreva o que tentou, o comando, a saída e o que esperava, e pergunte. Muitas vezes, escrever a pergunta já resolve.
- Use o Claude (ou outra IA) para **explicar** erros, não para fazer o checkpoint por você. A partir do módulo 07 isso muda, e usar IA bem passa a ser o exercício.
