import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';

class TreasureOnboardingScreen extends StatefulWidget {
  const TreasureOnboardingScreen({super.key});

  @override
  State<TreasureOnboardingScreen> createState() =>
      _TreasureOnboardingScreenState();
}

class _TreasureOnboardingScreenState extends State<TreasureOnboardingScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  int _currentPage = 0;
  late AnimationController _treasureController;
  late AnimationController _sparkleController;

  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: '¡Bienvenido, Explorador!',
      description: 'Descubre el tesoro más valioso: el conocimiento financiero',
      icon: Icons.auto_awesome,
      color: AppColors.wimiGold,
    ),
    OnboardingPage(
      title: 'Aprende como un Aventurero',
      description:
          'Cada lección es un mapa que te lleva al tesoro de la sabiduría',
      icon: Icons.map,
      color: AppColors.wimiEmerald,
    ),
    OnboardingPage(
      title: 'Gana Monedas de Oro',
      description: 'Cada logro te acerca más al cofre del tesoro',
      icon: Icons.monetization_on,
      color: AppColors.wimiBronze,
    ),
    OnboardingPage(
      title: '¡Comienza tu Aventura!',
      description: 'El tesoro de las finanzas personales te espera',
      icon: Icons.rocket_launch,
      color: AppColors.wimiRuby,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _treasureController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _sparkleController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pageController.dispose();
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
          child: Column(
            children: [
              // Header con tesoro animado
              _buildHeader(),

              // Páginas de onboarding
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: _pages.length,
                  itemBuilder: (context, index) {
                    return _buildOnboardingPage(_pages[index]);
                  },
                ),
              ),

              // Indicadores y botones
              _buildBottomSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Tesoro principal
          AnimatedBuilder(
            animation: _treasureController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _treasureController.value * 0.1,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [AppColors.wimiGold, AppColors.wimiBronze],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.wimiGold.withOpacity(0.5),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),

          // Partículas de oro
          ...List.generate(8, (index) {
            return AnimatedBuilder(
              animation: _sparkleController,
              builder: (context, child) {
                final angle = (index * 45) * (3.14159 / 180);
                final radius = 80 + (index % 3) * 20;
                final x = radius * (angle + _sparkleController.value * 2).cos();
                final y = radius * (angle + _sparkleController.value * 2).sin();

                return Positioned(
                  left: 200 + x,
                  top: 100 + y,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.wimiGold,
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage(OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icono principal
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [page.color, page.color.withOpacity(0.7)],
              ),
              boxShadow: [
                BoxShadow(
                  color: page.color.withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(page.icon, size: 60, color: Colors.white),
          ).animate().scale(duration: 600.ms, curve: Curves.elasticOut),

          const SizedBox(height: 40),

          // Título
          Text(
                page.title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              )
              .animate()
              .fadeIn(duration: 800.ms, delay: 200.ms)
              .slideY(begin: 0.3, end: 0, duration: 800.ms, delay: 200.ms),

          const SizedBox(height: 20),

          // Descripción
          Text(
                page.description,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              )
              .animate()
              .fadeIn(duration: 800.ms, delay: 400.ms)
              .slideY(begin: 0.3, end: 0, duration: 800.ms, delay: 400.ms),
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          // Indicadores de página
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _pages.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 24 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? AppColors.wimiGold
                      : Colors.white30,
                  borderRadius: BorderRadius.circular(4),
                ),
              ).animate().scale(duration: 300.ms, curve: Curves.easeInOut),
            ),
          ),

          const SizedBox(height: 32),

          // Botones
          Row(
            children: [
              // Botón anterior
              if (_currentPage > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.wimiGold),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Anterior',
                      style: TextStyle(color: AppColors.wimiGold),
                    ),
                  ),
                ),

              if (_currentPage > 0) const SizedBox(width: 16),

              // Botón siguiente/continuar
              Expanded(
                flex: _currentPage == 0 ? 1 : 1,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage < _pages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      // Ir a la pantalla de autenticación
                      context.go('/auth');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.wimiGold,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _currentPage < _pages.length - 1
                        ? 'Siguiente'
                        : '¡Comenzar!',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
