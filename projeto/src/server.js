// Trilha Terminal — app do projeto fio-condutor.
// Uma API HTTP mínima, sem framework, para você versionar, dockerizar e subir no k3s.
//
// Variáveis de ambiente:
//   PORT          porta HTTP (padrão 3000)
//   APP_VERSION   versão exibida em /health (padrão "dev")
//   DATABASE_URL  ex.: postgres://trilha:trilha@db:5432/trilha
//                 sem ela, a app sobe mas /visitas responde 503.

const http = require("node:http");

const PORT = Number(process.env.PORT || 3000);
const VERSION = process.env.APP_VERSION || "dev";
const DATABASE_URL = process.env.DATABASE_URL;

let pool = null;
if (DATABASE_URL) {
  const { Pool } = require("pg");
  pool = new Pool({ connectionString: DATABASE_URL });
}

async function ensureSchema() {
  if (!pool) return;
  await pool.query(
    "CREATE TABLE IF NOT EXISTS visitas (id SERIAL PRIMARY KEY, criada_em TIMESTAMPTZ DEFAULT now())"
  );
}

function send(res, status, body) {
  const json = JSON.stringify(body);
  res.writeHead(status, {
    "content-type": "application/json; charset=utf-8",
    "content-length": Buffer.byteLength(json),
  });
  res.end(json);
}

async function dbOk() {
  if (!pool) return "sem-banco";
  try {
    await pool.query("SELECT 1");
    return "ok";
  } catch {
    return "erro";
  }
}

const routes = {
  "GET /health": async (_req, res) => {
    send(res, 200, { status: "ok", versao: VERSION, banco: await dbOk() });
  },

  "POST /visitas": async (_req, res) => {
    if (!pool) return send(res, 503, { erro: "DATABASE_URL não configurada" });
    await pool.query("INSERT INTO visitas DEFAULT VALUES");
    const { rows } = await pool.query("SELECT count(*)::int AS total FROM visitas");
    send(res, 201, rows[0]);
  },

  "GET /visitas": async (_req, res) => {
    if (!pool) return send(res, 503, { erro: "DATABASE_URL não configurada" });
    const { rows } = await pool.query("SELECT count(*)::int AS total FROM visitas");
    send(res, 200, rows[0]);
  },

  // Módulo 07 (Claude Code): implemente GET /sobre aqui.
  // Módulo 08 (Capstone): implemente /notas aqui.
};

const server = http.createServer(async (req, res) => {
  const path = new URL(req.url, "http://localhost").pathname;
  const handler = routes[`${req.method} ${path}`];
  try {
    if (!handler) return send(res, 404, { erro: "rota não encontrada" });
    await handler(req, res);
  } catch (err) {
    console.error(err);
    send(res, 500, { erro: "erro interno" });
  }
  console.log(`${new Date().toISOString()} ${req.method} ${path} ${res.statusCode}`);
});

ensureSchema()
  .catch((err) => console.error("falha ao criar schema:", err.message))
  .finally(() => {
    server.listen(PORT, () => console.log(`trilha-app ${VERSION} ouvindo na porta ${PORT}`));
  });

// Encerramento limpo: docker stop e kubectl delete mandam SIGTERM.
for (const sig of ["SIGTERM", "SIGINT"]) {
  process.on(sig, () => {
    console.log(`recebi ${sig}, encerrando`);
    server.close(() => (pool ? pool.end() : Promise.resolve()).then(() => process.exit(0)));
  });
}
