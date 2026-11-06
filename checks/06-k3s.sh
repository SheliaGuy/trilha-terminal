# shellcheck shell=bash
# Checkpoint 06 — Kubernetes com k3s
K="$TRILHA_ROOT/projeto/k8s"
D="$TRILHA_ROOT/checkpoints/06-k3s"
YQ="${YQ:-yq}"

# Consulta todos os manifests de projeto/k8s com yq (mikefarah, v4)
_q() { "$YQ" ea "$1" "$K"/*.yaml 2>/dev/null | grep -v '^---$' | grep -v '^null$' | head -1; }
_app='select(.kind=="Deployment" and .metadata.name=="app" and .metadata.namespace=="trilha") | .spec.template.spec.containers[0]'

section "Manifests (projeto/k8s/*.yaml)"
if ! "$YQ" --version 2>/dev/null | grep -q mikefarah; then
  fail "yq (mikefarah v4) instalado" "veja a instalação do yq no módulo 00"
else
  check "pasta projeto/k8s com arquivos .yaml" "crie projeto/k8s/" bash -c "ls '$K'/*.yaml"
  check "Namespace trilha" "kind: Namespace, name: trilha" test -n "$(_q 'select(.kind=="Namespace" and .metadata.name=="trilha") | .metadata.name')"
  check "Deployment app no namespace trilha" "metadata.name: app, metadata.namespace: trilha" \
    test -n "$(_q 'select(.kind=="Deployment" and .metadata.name=="app" and .metadata.namespace=="trilha") | .metadata.name')"
  check "app com 2 ou mais réplicas" "spec.replicas: 2" \
    test "$(_q 'select(.kind=="Deployment" and .metadata.name=="app") | .spec.replicas')" -ge 2
  _img=$(_q "$_app | .image")
  check "imagem da app com tag fixa ($_img)" "ex.: trilha-app:0.1.0 (nunca latest)" bash -c "[[ '$_img' == *:* && '$_img' != *:latest ]]"
  check "imagePullPolicy IfNotPresent ou Never" "a imagem é local (importada no k3s), não está num registry" \
    grep -Eqx 'IfNotPresent|Never' <<<"$(_q "$_app | .imagePullPolicy")"
  check "readinessProbe em /health" "readinessProbe.httpGet.path: /health" test "$(_q "$_app | .readinessProbe.httpGet.path")" = "/health"
  check "livenessProbe definida" "livenessProbe.httpGet" test -n "$(_q "$_app | .livenessProbe")"
  check "requests de cpu" "resources.requests.cpu: 50m" test -n "$(_q "$_app | .resources.requests.cpu")"
  check "limit de memória" "resources.limits.memory: 128Mi" test -n "$(_q "$_app | .resources.limits.memory")"
  check "config vem de um ConfigMap" "envFrom: - configMapRef: name: app" test -n "$(_q "$_app | .envFrom[].configMapRef.name")"
  check "DATABASE_URL vem de um Secret" "env: valueFrom.secretKeyRef" \
    test -n "$(_q "$_app | (.env[] | select(.name==\"DATABASE_URL\") | .valueFrom.secretKeyRef.name)")"
  check "Service app: porta 80 → 3000" "ports: - port: 80, targetPort: 3000" \
    test "$(_q 'select(.kind=="Service" and .metadata.name=="app") | .spec.ports[0].port + "→" + (.spec.ports[0].targetPort | tostring)')" = "80→3000"
  check "Deployment db" "o postgres também roda no cluster" \
    test -n "$(_q 'select(.kind=="Deployment" and .metadata.name=="db") | .metadata.name')"
  check "Service db" "o app acha o banco pelo nome do Service: db" \
    test -n "$(_q 'select(.kind=="Service" and .metadata.name=="db") | .metadata.name')"
  if has_cmd kubeconform; then
    check "kubeconform valida os manifests" "rode: kubeconform -strict -summary projeto/k8s" kubeconform -strict "$K"
  else
    skip "kubeconform valida os manifests" "kubeconform não instalado"
  fi
fi

section "Debug"
check "diagnostico.md existe" "crie checkpoints/06-k3s/diagnostico.md" test -f "$D/diagnostico.md"
check "diagnóstico cita o problema de imagem" "o que o 'kubectl describe pod' mostrou nos Events?" \
  file_has "$D/diagnostico.md" '(ImagePullBackOff|ErrImagePull|ErrImageNeverPull)'
check "diagnóstico cita o problema da readiness" "por que o pod não fica READY 1/1?" file_has "$D/diagnostico.md" '[Rr]eadiness'

section "Cluster (k3s)"
local_only "kubectl fala com o cluster" "confira o ~/.kube/config (veja a página)" kubectl get nodes
local_only "node Ready" "sudo systemctl status k3s" bash -c "kubectl get nodes --no-headers | grep -q ' Ready '"
local_only "deployment app com todas as réplicas prontas" "kubectl -n trilha describe deploy app" \
  bash -c "r=\$(kubectl -n trilha get deploy app -o jsonpath='{.status.readyReplicas}'); [[ \${r:-0} -ge 2 ]]"
local_only "deployment db pronto" "kubectl -n trilha describe deploy db" \
  bash -c "[[ \$(kubectl -n trilha get deploy db -o jsonpath='{.status.readyReplicas}') -ge 1 ]]"
local_only "o que roda é o que está no manifest" "kubectl apply -f projeto/k8s/" \
  bash -c "[[ \$(kubectl -n trilha get deploy app -o jsonpath='{.spec.template.spec.containers[0].image}') == '$(_q "$_app | .image")' ]]"
local_only "/health via port-forward responde banco ok" "kubectl -n trilha port-forward svc/app 8080:80 e teste com curl" bash -c '
  kubectl -n trilha port-forward svc/app 18080:80 >/dev/null 2>&1 & pf=$!
  for _ in $(seq 1 15); do curl -fsS localhost:18080/health 2>/dev/null | grep -q "\"banco\":\"ok\"" && { kill $pf; exit 0; }; sleep 1; done
  kill $pf; exit 1'
local_only "deployment 'quebrado' consertado" "./trilha exercicio 06 e siga as instruções" \
  bash -c "[[ \$(kubectl -n trilha-debug get deploy quebrado -o jsonpath='{.status.readyReplicas}') -ge 1 ]]"

require_local_evidence "$D"
