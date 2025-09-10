import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:wimi_app/features/auth/models/auth_user.dart';

void main() {
  group('AuthUser Tests', () {
    late MockUser mockFirebaseUser;

    setUp(() {
      mockFirebaseUser = MockUser();
    });

    group('fromFirebaseUser', () {
      test('should create AuthUser from Firebase User correctly', () {
        // Arrange
        const uid = 'user123';
        const email = 'test@example.com';
        const displayName = 'Test User';
        const photoURL = 'https://example.com/photo.jpg';
        const emailVerified = true;
        final creationTime = DateTime(2024, 1, 1);
        final lastSignInTime = DateTime(2024, 1, 2);

        when(mockFirebaseUser.uid).thenReturn(uid);
        when(mockFirebaseUser.email).thenReturn(email);
        when(mockFirebaseUser.displayName).thenReturn(displayName);
        when(mockFirebaseUser.photoURL).thenReturn(photoURL);
        when(mockFirebaseUser.emailVerified).thenReturn(emailVerified);
        when(mockFirebaseUser.metadata).thenReturn(
          UserMetadata(
            creationTime: creationTime,
            lastSignInTime: lastSignInTime,
          ),
        );

        // Act
        final authUser = AuthUser.fromFirebaseUser(mockFirebaseUser);

        // Assert
        expect(authUser.id, equals(uid));
        expect(authUser.email, equals(email));
        expect(authUser.displayName, equals(displayName));
        expect(authUser.photoURL, equals(photoURL));
        expect(authUser.emailVerified, equals(emailVerified));
        expect(authUser.createdAt, equals(creationTime));
        expect(authUser.lastSignInAt, equals(lastSignInTime));
      });

      test('should handle null values correctly', () {
        // Arrange
        const uid = 'user123';
        const email = 'test@example.com';

        when(mockFirebaseUser.uid).thenReturn(uid);
        when(mockFirebaseUser.email).thenReturn(email);
        when(mockFirebaseUser.displayName).thenReturn(null);
        when(mockFirebaseUser.photoURL).thenReturn(null);
        when(mockFirebaseUser.emailVerified).thenReturn(false);
        when(
          mockFirebaseUser.metadata,
        ).thenReturn(UserMetadata(creationTime: null, lastSignInTime: null));

        // Act
        final authUser = AuthUser.fromFirebaseUser(mockFirebaseUser);

        // Assert
        expect(authUser.id, equals(uid));
        expect(authUser.email, equals(email));
        expect(authUser.displayName, isNull);
        expect(authUser.photoURL, isNull);
        expect(authUser.emailVerified, isFalse);
        expect(authUser.createdAt, isA<DateTime>());
        expect(authUser.lastSignInAt, isA<DateTime>());
      });
    });

    group('fromJson', () {
      test('should create AuthUser from JSON correctly', () {
        // Arrange
        final json = {
          'id': 'user123',
          'email': 'test@example.com',
          'displayName': 'Test User',
          'photoURL': 'https://example.com/photo.jpg',
          'emailVerified': true,
          'createdAt': '2024-01-01T00:00:00.000Z',
          'lastSignInAt': '2024-01-02T00:00:00.000Z',
        };

        // Act
        final authUser = AuthUser.fromJson(json);

        // Assert
        expect(authUser.id, equals('user123'));
        expect(authUser.email, equals('test@example.com'));
        expect(authUser.displayName, equals('Test User'));
        expect(authUser.photoURL, equals('https://example.com/photo.jpg'));
        expect(authUser.emailVerified, isTrue);
        expect(authUser.createdAt, equals(DateTime(2024, 1, 1)));
        expect(authUser.lastSignInAt, equals(DateTime(2024, 1, 2)));
      });

      test('should handle missing JSON fields correctly', () {
        // Arrange
        final json = {'id': 'user123', 'email': 'test@example.com'};

        // Act
        final authUser = AuthUser.fromJson(json);

        // Assert
        expect(authUser.id, equals('user123'));
        expect(authUser.email, equals('test@example.com'));
        expect(authUser.displayName, isNull);
        expect(authUser.photoURL, isNull);
        expect(authUser.emailVerified, isFalse);
        expect(authUser.createdAt, isA<DateTime>());
        expect(authUser.lastSignInAt, isA<DateTime>());
      });
    });

    group('toJson', () {
      test('should convert AuthUser to JSON correctly', () {
        // Arrange
        final authUser = AuthUser(
          id: 'user123',
          email: 'test@example.com',
          displayName: 'Test User',
          photoURL: 'https://example.com/photo.jpg',
          emailVerified: true,
          createdAt: DateTime(2024, 1, 1),
          lastSignInAt: DateTime(2024, 1, 2),
        );

        // Act
        final json = authUser.toJson();

        // Assert
        expect(json['id'], equals('user123'));
        expect(json['email'], equals('test@example.com'));
        expect(json['displayName'], equals('Test User'));
        expect(json['photoURL'], equals('https://example.com/photo.jpg'));
        expect(json['emailVerified'], isTrue);
        expect(json['createdAt'], equals('2024-01-01T00:00:00.000Z'));
        expect(json['lastSignInAt'], equals('2024-01-02T00:00:00.000Z'));
      });
    });

    group('copyWith', () {
      test('should create copy with updated values', () {
        // Arrange
        final originalUser = AuthUser(
          id: 'user123',
          email: 'test@example.com',
          displayName: 'Test User',
          photoURL: 'https://example.com/photo.jpg',
          emailVerified: true,
          createdAt: DateTime(2024, 1, 1),
          lastSignInAt: DateTime(2024, 1, 2),
        );

        // Act
        final updatedUser = originalUser.copyWith(
          displayName: 'Updated User',
          emailVerified: false,
        );

        // Assert
        expect(updatedUser.id, equals('user123'));
        expect(updatedUser.email, equals('test@example.com'));
        expect(updatedUser.displayName, equals('Updated User'));
        expect(updatedUser.photoURL, equals('https://example.com/photo.jpg'));
        expect(updatedUser.emailVerified, isFalse);
        expect(updatedUser.createdAt, equals(DateTime(2024, 1, 1)));
        expect(updatedUser.lastSignInAt, equals(DateTime(2024, 1, 2)));
      });
    });

    group('equality', () {
      test('should be equal when IDs are the same', () {
        // Arrange
        final user1 = AuthUser(
          id: 'user123',
          email: 'test1@example.com',
          emailVerified: true,
          createdAt: DateTime(2024, 1, 1),
          lastSignInAt: DateTime(2024, 1, 2),
        );

        final user2 = AuthUser(
          id: 'user123',
          email: 'test2@example.com',
          emailVerified: false,
          createdAt: DateTime(2024, 1, 3),
          lastSignInAt: DateTime(2024, 1, 4),
        );

        // Act & Assert
        expect(user1, equals(user2));
        expect(user1.hashCode, equals(user2.hashCode));
      });

      test('should not be equal when IDs are different', () {
        // Arrange
        final user1 = AuthUser(
          id: 'user123',
          email: 'test@example.com',
          emailVerified: true,
          createdAt: DateTime(2024, 1, 1),
          lastSignInAt: DateTime(2024, 1, 2),
        );

        final user2 = AuthUser(
          id: 'user456',
          email: 'test@example.com',
          emailVerified: true,
          createdAt: DateTime(2024, 1, 1),
          lastSignInAt: DateTime(2024, 1, 2),
        );

        // Act & Assert
        expect(user1, isNot(equals(user2)));
      });
    });
  });
}

class MockUser extends Mock implements User {}
