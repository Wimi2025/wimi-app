import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:wimi_app/features/auth/services/auth_service.dart';
import 'package:wimi_app/features/auth/models/auth_user.dart';

import 'auth_service_test.mocks.dart';

@GenerateMocks([FirebaseAuth, User, UserCredential])
void main() {
  group('AuthService Tests', () {
    late AuthService authService;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockUser mockUser;
    late MockUserCredential mockUserCredential;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      mockUser = MockUser();
      mockUserCredential = MockUserCredential();
      authService = AuthService();
    });

    group('signInWithEmail', () {
      test('should return AuthUser when sign in is successful', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'password123';

        when(mockUser.uid).thenReturn('user123');
        when(mockUser.email).thenReturn(email);
        when(mockUser.displayName).thenReturn('Test User');
        when(mockUser.photoURL).thenReturn('https://example.com/photo.jpg');
        when(mockUser.emailVerified).thenReturn(true);
        when(mockUser.metadata).thenReturn(
          UserMetadata(
            creationTime: DateTime(2024, 1, 1),
            lastSignInTime: DateTime(2024, 1, 2),
          ),
        );

        when(mockUserCredential.user).thenReturn(mockUser);
        when(
          mockFirebaseAuth.signInWithEmailAndPassword(email, password),
        ).thenAnswer((_) async => mockUserCredential);

        // Act
        final result = await authService.signInWithEmail(email, password);

        // Assert
        expect(result, isA<AuthUser>());
        expect(result.id, equals('user123'));
        expect(result.email, equals(email));
        expect(result.displayName, equals('Test User'));
        expect(result.emailVerified, isTrue);
      });

      test('should throw exception when sign in fails', () async {
        // Arrange
        const email = 'test@example.com';
        const password = 'wrongpassword';

        when(
          mockFirebaseAuth.signInWithEmailAndPassword(email, password),
        ).thenThrow(FirebaseAuthException(code: 'user-not-found'));

        // Act & Assert
        expect(
          () => authService.signInWithEmail(email, password),
          throwsA(isA<FirebaseAuthException>()),
        );
      });
    });

    group('signUpWithEmail', () {
      test('should return AuthUser when sign up is successful', () async {
        // Arrange
        const email = 'new@example.com';
        const password = 'password123';
        const displayName = 'New User';

        when(mockUser.uid).thenReturn('newuser123');
        when(mockUser.email).thenReturn(email);
        when(mockUser.displayName).thenReturn(displayName);
        when(mockUser.emailVerified).thenReturn(false);
        when(mockUser.metadata).thenReturn(
          UserMetadata(
            creationTime: DateTime(2024, 1, 1),
            lastSignInTime: DateTime(2024, 1, 1),
          ),
        );

        when(mockUserCredential.user).thenReturn(mockUser);
        when(
          mockFirebaseAuth.createUserWithEmailAndPassword(email, password),
        ).thenAnswer((_) async => mockUserCredential);
        when(
          mockUser.updateDisplayName(displayName),
        ).thenAnswer((_) async => null);

        // Act
        final result = await authService.signUpWithEmail(
          email,
          password,
          displayName,
        );

        // Assert
        expect(result, isA<AuthUser>());
        expect(result.id, equals('newuser123'));
        expect(result.email, equals(email));
        expect(result.displayName, equals(displayName));
        expect(result.emailVerified, isFalse);
      });
    });

    group('signOut', () {
      test('should call Firebase signOut successfully', () async {
        // Arrange
        when(mockFirebaseAuth.signOut()).thenAnswer((_) async => null);

        // Act
        await authService.signOut();

        // Assert
        verify(mockFirebaseAuth.signOut()).called(1);
      });
    });

    group('resetPassword', () {
      test(
        'should call Firebase sendPasswordResetEmail successfully',
        () async {
          // Arrange
          const email = 'test@example.com';
          when(
            mockFirebaseAuth.sendPasswordResetEmail(email: email),
          ).thenAnswer((_) async => null);

          // Act
          await authService.resetPassword(email);

          // Assert
          verify(
            mockFirebaseAuth.sendPasswordResetEmail(email: email),
          ).called(1);
        },
      );
    });
  });
}

class MockUserCredential extends Mock implements UserCredential {}
