import 'package:flutter/material.dart';

import '../../../shared/services/firebase_service.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  // Getters
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasUser => _user != null;

  // Cargar perfil de usuario
  Future<void> loadUserProfile(String userId) async {
    try {
      _setLoading(true);
      _clearError();
      
      final userData = await _firebaseService.getUserProfile(userId);
      if (userData != null) {
        _user = UserModel.fromJson(userData);
        notifyListeners();
      }
    } catch (e) {
      _setError('Error al cargar perfil: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Actualizar experiencia del usuario
  Future<void> addExperience(int experience) async {
    if (_user == null) return;
    
    try {
      final newExperience = _user!.experience + experience;
      final newLevel = _calculateLevel(newExperience);
      
      final updatedUser = _user!.copyWith(
        experience: newExperience,
        level: newLevel,
      );
      
      await _firebaseService.updateUserProfile(updatedUser);
      _user = updatedUser;
      notifyListeners();
    } catch (e) {
      _setError('Error al actualizar experiencia: $e');
    }
  }

  // Agregar monedas
  Future<void> addCoins(int coins) async {
    if (_user == null) return;
    
    try {
      final newCoins = _user!.coins + coins;
      final updatedUser = _user!.copyWith(coins: newCoins);
      
      await _firebaseService.updateUserProfile(updatedUser);
      _user = updatedUser;
      notifyListeners();
    } catch (e) {
      _setError('Error al actualizar monedas: $e');
    }
  }

  // Actualizar streak
  Future<void> updateStreak() async {
    if (_user == null) return;
    
    try {
      final today = DateTime.now();
      final lastLogin = _user!.lastLogin;
      final isConsecutiveDay = _isConsecutiveDay(lastLogin, today);
      
      int newStreak = _user!.streak;
      if (isConsecutiveDay) {
        newStreak++;
      } else if (_isMoreThanOneDayGap(lastLogin, today)) {
        newStreak = 1; // Reset streak
      }
      
      final updatedUser = _user!.copyWith(
        streak: newStreak,
        lastLogin: today,
      );
      
      await _firebaseService.updateUserProfile(updatedUser);
      _user = updatedUser;
      notifyListeners();
    } catch (e) {
      _setError('Error al actualizar streak: $e');
    }
  }

  // Completar lección
  Future<void> completeLesson(String lessonId) async {
    if (_user == null) return;
    
    try {
      final completedLessons = List<String>.from(_user!.completedLessons);
      if (!completedLessons.contains(lessonId)) {
        completedLessons.add(lessonId);
        
        final updatedUser = _user!.copyWith(
          completedLessons: completedLessons,
        );
        
        await _firebaseService.updateUserProfile(updatedUser);
        _user = updatedUser;
        notifyListeners();
      }
    } catch (e) {
      _setError('Error al completar lección: $e');
    }
  }

  // Agregar logro
  Future<void> addAchievement(String achievementId) async {
    if (_user == null) return;
    
    try {
      final achievements = List<String>.from(_user!.achievements);
      if (!achievements.contains(achievementId)) {
        achievements.add(achievementId);
        
        final updatedUser = _user!.copyWith(
          achievements: achievements,
        );
        
        await _firebaseService.updateUserProfile(updatedUser);
        _user = updatedUser;
        notifyListeners();
      }
    } catch (e) {
      _setError('Error al agregar logro: $e');
    }
  }

  // Actualizar progreso por categoría
  Future<void> updateCategoryProgress(String category, int progress) async {
    if (_user == null) return;
    
    try {
      final categoryProgress = Map<String, int>.from(_user!.categoryProgress);
      categoryProgress[category] = progress;
      
      final updatedUser = _user!.copyWith(
        categoryProgress: categoryProgress,
      );
      
      await _firebaseService.updateUserProfile(updatedUser);
      _user = updatedUser;
      notifyListeners();
    } catch (e) {
      _setError('Error al actualizar progreso: $e');
    }
  }

  // Métodos privados
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  int _calculateLevel(int experience) {
    // Fórmula: nivel = raíz cuadrada de (experiencia / 100) + 1
    return (experience / 100).floor() + 1;
  }

  bool _isConsecutiveDay(DateTime lastLogin, DateTime today) {
    final difference = today.difference(lastLogin).inDays;
    return difference == 1;
  }

  bool _isMoreThanOneDayGap(DateTime lastLogin, DateTime today) {
    final difference = today.difference(lastLogin).inDays;
    return difference > 1;
  }

  // Limpiar datos del usuario
  void clearUser() {
    _user = null;
    notifyListeners();
  }
} 