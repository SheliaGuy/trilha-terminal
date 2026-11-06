# 01 · Shell

**Tempo:** 2 dias · **Saída:** você responde perguntas sobre um arquivo de log de 2.000 linhas com uma linha de comando, em vez de abrir o arquivo e procurar no olho.

## Você consegue...

- [ ] dizer em que pasta está e ir para qualquer outra sem se perder
- [ ] criar, copiar, mover e apagar arquivos e pastas com segurança
- [ ] ler um arquivo grande sem abrir um editor
- [ ] encadear comandos com `|` e mandar a saída para um arquivo
- [ ] filtrar linhas (`grep`), pegar colunas (`awk`), contar e ordenar (`sort | uniq -c`)
- [ ] dar permissão de execução a um script e rodá-lo
- [ ] achar e matar um processo travado

## 1. Anatomia de um comando

```text
ls  -la   /etc
│    │     └── argumento: sobre o que agir
│    └──────── opções (flags): como agir. -la é o mesmo que -l -a
└───────────── o programa
```

Para descobrir o que um comando faz: `man ls` (sai com `q`), `ls --help`, ou instale o `tldr` com `sudo apt install tldr` e rode `tldr ls`, que mostra exemplos práticos.

## 2. Navegar

```bash
pwd                 # onde estou?
ls -la              # o que tem aqui (inclusive ocultos, que começam com ponto)
cd ~/dev            # vai para a pasta dev na sua home
cd ..               # sobe um nível
cd -                # volta para a pasta anterior
cd                  # sem argumento: vai para a home
```

- **Caminho absoluto** começa em `/`: `/home/ana/dev`.
- **Caminho relativo** parte de onde você está: `dev/trilha-terminal`.
- `.` é a pasta atual, `..` é a pasta de cima e `~` é a sua home.

**Use `Tab` o tempo todo.** Ele completa nomes de arquivos e comandos. Dois `Tab` mostram as opções. Isso evita 90% dos erros de digitação.

## 3. Arquivos e pastas

```bash
mkdir -p projetos/teste/a     # -p cria os pais e não reclama se já existir
touch notas.txt               # cria um arquivo vazio (ou atualiza a data)
cp notas.txt copia.txt
cp -r projetos backup         # -r copia pastas
mv copia.txt renomeado.txt    # mover e renomear são o mesmo comando
rm renomeado.txt
rm -r backup                  # apaga a pasta e tudo dentro
```

!!! danger "Não existe lixeira"
    O `rm` apaga para sempre. Antes de um `rm -r` com curinga, rode o **mesmo comando com `ls`** para ver o que vai sumir: `ls *.log` e só depois `rm *.log`. E **nunca** rode `sudo rm -rf` copiado da internet sem entender cada parte.

Curingas (*globs*): `*` é qualquer coisa, `?` é um caractere, `{a,b}` é a ou b. Exemplo: `ls exercicios/shell/*.log`.

## 4. Ler arquivos

```bash
cat arquivo.txt            # despeja tudo (bom para arquivos pequenos)
less app.log               # navega: espaço desce, b sobe, /texto busca, q sai
head -20 app.log           # primeiras 20 linhas
tail -20 app.log           # últimas 20
tail -f /var/log/syslog    # acompanha o arquivo crescendo (Ctrl+C para sair)
wc -l app.log              # quantas linhas
```

## 5. Redirecionar e encadear

Todo programa tem três canais: **entrada** (stdin), **saída** (stdout) e **erro** (stderr).

```bash
ls > lista.txt             # saída para arquivo (sobrescreve)
ls >> lista.txt            # anexa no fim
ls /nao-existe 2> erros.txt    # só o canal de erro
comando > tudo.txt 2>&1    # saída e erro no mesmo arquivo
comando > /dev/null        # joga a saída fora
```

O **pipe** `|` liga a saída de um comando na entrada do próximo. É aqui que o terminal fica poderoso:

```bash
cat app.log | grep ERROR | wc -l
```

Leia da esquerda para a direita: pega o log, fica só com as linhas que têm ERROR e conta.

## 6. As ferramentas de filtro

O arquivo `exercicios/shell/app.log` tem linhas assim:

```text
2026-10-01T08:00:05Z INFO  10.0.0.149 GET /api/pedidos 200 899ms
│                    │     │          │   │            │   └ 7: duração
│                    │     │          │   │            └──── 6: status HTTP
│                    │     │          │   └───────────────── 5: rota
│                    │     │          └───────────────────── 4: método
│                    │     └──────────────────────────────── 3: IP
│                    └────────────────────────────────────── 2: nível
└─────────────────────────────────────────────────────────── 1: data/hora
```

Explore com estes comandos. Rode cada um e entenda a saída antes de seguir:

```bash
cd ~/dev/trilha-terminal/exercicios/shell
grep ERROR app.log | head                    # linhas com ERROR
grep -c ERROR app.log                        # quantas
grep -v INFO app.log | head                  # tudo que NÃO é INFO
grep -E ' (500|503) ' app.log | head         # regex: status 500 ou 503
awk '{print $3}' app.log | head              # só a coluna 3 (IP)
awk '$6 >= 500 {print $5, $6}' app.log | head   # rota e status quando status >= 500
awk '{print $4}' app.log | sort | uniq -c    # quantas requisições por método
awk '{print $4}' app.log | sort | uniq -c | sort -k1,1nr   # idem, do maior para o menor
```

- `uniq` só junta linhas **iguais e vizinhas**, por isso vem sempre depois de `sort`.
- `uniq -c` conta as repetições.
- `sort -n` ordena por número, `-r` inverte e `-k2` usa a coluna 2.

## 7. Permissões

```bash
ls -l script.sh
# -rwxr-xr-- 1 ana ana 120 out 16 10:00 script.sh
#  └┬┘└┬┘└┬┘
#  dono grupo outros   r=ler w=escrever x=executar
chmod +x script.sh     # dá permissão de execução
./script.sh            # roda o script da pasta atual
```

Um script começa com o *shebang*, que diz quem deve interpretar o arquivo:

```bash
#!/usr/bin/env bash
echo "Recebi o arquivo: $1"     # $1 é o primeiro argumento
```

## 8. Variáveis de ambiente e PATH

```bash
echo $HOME
export MEU_TOKEN=abc123      # vale para este terminal e os programas que ele abrir
env | grep MEU               # lista as variáveis
echo $PATH                   # pastas onde o shell procura programas
which node                   # qual 'node' está sendo usado
```

Para algo valer sempre, coloque no fim do `~/.bashrc` e rode `source ~/.bashrc`. É lá que também moram os aliases, por exemplo `alias gs='git status'`.

## 9. Processos

```bash
ps aux | grep node      # processos com 'node' no nome
top                     # monitor ao vivo (q sai); htop é mais bonito: sudo apt install htop
kill 12345              # pede para o processo 12345 encerrar (SIGTERM)
kill -9 12345           # força (SIGKILL), só se o anterior não funcionou
```

- `Ctrl+C` interrompe o comando atual.
- `Ctrl+Z` pausa; `bg` continua a tarefa em segundo plano e `fg` traz de volta.
- `comando &` já inicia em segundo plano.

## 10. Atalhos que economizam horas

| Atalho | Faz |
|---|---|
| `Tab` | completa |
| `↑` / `↓` | histórico |
| `Ctrl+R` | busca no histórico (digite parte do comando) |
| `Ctrl+A` / `Ctrl+E` | início / fim da linha |
| `Ctrl+W` | apaga a palavra anterior |
| `Ctrl+L` | limpa a tela |
| `!!` | repete o último comando (`sudo !!` é um clássico) |

## Checkpoint

Crie três scripts em `checkpoints/01-shell/`. Cada um **recebe o caminho do log como primeiro argumento (`$1`)** e imprime a resposta. O check roda os scripts contra `app.log` e contra um segundo log, `app-2.log`. Por isso, não use caminho fixo nem escreva a resposta direto no script.

**`erros-por-rota.sh`:** quantas linhas `ERROR` cada rota tem, da maior para a menor. Formato: `quantidade rota`, uma por linha.

```text
60 /api/pagamentos
35 /api/estoque
...
```

**`top-ips.sh`:** os **3** IPs com mais requisições (de qualquer nível), do maior para o menor. Só o IP, um por linha.

**`lentas.sh`:** quantas requisições demoraram **mais de 1000 ms**. Só o número.

!!! tip "Dica para `lentas.sh`"
    A coluna 7 vem como `899ms`. No `awk`, `sub(/ms$/, "", $7)` remove o sufixo antes de comparar.

```bash
chmod +x checkpoints/01-shell/*.sh
checkpoints/01-shell/top-ips.sh exercicios/shell/app.log     # teste manual
./trilha check 01
```

<div class="checkpoint" markdown>
**Checkpoint 01:** `./trilha check 01` verde → commit → PR → merge.
</div>
