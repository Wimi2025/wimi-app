import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import 'firebase_options.dart';
import 'app/app.dart';
import 'core/services/app_logger.dart';
import 'core/services/crash_service.dart';

final logger = Logger();

void main() async {
  // Configuración inicial
  WidgetsFlutterBinding.ensureInitialized();

  // Configurar orientación
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configurar barra de estado
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Inicializar servicios
  await _initializeServices();

  // Configurar manejo de errores
  _setupErrorHandling();

  // Ejecutar aplicación
  runApp(ProviderScope(child: const WimiApp()));
}

Future<void> _initializeServices() async {
  try {
    // Inicializar Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    logger.i('✅ Firebase inicializado correctamente');

    // Configurar Crashlytics en modo release
    if (!kDebugMode) {
      FlutterError.onError = (errorDetails) {
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      };

      // Configurar crash reporting
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    }

    // Configurar logger
    AppLogger.initialize();
    logger.i('✅ Logger configurado');

    // Configurar crash service
    CrashService.initialize();
    logger.i('✅ Crash service configurado');
  } catch (e, stackTrace) {
    logger.e(
      '❌ Error al inicializar servicios',
      error: e,
      stackTrace: stackTrace,
    );
    // En caso de error crítico, continuar con configuración básica
    _initializeBasicApp();
  }
}

void _setupErrorHandling() {
  // Capturar errores no manejados
  PlatformDispatcher.instance.onError = (error, stack) {
    if (!kDebugMode) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    }
    logger.e('Error no manejado', error: error, stackTrace: stack);
    return true;
  };

  // Configurar manejo de errores de Flutter
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    if (!kDebugMode) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    }
    logger.e(
      'Flutter Error',
      error: details.exception,
      stackTrace: details.stack,
    );
  };
}

void _initializeBasicApp() {
  // Configuración básica sin Firebase si hay problemas críticos
  logger.w('⚠️ Inicializando aplicación en modo básico');
}
