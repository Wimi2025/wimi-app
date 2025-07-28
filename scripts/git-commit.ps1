# Script para automatizar commits y push en Wimi App
param(
    [string]$Message = "Update: Cambios automáticos desde Cursor",
    [switch]$Push = $true,
    [switch]$All = $true
)

Write-Host "🚀 Iniciando proceso de commit automático..." -ForegroundColor Green

# Verificar estado de Git
Write-Host "📋 Verificando estado de Git..." -ForegroundColor Yellow
git status

# Agregar todos los archivos si se especifica -All
if ($All) {
    Write-Host "📁 Agregando todos los archivos..." -ForegroundColor Yellow
    git add .
} else {
    Write-Host "📁 Agregando archivos modificados..." -ForegroundColor Yellow
    git add -u
}

# Verificar qué se va a commitear
Write-Host "📝 Archivos preparados para commit:" -ForegroundColor Yellow
git status --porcelain

# Realizar commit
Write-Host "💾 Realizando commit con mensaje: $Message" -ForegroundColor Yellow
git commit -m $Message

# Push si se especifica
if ($Push) {
    Write-Host "🚀 Haciendo push al repositorio remoto..." -ForegroundColor Yellow
    git push
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Push exitoso!" -ForegroundColor Green
    } else {
        Write-Host "❌ Error en el push. Verifica la conexión." -ForegroundColor Red
    }
}

Write-Host "🎉 Proceso completado!" -ForegroundColor Green 