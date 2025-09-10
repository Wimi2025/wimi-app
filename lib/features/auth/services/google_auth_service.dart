import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/auth_user.dart';

class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger _logger = Logger();

  // Iniciar sesión con Google
  Future<AuthUser?> signInWithGoogle() async {
    try {
      _logger.i('Iniciando sesión con Google...');

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        _logger.w('Usuario canceló el login con Google');
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      final User? firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw Exception('Error: Usuario de Firebase nulo');
      }

      // Crear o actualizar perfil en Firestore
      await _createOrUpdateUserProfile(firebaseUser);

      final authUser = AuthUser.fromFirebaseUser(firebaseUser);
      _logger.i('✅ Login con Google exitoso: ${authUser.email}');

      return authUser;
    } catch (e) {
      _logger.e('❌ Error en login con Google', error: e);
      rethrow;
    }
  }

  // Crear o actualizar perfil de usuario en Firestore
  Future<void> _createOrUpdateUserProfile(User firebaseUser) async {
    try {
      final userRef = _firestore.collection('users').doc(firebaseUser.uid);
      final doc = await userRef.get();

      if (!doc.exists) {
        // Crear nuevo perfil de usuario
        await userRef.set({
          'id': firebaseUser.uid,
          'email': firebaseUser.email,
          'displayName': firebaseUser.displayName ?? 'Explorador',
          'photoURL': firebaseUser.photoURL,
          'level': 1,
          'experience': 0,
          'coins': 100, // Monedas iniciales
          'streak': 0,
          'lastLogin': FieldValue.serverTimestamp(),
          'completedLessons': [],
          'achievements': ['first_login'],
          'categoryProgress': {},
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'isGoogleUser': true,
        });
        _logger.i('✅ Perfil de usuario creado en Firestore');
      } else {
        // Actualizar último login
        await userRef.update({
          'lastLogin': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        _logger.i('✅ Perfil de usuario actualizado en Firestore');
      }
    } catch (e) {
      _logger.e('❌ Error al crear/actualizar perfil en Firestore', error: e);
      rethrow;
    }
  }

  // Cerrar sesión de Google
  Future<void> signOut() async {
    try {
      _logger.i('Cerrando sesión de Google...');
      await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
      _logger.i('✅ Sesión de Google cerrada correctamente');
    } catch (e) {
      _logger.e('❌ Error al cerrar sesión de Google', error: e);
      rethrow;
    }
  }

  // Verificar si el usuario está autenticado con Google
  bool get isSignedIn => _googleSignIn.currentUser != null;

  // Obtener usuario actual de Google
  GoogleSignInAccount? get currentGoogleUser => _googleSignIn.currentUser;
}
