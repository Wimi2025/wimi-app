import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:wimi_app/core/navigation/app_router.dart';
import 'package:wimi_app/features/onboarding/screens/welcome_screen.dart';
import 'package:wimi_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:wimi_app/features/lessons/screens/lessons_screen.dart';
import 'package:wimi_app/features/gamification/screens/achievements_screen.dart';
import 'package:wimi_app/features/profile/screens/profile_screen.dart';

void main() {
  group('Navigation Integration Tests', () {
    late GoRouter router;

    setUp(() {
      router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const WelcomeScreen(),
          ),
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/lessons',
            builder: (context, state) => const LessonsScreen(),
          ),
          GoRoute(
            path: '/achievements',
            builder: (context, state) => const AchievementsScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      );
    });

    testWidgets('should navigate from welcome to dashboard', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp.router(routerConfig: router)),
      );

      // Act
      await tester.tap(find.text('Comenzar Aventura'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('¡Hola, Usuario!'), findsOneWidget);
    });

    testWidgets('should navigate from dashboard to lessons', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp.router(routerConfig: router)),
      );

      // Navigate to dashboard first
      await tester.tap(find.text('Comenzar Aventura'));
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('Lecciones'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Lecciones'), findsOneWidget);
      expect(find.byIcon(Icons.school), findsOneWidget);
    });

    testWidgets('should navigate from dashboard to achievements', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp.router(routerConfig: router)),
      );

      // Navigate to dashboard first
      await tester.tap(find.text('Comenzar Aventura'));
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('Logros'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Logros'), findsOneWidget);
      expect(find.byIcon(Icons.emoji_events), findsOneWidget);
    });

    testWidgets('should navigate from dashboard to profile', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp.router(routerConfig: router)),
      );

      // Navigate to dashboard first
      await tester.tap(find.text('Comenzar Aventura'));
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('Perfil'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Perfil de Usuario'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('should navigate back from dashboard to welcome', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp.router(routerConfig: router)),
      );

      // Navigate to dashboard first
      await tester.tap(find.text('Comenzar Aventura'));
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.text('Volver'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Wimi'), findsOneWidget);
      expect(find.text('Comenzar Aventura'), findsOneWidget);
    });

    testWidgets('should have back navigation from lessons', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp.router(routerConfig: router)),
      );

      // Navigate to lessons
      await tester.tap(find.text('Comenzar Aventura'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Lecciones'));
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Dashboard'), findsOneWidget);
    });

    testWidgets('should have back navigation from achievements', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp.router(routerConfig: router)),
      );

      // Navigate to achievements
      await tester.tap(find.text('Comenzar Aventura'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Logros'));
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Dashboard'), findsOneWidget);
    });

    testWidgets('should have back navigation from profile', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp.router(routerConfig: router)),
      );

      // Navigate to profile
      await tester.tap(find.text('Comenzar Aventura'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Perfil'));
      await tester.pumpAndSettle();

      // Act
      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Dashboard'), findsOneWidget);
    });

    testWidgets('should maintain navigation state correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(child: MaterialApp.router(routerConfig: router)),
      );

      // Navigate through multiple screens
      await tester.tap(find.text('Comenzar Aventura'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Lecciones'));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.arrow_back));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Logros'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Logros'), findsOneWidget);
      expect(find.text('Sistema de gamificación'), findsOneWidget);
    });
  });
}
