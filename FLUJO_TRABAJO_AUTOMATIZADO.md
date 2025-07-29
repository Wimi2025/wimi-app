# 🔄 Flujo de Trabajo Automatizado - Wimi App

## 🎯 **Respuesta a tu Pregunta**

### **✅ NO necesitas desproteger la rama main cada vez**

**La protección de ramas está diseñada para funcionar CON Pull Requests, no en contra de ellos.**

## 🚀 **Flujo de Trabajo Profesional (Recomendado)**

### **📋 Paso a Paso Automatizado:**

#### **1. Crear Nueva Funcionalidad**
```bash
# Desde Cursor, crear nueva rama
git checkout -b feature/nueva-funcionalidad

# Desarrollar normalmente (auto-save funciona)
# Hacer cambios en los archivos...
```

#### **2. Commit y Push Automático**
```bash
# Opción A: Script automático
.\scripts\git-commit.ps1 -Message "feat: Nueva funcionalidad"

# Opción B: Desde Cursor (Ctrl+Shift+P)
# "Tasks: Run Task" → "Git: Commit & Push"
```

#### **3. Crear Pull Request Automático**
```bash
# Opción A: Script automático
.\scripts\create-pr.ps1 -Title "feat: Nueva funcionalidad"

# Opción B: Desde Cursor (Ctrl+Shift+P)
# "Tasks: Run Task" → "Git: Create Pull Request"
```

#### **4. Merge Automático**
- ✅ **GitHub Actions** ejecuta tests automáticamente
- ✅ **Si pasan los tests** → Merge automático
- ✅ **Si fallan los tests** → Se bloquea hasta arreglar

## 🔧 **Configuración Actual**

### **✅ Protección de Ramas (ACTIVADA)**
- **Pull Requests obligatorios** para merge a `main`
- **Tests automáticos** antes del merge
- **Reviews requeridos** (configurable)
- **Auto-merge** cuando los tests pasen

### **✅ Automatización Completa**
- **Auto-save** en Cursor (1 segundo)
- **Formateo automático** al guardar
- **Scripts de commit/push** automatizados
- **Creación de PRs** automatizada
- **GitHub Actions** para CI/CD

## 🛠️ **Cómo Usar Desde Cursor**

### **📝 Desarrollo Normal:**
1. **Crear rama de feature:**
   ```bash
   git checkout -b feature/mi-nueva-funcionalidad
   ```

2. **Desarrollar con auto-save:**
   - Escribir código normalmente
   - Los archivos se guardan automáticamente
   - Formateo automático aplicado

3. **Commit automático:**
   - **Ctrl+Shift+P** → "Tasks: Run Task"
   - Seleccionar "Git: Commit & Push"
   - O usar: `.\scripts\git-commit.ps1`

4. **Crear PR automático:**
   - **Ctrl+Shift+P** → "Tasks: Run Task"
   - Seleccionar "Git: Create Pull Request"
   - O usar: `.\scripts\create-pr.ps1`

### **🔄 Flujo Completo Ejemplo:**

```bash
# 1. Crear rama
git checkout -b feature/login-mejorado

# 2. Desarrollar (auto-save funciona)
# Editar archivos en Cursor...

# 3. Commit automático
.\scripts\git-commit.ps1 -Message "feat: Mejorar sistema de login"

# 4. Crear PR automático
.\scripts\create-pr.ps1 -Title "feat: Mejorar sistema de login" -Body "Implementación de login mejorado con validaciones"

# 5. ¡Listo! Los tests se ejecutan automáticamente
# Si pasan → Merge automático
# Si fallan → Se bloquea hasta arreglar
```

## 🎯 **Ventajas del Sistema**

### **✅ Seguridad:**
- **Nunca** se puede hacer push directo a `main`
- **Tests obligatorios** antes del merge
- **Reviews** opcionales pero recomendados

### **✅ Automatización:**
- **Auto-save** en Cursor
- **Formateo automático**
- **Tests automáticos**
- **Merge automático** cuando todo está bien

### **✅ Profesionalismo:**
- **Historial limpio** de commits
- **Pull Requests** documentados
- **CI/CD** completo
- **Flujo estándar** de la industria

## 🔍 **Verificación del Sistema**

### **✅ Para Verificar que Todo Funciona:**

1. **Crear rama de prueba:**
   ```bash
   git checkout -b test/verificacion-sistema
   ```

2. **Hacer un cambio pequeño:**
   ```bash
   echo "# Test" >> README.md
   ```

3. **Probar commit automático:**
   ```bash
   .\scripts\git-commit.ps1 -Message "test: Verificar sistema"
   ```

4. **Probar creación de PR:**
   ```bash
   .\scripts\create-pr.ps1 -Title "test: Verificar sistema" -Body "Prueba del flujo automatizado"
   ```

5. **Verificar en GitHub:**
   - Ir a: https://github.com/Wimi2025/wimi-app/pulls
   - Ver que el PR se creó
   - Ver que los tests se ejecutan automáticamente

## 🚨 **Casos Especiales**

### **🔄 Si Necesitas Merge Directo (Emergencias):**
```bash
# 1. Deshabilitar temporalmente protección
# Ir a: https://github.com/Wimi2025/wimi-app/settings/rules
# Deshabilitar "Protección main"

# 2. Merge directo
git checkout main
git merge feature/emergencia
git push origin main

# 3. Rehabilitar protección
# Volver a habilitar "Protección main"
```

### **🔧 Si Hay Conflictos:**
```bash
# 1. Resolver conflictos localmente
git checkout feature/mi-feature
git merge main  # Para traer cambios recientes
# Resolver conflictos manualmente

# 2. Commit de resolución
git add .
git commit -m "fix: Resolver conflictos de merge"

# 3. Push y crear PR
git push origin feature/mi-feature
.\scripts\create-pr.ps1
```

## 🎉 **Resumen**

### **✅ Lo que SÍ puedes hacer:**
- ✅ Desarrollar en ramas de feature
- ✅ Commit y push automático
- ✅ Crear Pull Requests automáticamente
- ✅ Merge automático cuando los tests pasen
- ✅ Todo desde Cursor sin tocar GitHub web

### **❌ Lo que NO necesitas hacer:**
- ❌ Desproteger ramas cada vez
- ❌ Merge manual en GitHub
- ❌ Gestión manual de tests
- ❌ Formateo manual de código

### **🚀 Resultado:**
- **Desarrollo fluido** y automatizado
- **Seguridad máxima** en la rama principal
- **Calidad garantizada** con tests automáticos
- **Flujo profesional** estándar de la industria

---

**¡Tu sistema está configurado para desarrollo profesional automatizado! 🎉**

**Enlaces útiles:**
- **Repositorio**: https://github.com/Wimi2025/wimi-app
- **Pull Requests**: https://github.com/Wimi2025/wimi-app/pulls
- **Actions**: https://github.com/Wimi2025/wimi-app/actions
- **Settings**: https://github.com/Wimi2025/wimi-app/settings 