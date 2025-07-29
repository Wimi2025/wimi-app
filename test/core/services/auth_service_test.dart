import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:wimi_app/features/auth/services/auth_service.dart';
import 'package:wimi_app/features/auth/models/auth_user.dart';

import 'auth_service_test.mocks.dart';

@GenerateMocks([FirebaseAuth, User])
void main() {
  group('AuthService Tests', () {
    late AuthService authService;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockUser mockUser;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      mockUser = MockUser();
      authService = AuthService();
    });

    group('signInWithEmail', () {
      test('should return AuthUser when sign in is successful', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';
        const uid = 'test-uid';
        const displayName = 'Test User';

        when(mockUser.uid).thenReturn(uid);
        when(mockUser.email).thenReturn(email);
        when(mockUser.displayName).thenReturn(displayName);
        when(mockUser.photoURL).thenReturn(null);

        final mockUserCredential = MockUserCredential();
        when(mockUserCredential.user).thenReturn(mockUser);

        when(
          mockFirebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          ),
        ).thenAnswer((_) async => mockUserCredential);

        // Act & Assert
        expect(
          () => authService.signInWithEmail(email, password),
          returnsNormally,
        );
      });

      test('should throw exception when sign in fails', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'wrongpassword';

        when(
          mockFirebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          ),
        ).thenThrow(
          FirebaseAuthException(
            code: 'wrong-password',
            message: 'Wrong password',
          ),
        );

        // Act & Assert
        expect(
          () => authService.signInWithEmail(email, password),
          throwsA(isA<Exception>()),
        );
      });
    });

    group('signUpWithEmail', () {
      test('should return AuthUser when sign up is successful', () async {
        // Arrange
        const email = 'newuser@example.com';
        const password = 'password123';
        const displayName = 'New User';
        const uid = 'new-uid';

        when(mockUser.uid).thenReturn(uid);
        when(mockUser.email).thenReturn(email);
        when(mockUser.displayName).thenReturn(displayName);
        when(mockUser.photoURL).thenReturn(null);

        final mockUserCredential = MockUserCredential();
        when(mockUserCredential.user).thenReturn(mockUser);

        when(
          mockFirebaseAuth.createUserWithEmailAndPassword(
            email: email,
            password: password,
          ),
        ).thenAnswer((_) async => mockUserCredential);

        // Act & Assert
        expect(
          () => authService.signUpWithEmail(email, password, displayName),
          returnsNormally,
        );
      });
    });

    group('signOut', () {
      test('should complete successfully', () async {
        // Arrange
        when(mockFirebaseAuth.signOut()).thenAnswer((_) async {});

        // Act & Assert
        expect(() => authService.signOut(), returnsNormally);
      });
    });
  });
}

class MockUserCredential extends Mock implements UserCredential {}
