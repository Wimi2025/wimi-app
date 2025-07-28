# 🌿 Configuración de Protección de Ramas - Wimi App

## 📋 Reglas de Protección Recomendadas

### **Rama `main` (Producción)**
- ✅ **Require a pull request before merging**
- ✅ **Require status checks to pass before merging**
- ✅ **Require branches to be up to date before merging**
- ✅ **Require linear history**
- ✅ **Include administrators**
- ✅ **Restrict pushes that create files that are larger than 100 MB**

### **Rama `develop` (Desarrollo)**
- ✅ **Require a pull request before merging**
- ✅ **Require status checks to pass before merging**
- ✅ **Allow force pushes**
- ✅ **Allow deletions**

### **Ramas de Feature (`feature/*`)**
- ✅ **Require a pull request before merging**
- ✅ **Require status checks to pass before merging**
- ✅ **Allow force pushes**
- ✅ **Allow deletions**

## 🔧 Configuración en GitHub

### **Paso 1: Ir a Settings del Repositorio**
1. Ve a: https://github.com/Wimi2025/wimi-app/settings
2. Navega a "Branches" en el menú lateral

### **Paso 2: Configurar Reglas para `main`**
1. Click en "Add rule"
2. **Branch name pattern**: `main`
3. **Settings**:
   - ✅ Require a pull request before merging
   - ✅ Require status checks to pass before merging
   - ✅ Require branches to be up to date before merging
   - ✅ Require linear history
   - ✅ Include administrators
   - ✅ Restrict pushes that create files that are larger than 100 MB

### **Paso 3: Configurar Reglas para `develop`**
1. Click en "Add rule"
2. **Branch name pattern**: `develop`
3. **Settings**:
   - ✅ Require a pull request before merging
   - ✅ Require status checks to pass before merging
   - ✅ Allow force pushes
   - ✅ Allow deletions

### **Paso 4: Configurar Reglas para Features**
1. Click en "Add rule"
2. **Branch name pattern**: `feature/*`
3. **Settings**:
   - ✅ Require a pull request before merging
   - ✅ Require status checks to pass before merging
   - ✅ Allow force pushes
   - ✅ Allow deletions

## 🚀 Flujo de Trabajo Recomendado

### **Para Nuevas Funcionalidades:**
```bash
# Crear rama de feature
git checkout -b feature/nueva-funcionalidad

# Desarrollar cambios
# ... hacer cambios ...

# Commit y push
git add .
git commit -m "feat: Nueva funcionalidad"
git push origin feature/nueva-funcionalidad

# Crear Pull Request a develop
# Merge en develop cuando esté listo
```

### **Para Releases:**
```bash
# Desde develop, crear rama de release
git checkout -b release/v1.0.0

# Hacer ajustes finales
# ... ajustes ...

# Merge a main y develop
git checkout main
git merge release/v1.0.0
git push origin main

git checkout develop
git merge release/v1.0.0
git push origin develop

# Eliminar rama de release
git branch -d release/v1.0.0
```

## 🔍 Status Checks Requeridos

### **Checks Obligatorios:**
- ✅ **Flutter CI/CD / test** - Tests unitarios
- ✅ **Flutter CI/CD / build-web** - Build de web
- ✅ **Flutter CI/CD / build-android** - Build de Android

### **Checks Opcionales:**
- ✅ **Code coverage** - Cobertura de código
- ✅ **Security scan** - Escaneo de seguridad

## 📊 Beneficios de esta Configuración

1. **Calidad del Código**: Todos los cambios pasan por review
2. **Estabilidad**: Tests obligatorios antes del merge
3. **Trazabilidad**: Historial lineal y documentado
4. **Seguridad**: Protección contra cambios accidentales
5. **Colaboración**: Reviews obligatorios para cambios importantes

## 🎯 Próximos Pasos

1. **Configurar las reglas** en GitHub Settings
2. **Hacer merge de la rama consolidada** a main
3. **Eliminar ramas antiguas** después del merge
4. **Configurar GitHub Actions** para CI/CD automático
5. **Documentar el flujo** para el equipo

---

**Nota**: Esta configuración asegura que tu repositorio mantenga alta calidad y estabilidad en el código de producción. 