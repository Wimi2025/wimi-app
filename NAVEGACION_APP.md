# 🧭 Guía de Navegación - Wimi App

## 🚀 Cómo Ejecutar la Aplicación

### Opción 1: Windows (Recomendado para desarrollo)
```bash
flutter run -d windows
```

### Opción 2: Web (Chrome)
```bash
flutter run -d chrome
```

### Opción 3: Android
```bash
flutter run -d android
```

## 📱 Flujo de Navegación Completo

### 1. 🏠 **Pantalla de Bienvenida** (`/`)
- **Acceso**: Primera pantalla al abrir la app
- **Elementos**:
  - Logo de Wimi
  - Título "Educación Financiera Gamificada"
  - Botón "¡Comenzar Aventura!"
- **Navegación**:
  - Si usuario NO autenticado → Login
  - Si usuario autenticado → Dashboard

### 2. 🔐 **Pantalla de Login** (`/login`)
- **Acceso**: Desde Welcome Screen o botón "Iniciar Sesión"
- **Elementos**:
  - Campo Email
  - Campo Contraseña
  - Botón "Iniciar Sesión"
  - Link "¿Olvidaste tu contraseña?"
  - Link "¿No tienes cuenta? Regístrate"
- **Navegación**:
  - Login exitoso → Dashboard
  - "Regístrate" → Register Screen
  - "Olvidé contraseña" → Password Reset

### 3. 📝 **Pantalla de Registro** (`/register`)
- **Acceso**: Desde Login Screen
- **Elementos**:
  - Campo Nombre completo
  - Campo Email
  - Campo Contraseña
  - Campo Confirmar contraseña
  - Botón "Crear Cuenta"
  - Link "¿Ya tienes cuenta? Inicia sesión"
- **Navegación**:
  - Registro exitoso → Dashboard
  - "Inicia sesión" → Login Screen

### 4. 🎯 **Dashboard Principal** (`/dashboard`)
- **Acceso**: Después de login/registro exitoso
- **Elementos**:
  - **Header**: Nombre del usuario, nivel, XP
  - **Stats Cards**:
    - Nivel actual con progreso
    - XP total
    - Monedas ganadas
    - Racha diaria
  - **Quick Actions**:
    - "Continuar Aprendiendo" → Lessons
    - "Ver Logros" → Achievements
    - "Mi Perfil" → Profile
    - "Cerrar Sesión" → Welcome
- **Navegación**:
  - "Continuar Aprendiendo" → Lessons Screen
  - "Ver Logros" → Achievements Screen
  - "Mi Perfil" → Profile Screen
  - "Cerrar Sesión" → Welcome Screen

### 5. 📚 **Pantalla de Lecciones** (`/lessons`)
- **Acceso**: Desde Dashboard → "Continuar Aprendiendo"
- **Elementos**:
  - **Categorías**:
    - 🏦 Conceptos Básicos
    - 💰 Ahorro e Inversión
    - 📊 Presupuesto
    - 🏠 Créditos
    - 📈 Inversiones Avanzadas
  - **Cada categoría muestra**:
    - Icono representativo
    - Título
    - Descripción
    - Progreso (X/Y lecciones completadas)
    - Estado (Bloqueado/Disponible)
- **Navegación**:
  - Seleccionar categoría → Lecciones específicas
  - Botón atrás → Dashboard

### 6. 🏆 **Pantalla de Logros** (`/achievements`)
- **Acceso**: Desde Dashboard → "Ver Logros"
- **Elementos**:
  - **Grid de Logros**:
    - Icono del logro
    - Título
    - Descripción
    - Estado (Desbloqueado/Bloqueado)
    - Progreso (si aplica)
  - **Categorías de Logros**:
    - 🎯 Primeros Pasos
    - 📚 Aprendizaje Continuo
    - 💰 Maestro del Ahorro
    - 🏆 Experto Financiero
- **Navegación**:
  - Botón atrás → Dashboard

### 7. 👤 **Pantalla de Perfil** (`/profile`)
- **Acceso**: Desde Dashboard → "Mi Perfil"
- **Elementos**:
  - **Información Personal**:
    - Foto de perfil
    - Nombre completo
    - Email
  - **Estadísticas**:
    - Nivel actual
    - XP total
    - Lecciones completadas
    - Logros desbloqueados
  - **Configuración**:
    - "Editar Perfil"
    - "Notificaciones"
    - "Privacidad"
    - "Ayuda y Soporte"
    - "Cerrar Sesión"
- **Navegación**:
  - "Editar Perfil" → Formulario de edición
  - "Cerrar Sesión" → Welcome Screen
  - Botón atrás → Dashboard

## 🎮 Características Gamificadas

### Sistema de Niveles
- **Nivel 1-5**: Principiante
- **Nivel 6-10**: Intermedio
- **Nivel 11-15**: Avanzado
- **Nivel 16+**: Experto

### Sistema de XP
- **Completar lección**: +50 XP
- **Logro desbloqueado**: +100 XP
- **Racha diaria**: +25 XP/día
- **Quiz perfecto**: +75 XP

### Sistema de Monedas
- **Completar lección**: +10 monedas
- **Logro desbloqueado**: +25 monedas
- **Racha diaria**: +5 monedas

### Sistema de Rachas
- **Día 1**: +5 XP
- **Día 3**: +10 XP
- **Día 7**: +25 XP
- **Día 30**: +100 XP

## 🔧 Comandos de Desarrollo

### Ejecutar en modo debug
```bash
flutter run --debug
```

### Ejecutar en modo release
```bash
flutter run --release
```

### Hot reload (durante desarrollo)
```
r + Enter
```

### Hot restart (durante desarrollo)
```
R + Enter
```

### Salir de la aplicación
```
q + Enter
```

## 📊 Estados de la Aplicación

### Usuario No Autenticado
- Welcome Screen
- Login Screen
- Register Screen

### Usuario Autenticado
- Dashboard
- Lessons
- Achievements
- Profile

### Estados de Carga
- Loading spinners en botones
- Skeleton screens
- Progress indicators

### Estados de Error
- Mensajes de error en formularios
- Snackbars para notificaciones
- Diálogos de confirmación

## 🎨 Temas y Personalización

### Tema Claro
- Colores vibrantes
- Fondo blanco
- Texto oscuro

### Tema Oscuro
- Colores suaves
- Fondo oscuro
- Texto claro

### Cambio Automático
- Se adapta al tema del sistema
- Cambio manual disponible en perfil

## 🔒 Seguridad y Autenticación

### Persistencia de Sesión
- La sesión se mantiene entre reinicios
- Logout manual requerido

### Validación de Formularios
- Email válido requerido
- Contraseña mínima 6 caracteres
- Confirmación de contraseña

### Recuperación de Contraseña
- Envío de email de reset
- Link temporal de recuperación

---

**¡Disfruta explorando Wimi App! 🚀**

Para más información, consulta el `README.md` o `SETUP_GUIDE.md`. 