# 02 · Vim de sobrevivência

**Tempo:** 1 dia · **Saída:** você abre, edita e sai do vim sem pânico. Isso basta para editar o commit que o git abriu, o YAML num servidor via SSH ou o `/etc/wsl.conf`.

!!! note "A meta não é virar usuário de vim"
    No dia a dia você vai usar o VS Code. Mas o vim (ou o `vi`) está em **todo** servidor e container, e é o editor padrão do git. Meia hora de vim agora evita muitas horas de desespero depois.

## Você consegue...

- [ ] sair do vim salvando, e sair sem salvar
- [ ] explicar a diferença entre modo normal, inserção e visual
- [ ] apagar, copiar e colar linhas sem o mouse
- [ ] buscar e substituir um texto no arquivo inteiro
- [ ] desfazer e refazer

## 1. Os modos (a única ideia que importa)

```text
          i, a, o
 NORMAL ───────────► INSERÇÃO      (digita texto normalmente)
   ▲  ◄───────────
   │      Esc
   │ v / V
   ▼
 VISUAL                             (seleciona texto)
   │ :
   ▼
 COMANDO  (:w, :q, :%s...)
```

O vim **abre no modo normal**, onde as teclas são comandos e não texto. Por isso quem abre o vim pela primeira vez sai digitando e "quebra" o arquivo. **Na dúvida, aperte `Esc`** para voltar ao modo normal.

## 2. Sair (decore isto hoje)

| Comando | Faz |
|---|---|
| `:w` | salva |
| `:q` | sai (só se não houver alteração) |
| `:wq` ou `:x` | salva e sai |
| `:q!` | sai **descartando** as alterações |

Sempre aperte `Esc` antes, e `Enter` depois.

## 3. O mínimo para editar

**Entrar no modo de inserção**

| Tecla | Onde começa a digitar |
|---|---|
| `i` | antes do cursor |
| `a` | depois do cursor |
| `o` | numa linha nova abaixo |
| `O` | numa linha nova acima |

**Mover (modo normal)**

| Tecla | Vai para |
|---|---|
| `h j k l` | ← ↓ ↑ → (as setas também funcionam) |
| `w` / `b` | próxima palavra / palavra anterior |
| `0` / `$` | início / fim da linha |
| `gg` / `G` | primeira / última linha |
| `42G` ou `:42` | linha 42 |

**Editar (modo normal)**

| Tecla | Faz |
|---|---|
| `x` | apaga o caractere sob o cursor |
| `dd` | recorta a linha (`3dd` recorta 3 linhas) |
| `yy` | copia a linha |
| `p` / `P` | cola abaixo / acima |
| `cw` | troca a palavra: apaga até o fim dela e entra em inserção |
| `r` + tecla | troca um caractere |
| `u` | desfaz |
| `Ctrl+R` | refaz |
| `.` | repete a última alteração |

O padrão é **verbo + movimento**: `d` (apagar) + `w` (palavra) = `dw`. `y$` copia até o fim da linha, `d}` apaga até o próximo parágrafo, e assim por diante.

**Buscar e substituir**

| Comando | Faz |
|---|---|
| `/texto` | busca para frente; `n` vai para a próxima e `N` para a anterior |
| `:%s/velho/novo/g` | troca em todo o arquivo |
| `:%s/velho/novo/gc` | idem, pedindo confirmação em cada ocorrência |

## 4. vimtutor (obrigatório)

```bash
vimtutor
```

É um tutorial interativo de cerca de 30 minutos que já vem instalado. Faça **inteiro**, digitando.

## 5. Um `.vimrc` mínimo

Crie `~/.vimrc` (dá para usar o próprio vim: `vim ~/.vimrc`):

```vim
set number          " mostra o número das linhas
syntax on           " cores
set expandtab       " Tab vira espaços (essencial para YAML)
set shiftwidth=2    " >> e << andam 2 espaços
set tabstop=2
set ignorecase smartcase   " busca sem diferenciar maiúsculas, a menos que você use uma
set hlsearch        " destaca o resultado da busca (:noh limpa)
```

!!! warning "YAML e Tab"
    YAML **não aceita Tab** para indentar, só espaços. Sem o `expandtab`, você vai quebrar manifests do Kubernetes sem perceber.

## Checkpoint

```bash
cp exercicios/vim/config-quebrado.yaml checkpoints/02-vim/config.yaml
vim checkpoints/02-vim/config.yaml
```

Dentro do vim, resolva os 6 `TODO` usando **só o vim**: sem VS Code e sem `sed`. Cada `TODO` dá uma dica de comando. Salve com `:wq` e rode:

```bash
./trilha check 02
```

O check diz qual `TODO` ainda está errado. Errou feio antes de salvar? Saia com `:q!`. Já salvou? Rode o `cp` de novo e recomece.

<div class="checkpoint" markdown>
**Checkpoint 02:** `./trilha check 02` verde e `vimtutor` concluído.
</div>
