# Script para crear Pull Requests
param(
    [string]$Title = "feat: Nueva funcionalidad",
    [string]$BaseBranch = "main"
)

Write-Host "Iniciando proceso de Pull Request..." -ForegroundColor Green

# Obtener rama actual
$currentBranch = git branch --show-current
Write-Host "Rama actual: $currentBranch" -ForegroundColor Cyan
Write-Host "Rama destino: $BaseBranch" -ForegroundColor Cyan

# Commit si hay cambios
$status = git status --porcelain
if ($status) {
    Write-Host "Haciendo commit de cambios..." -ForegroundColor Yellow
    git add .
    git commit -m $Title
}

# Push
Write-Host "Subiendo rama..." -ForegroundColor Yellow
git push origin $currentBranch

# Abrir URL para crear PR
$prUrl = "https://github.com/Wimi2025/wimi-app/compare/$BaseBranch...$currentBranch"
Write-Host "URL para crear PR: $prUrl" -ForegroundColor Cyan
Start-Process $prUrl

Write-Host "Proceso completado!" -ForegroundColor Green 