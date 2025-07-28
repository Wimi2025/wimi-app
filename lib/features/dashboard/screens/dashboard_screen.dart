import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../app/navigation/app_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../auth/providers/auth_provider.dart';
import '../../gamification/providers/user_provider.dart';
import '../../gamification/models/user_model.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: () => context.goToProfile(),
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: Consumer2<AuthProvider, UserProvider>(
        builder: (context, authProvider, userProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Saludo
                Text(
                  '¡Hola, ${authProvider.user?.displayName ?? 'Usuario'}!',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                
                const SizedBox(height: 24),
                
                // Estadísticas del usuario
                if (userProvider.user != null) ...[
                  _buildUserStats(userProvider.user!),
                  const SizedBox(height: 24),
                ],
                
                // Acciones rápidas
                Text(
                  'Acciones Rápidas',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                
                const SizedBox(height: 16),
                
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildActionCard(
                        context,
                        'Lecciones',
                        Icons.school,
                        AppColors.primary,
                        () => context.goToLessons(),
                      ),
                      _buildActionCard(
                        context,
                        'Logros',
                        Icons.emoji_events,
                        AppColors.secondary,
                        () => context.goToAchievements(),
                      ),
                      _buildActionCard(
                        context,
                        'Perfil',
                        Icons.person,
                        AppColors.info,
                        () => context.goToProfile(),
                      ),
                      _buildActionCard(
                        context,
                        'Cerrar Sesión',
                        Icons.logout,
                        AppColors.error,
                        () => _handleLogout(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserStats(UserModel user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tu Progreso',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Nivel', '${user.level}', Icons.trending_up),
                _buildStatItem('XP', '${user.experience}', Icons.star),
                _buildStatItem('Monedas', '${user.coins}', Icons.monetization_on),
                _buildStatItem('Racha', '${user.streak}', Icons.local_fire_department),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.signOut();
    if (context.mounted) {
      context.goToWelcome();
    }
  }
} 