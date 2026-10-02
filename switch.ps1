param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("v1", "v2")]
    [string]$target
)

(Get-Content k8s/service.yaml) -creplace 'version: v[12]', "version: $target" | Set-Content k8s/service.yaml
kubectl apply -f k8s/service.yaml