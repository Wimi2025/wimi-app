import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

import '../models/auth_user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Logger _logger = Logger();

  // Stream del estado de autenticación
  Stream<AuthUser?> get authStateChanges {
    return _auth.authStateChanges().map((User? firebaseUser) {
      if (firebaseUser == null) return null;
      return AuthUser.fromFirebaseUser(firebaseUser);
    });
  }

  // Usuario actual
  AuthUser? get currentUser {
    final user = _auth.currentUser;
    if (user == null) return null;
    return AuthUser.fromFirebaseUser(user);
  }

  // Iniciar sesión con email y contraseña
  Future<AuthUser> signInWithEmail(String email, String password) async {
    try {
      _logger.i('Iniciando sesión con email: $email');
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw Exception('Error al iniciar sesión: usuario nulo');
      }

      final authUser = AuthUser.fromFirebaseUser(credential.user!);
      _logger.i('✅ Sesión iniciada correctamente: ${authUser.email}');
      return authUser;
    } catch (e) {
      _logger.e('❌ Error al iniciar sesión', error: e);
      rethrow;
    }
  }

  // Registrarse con email y contraseña
  Future<AuthUser> signUpWithEmail(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      _logger.i('Registrando usuario: $email');
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user == null) {
        throw Exception('Error al registrar: usuario nulo');
      }

      // Actualizar display name
      await credential.user!.updateDisplayName(displayName);

      final authUser = AuthUser.fromFirebaseUser(credential.user!);
      _logger.i('✅ Usuario registrado correctamente: ${authUser.email}');
      return authUser;
    } catch (e) {
      _logger.e('❌ Error al registrar usuario', error: e);
      rethrow;
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    try {
      _logger.i('Cerrando sesión');
      await _auth.signOut();
      _logger.i('✅ Sesión cerrada correctamente');
    } catch (e) {
      _logger.e('❌ Error al cerrar sesión', error: e);
      rethrow;
    }
  }

  // Enviar email de verificación
  Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No hay usuario autenticado');

      await user.sendEmailVerification();
      _logger.i('✅ Email de verificación enviado');
    } catch (e) {
      _logger.e('❌ Error al enviar email de verificación', error: e);
      rethrow;
    }
  }

  // Restablecer contraseña
  Future<void> resetPassword(String email) async {
    try {
      _logger.i('Solicitando restablecimiento de contraseña: $email');
      await _auth.sendPasswordResetEmail(email: email);
      _logger.i('✅ Email de restablecimiento enviado');
    } catch (e) {
      _logger.e('❌ Error al restablecer contraseña', error: e);
      rethrow;
    }
  }

  // Actualizar perfil
  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No hay usuario autenticado');

      await user.updateDisplayName(displayName);
      if (photoURL != null) {
        await user.updatePhotoURL(photoURL);
      }

      _logger.i('✅ Perfil actualizado correctamente');
    } catch (e) {
      _logger.e('❌ Error al actualizar perfil', error: e);
      rethrow;
    }
  }
}
