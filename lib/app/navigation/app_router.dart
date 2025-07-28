import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/onboarding/screens/welcome_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/lessons/screens/lessons_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/gamification/screens/achievements_screen.dart';

class AppRouter {
  static const String welcome = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String lessons = '/lessons';
  static const String profile = '/profile';
  static const String achievements = '/achievements';

  static final GoRouter router = GoRouter(
    initialLocation: welcome,
    routes: [
      // Pantalla de bienvenida
      GoRoute(
        path: welcome,
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      
      // Autenticación
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      
      GoRoute(
        path: register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      
      // Dashboard principal
      GoRoute(
        path: dashboard,
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      
      // Lecciones
      GoRoute(
        path: lessons,
        name: 'lessons',
        builder: (context, state) => const LessonsScreen(),
      ),
      
      // Perfil
      GoRoute(
        path: profile,
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      
      // Logros
      GoRoute(
        path: achievements,
        name: 'achievements',
        builder: (context, state) => const AchievementsScreen(),
      ),
    ],
    
    // Manejo de errores
    errorBuilder: (context, state) => Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              'Página no encontrada',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'La página ${state.uri} no existe',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(dashboard),
              child: const Text('Ir al Dashboard'),
            ),
          ],
        ),
      ),
    ),
  );
}

// Extensiones útiles para navegación
extension NavigationExtension on BuildContext {
  void goToWelcome() => go(AppRouter.welcome);
  void goToLogin() => go(AppRouter.login);
  void goToRegister() => go(AppRouter.register);
  void goToDashboard() => go(AppRouter.dashboard);
  void goToLessons() => go(AppRouter.lessons);
  void goToProfile() => go(AppRouter.profile);
  void goToAchievements() => go(AppRouter.achievements);
  
  void goBack() => pop();
} 