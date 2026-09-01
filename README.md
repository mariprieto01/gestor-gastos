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
