# 05 · Docker e Docker Compose

**Tempo:** 3 dias · **Saída:** a app do projeto roda em container, com Postgres ao lado, subindo com um comando só. Os dados sobrevivem a restart.

## Você consegue...

- [ ] explicar a diferença entre imagem e container
- [ ] rodar um container, ver os logs, entrar nele e parar
- [ ] publicar uma porta e montar um volume
- [ ] escrever um Dockerfile que aproveita o cache de camadas
- [ ] subir app + banco com Docker Compose
- [ ] limpar o que o Docker acumulou no disco

## 1. Imagem × container

- **Imagem:** um pacote só de leitura com o sistema de arquivos e o comando inicial. É a "classe".
- **Container:** uma imagem em execução, com uma camada gravável por cima. É a "instância". Ele é descartável: apagou, a camada gravável vai junto.

```bash
docker run --rm hello-world
docker images                 # imagens baixadas
docker ps                     # containers rodando (-a inclui os parados)
```

## 2. Rodando containers de verdade

```bash
docker run -d --name web -p 8080:80 nginx:1.27-alpine
#          │  │          │         └ imagem:tag
#          │  │          └ porta do host 8080 → porta 80 do container
#          │  └ nome (senão o Docker inventa um)
#          └ detached: roda em segundo plano
curl localhost:8080
docker logs -f web            # acompanha os logs (Ctrl+C sai só dos logs)
docker exec -it web sh        # abre um shell dentro do container (exit para sair)
docker stop web && docker rm web
```

Agora um Postgres, com variáveis de ambiente e volume:

```bash
docker run -d --name pg \
  -e POSTGRES_PASSWORD=segredo \
  -v pgdados:/var/lib/postgresql/data \
  -p 5432:5432 postgres:17-alpine
docker exec -it pg psql -U postgres -c 'select version();'
docker rm -f pg               # o container some...
docker volume ls              # ...mas o volume pgdados (e os dados) continua lá
```

!!! warning "Tag `latest` é armadilha"
    `latest` não quer dizer "a mais nova estável": quer dizer "a que estava marcada como latest quando você baixou". Sempre use tag fixa: `postgres:17-alpine`, `node:24-alpine`.

## 3. Dockerfile

Na pasta `projeto/` está a app. Entenda cada linha deste Dockerfile antes de escrever o seu:

```dockerfile
FROM node:24-alpine            # imagem base: Node em Alpine Linux (pequena)
WORKDIR /app                   # pasta de trabalho dentro da imagem
ENV NODE_ENV=production

COPY package*.json ./          # 1º: só os manifests de dependência...
RUN npm ci --omit=dev          # ...e instala. Essa camada fica em cache!

COPY src ./src                 # 2º: o código, que muda o tempo todo

USER node                      # não rode como root
EXPOSE 3000                    # documenta a porta
CMD ["node", "src/server.js"]  # exec form: o node recebe o SIGTERM direto
```

**Por que copiar o `package.json` antes do código?** Cada instrução gera uma camada, e o Docker reaproveita a camada se nada que veio antes mudou. Mudou só o código? O `npm ci` vem do cache e o build leva segundos, e não minutos.

Crie também `projeto/.dockerignore`, para não mandar lixo para o build:

```text
node_modules
npm-debug.log
.env
```

```bash
cd projeto
npm install                   # gera o package-lock.json, que o npm ci exige
docker build -t trilha-app:0.1.0 .
docker run --rm -p 3000:3000 trilha-app:0.1.0
curl localhost:3000/health    # em outro terminal
```

Mude uma linha do `server.js` e rode o build de novo: veja os `CACHED` na saída.

!!! info "Commite o `package-lock.json`"
    Ele trava as versões exatas das dependências. Sem ele, o `npm ci` falha, e cada build pode instalar versões diferentes.

## 4. Docker Compose

Rodar vários `docker run` com 10 flags cada não escala. O Compose descreve tudo num arquivo YAML. Comece por este esqueleto e **complete** o que falta:

```yaml
# projeto/compose.yaml
services:
  app:
    build: .
    ports:
      - "3000:3000"
    environment:
      DATABASE_URL: postgres://trilha:trilha@db:5432/trilha   # 'db' é o nome do serviço
      APP_VERSION: 0.1.0
    # TODO: só subir quando o db estiver saudável (depends_on + condition)

  db:
    image: postgres:17-alpine
    environment:
      POSTGRES_USER: trilha
      POSTGRES_PASSWORD: trilha
      POSTGRES_DB: trilha
    # TODO: volume nomeado montado em /var/lib/postgresql/data
    # TODO: healthcheck usando pg_isready

# TODO: declarar o volume nomeado
```

```bash
docker compose up -d --build     # sobe tudo
docker compose ps                # estado e saúde
docker compose logs -f app
curl -X POST localhost:3000/visitas
docker compose down              # para e remove os containers (os volumes ficam)
docker compose down -v           # remove os volumes também (os dados somem)
```

!!! info "Rede do Compose"
    O Compose cria uma rede onde **cada serviço é acessível pelo nome**. Por isso o `DATABASE_URL` usa `db` e não `localhost`. Dentro de um container, `localhost` é o próprio container.

## 5. Limpeza

```bash
docker system df          # quanto espaço o Docker está usando
docker image prune        # imagens sem tag
docker system prune       # containers parados, redes e imagens órfãs
docker volume prune       # volumes sem uso (cuidado: dados)
```

## Checkpoint

Escreva `projeto/Dockerfile`, `projeto/.dockerignore` e `projeto/compose.yaml`. O check verifica a estrutura e depois **sobe tudo de verdade**:

- `/health` responde com `"banco":"ok"`
- `POST /visitas` incrementa o contador
- a app roda com um usuário que não é root
- os dados sobrevivem a `down` e `up` (sem `-v`)

```bash
./trilha check 05
```

O check usa a porta 3000. Se ela estiver ocupada (outro compose rodando), rode `docker compose down` antes.

<div class="checkpoint" markdown>
**Checkpoint 05:** `./trilha check 05` verde. Lembre: branch e commits com a chave da issue do módulo 05.
</div>
