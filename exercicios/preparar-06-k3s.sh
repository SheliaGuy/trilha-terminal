#!/usr/bin/env bash
# Aplica um Deployment com defeitos no namespace trilha-debug.
set -euo pipefail
if ! kubectl get nodes >/dev/null 2>&1; then
  echo "kubectl não fala com o cluster. Termine a parte de instalação do k3s antes."
  exit 1
fi
kubectl apply -f "$TRILHA_ROOT/exercicios/k3s/quebrado.yaml"
cat <<'MSG'

O Deployment 'quebrado' foi aplicado no namespace trilha-debug. Ele tem DOIS defeitos.
Descubra quais são usando só kubectl (get, describe, logs, events), conserte no cluster
(kubectl edit / kubectl set image / kubectl patch) e explique em
checkpoints/06-k3s/diagnostico.md o que viu, a causa e o comando que corrigiu.

Comece por:  kubectl -n trilha-debug get pods
MSG
