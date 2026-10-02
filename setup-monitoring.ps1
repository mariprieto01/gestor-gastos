$ErrorActionPreference = "Stop"

docker build -t gestor-gastos:v1 ./v1
docker build -t gestor-gastos:v2 ./v2

minikube image load gestor-gastos:v1
minikube image load gestor-gastos:v2

kubectl apply -f k8s/
kubectl rollout restart deployment gestor-gastos-v1 gestor-gastos-v2

kubectl apply -f k8s/monitoring/

kubectl rollout status deployment prometheus
kubectl rollout status deployment grafana

Write-Host ""
Write-Host "Listo. Abri cada uno en su propia terminal de PowerShell:"
Write-Host "  Grafana:    minikube service grafana       (usuario: admin  clave: admin)"
Write-Host "  Prometheus: minikube service prometheus"