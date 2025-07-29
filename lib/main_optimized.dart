import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:logger/logger.dart';

import 'firebase_options.dart';
import 'app/app.dart';
import 'core/services/app_logger.dart';
import 'core/services/crash_service.dart';
import 'core/services/performance_service.dart';

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

  // Ejecutar app con manejo de errores
  await SentryFlutter.init((options) {
    options.dsn = 'YOUR_SENTRY_DSN'; // TODO: Configurar en producción
    options.tracesSampleRate = 1.0;
    options.debug = false;
  }, appRunner: () => runApp(ProviderScope(child: WimiApp())));
}

Future<void> _initializeServices() async {
  try {
    // Inicializar Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    logger.i('✅ Firebase inicializado correctamente');

    // Configurar Crashlytics
    FlutterError.onError = (errorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
    };

    // Configurar logger
    AppLogger.initialize();
    logger.i('✅ Logger configurado');

    // Inicializar servicios de performance
    PerformanceService.initialize();
    logger.i('✅ Performance service inicializado');

    // Configurar crash reporting
    CrashService.initialize();
    logger.i('✅ Crash service configurado');
  } catch (e, stackTrace) {
    logger.e(
      '❌ Error al inicializar servicios',
      error: e,
      stackTrace: stackTrace,
    );
    // En caso de error crítico, mostrar pantalla de error
    runApp(ErrorApp(error: e.toString()));
  }
}

void _setupErrorHandling() {
  // Capturar errores no manejados
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    logger.e('Error no manejado', error: error, stackTrace: stack);
    return true;
  };

  // Configurar manejo de errores de Flutter
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    FirebaseCrashlytics.instance.recordFlutterFatalError(details);
    logger.e(
      'Flutter Error',
      error: details.exception,
      stackTrace: details.stack,
    );
  };
}

// App de error para casos críticos
class ErrorApp extends StatelessWidget {
  final String error;

  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Error de Inicialización',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'No se pudo inicializar la aplicación',
                style: TextStyle(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // Reintentar inicialización
                  SystemNavigator.pop();
                },
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
