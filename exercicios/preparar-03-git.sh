#!/usr/bin/env bash
# Prepara o exercício de conflito do módulo 03.
# Cria duas branches locais que alteram a MESMA linha de checkpoints/03-git/equipe.md.
set -euo pipefail
cd "$TRILHA_ROOT"

if [[ -n "$(git status --porcelain)" ]]; then
  echo "Seu working tree tem alterações. Faça commit ou 'git stash' antes de preparar o exercício."
  exit 1
fi
for b in exercicio/conflito-a exercicio/conflito-b; do
  if git show-ref --verify --quiet "refs/heads/$b"; then
    echo "A branch $b já existe. Para recomeçar: git branch -D exercicio/conflito-a exercicio/conflito-b"
    exit 1
  fi
done

origem=$(git rev-parse --abbrev-ref HEAD)
bot=(-c user.name="Trilha Bot" -c user.email="bot@trilha.local")
f=checkpoints/03-git/equipe.md

git switch -q -c exercicio/conflito-a
mkdir -p checkpoints/03-git
cat >"$f" <<'MD'
# Equipe do projeto

| Papel | Pessoa |
|---|---|
| Tech lead | (definir) |
| Dev | (definir) |
MD
git add "$f"
git "${bot[@]}" commit -q -m "docs: cria tabela da equipe [trilha-c0]"
base=$(git rev-parse HEAD)

sed -i 's/^| Tech lead | (definir) |$/| Tech lead | Ana |/' "$f"
git "${bot[@]}" commit -q -am "docs: Ana assume como tech lead [trilha-a]"

git switch -q -c exercicio/conflito-b "$base"
sed -i 's/^| Tech lead | (definir) |$/| Tech lead | Bruno |/' "$f"
git "${bot[@]}" commit -q -am "docs: Bruno assume como tech lead [trilha-b]"

git switch -q "$origem"
cat <<MSG
Pronto. Duas branches foram criadas a partir de '$origem':
  exercicio/conflito-a  → define Ana como tech lead
  exercicio/conflito-b  → define Bruno como tech lead

Agora siga a página do módulo 03:
  git switch -c feat/03-git
  git merge exercicio/conflito-a
  git merge exercicio/conflito-b     # vai dar conflito, e é esse o objetivo
MSG
