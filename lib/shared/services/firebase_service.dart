import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

import '../../features/auth/models/auth_user.dart';
import '../../features/gamification/models/user_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Colecciones
  static const String _usersCollection = 'users';
  static const String _lessonsCollection = 'lessons';
  static const String _achievementsCollection = 'achievements';
  static const String _leaderboardsCollection = 'leaderboards';

  // ========== USUARIOS ==========

  // Crear perfil de usuario
  Future<void> createUserProfile(AuthUser authUser) async {
    try {
      final userModel = UserModel(
        id: authUser.id,
        email: authUser.email,
        displayName: authUser.displayName ?? 'Usuario',
        photoURL: authUser.photoURL,
        level: 1,
        experience: 0,
        coins: 0,
        streak: 0,
        lastLogin: DateTime.now(),
        completedLessons: [],
        achievements: [],
        categoryProgress: {},
      );

      await _firestore
          .collection(_usersCollection)
          .doc(authUser.id)
          .set(userModel.toJson());
    } catch (e) {
      throw Exception('Error al crear perfil de usuario: $e');
    }
  }

  // Obtener perfil de usuario
  Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      final doc = await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .get();

      if (doc.exists) {
        return doc.data();
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener perfil de usuario: $e');
    }
  }

  // Actualizar perfil de usuario
  Future<void> updateUserProfile(UserModel user) async {
    try {
      await _firestore
          .collection(_usersCollection)
          .doc(user.id)
          .update(user.toJson());
    } catch (e) {
      throw Exception('Error al actualizar perfil de usuario: $e');
    }
  }

  // Actualizar último login
  Future<void> updateUserLastLogin(String userId) async {
    try {
      await _firestore
          .collection(_usersCollection)
          .doc(userId)
          .update({
        'lastLogin': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Error al actualizar último login: $e');
    }
  }

  // ========== LECCIONES ==========

  // Obtener todas las lecciones
  Future<List<Map<String, dynamic>>> getAllLessons() async {
    try {
      final querySnapshot = await _firestore
          .collection(_lessonsCollection)
          .orderBy('order')
          .get();

      return querySnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
    } catch (e) {
      throw Exception('Error al obtener lecciones: $e');
    }
  }

  // Obtener lecciones por categoría
  Future<List<Map<String, dynamic>>> getLessonsByCategory(String category) async {
    try {
      final querySnapshot = await _firestore
          .collection(_lessonsCollection)
          .where('category', isEqualTo: category)
          .orderBy('order')
          .get();

      return querySnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
    } catch (e) {
      throw Exception('Error al obtener lecciones por categoría: $e');
    }
  }

  // Obtener lección específica
  Future<Map<String, dynamic>?> getLesson(String lessonId) async {
    try {
      final doc = await _firestore
          .collection(_lessonsCollection)
          .doc(lessonId)
          .get();

      if (doc.exists) {
        return {'id': doc.id, ...doc.data()!};
      }
      return null;
    } catch (e) {
      throw Exception('Error al obtener lección: $e');
    }
  }

  // ========== LOGROS ==========

  // Obtener todos los logros
  Future<List<Map<String, dynamic>>> getAllAchievements() async {
    try {
      final querySnapshot = await _firestore
          .collection(_achievementsCollection)
          .orderBy('order')
          .get();

      return querySnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
    } catch (e) {
      throw Exception('Error al obtener logros: $e');
    }
  }

  // ========== LEADERBOARDS ==========

  // Obtener leaderboard global
  Future<List<Map<String, dynamic>>> getGlobalLeaderboard({int limit = 10}) async {
    try {
      final querySnapshot = await _firestore
          .collection(_usersCollection)
          .orderBy('experience', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
    } catch (e) {
      throw Exception('Error al obtener leaderboard: $e');
    }
  }

  // Obtener leaderboard por categoría
  Future<List<Map<String, dynamic>>> getCategoryLeaderboard(String category, {int limit = 10}) async {
    try {
      final querySnapshot = await _firestore
          .collection(_usersCollection)
          .orderBy('categoryProgress.$category', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();
    } catch (e) {
      throw Exception('Error al obtener leaderboard por categoría: $e');
    }
  }

  // ========== ANALYTICS ==========

  // Registrar evento de analytics
  Future<void> logEvent(String name, {Map<String, dynamic>? parameters}) async {
    try {
      await _analytics.logEvent(
        name: name,
        parameters: parameters,
      );
    } catch (e) {
      // No lanzar excepción para analytics
      debugPrint('Error al registrar evento de analytics: $e');
    }
  }

  // Registrar inicio de sesión
  Future<void> logLogin() async {
    await logEvent('login');
  }

  // Registrar registro de usuario
  Future<void> logSignUp() async {
    await logEvent('sign_up');
  }

  // Registrar completación de lección
  Future<void> logLessonCompleted(String lessonId, String category) async {
    await logEvent('lesson_completed', parameters: {
      'lesson_id': lessonId,
      'category': category,
    });
  }

  // Registrar ganancia de XP
  Future<void> logXPGained(int xp) async {
    await logEvent('xp_gained', parameters: {
      'xp_amount': xp,
    });
  }

  // Registrar subida de nivel
  Future<void> logLevelUp(int level) async {
    await logEvent('level_up', parameters: {
      'level': level,
    });
  }

  // ========== UTILIDADES ==========

  // Verificar si existe un documento
  Future<bool> documentExists(String collection, String documentId) async {
    try {
      final doc = await _firestore
          .collection(collection)
          .doc(documentId)
          .get();
      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  // Obtener timestamp del servidor
  FieldValue get serverTimestamp => FieldValue.serverTimestamp();

  // Crear referencia a documento
  DocumentReference getDocumentReference(String collection, String documentId) {
    return _firestore.collection(collection).doc(documentId);
  }
} 