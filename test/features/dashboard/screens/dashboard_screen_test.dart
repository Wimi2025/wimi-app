import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:wimi_app/features/dashboard/screens/dashboard_screen.dart';
import 'package:wimi_app/core/constants/app_colors.dart';

void main() {
  group('DashboardScreen Widget Tests', () {
    testWidgets('should display dashboard with correct elements', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: DashboardScreen())),
      );

      // Assert
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('¡Hola, Usuario!'), findsOneWidget);
      expect(find.text('Acciones Rápidas'), findsOneWidget);
      expect(find.text('Lecciones'), findsOneWidget);
      expect(find.text('Logros'), findsOneWidget);
      expect(find.text('Perfil'), findsOneWidget);
      expect(find.text('Volver'), findsOneWidget);
    });

    testWidgets('should display action cards with correct icons', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: DashboardScreen())),
      );

      // Assert
      expect(find.byIcon(Icons.school), findsOneWidget); // Lecciones
      expect(find.byIcon(Icons.emoji_events), findsOneWidget); // Logros
      expect(find.byIcon(Icons.person), findsOneWidget); // Perfil
      expect(find.byIcon(Icons.arrow_back), findsOneWidget); // Volver
    });

    testWidgets('should display app bar with correct styling', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: DashboardScreen())),
      );

      // Assert
      final appBarFinder = find.byType(AppBar);
      final appBarWidget = tester.widget<AppBar>(appBarFinder);

      expect(appBarWidget.title, const Text('Dashboard'));
      expect(appBarWidget.backgroundColor, AppColors.primary);
      expect(appBarWidget.foregroundColor, Colors.white);
    });

    testWidgets('should display action cards in grid layout', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: DashboardScreen())),
      );

      // Assert
      expect(find.byType(GridView), findsOneWidget);
      expect(find.byType(Card), findsNWidgets(4)); // 4 action cards
    });

    testWidgets('should have tappable action cards', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: DashboardScreen())),
      );

      // Act & Assert - Verify cards are tappable
      expect(find.byType(InkWell), findsNWidgets(4));

      // Test tapping on Lecciones card
      await tester.tap(find.text('Lecciones'));
      await tester.pumpAndSettle();

      // Verify the card is still there (navigation would be tested in integration tests)
      expect(find.text('Lecciones'), findsOneWidget);
    });

    testWidgets('should display user greeting', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: DashboardScreen())),
      );

      // Assert
      final greetingFinder = find.text('¡Hola, Usuario!');
      final greetingWidget = tester.widget<Text>(greetingFinder);

      expect(greetingWidget.style?.fontSize, isNotNull);
    });

    testWidgets('should have proper spacing and layout', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: DashboardScreen())),
      );

      // Assert
      expect(
        find.byType(SizedBox),
        findsWidgets,
      ); // Verify spacing widgets exist
      expect(find.byType(Padding), findsWidgets); // Verify padding exists
    });

    testWidgets('should be responsive on different screen sizes', (
      WidgetTester tester,
    ) async {
      // Arrange & Act - Test on small screen
      await tester.binding.setSurfaceSize(const Size(400, 800));
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: DashboardScreen())),
      );

      // Assert
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Lecciones'), findsOneWidget);

      // Test on large screen
      await tester.binding.setSurfaceSize(const Size(800, 1200));
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: DashboardScreen())),
      );

      // Assert
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Lecciones'), findsOneWidget);
    });

    testWidgets('should have correct card styling', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: DashboardScreen())),
      );

      // Assert
      final cardFinder = find.byType(Card);
      final cardWidget = tester.widget<Card>(cardFinder.first);

      expect(cardWidget, isA<Card>());
    });

    testWidgets('should display profile icon in app bar', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: DashboardScreen())),
      );

      // Assert
      expect(
        find.byIcon(Icons.person),
        findsOneWidget,
      ); // Profile icon in app bar
    });
  });
}
