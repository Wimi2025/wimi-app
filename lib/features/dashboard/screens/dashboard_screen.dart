import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen>
    with TickerProviderStateMixin {
  late AnimationController _treasureController;
  late AnimationController _sparkleController;

  @override
  void initState() {
    super.initState();
    _treasureController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _sparkleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _treasureController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header con tesoro
                _buildHeader(),

                const SizedBox(height: 24),

                // Estadísticas del usuario
                _buildUserStats(),

                const SizedBox(height: 24),

                // Acciones principales
                _buildMainActions(),

                const SizedBox(height: 24),

                // Acciones rápidas
                _buildQuickActions(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Tesoro animado
        AnimatedBuilder(
          animation: _treasureController,
          builder: (context, child) {
            return Transform.rotate(
              angle: _treasureController.value * 0.1,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [AppColors.wimiGold, AppColors.wimiBronze],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.wimiGold.withOpacity(0.5),
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  size: 30,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),

        const SizedBox(width: 16),

        // Saludo
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                    '¡Bienvenido, Explorador!',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: 0.3, end: 0, duration: 600.ms),

              Text(
                    'El tesoro de las finanzas te espera',
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  )
                  .animate()
                  .fadeIn(duration: 800.ms, delay: 200.ms)
                  .slideY(begin: 0.3, end: 0, duration: 800.ms, delay: 200.ms),
            ],
          ),
        ),

        // Botón de perfil
        IconButton(
          onPressed: () => context.go('/profile'),
          icon: const Icon(Icons.person, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildUserStats() {
    return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.wimiGold.withOpacity(0.2),
                AppColors.wimiBronze.withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.wimiGold.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // XP
              Expanded(
                child: _buildStatItem(
                  icon: Icons.star,
                  label: 'XP',
                  value: '1,250',
                  color: AppColors.wimiGold,
                ),
              ),

              Container(
                width: 1,
                height: 40,
                color: Colors.white.withOpacity(0.2),
              ),

              // Nivel
              Expanded(
                child: _buildStatItem(
                  icon: Icons.trending_up,
                  label: 'Nivel',
                  value: '5',
                  color: AppColors.wimiEmerald,
                ),
              ),

              Container(
                width: 1,
                height: 40,
                color: Colors.white.withOpacity(0.2),
              ),

              // Monedas
              Expanded(
                child: _buildStatItem(
                  icon: Icons.monetization_on,
                  label: 'Monedas',
                  value: '450',
                  color: AppColors.wimiRuby,
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 800.ms, delay: 400.ms)
        .slideY(begin: 0.3, end: 0, duration: 800.ms, delay: 400.ms);
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.7)),
        ),
      ],
    );
  }

  Widget _buildMainActions() {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Explorar Tesoros',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    title: 'Lecciones',
                    subtitle: 'Aprende finanzas',
                    icon: Icons.school,
                    color: AppColors.wimiGold,
                    onTap: () => context.go('/lessons'),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: _buildActionCard(
                    title: 'Logros',
                    subtitle: 'Tus conquistas',
                    icon: Icons.emoji_events,
                    color: AppColors.wimiEmerald,
                    onTap: () => context.go('/achievements'),
                  ),
                ),
              ],
            ),
          ],
        )
        .animate()
        .fadeIn(duration: 800.ms, delay: 600.ms)
        .slideY(begin: 0.3, end: 0, duration: 800.ms, delay: 600.ms);
  }

  Widget _buildQuickActions() {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Acciones Rápidas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildQuickActionButton(
                    icon: Icons.trending_up,
                    label: 'Progreso',
                    color: AppColors.wimiSapphire,
                    onTap: () {},
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _buildQuickActionButton(
                    icon: Icons.leaderboard,
                    label: 'Ranking',
                    color: AppColors.wimiRuby,
                    onTap: () {},
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _buildQuickActionButton(
                    icon: Icons.settings,
                    label: 'Config',
                    color: AppColors.wimiBronze,
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ],
        )
        .animate()
        .fadeIn(duration: 800.ms, delay: 800.ms)
        .slideY(begin: 0.3, end: 0, duration: 800.ms, delay: 800.ms);
  }

  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.2), color.withOpacity(0.1)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withOpacity(0.3), width: 1),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 40),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.3), width: 1),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
