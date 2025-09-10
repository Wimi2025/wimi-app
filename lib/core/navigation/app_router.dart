import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/onboarding/screens/treasure_onboarding_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/treasure_auth_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/lessons/screens/lessons_screen.dart';
import '../../features/lessons/screens/routes_screen.dart';
import '../../features/gamification/screens/achievements_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../providers/auth_provider.dart';

// Provider para el router
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authState.isAuthenticated;
      final isLoggingIn =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      // Si no está autenticado y no está en login/register, redirigir a welcome
      if (!isLoggedIn && !isLoggingIn && state.matchedLocation != '/') {
        return '/';
      }

      // Si está autenticado y está en welcome/login/register, redirigir a dashboard
      if (isLoggedIn && (state.matchedLocation == '/' || isLoggingIn)) {
        return '/dashboard';
      }

      return null; // No redirect
    },
    routes: [
      // Onboarding
      GoRoute(
        path: '/',
        name: 'welcome',
        builder: (context, state) => const TreasureOnboardingScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const TreasureOnboardingScreen(),
      ),

      // Autenticación
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const TreasureAuthScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Aplicación principal
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/lessons',
        name: 'lessons',
        builder: (context, state) => const RoutesScreen(),
      ),
      GoRoute(
        path: '/lessons/:routeId',
        name: 'lessons-route',
        builder: (context, state) {
          final routeId = state.pathParameters['routeId']!;
          return LessonsScreen(routeId: routeId);
        },
      ),
      GoRoute(
        path: '/achievements',
        name: 'achievements',
        builder: (context, state) => const AchievementsScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Página no encontrada',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              state.error.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Volver al inicio'),
            ),
          ],
        ),
      ),
    ),
  );
});
