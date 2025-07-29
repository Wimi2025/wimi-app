import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'app_logger.dart';

class CrashService {
  static FirebaseCrashlytics? _crashlytics;

  static void initialize() {
    if (!kDebugMode) {
      _crashlytics = FirebaseCrashlytics.instance;
      AppLogger.info('✅ Crash service inicializado');
    } else {
      AppLogger.info('ℹ️ Crash service deshabilitado en modo debug');
    }
  }

  static Future<void> recordError(
    dynamic exception,
    StackTrace stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    AppLogger.error('Crash registrado: $reason', exception, stackTrace);

    if (_crashlytics != null) {
      await _crashlytics!.recordError(
        exception,
        stackTrace,
        reason: reason,
        fatal: fatal,
      );
    }
  }

  static Future<void> recordFlutterError(FlutterErrorDetails details) async {
    AppLogger.error(
      'Flutter error registrado',
      details.exception,
      details.stack,
    );

    if (_crashlytics != null) {
      await _crashlytics!.recordFlutterFatalError(details);
    }
  }

  static Future<void> log(String message) async {
    AppLogger.info('Crash log: $message');

    if (_crashlytics != null) {
      await _crashlytics!.log(message);
    }
  }

  static Future<void> setUserId(String userId) async {
    if (_crashlytics != null) {
      await _crashlytics!.setUserIdentifier(userId);
    }
  }

  static Future<void> setCustomKey(String key, dynamic value) async {
    if (_crashlytics != null) {
      await _crashlytics!.setCustomKey(key, value);
    }
  }
}
