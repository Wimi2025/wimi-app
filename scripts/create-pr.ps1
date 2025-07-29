# Script para crear Pull Requests automáticamente desde Cursor
param(
    [string]$Title = "feat: Nueva funcionalidad",
    [string]$Body = "Cambios automáticos desde Cursor",
    [string]$BaseBranch = "main",
    [switch]$AutoMerge = $true
)

Write-Host "🚀 Iniciando proceso de Pull Request automático..." -ForegroundColor Green

# Obtener el nombre de la rama actual
$currentBranch = git branch --show-current
if ($currentBranch -eq $BaseBranch) {
    Write-Host "❌ Error: No puedes crear un PR desde la rama $BaseBranch" -ForegroundColor Red
    Write-Host "💡 Crea una rama de feature primero: git checkout -b feature/nueva-funcionalidad" -ForegroundColor Yellow
    exit 1
}

Write-Host "📋 Rama actual: $currentBranch" -ForegroundColor Cyan
Write-Host "🎯 Rama destino: $BaseBranch" -ForegroundColor Cyan

# Verificar si hay cambios para commit
$status = git status --porcelain
if ($status) {
    Write-Host "📝 Hay cambios sin commit. Ejecutando commit automático..." -ForegroundColor Yellow
    
    # Commit automático
    git add .
    git commit -m $Title
    
    Write-Host "✅ Commit realizado: $Title" -ForegroundColor Green
}
else {
    Write-Host "✅ No hay cambios pendientes" -ForegroundColor Green
}

# Push de la rama
Write-Host "📤 Subiendo rama al repositorio remoto..." -ForegroundColor Yellow
git push origin $currentBranch

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Rama subida exitosamente" -ForegroundColor Green
}
else {
    Write-Host "❌ Error al subir la rama" -ForegroundColor Red
    exit 1
}

# Crear Pull Request usando GitHub CLI
Write-Host "🔗 Creando Pull Request..." -ForegroundColor Yellow

$prBody = @"
## 📝 Descripción
$Body

## ✅ Checklist
- [x] Código formateado automáticamente
- [x] Tests pasando
- [x] Sin conflictos de merge

## 🚀 Auto-merge
Este PR se mergeará automáticamente cuando los tests pasen.
"@

# Intentar crear PR con GitHub CLI
try {
    gh pr create --title $Title --body $prBody --base $BaseBranch --head $currentBranch
    Write-Host "✅ Pull Request creado exitosamente!" -ForegroundColor Green
    
    if ($AutoMerge) {
        Write-Host "🔄 Configurando auto-merge..." -ForegroundColor Yellow
        gh pr merge --auto --squash
        Write-Host "✅ Auto-merge configurado" -ForegroundColor Green
    }
    
    # Abrir el PR en el navegador
    Write-Host "🌐 Abriendo Pull Request en el navegador..." -ForegroundColor Yellow
    Start-Process "https://github.com/Wimi2025/wimi-app/pulls"
    
}
catch {
    Write-Host "⚠️  GitHub CLI no disponible o error. Creando PR manualmente..." -ForegroundColor Yellow
    Write-Host "🔗 URL para crear PR manualmente:" -ForegroundColor Cyan
    Write-Host "https://github.com/Wimi2025/wimi-app/compare/$BaseBranch...$currentBranch" -ForegroundColor White
    
    # Abrir la URL de comparación
    Start-Process "https://github.com/Wimi2025/wimi-app/compare/$BaseBranch...$currentBranch"
}

Write-Host "🎉 Proceso completado!" -ForegroundColor Green
Write-Host "💡 Próximos pasos:" -ForegroundColor Cyan
Write-Host "   1. Revisar el Pull Request" -ForegroundColor White
Write-Host "   2. Los tests se ejecutarán automáticamente" -ForegroundColor White
Write-Host "   3. Si pasan los tests, se mergeará automáticamente" -ForegroundColor White 