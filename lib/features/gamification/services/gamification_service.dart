import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';

import '../models/user_model.dart';
import '../../lessons/services/analytics_service.dart';

class GamificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AnalyticsService _analytics = AnalyticsService();
  final Logger _logger = Logger();

  static const String _usersCollection = 'users';
  static const String _userStatsCollection = 'userStats';

  // Calcular XP por lección completada
  int calculateLessonXP(int score, int durationMin) {
    // XP base por completar la lección
    int baseXP = 50;

    // Bonus por puntuación (0-100)
    int scoreBonus = (score * 0.5).round();

    // Bonus por duración (lecciones más largas dan más XP)
    int durationBonus = (durationMin * 2).round();

    // Bonus por puntuación perfecta
    int perfectBonus = score == 100 ? 25 : 0;

    return baseXP + scoreBonus + durationBonus + perfectBonus;
  }

  // Calcular XP por ejercicio individual
  int calculateExerciseXP(String exerciseType, bool isCorrect) {
    switch (exerciseType) {
      case 'mcq':
        return isCorrect ? 10 : 0;
      case 'vf':
        return isCorrect ? 8 : 0;
      case 'gap':
        return isCorrect ? 12 : 0;
      case 'slider':
        return isCorrect ? 15 : 0;
      case 'sim':
        return 20; // Los simuladores siempre dan XP
      default:
        return isCorrect ? 5 : 0;
    }
  }

  // Calcular nivel basado en XP
  int calculateLevel(int totalXP) {
    // Fórmula: nivel = sqrt(XP / 100) + 1
    return (totalXP / 100).sqrt().floor() + 1;
  }

  // Calcular XP necesario para el siguiente nivel
  int calculateXPForNextLevel(int currentLevel) {
    return (currentLevel * currentLevel * 100);
  }

  // Calcular XP necesario para el nivel actual
  int calculateXPForCurrentLevel(int currentLevel) {
    if (currentLevel <= 1) return 0;
    return ((currentLevel - 1) * (currentLevel - 1) * 100);
  }

  // Calcular progreso hacia el siguiente nivel
  double calculateLevelProgress(int currentXP, int currentLevel) {
    final xpForCurrentLevel = calculateXPForCurrentLevel(currentLevel);
    final xpForNextLevel = calculateXPForNextLevel(currentLevel);
    final xpInCurrentLevel = currentXP - xpForCurrentLevel;
    final xpNeededForNextLevel = xpForNextLevel - xpForCurrentLevel;

    return xpInCurrentLevel / xpNeededForNextLevel;
  }

  // Actualizar XP del usuario
  Future<UserModel> updateUserXP(
    String userId,
    int xpEarned, {
    String? routeId,
    String? lessonId,
  }) async {
    try {
      final userRef = _firestore.collection(_usersCollection).doc(userId);

      return await _firestore.runTransaction<UserModel>((transaction) async {
        final userDoc = await transaction.get(userRef);

        if (!userDoc.exists) {
          throw Exception('Usuario no encontrado');
        }

        final currentData = userDoc.data()!;
        final currentXP = currentData['experience'] ?? 0;
        final currentLevel = currentData['level'] ?? 1;
        final currentCoins = currentData['coins'] ?? 0;

        final newXP = currentXP + xpEarned;
        final newLevel = calculateLevel(newXP);
        final newCoins =
            currentCoins + (xpEarned ~/ 10); // 1 moneda por cada 10 XP

        // Verificar si subió de nivel
        final leveledUp = newLevel > currentLevel;

        // Actualizar datos del usuario
        transaction.update(userRef, {
          'experience': newXP,
          'level': newLevel,
          'coins': newCoins,
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // Crear nuevo modelo de usuario
        final updatedUser = UserModel(
          id: userId,
          email: currentData['email'] ?? '',
          displayName: currentData['displayName'] ?? '',
          photoURL: currentData['photoURL'],
          level: newLevel,
          experience: newXP,
          coins: newCoins,
          streak: currentData['streak'] ?? 0,
          lastLogin: DateTime.now(),
          completedLessons: List<String>.from(
            currentData['completedLessons'] ?? [],
          ),
          achievements: List<String>.from(currentData['achievements'] ?? []),
          categoryProgress: Map<String, int>.from(
            currentData['categoryProgress'] ?? {},
          ),
        );

        // Log de analytics
        if (leveledUp) {
          await _analytics.logLevelUp(
            userId: userId,
            fromLevel: currentLevel,
            toLevel: newLevel,
          );
        }

        // Log de progreso
        if (routeId != null) {
          await _analytics.logProgressUpdate(
            userId: userId,
            routeId: routeId,
            lessonsCompleted: updatedUser.completedLessons.length,
            totalLessons: 20, // Total de lecciones en la app
            xpEarned: xpEarned,
          );
        }

        _logger.i('XP actualizado: +$xpEarned XP para usuario $userId');
        return updatedUser;
      });
    } catch (e) {
      _logger.e('Error al actualizar XP del usuario', error: e);
      rethrow;
    }
  }

  // Actualizar streak del usuario
  Future<UserModel> updateUserStreak(String userId) async {
    try {
      final userRef = _firestore.collection(_usersCollection).doc(userId);

      return await _firestore.runTransaction<UserModel>((transaction) async {
        final userDoc = await transaction.get(userRef);

        if (!userDoc.exists) {
          throw Exception('Usuario no encontrado');
        }

        final currentData = userDoc.data()!;
        final currentStreak = currentData['streak'] ?? 0;
        final lastActiveAt = (currentData['lastActiveAt'] as Timestamp?)
            ?.toDate();
        final now = DateTime.now();

        int newStreak = currentStreak;

        // Verificar si es un nuevo día
        if (lastActiveAt != null) {
          final daysDifference = now.difference(lastActiveAt).inDays;

          if (daysDifference == 1) {
            // Día consecutivo
            newStreak = currentStreak + 1;
          } else if (daysDifference > 1) {
            // Se perdió el streak
            newStreak = 1;
          }
          // Si daysDifference == 0, es el mismo día, mantener streak
        } else {
          // Primera vez activo
          newStreak = 1;
        }

        // Actualizar streak y última actividad
        transaction.update(userRef, {
          'streak': newStreak,
          'lastActiveAt': Timestamp.fromDate(now),
          'updatedAt': FieldValue.serverTimestamp(),
        });

        // Log de analytics
        if (newStreak != currentStreak) {
          await _analytics.logStreakUpdate(
            userId: userId,
            streakDays: newStreak,
          );
        }

        _logger.i('Streak actualizado: $newStreak días para usuario $userId');

        // Retornar usuario actualizado
        return UserModel(
          id: userId,
          email: currentData['email'] ?? '',
          displayName: currentData['displayName'] ?? '',
          photoURL: currentData['photoURL'],
          level: currentData['level'] ?? 1,
          experience: currentData['experience'] ?? 0,
          coins: currentData['coins'] ?? 0,
          streak: newStreak,
          lastLogin: now,
          completedLessons: List<String>.from(
            currentData['completedLessons'] ?? [],
          ),
          achievements: List<String>.from(currentData['achievements'] ?? []),
          categoryProgress: Map<String, int>.from(
            currentData['categoryProgress'] ?? {},
          ),
        );
      });
    } catch (e) {
      _logger.e('Error al actualizar streak del usuario', error: e);
      rethrow;
    }
  }

  // Agregar logro al usuario
  Future<void> addAchievement(String userId, String achievementId) async {
    try {
      final userRef = _firestore.collection(_usersCollection).doc(userId);

      await _firestore.runTransaction((transaction) async {
        final userDoc = await transaction.get(userRef);

        if (!userDoc.exists) {
          throw Exception('Usuario no encontrado');
        }

        final currentData = userDoc.data()!;
        final currentAchievements = List<String>.from(
          currentData['achievements'] ?? [],
        );

        if (!currentAchievements.contains(achievementId)) {
          currentAchievements.add(achievementId);

          transaction.update(userRef, {
            'achievements': currentAchievements,
            'updatedAt': FieldValue.serverTimestamp(),
          });

          _logger.i('Logro agregado: $achievementId para usuario $userId');
        }
      });
    } catch (e) {
      _logger.e('Error al agregar logro', error: e);
      rethrow;
    }
  }

  // Verificar y otorgar logros
  Future<void> checkAndAwardAchievements(String userId, UserModel user) async {
    try {
      final achievements = <String>[];

      // Logro: Primera lección completada
      if (user.completedLessons.length == 1 &&
          !user.achievements.contains('first_lesson')) {
        achievements.add('first_lesson');
      }

      // Logro: 5 lecciones completadas
      if (user.completedLessons.length == 5 &&
          !user.achievements.contains('five_lessons')) {
        achievements.add('five_lessons');
      }

      // Logro: 10 lecciones completadas
      if (user.completedLessons.length == 10 &&
          !user.achievements.contains('ten_lessons')) {
        achievements.add('ten_lessons');
      }

      // Logro: Streak de 7 días
      if (user.streak == 7 && !user.achievements.contains('week_streak')) {
        achievements.add('week_streak');
      }

      // Logro: Streak de 30 días
      if (user.streak == 30 && !user.achievements.contains('month_streak')) {
        achievements.add('month_streak');
      }

      // Logro: Nivel 5
      if (user.level == 5 && !user.achievements.contains('level_five')) {
        achievements.add('level_five');
      }

      // Logro: Nivel 10
      if (user.level == 10 && !user.achievements.contains('level_ten')) {
        achievements.add('level_ten');
      }

      // Otorgar logros
      for (final achievement in achievements) {
        await addAchievement(userId, achievement);
      }

      if (achievements.isNotEmpty) {
        _logger.i(
          'Logros otorgados: ${achievements.join(', ')} para usuario $userId',
        );
      }
    } catch (e) {
      _logger.e('Error al verificar logros', error: e);
    }
  }

  // Obtener estadísticas del usuario
  Future<Map<String, dynamic>> getUserStats(String userId) async {
    try {
      final userDoc = await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .get();

      if (!userDoc.exists) {
        throw Exception('Usuario no encontrado');
      }

      final data = userDoc.data()!;
      final currentLevel = data['level'] ?? 1;
      final currentXP = data['experience'] ?? 0;

      return {
        'level': currentLevel,
        'xp': currentXP,
        'coins': data['coins'] ?? 0,
        'streak': data['streak'] ?? 0,
        'completedLessons': data['completedLessons']?.length ?? 0,
        'achievements': data['achievements']?.length ?? 0,
        'xpForNextLevel': calculateXPForNextLevel(currentLevel),
        'xpForCurrentLevel': calculateXPForCurrentLevel(currentLevel),
        'levelProgress': calculateLevelProgress(currentXP, currentLevel),
      };
    } catch (e) {
      _logger.e('Error al obtener estadísticas del usuario', error: e);
      rethrow;
    }
  }
}
