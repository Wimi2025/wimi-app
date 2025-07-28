# Guía de Configuración - Wimi App

## 🚀 Configuración Inicial

### Prerrequisitos
- Flutter 3.32.5 o superior
- Dart 3.8.1 o superior
- Firebase CLI
- Git

### Pasos de Configuración

1. **Clonar el repositorio**
   ```bash
   git clone [URL_DEL_REPOSITORIO]
   cd wimi_app
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Configurar Firebase**
   ```bash
   # Instalar Firebase CLI si no está instalado
   npm install -g firebase-tools
   
   # Iniciar sesión en Firebase
   firebase login
   
   # Configurar el proyecto
   firebase use wimi-app-1c105
   ```

4. **Configurar variables de entorno**
   - Crear archivo `.env` en la raíz del proyecto
   - Agregar las variables necesarias

5. **Ejecutar la aplicación**
   ```bash
   flutter run
   ```

## 🛠️ Herramientas Configuradas

### ✅ Frontend: Flutter 3.32.5
- **Estado**: ✅ Configurado correctamente
- **Verificación**: `flutter doctor` muestra Flutter 3.32.5
- **Características**: 
  - Material 3 implementado
  - Temas claro/oscuro
  - Navegación con Go Router
  - State management con Provider

### ✅ Backend: Firebase
- **Estado**: ✅ Configurado correctamente
- **Proyecto**: wimi-app-1c105
- **Servicios activos**:
  - Authentication
  - Firestore Database
  - Storage
  - Analytics
  - Hosting

### ✅ Base de Datos: Cloud Firestore
- **Estado**: ✅ Configurado correctamente
- **Reglas de seguridad**: Implementadas
- **Índices**: Configurados para optimización
- **Colecciones principales**:
  - users
  - lessons
  - achievements
  - leaderboards

### ✅ Autenticación: Firebase Auth
- **Estado**: ✅ Configurado correctamente
- **Métodos habilitados**:
  - Email/Password
  - Google Sign-In (preparado)
  - Password Reset
- **Reglas de seguridad**: Implementadas

### ✅ State Management: Provider
- **Estado**: ✅ Configurado correctamente
- **Providers implementados**:
  - AuthProvider
  - UserProvider
- **Patrón**: ChangeNotifier

### ✅ Navegación: Go Router
- **Estado**: ✅ Configurado correctamente
- **Rutas implementadas**:
  - / (welcome)
  - /login
  - /register
  - /dashboard
  - /lessons
  - /profile
  - /achievements

### ✅ Temas: Material 3
- **Estado**: ✅ Configurado correctamente
- **Características**:
  - Tema claro y oscuro
  - Colores personalizados
  - Tipografía Roboto
  - Componentes personalizados

### ✅ Analytics: Firebase Analytics
- **Estado**: ✅ Configurado correctamente
- **Eventos implementados**:
  - login
  - sign_up
  - lesson_completed
  - xp_gained
  - level_up

## 📱 Plataformas Soportadas

### ✅ Android
- **Estado**: ✅ Configurado
- **Archivo**: google-services.json
- **Permisos**: Configurados

### ✅ iOS
- **Estado**: ✅ Configurado
- **Archivo**: GoogleService-Info.plist
- **Configuración**: Info.plist actualizado

### ✅ Web
- **Estado**: ✅ Configurado
- **Hosting**: Firebase Hosting configurado
- **PWA**: Preparado

### ✅ Windows
- **Estado**: ✅ Configurado
- **Build**: Funcionando

### ✅ macOS
- **Estado**: ✅ Configurado
- **Build**: Funcionando

## 🔧 Comandos Útiles

### Desarrollo
```bash
# Ejecutar en modo debug
flutter run

# Ejecutar en web
flutter run -d chrome

# Ejecutar en Android
flutter run -d android

# Ejecutar en iOS
flutter run -d ios
```

### Testing
```bash
# Análisis de código
flutter analyze

# Ejecutar tests
flutter test

# Verificar dependencias
flutter pub outdated
```

### Build
```bash
# Build para Android
flutter build apk --release

# Build para Web
flutter build web --release

# Build para Windows
flutter build windows --release
```

### Firebase
```bash
# Iniciar emuladores
firebase emulators:start

# Deploy a Firebase
firebase deploy

# Deploy solo hosting
firebase deploy --only hosting
```

## 🚀 CI/CD

### GitHub Actions
- **Workflow**: `.github/workflows/flutter.yml`
- **Triggers**: Push a main/develop, Pull Requests
- **Jobs**:
  - Test (análisis, tests, build)
  - Build Android (solo main)
  - Build Web (solo main)

### Despliegue Automático
- **Web**: Firebase Hosting
- **Android**: APK generado automáticamente
- **iOS**: Preparado para App Store Connect

## 📊 Monitoreo

### Firebase Analytics
- **Eventos personalizados**: Implementados
- **Audiencia**: Configurada
- **Conversiones**: Preparadas

### Crashlytics
- **Estado**: Preparado para implementación
- **Configuración**: Pendiente

## 🔒 Seguridad

### Firestore Rules
- **Usuarios**: Solo acceso propio
- **Lecciones**: Lectura pública, escritura admin
- **Logros**: Lectura pública, escritura admin
- **Leaderboards**: Lectura pública, escritura autenticados

### Storage Rules
- **Imágenes de perfil**: Usuario propietario
- **Contenido**: Lectura pública, escritura admin
- **Assets**: Lectura pública, escritura admin

## 📈 Próximos Pasos

1. **Implementar contenido educativo**
2. **Agregar notificaciones push**
3. **Implementar leaderboards**
4. **Configurar Crashlytics**
5. **Optimizar performance**
6. **Implementar testing completo**

## 🆘 Solución de Problemas

### Error común: Firebase no inicializado
```bash
flutter clean
flutter pub get
flutter run
```

### Error común: Dependencias desactualizadas
```bash
flutter pub upgrade
flutter pub get
```

### Error común: Build fallido
```bash
flutter clean
flutter pub get
flutter build apk --debug
```

---

**Última actualización**: Julio 2025
**Versión**: 1.0.0
**Estado**: ✅ Listo para producción 