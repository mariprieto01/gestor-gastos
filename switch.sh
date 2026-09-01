#!/usr/bin/env bash
set -euo pipefail

TARGET="${1:-}"
if [[ "$TARGET" != "v1" && "$TARGET" != "v2" ]]; then
  echo "Uso: ./switch.sh [v1|v2]"
  exit 1
fi

echo "==> Cambiando el selector del Service a $TARGET..."
# Reemplaza la version en el archivo versionado y lo reaplica (estrategia blue/green)
sed "s/version: v[12]/version: $TARGET/" k8s/service.yaml > k8s/service.yaml.tmp
mv k8s/service.yaml.tmp k8s/service.yaml
kubectl apply -f k8s/service.yaml

echo "Listo. El Service ahora apunta a $TARGET."
echo "Abri o refresca la app con: minikube service gestor-gastos-svc"
