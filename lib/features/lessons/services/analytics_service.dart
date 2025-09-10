import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:logger/logger.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  final Logger _logger = Logger();

  // Eventos de lecciones
  Future<void> logLessonStart({
    required String routeId,
    required String lessonId,
    required String userId,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'lesson_start',
        parameters: {
          'route_id': routeId,
          'lesson_id': lessonId,
          'user_id': _hashUserId(userId),
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
      _logger.i('Analytics: lesson_start logged for $lessonId');
    } catch (e) {
      _logger.e('Error logging lesson_start', error: e);
    }
  }

  Future<void> logLessonComplete({
    required String routeId,
    required String lessonId,
    required String userId,
    required int score,
    required int xpEarned,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'lesson_complete',
        parameters: {
          'route_id': routeId,
          'lesson_id': lessonId,
          'user_id': _hashUserId(userId),
          'score': score,
          'xp_earned': xpEarned,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
      _logger.i('Analytics: lesson_complete logged for $lessonId');
    } catch (e) {
      _logger.e('Error logging lesson_complete', error: e);
    }
  }

  Future<void> logQuizAnswer({
    required String routeId,
    required String lessonId,
    required String userId,
    required String questionType, // 'mcq', 'vf', 'gap', 'slider'
    required bool isCorrect,
    required int questionIndex,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'quiz_answer',
        parameters: {
          'route_id': routeId,
          'lesson_id': lessonId,
          'user_id': _hashUserId(userId),
          'question_type': questionType,
          'is_correct': isCorrect,
          'question_index': questionIndex,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
      _logger.i('Analytics: quiz_answer logged for $lessonId');
    } catch (e) {
      _logger.e('Error logging quiz_answer', error: e);
    }
  }

  Future<void> logSimulatorUsed({
    required String routeId,
    required String lessonId,
    required String userId,
    required String
    simulatorName, // 'presupuesto', 'cuota_interes', 'interes_compuesto'
    required Map<String, dynamic> params,
  }) async {
    try {
      // Crear una versión simplificada de los parámetros para Analytics
      final paramsMin = <String, dynamic>{};
      for (final entry in params.entries) {
        if (entry.value is num) {
          paramsMin[entry.key] = entry.value;
        } else if (entry.value is String) {
          paramsMin[entry.key] = entry.value;
        }
      }

      await _analytics.logEvent(
        name: 'sim_used',
        parameters: {
          'route_id': routeId,
          'lesson_id': lessonId,
          'user_id': _hashUserId(userId),
          'simulator_name': simulatorName,
          'params_min': paramsMin,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
      _logger.i('Analytics: sim_used logged for $lessonId');
    } catch (e) {
      _logger.e('Error logging sim_used', error: e);
    }
  }

  // Eventos de gamificación
  Future<void> logStreakUpdate({
    required String userId,
    required int streakDays,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'streak_update',
        parameters: {
          'user_id': _hashUserId(userId),
          'streak_days': streakDays,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
      _logger.i('Analytics: streak_update logged for user');
    } catch (e) {
      _logger.e('Error logging streak_update', error: e);
    }
  }

  Future<void> logLevelUp({
    required String userId,
    required int fromLevel,
    required int toLevel,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'level_up',
        parameters: {
          'user_id': _hashUserId(userId),
          'from_level': fromLevel,
          'to_level': toLevel,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
      _logger.i('Analytics: level_up logged for user');
    } catch (e) {
      _logger.e('Error logging level_up', error: e);
    }
  }

  // Eventos de progreso
  Future<void> logProgressUpdate({
    required String userId,
    required String routeId,
    required int lessonsCompleted,
    required int totalLessons,
    required int xpEarned,
  }) async {
    try {
      await _analytics.logEvent(
        name: 'progress_update',
        parameters: {
          'user_id': _hashUserId(userId),
          'route_id': routeId,
          'lessons_completed': lessonsCompleted,
          'total_lessons': totalLessons,
          'xp_earned': xpEarned,
          'completion_percentage': (lessonsCompleted / totalLessons * 100)
              .round(),
          'timestamp': DateTime.now().millisecondsSinceEpoch,
        },
      );
      _logger.i('Analytics: progress_update logged for $routeId');
    } catch (e) {
      _logger.e('Error logging progress_update', error: e);
    }
  }

  // Eventos de engagement
  Future<void> logScreenView({
    required String screenName,
    required String userId,
    Map<String, dynamic>? parameters,
  }) async {
    try {
      final params = <String, dynamic>{
        'user_id': _hashUserId(userId),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      if (parameters != null) {
        params.addAll(parameters);
      }

      await _analytics.logEvent(name: 'screen_view', parameters: params);
      _logger.i('Analytics: screen_view logged for $screenName');
    } catch (e) {
      _logger.e('Error logging screen_view', error: e);
    }
  }

  Future<void> logUserEngagement({
    required String userId,
    required String
    action, // 'lesson_start', 'lesson_complete', 'simulator_use', etc.
    required String routeId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final params = <String, dynamic>{
        'user_id': _hashUserId(userId),
        'action': action,
        'route_id': routeId,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      if (metadata != null) {
        params.addAll(metadata);
      }

      await _analytics.logEvent(name: 'user_engagement', parameters: params);
      _logger.i('Analytics: user_engagement logged for $action');
    } catch (e) {
      _logger.e('Error logging user_engagement', error: e);
    }
  }

  // Eventos de error
  Future<void> logError({
    required String errorType,
    required String errorMessage,
    required String userId,
    String? routeId,
    String? lessonId,
  }) async {
    try {
      final params = <String, dynamic>{
        'error_type': errorType,
        'error_message': errorMessage,
        'user_id': _hashUserId(userId),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      if (routeId != null) params['route_id'] = routeId;
      if (lessonId != null) params['lesson_id'] = lessonId;

      await _analytics.logEvent(name: 'app_error', parameters: params);
      _logger.i('Analytics: app_error logged for $errorType');
    } catch (e) {
      _logger.e('Error logging app_error', error: e);
    }
  }

  // Configurar propiedades del usuario
  Future<void> setUserProperties({
    required String userId,
    required int level,
    required int xp,
    required int streak,
    required List<String> completedRoutes,
  }) async {
    try {
      await _analytics.setUserProperty(
        name: 'user_level',
        value: level.toString(),
      );

      await _analytics.setUserProperty(name: 'user_xp', value: xp.toString());

      await _analytics.setUserProperty(
        name: 'user_streak',
        value: streak.toString(),
      );

      await _analytics.setUserProperty(
        name: 'completed_routes',
        value: completedRoutes.join(','),
      );

      _logger.i('Analytics: user properties set for user');
    } catch (e) {
      _logger.e('Error setting user properties', error: e);
    }
  }

  // Hash del userId para privacidad
  String _hashUserId(String userId) {
    // En un entorno real, usarías un hash más seguro
    return userId.hashCode.toString();
  }

  // Obtener instancia de Firebase Analytics
  FirebaseAnalytics get analytics => _analytics;
}
