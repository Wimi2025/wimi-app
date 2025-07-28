import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import '../features/auth/providers/auth_provider.dart';
import '../features/gamification/providers/user_provider.dart';
import '../shared/services/firebase_service.dart';
import 'theme/app_theme.dart';
import 'navigation/app_router.dart';

class WimiApp extends StatelessWidget {
  const WimiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        Provider<FirebaseService>(create: (_) => FirebaseService()),
      ],
      child: MaterialApp.router(
        title: 'Wimi - Educación Financiera Gamificada',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
            child: child!,
          );
        },
      ),
    );
  }
}

class AppInitializer {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    
    // Inicializar Firebase
    await Firebase.initializeApp();
    
    // Configuraciones adicionales
    await _configureApp();
  }
  
  static Future<void> _configureApp() async {
    // Configurar orientación de pantalla
    // Configurar notificaciones
    // Configurar analytics
    // etc.
  }
} 