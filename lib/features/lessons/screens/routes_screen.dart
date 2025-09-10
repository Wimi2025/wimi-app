import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../models/lesson_model.dart';
import '../services/lesson_repository.dart';

class RoutesScreen extends ConsumerStatefulWidget {
  const RoutesScreen({super.key});

  @override
  ConsumerState<RoutesScreen> createState() => _RoutesScreenState();
}

class _RoutesScreenState extends ConsumerState<RoutesScreen> {
  final LessonRepository _lessonRepository = LessonRepository();
  List<RouteModel> _routes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRoutes();
  }

  Future<void> _loadRoutes() async {
    try {
      final routes = await _lessonRepository.getRoutes();
      setState(() {
        _routes = routes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar rutas: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
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
                // Header
                _buildHeader(),

                const SizedBox(height: 24),

                // Lista de rutas
                Expanded(
                  child: _isLoading ? _buildLoading() : _buildRoutesList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Botón de regreso
        IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),

        const SizedBox(height: 16),

        // Título
        Text(
              'Rutas de Aprendizaje',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            )
            .animate()
            .fadeIn(duration: 600.ms)
            .slideY(begin: 0.3, end: 0, duration: 600.ms),

        const SizedBox(height: 8),

        // Subtítulo
        Text(
              'Elige tu aventura financiera',
              style: const TextStyle(fontSize: 16, color: Colors.white70),
            )
            .animate()
            .fadeIn(duration: 800.ms, delay: 200.ms)
            .slideY(begin: 0.3, end: 0, duration: 800.ms, delay: 200.ms),
      ],
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.wimiGold),
      ),
    );
  }

  Widget _buildRoutesList() {
    return ListView.builder(
      itemCount: _routes.length,
      itemBuilder: (context, index) {
        final route = _routes[index];
        return _buildRouteCard(route, index);
      },
    );
  }

  Widget _buildRouteCard(RouteModel route, int index) {
    final colors = [
      AppColors.wimiGold,
      AppColors.wimiEmerald,
      AppColors.wimiRuby,
      AppColors.wimiSapphire,
    ];

    final color = colors[index % colors.length];

    return Container(
          margin: const EdgeInsets.only(bottom: 16),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.go('/lessons/${route.id}'),
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
                child: Row(
                  children: [
                    // Icono
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getIconData(route.icon),
                        color: color,
                        size: 30,
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Contenido
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            route.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            '5 lecciones disponibles',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Barra de progreso
                          Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: 0.0, // TODO: Calcular progreso real
                              child: Container(
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Flecha
                    Icon(Icons.arrow_forward_ios, color: color, size: 20),
                  ],
                ),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 600.ms, delay: (index * 100).ms)
        .slideX(begin: 0.3, end: 0, duration: 600.ms, delay: (index * 100).ms);
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'account_balance_wallet':
        return Icons.account_balance_wallet;
      case 'savings':
        return Icons.savings;
      case 'credit_card':
        return Icons.credit_card;
      case 'trending_up':
        return Icons.trending_up;
      default:
        return Icons.school;
    }
  }
}
