import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';

import '../models/lesson_model.dart';

class LessonRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  static const String _routesCollection = 'routes';
  static const String _lessonsCollection = 'lessons';
  static const String _userProgressCollection = 'userProgress';
  static const String _userStatsCollection = 'userStats';
  static const String _leaderboardsCollection = 'leaderboards';

  // Cache local
  final Map<String, List<RouteModel>> _routesCache = {};
  final Map<String, List<LessonModel>> _lessonsCache = {};
  final Map<String, UserProgress> _progressCache = {};

  // Obtener rutas (cache + Firestore fallback)
  Future<List<RouteModel>> getRoutes() async {
    try {
      // Intentar cargar desde cache local primero
      if (_routesCache.isNotEmpty) {
        final allRoutes = _routesCache.values.expand((x) => x).toList();
        allRoutes.sort((a, b) => a.order.compareTo(b.order));
        return allRoutes;
      }

      // Cargar desde archivos JSON locales
      final routes = await _loadRoutesFromAssets();
      if (routes.isNotEmpty) {
        _routesCache['all'] = routes;
        return routes;
      }

      // Fallback a Firestore
      final snapshot = await _firestore.collection(_routesCollection).get();
      final routesFromFirestore = snapshot.docs
          .map((doc) => RouteModel.fromFirestore(doc))
          .toList();

      routesFromFirestore.sort((a, b) => a.order.compareTo(b.order));
      _routesCache['all'] = routesFromFirestore;

      return routesFromFirestore;
    } catch (e) {
      _logger.e('Error al obtener rutas', error: e);
      return [];
    }
  }

  // Obtener lecciones de una ruta específica
  Future<List<LessonModel>> getLessonsByRoute(String routeId) async {
    try {
      // Verificar cache
      if (_lessonsCache.containsKey(routeId)) {
        return _lessonsCache[routeId]!;
      }

      // Cargar desde archivos JSON locales
      final lessons = await _loadLessonsFromAssets(routeId);
      if (lessons.isNotEmpty) {
        _lessonsCache[routeId] = lessons;
        return lessons;
      }

      // Fallback a Firestore
      final snapshot = await _firestore
          .collection(_lessonsCollection)
          .where('routeId', isEqualTo: routeId)
          .orderBy('order')
          .get();

      final lessonsFromFirestore = snapshot.docs
          .map((doc) => LessonModel.fromFirestore(doc))
          .toList();

      _lessonsCache[routeId] = lessonsFromFirestore;
      return lessonsFromFirestore;
    } catch (e) {
      _logger.e('Error al obtener lecciones para ruta $routeId', error: e);
      return [];
    }
  }

  // Obtener progreso del usuario para una lección
  Future<UserProgress?> getUserProgress(String userId, String lessonId) async {
    try {
      final cacheKey = '${userId}_$lessonId';

      if (_progressCache.containsKey(cacheKey)) {
        return _progressCache[cacheKey];
      }

      final doc = await _firestore
          .collection(_userProgressCollection)
          .doc(userId)
          .collection('lessons')
          .doc(lessonId)
          .get();

      if (doc.exists) {
        final progress = UserProgress.fromFirestore(doc);
        _progressCache[cacheKey] = progress;
        return progress;
      }

      return null;
    } catch (e) {
      _logger.e('Error al obtener progreso del usuario', error: e);
      return null;
    }
  }

  // Actualizar progreso del usuario
  Future<void> updateUserProgress(UserProgress progress) async {
    try {
      final cacheKey = '${progress.userId}_${progress.lessonId}';

      await _firestore
          .collection(_userProgressCollection)
          .doc(progress.userId)
          .collection('lessons')
          .doc(progress.lessonId)
          .set(progress.toFirestore());

      _progressCache[cacheKey] = progress;
      _logger.i('Progreso actualizado: ${progress.lessonId}');
    } catch (e) {
      _logger.e('Error al actualizar progreso', error: e);
      rethrow;
    }
  }

  // Marcar lección como iniciada
  Future<void> startLesson(String userId, String lessonId) async {
    final progress = UserProgress(
      userId: userId,
      lessonId: lessonId,
      status: 'in_progress',
      score: 0,
      attempts: 0,
      lastAt: DateTime.now(),
    );

    await updateUserProgress(progress);
  }

  // Completar lección
  Future<void> completeLesson(String userId, String lessonId, int score) async {
    final existingProgress = await getUserProgress(userId, lessonId);
    final progress = UserProgress(
      userId: userId,
      lessonId: lessonId,
      status: 'done',
      score: score,
      attempts: (existingProgress?.attempts ?? 0) + 1,
      lastAt: DateTime.now(),
    );

    await updateUserProgress(progress);
  }

  // Obtener estadísticas del usuario
  Future<UserStats?> getUserStats(String userId, String period) async {
    try {
      final doc = await _firestore
          .collection(_userStatsCollection)
          .doc(userId)
          .collection('periods')
          .doc(period)
          .get();

      if (doc.exists) {
        return UserStats.fromFirestore(doc);
      }

      return null;
    } catch (e) {
      _logger.e('Error al obtener estadísticas del usuario', error: e);
      return null;
    }
  }

  // Obtener leaderboard
  Future<List<LeaderboardEntry>> getLeaderboard(
    String period,
    String category, {
    int limit = 100,
  }) async {
    try {
      final snapshot = await _firestore
          .collection(_leaderboardsCollection)
          .doc(period)
          .collection(category)
          .orderBy('xp', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => LeaderboardEntry.fromFirestore(doc))
          .toList();
    } catch (e) {
      _logger.e('Error al obtener leaderboard', error: e);
      return [];
    }
  }

  // Cargar rutas desde assets locales
  Future<List<RouteModel>> _loadRoutesFromAssets() async {
    try {
      final routes = <RouteModel>[];

      // Rutas predefinidas
      final routeData = [
        {
          'routeId': 'presupuesto',
          'title': 'Presupuesto Personal',
          'icon': 'account_balance_wallet',
          'order': 1,
        },
        {
          'routeId': 'ahorro',
          'title': 'Ahorro e Inversión',
          'icon': 'savings',
          'order': 2,
        },
        {
          'routeId': 'deuda',
          'title': 'Deuda y Crédito',
          'icon': 'credit_card',
          'order': 3,
        },
        {
          'routeId': 'inversion',
          'title': 'Inversión Básica',
          'icon': 'trending_up',
          'order': 4,
        },
      ];

      for (final data in routeData) {
        routes.add(RouteModel.fromJson(data));
      }

      return routes;
    } catch (e) {
      _logger.e('Error al cargar rutas desde assets', error: e);
      return [];
    }
  }

  // Cargar lecciones desde assets locales
  Future<List<LessonModel>> _loadLessonsFromAssets(String routeId) async {
    try {
      final lessons = <LessonModel>[];

      // Cargar desde archivos JSON en content/
      final directory = Directory('content/$routeId');
      if (await directory.exists()) {
        final files = await directory
            .list()
            .where((entity) => entity.path.endsWith('.json'))
            .toList();

        for (final file in files) {
          try {
            final content = await File(file.path).readAsString();
            final jsonData = json.decode(content);
            lessons.add(LessonModel.fromJson(jsonData));
          } catch (e) {
            _logger.w('Error al cargar lección ${file.path}', error: e);
          }
        }
      }

      // Ordenar por order
      lessons.sort((a, b) => a.order.compareTo(b.order));
      return lessons;
    } catch (e) {
      _logger.e('Error al cargar lecciones desde assets', error: e);
      return [];
    }
  }

  // Sincronizar contenido con Firestore (para administradores)
  Future<void> syncContentToFirestore() async {
    try {
      // Sincronizar rutas
      final routes = await _loadRoutesFromAssets();
      for (final route in routes) {
        await _firestore
            .collection(_routesCollection)
            .doc(route.id)
            .set(route.toFirestore());
      }

      // Sincronizar lecciones
      for (final route in routes) {
        final lessons = await _loadLessonsFromAssets(route.id);
        for (final lesson in lessons) {
          await _firestore
              .collection(_lessonsCollection)
              .doc(lesson.id)
              .set(lesson.toFirestore());
        }
      }

      _logger.i('Contenido sincronizado con Firestore');
    } catch (e) {
      _logger.e('Error al sincronizar contenido', error: e);
      rethrow;
    }
  }

  // Limpiar cache
  void clearCache() {
    _routesCache.clear();
    _lessonsCache.clear();
    _progressCache.clear();
  }
}
