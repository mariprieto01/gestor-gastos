#!/usr/bin/env bash
set -e

target="${1:-}"
if [[ "$target" != "v1" && "$target" != "v2" ]]; then
  echo "Uso: ./switch.sh [v1|v2]"
  exit 1
fi

sed "s/version: v[12]/version: $target/" k8s/service.yaml > k8s/service.yaml.tmp
mv k8s/service.yaml.tmp k8s/service.yaml
kubectl apply -f k8s/service.yaml