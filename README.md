# Gestor de Gastos — Entregable 1 (DevOps)

Aplicación web para registrar y visualizar gastos personales, contenerizada con Docker y desplegada en Kubernetes (minikube) con estrategia de despliegue blue/green.

Todos los comandos se corren en PowerShell, parado en la carpeta del proyecto (gestor-gastos).

# Requisitos previos

- Docker Desktop (abierto)
- minikube
- kubectl

# Levantar todo

Windows (PowerShell):

    powershell -ExecutionPolicy Bypass -File setup.ps1

Linux / Mac / WSL:

    chmod +x setup.sh switch.sh
    ./setup.sh

Esto inicia minikube, buildea las imágenes v1 y v2, las carga en el cluster, aplica los manifiestos y espera a que los Pods estén listos.

# Abrir la app

    minikube service gestor-gastos-svc

Esta terminal queda ocupada manteniendo el acceso abierto. Para cambiar de versión, abrí otra ventana de PowerShell.

# Alternar versiones (blue/green)

Cambia el selector del Service entre v1 y v2 y reaplica. Después refrescá la app en el navegador.
    
Windows (PowerShell):

    powershell -ExecutionPolicy Bypass -File switch.ps1 v2
    powershell -ExecutionPolicy Bypass -File switch.ps1 v1

Linux / Mac / WSL:

    ./switch.sh v2
    ./switch.sh v1

# Bajar todo

    kubectl delete -f k8s/
    minikube stop

# Entregable 2 — Monitoreo y observabilidad

Se agrega monitoreo con Prometheus y Grafana, y una alerta cuando se crean más de 5 gastos de la misma categoría en 5 minutos. 

# Levantar el monitoreo

Con Docker Desktop abierto, correr:

    powershell -ExecutionPolicy Bypass -File setup.ps1
    powershell -ExecutionPolicy Bypass -File setup-monitoring.ps1

Reconstruye la app con las métricas, reinicia los pods y despliega Prometheus y Grafana.

# Ver Grafana

    minikube service grafana

Usuario: admin / clave: admin. 
El dashboard "Gestor de Gastos - Monitoreo" tiene: RPS, latencia promedio, gastos por categoría y memoria del proceso.

# Ver Prometheus

    minikube service prometheus

En Status > Targets se ve el scraping cada 5 segundos. En Alerts está la alerta DemasiadosGastosEnCategoria.

# Disparar la alerta

    minikube service gestor-gastos-svc

Abrir la app y cargar varios gastos de la misma categoría (5 o más) en pocos minutos. En Prometheus > Alerts, la alerta DemasiadosGastosEnCategoria pasa a FIRING al superar el umbral de 5 gastos en 5 minutos. El umbral se cambia en k8s/monitoring/prometheus-config.yaml.

# Bajar el monitoreo

    kubectl delete -f k8s/monitoring/
    minikube stop