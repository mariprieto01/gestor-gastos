$ErrorActionPreference = "Stop"

minikube status *> $null
if ($LASTEXITCODE -ne 0) { minikube start }

docker build -t gestor-gastos:v1 ./v1
docker build -t gestor-gastos:v2 ./v2

minikube image load gestor-gastos:v1
minikube image load gestor-gastos:v2

kubectl apply -f k8s/
kubectl wait --for=condition=available --timeout=120s deployment -l app=gestor-gastos

Write-Host "Listo. Abri la app con: minikube service gestor-gastos-svc"