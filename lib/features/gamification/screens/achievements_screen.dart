import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logros'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tus Logros',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Completa desafíos para desbloquear logros especiales',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.8,
                ),
                itemCount: _achievements.length,
                itemBuilder: (context, index) {
                  final achievement = _achievements[index];
                  return _buildAchievementCard(achievement);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementCard(Map<String, dynamic> achievement) {
    final isUnlocked = achievement['unlocked'] as bool;
    final color = isUnlocked ? achievement['color'] as Color : Colors.grey;
    
    return Card(
      child: InkWell(
        onTap: () {
          // Mostrar detalles del logro
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                achievement['icon'] as IconData,
                size: 48,
                color: color,
              ),
              const SizedBox(height: 12),
              Text(
                achievement['title'] as String,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                achievement['description'] as String,
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              if (isUnlocked)
                Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 20,
                )
              else
                Icon(
                  Icons.lock,
                  color: Colors.grey,
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Datos de ejemplo de logros
  static const List<Map<String, dynamic>> _achievements = [
    {
      'title': 'Primer Paso',
      'description': 'Completa tu primera lección',
      'icon': Icons.first_page,
      'color': AppColors.primary,
      'unlocked': true,
    },
    {
      'title': 'Racha de 7 días',
      'description': 'Aprende durante 7 días consecutivos',
      'icon': Icons.local_fire_department,
      'color': AppColors.secondary,
      'unlocked': false,
    },
    {
      'title': 'Nivel 10',
      'description': 'Alcanza el nivel 10',
      'icon': Icons.trending_up,
      'color': AppColors.info,
      'unlocked': false,
    },
    {
      'title': 'Ahorrador',
      'description': 'Completa 5 lecciones de ahorro',
      'icon': Icons.savings,
      'color': AppColors.success,
      'unlocked': false,
    },
    {
      'title': 'Inversor',
      'description': 'Completa 5 lecciones de inversión',
      'icon': Icons.account_balance,
      'color': AppColors.warning,
      'unlocked': false,
    },
    {
      'title': 'Maestro',
      'description': 'Completa todas las lecciones',
      'icon': Icons.school,
      'color': AppColors.gold,
      'unlocked': false,
    },
  ];
} 