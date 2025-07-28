import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'core/constants/app_colors.dart';

void main() {
  runApp(const WimiAppDemo());
}

class WimiAppDemo extends StatelessWidget {
  const WimiAppDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DemoAuthProvider()),
        ChangeNotifierProvider(create: (_) => DemoUserProvider()),
      ],
      child: MaterialApp.router(
        title: 'Wimi - Educación Financiera Gamificada (DEMO)',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.light,
          ),
          fontFamily: 'Roboto',
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.dark,
          ),
          fontFamily: 'Roboto',
        ),
        themeMode: ThemeMode.system,
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

// Router simplificado
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const DemoWelcomeScreen()),
    GoRoute(
      path: '/login',
      builder: (context, state) => const DemoLoginScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DemoDashboardScreen(),
    ),
    GoRoute(
      path: '/lessons',
      builder: (context, state) => const DemoLessonsScreen(),
    ),
    GoRoute(
      path: '/achievements',
      builder: (context, state) => const DemoAchievementsScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const DemoProfileScreen(),
    ),
  ],
);

// Providers Mock
class DemoAuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  Future<void> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    _isAuthenticated = true;
    notifyListeners();
  }

  Future<void> signOut() async {
    _isAuthenticated = false;
    notifyListeners();
  }
}

class DemoUserProvider extends ChangeNotifier {
  final DemoUser _user = DemoUser(
    id: 'demo-user',
    email: 'demo@wimi.com',
    displayName: 'Usuario Demo',
    level: 5,
    experience: 450,
    coins: 150,
    streak: 7,
    completedLessons: 12,
    achievements: 8,
  );

  DemoUser get user => _user;
}

class DemoUser {
  final String id;
  final String email;
  final String displayName;
  final int level;
  final int experience;
  final int coins;
  final int streak;
  final int completedLessons;
  final int achievements;

  DemoUser({
    required this.id,
    required this.email,
    required this.displayName,
    required this.level,
    required this.experience,
    required this.coins,
    required this.streak,
    required this.completedLessons,
    required this.achievements,
  });

  int get nextLevelXP => (level * 100);
  double get progressToNextLevel => (experience % 100) / 100.0;
}

// Pantallas Demo
class DemoWelcomeScreen extends StatelessWidget {
  const DemoWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Logo
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(60),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.account_balance_wallet,
                  size: 60,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 40),

              // Título
              const Text(
                'Wimi',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Aprende finanzas de forma divertida',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 60),

              // Botón
              Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: ElevatedButton(
                  onPressed: () => context.go('/login'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    '¡Comenzar Aventura!',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const Spacer(),

              // Features
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FeatureItem(icon: Icons.school, text: 'Aprende'),
                    FeatureItem(icon: Icons.emoji_events, text: 'Gana'),
                    FeatureItem(icon: Icons.trending_up, text: 'Crece'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Version Demo
              const Text(
                'VERSIÓN DEMO - SIN FIREBASE',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const FeatureItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class DemoLoginScreen extends StatelessWidget {
  const DemoLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Bienvenido a Wimi',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 40),

            TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'demo@wimi.com',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                hintText: '123456',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  // Mostrar loading
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) =>
                        const Center(child: CircularProgressIndicator()),
                  );

                  final authProvider = Provider.of<DemoAuthProvider>(
                    context,
                    listen: false,
                  );
                  await authProvider.signIn('demo@wimi.com', '123456');

                  if (context.mounted) {
                    Navigator.of(context).pop(); // Cerrar loading
                    context.go('/dashboard');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Iniciar Sesión',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.info.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.info, color: AppColors.info),
                  const SizedBox(height: 8),
                  Text(
                    'VERSIÓN DEMO',
                    style: TextStyle(
                      color: AppColors.info,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Cualquier email/contraseña funciona\nNo se requiere registro real',
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DemoDashboardScreen extends StatelessWidget {
  const DemoDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DemoUserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.user;

        return Scaffold(
          appBar: AppBar(
            title: Text('¡Hola, ${user.displayName}!'),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                onPressed: () async {
                  final authProvider = Provider.of<DemoAuthProvider>(
                    context,
                    listen: false,
                  );
                  await authProvider.signOut();
                  if (context.mounted) {
                    context.go('/');
                  }
                },
                icon: const Icon(Icons.logout),
                tooltip: 'Cerrar Sesión',
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Banner de bienvenida
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '🎉 ¡Bienvenido a tu aventura financiera!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Estás en el nivel ${user.level} con ${user.experience} XP',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Stats Cards
                const Text(
                  'Tu Progreso',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        title: 'Nivel',
                        value: user.level.toString(),
                        icon: Icons.trending_up,
                        color: AppColors.primary,
                        subtitle: 'Tu nivel actual',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        title: 'XP',
                        value: user.experience.toString(),
                        icon: Icons.star,
                        color: AppColors.xp,
                        subtitle: 'Experiencia total',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        title: 'Monedas',
                        value: user.coins.toString(),
                        icon: Icons.monetization_on,
                        color: AppColors.gold,
                        subtitle: 'Monedas ganadas',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        title: 'Racha',
                        value: '${user.streak} días',
                        icon: Icons.local_fire_department,
                        color: AppColors.error,
                        subtitle: 'Días consecutivos',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Progreso al siguiente nivel
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.emoji_events,
                              color: AppColors.gold,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Progreso al Nivel ${user.level + 1}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        LinearProgressIndicator(
                          value: user.progressToNextLevel,
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.primary,
                          ),
                          minHeight: 8,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${user.experience % 100}/${user.nextLevelXP} XP',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${((user.progressToNextLevel) * 100).toInt()}%',
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Quick Actions
                const Text(
                  'Acciones Rápidas',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
                  children: [
                    _ActionCard(
                      title: 'Lecciones',
                      subtitle: '${user.completedLessons} completadas',
                      icon: Icons.school,
                      color: AppColors.primary,
                      onTap: () => context.go('/lessons'),
                    ),
                    _ActionCard(
                      title: 'Logros',
                      subtitle: '${user.achievements} desbloqueados',
                      icon: Icons.emoji_events,
                      color: AppColors.gold,
                      onTap: () => context.go('/achievements'),
                    ),
                    _ActionCard(
                      title: 'Perfil',
                      subtitle: 'Ver estadísticas',
                      icon: Icons.person,
                      color: AppColors.info,
                      onTap: () => context.go('/profile'),
                    ),
                    _ActionCard(
                      title: 'Explorar',
                      subtitle: 'Navega la demo',
                      icon: Icons.explore,
                      color: AppColors.secondary,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text(
                              '¡Explora todas las pantallas de la demo!',
                            ),
                            backgroundColor: AppColors.success,
                            action: SnackBarAction(
                              label: 'OK',
                              textColor: Colors.white,
                              onPressed: () {},
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Demo info
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.warning.withOpacity(0.3),
                    ),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.info, color: AppColors.warning),
                      SizedBox(height: 8),
                      Text(
                        'VERSIÓN DEMO',
                        style: TextStyle(
                          color: AppColors.warning,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Esta es una demo completamente funcional de Wimi App.\nTodas las funciones de navegación están disponibles.',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String subtitle;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.grey, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.grey, fontSize: 11),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Pantallas adicionales simplificadas
class DemoLessonsScreen extends StatelessWidget {
  const DemoLessonsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lessons = [
      {
        'title': 'Conceptos Básicos',
        'icon': Icons.school,
        'color': AppColors.primary,
        'progress': 0.8,
      },
      {
        'title': 'Ahorro e Inversión',
        'icon': Icons.savings,
        'color': AppColors.success,
        'progress': 0.6,
      },
      {
        'title': 'Presupuesto',
        'icon': Icons.pie_chart,
        'color': AppColors.info,
        'progress': 0.3,
      },
      {
        'title': 'Créditos',
        'icon': Icons.credit_card,
        'color': AppColors.warning,
        'progress': 0.1,
      },
      {
        'title': 'Inversiones Avanzadas',
        'icon': Icons.trending_up,
        'color': AppColors.error,
        'progress': 0.0,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lecciones'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Categorías de Aprendizaje',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Domina las finanzas paso a paso',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 24),

            Expanded(
              child: ListView.builder(
                itemCount: lessons.length,
                itemBuilder: (context, index) {
                  final lesson = lessons[index];
                  final isLocked =
                      (lesson['progress'] as double) == 0.0 && index > 2;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isLocked
                            ? Colors.grey
                            : (lesson['color'] as Color),
                        child: Icon(
                          isLocked ? Icons.lock : (lesson['icon'] as IconData),
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        lesson['title'] as String,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isLocked ? Colors.grey : null,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isLocked
                                ? 'Bloqueado - Completa lecciones anteriores'
                                : 'Progreso: ${((lesson['progress'] as double) * 100).toInt()}%',
                          ),
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: lesson['progress'] as double,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isLocked
                                  ? Colors.grey
                                  : (lesson['color'] as Color),
                            ),
                          ),
                        ],
                      ),
                      trailing: isLocked
                          ? null
                          : const Icon(Icons.arrow_forward_ios),
                      onTap: isLocked
                          ? null
                          : () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Abriendo: ${lesson['title']}'),
                                  backgroundColor: lesson['color'] as Color,
                                ),
                              );
                            },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DemoAchievementsScreen extends StatelessWidget {
  const DemoAchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final achievements = [
      {
        'title': 'Primer Paso',
        'description': 'Completa tu primera lección',
        'icon': Icons.star,
        'unlocked': true,
        'color': AppColors.gold,
      },
      {
        'title': 'Estudiante Dedicado',
        'description': 'Completa 5 lecciones',
        'icon': Icons.school,
        'unlocked': true,
        'color': AppColors.primary,
      },
      {
        'title': 'Racha de Fuego',
        'description': '7 días consecutivos',
        'icon': Icons.local_fire_department,
        'unlocked': true,
        'color': AppColors.error,
      },
      {
        'title': 'Coleccionista de Monedas',
        'description': 'Gana 100 monedas',
        'icon': Icons.monetization_on,
        'unlocked': true,
        'color': AppColors.gold,
      },
      {
        'title': 'Experto en Ahorro',
        'description': 'Completa módulo de ahorro',
        'icon': Icons.savings,
        'unlocked': false,
        'color': AppColors.success,
      },
      {
        'title': 'Maestro Financiero',
        'description': 'Completa todos los módulos',
        'icon': Icons.emoji_events,
        'unlocked': false,
        'color': AppColors.gold,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Logros'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.gold, AppColors.secondary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '🏆 Tus Logros',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Has desbloqueado 4 de 6 logros',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
                itemCount: achievements.length,
                itemBuilder: (context, index) {
                  final achievement = achievements[index];
                  final isUnlocked = achievement['unlocked'] as bool;

                  return Card(
                    elevation: isUnlocked ? 6 : 2,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: isUnlocked
                            ? LinearGradient(
                                colors: [
                                  (achievement['color'] as Color).withOpacity(
                                    0.1,
                                  ),
                                  (achievement['color'] as Color).withOpacity(
                                    0.05,
                                  ),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: isUnlocked
                                    ? (achievement['color'] as Color)
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Icon(
                                achievement['icon'] as IconData,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              achievement['title'] as String,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: isUnlocked ? null : Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              achievement['description'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                color: isUnlocked ? Colors.grey : Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isUnlocked
                                    ? (achievement['color'] as Color)
                                          .withOpacity(0.2)
                                    : Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                isUnlocked ? 'DESBLOQUEADO' : 'BLOQUEADO',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isUnlocked
                                      ? (achievement['color'] as Color)
                                      : Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DemoProfileScreen extends StatelessWidget {
  const DemoProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DemoUserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.user;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Mi Perfil'),
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Header del perfil
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: AppColors.primary,
                          child: Text(
                            user.displayName[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user.displayName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          user.email,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Nivel ${user.level}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Estadísticas
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Estadísticas',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _StatRow(
                          'Experiencia Total',
                          '${user.experience} XP',
                          Icons.star,
                          AppColors.xp,
                        ),
                        _StatRow(
                          'Lecciones Completadas',
                          user.completedLessons.toString(),
                          Icons.school,
                          AppColors.primary,
                        ),
                        _StatRow(
                          'Logros Desbloqueados',
                          user.achievements.toString(),
                          Icons.emoji_events,
                          AppColors.gold,
                        ),
                        _StatRow(
                          'Monedas Ganadas',
                          user.coins.toString(),
                          Icons.monetization_on,
                          AppColors.gold,
                        ),
                        _StatRow(
                          'Racha Actual',
                          '${user.streak} días',
                          Icons.local_fire_department,
                          AppColors.error,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Opciones
                Card(
                  child: Column(
                    children: [
                      _OptionTile('Editar Perfil', Icons.edit, () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Función de edición próximamente'),
                          ),
                        );
                      }),
                      _OptionTile('Notificaciones', Icons.notifications, () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Configuración de notificaciones'),
                          ),
                        );
                      }),
                      _OptionTile('Privacidad', Icons.security, () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Configuración de privacidad'),
                          ),
                        );
                      }),
                      _OptionTile('Ayuda y Soporte', Icons.help, () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Centro de ayuda próximamente'),
                          ),
                        );
                      }),
                      _OptionTile('Cerrar Sesión', Icons.logout, () async {
                        final authProvider = Provider.of<DemoAuthProvider>(
                          context,
                          listen: false,
                        );
                        await authProvider.signOut();
                        if (context.mounted) {
                          context.go('/');
                        }
                      }, isLogout: true),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Demo info
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.info.withOpacity(0.3)),
                  ),
                  child: const Column(
                    children: [
                      Icon(Icons.info, color: AppColors.info),
                      SizedBox(height: 8),
                      Text(
                        'PERFIL DEMO',
                        style: TextStyle(
                          color: AppColors.info,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Datos simulados para demostración',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatRow(this.label, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isLogout;

  const _OptionTile(this.title, this.icon, this.onTap, {this.isLogout = false});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isLogout ? AppColors.error : AppColors.primary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isLogout ? AppColors.error : null,
          fontWeight: isLogout ? FontWeight.bold : null,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
