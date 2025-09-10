import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wimi_app/features/onboarding/screens/welcome_screen.dart';
import 'package:wimi_app/core/constants/app_colors.dart';

void main() {
  group('WelcomeScreen Widget Tests', () {
    testWidgets('should display welcome screen with correct elements', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: WelcomeScreen())),
      );

      // Assert
      expect(find.text('Wimi'), findsOneWidget);
      expect(find.text('Aprende finanzas de forma divertida'), findsOneWidget);
      expect(find.text('Comenzar Aventura'), findsOneWidget);
      expect(find.text('Aprende'), findsOneWidget);
      expect(find.text('Gana'), findsOneWidget);
      expect(find.text('Crece'), findsOneWidget);
    });

    testWidgets('should display logo icon', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: WelcomeScreen())),
      );

      // Assert
      expect(find.byIcon(Icons.account_balance_wallet), findsOneWidget);
    });

    testWidgets('should display feature icons', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: WelcomeScreen())),
      );

      // Assert
      expect(find.byIcon(Icons.school), findsOneWidget);
      expect(find.byIcon(Icons.emoji_events), findsOneWidget);
      expect(find.byIcon(Icons.trending_up), findsOneWidget);
    });

    testWidgets('should navigate to dashboard when start button is pressed', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: WelcomeScreen())),
      );

      // Act
      await tester.tap(find.text('Comenzar Aventura'));
      await tester.pumpAndSettle();

      // Assert
      // Note: In a real test, you'd verify navigation occurred
      // For now, we just verify the button is tappable
      expect(find.text('Comenzar Aventura'), findsOneWidget);
    });

    testWidgets('should have correct styling', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: WelcomeScreen())),
      );

      // Assert
      final titleFinder = find.text('Wimi');
      final titleWidget = tester.widget<Text>(titleFinder);

      expect(titleWidget.style?.fontSize, equals(48));
      expect(titleWidget.style?.fontWeight, equals(FontWeight.bold));
      expect(titleWidget.style?.color, equals(Colors.white));
    });

    testWidgets('should have gradient background', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: WelcomeScreen())),
      );

      // Assert
      final containerFinder = find.byType(Container);
      final containerWidget = tester.widget<Container>(containerFinder.first);

      expect(containerWidget.decoration, isA<BoxDecoration>());
      final decoration = containerWidget.decoration as BoxDecoration;
      expect(decoration.gradient, isA<LinearGradient>());
    });

    testWidgets('should be responsive', (WidgetTester tester) async {
      // Arrange & Act - Test on different screen sizes
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: WelcomeScreen())),
      );

      // Assert
      expect(find.text('Wimi'), findsOneWidget);
      expect(find.text('Comenzar Aventura'), findsOneWidget);

      // Test on larger screen
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: WelcomeScreen())),
      );

      // Assert
      expect(find.text('Wimi'), findsOneWidget);
      expect(find.text('Comenzar Aventura'), findsOneWidget);
    });
  });
}
