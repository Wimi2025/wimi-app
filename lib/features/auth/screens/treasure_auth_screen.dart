import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_colors.dart';
import '../providers/auth_provider.dart';
import '../services/google_auth_service.dart';

class TreasureAuthScreen extends ConsumerStatefulWidget {
  const TreasureAuthScreen({super.key});

  @override
  State<TreasureAuthScreen> createState() => _TreasureAuthScreenState();
}

class _TreasureAuthScreenState extends ConsumerState<TreasureAuthScreen>
    with TickerProviderStateMixin {
  late AnimationController _treasureController;
  late AnimationController _sparkleController;
  late AnimationController _pulseController;

  final GoogleAuthService _googleAuthService = GoogleAuthService();
  bool _isLoading = false;

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

    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _treasureController.dispose();
    _sparkleController.dispose();
    _pulseController.dispose();
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
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Header con tesoro
                _buildHeader(),

                const Spacer(),

                // Contenido principal
                _buildMainContent(),

                const Spacer(),

                // Botones de autenticación
                _buildAuthButtons(),

                const SizedBox(height: 32),
              ],
            ),
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
          // Tesoro principal con pulso
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_pulseController.value * 0.1),
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.wimiGold,
                        AppColors.wimiBronze,
                        AppColors.wimiGold.withOpacity(0.8),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.wimiGold.withOpacity(0.6),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    size: 70,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),

          // Partículas de oro giratorias
          ...List.generate(12, (index) {
            return AnimatedBuilder(
              animation: _sparkleController,
              builder: (context, child) {
                final angle = (index * 30) * (3.14159 / 180);
                final radius = 100 + (index % 4) * 15;
                final x = radius * (angle + _sparkleController.value * 3).cos();
                final y = radius * (angle + _sparkleController.value * 3).sin();

                return Positioned(
                  left: 200 + x,
                  top: 100 + y,
                  child: Container(
                    width: 6 + (index % 3) * 2,
                    height: 6 + (index % 3) * 2,
                    decoration: BoxDecoration(
                      color: AppColors.wimiGold,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.wimiGold.withOpacity(0.8),
                          blurRadius: 4,
                        ),
                      ],
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

  Widget _buildMainContent() {
    return Column(
      children: [
        // Título principal
        Text(
              '¡Bienvenido, Explorador!',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            )
            .animate()
            .fadeIn(duration: 1000.ms, delay: 200.ms)
            .slideY(begin: 0.3, end: 0, duration: 1000.ms, delay: 200.ms),

        const SizedBox(height: 16),

        // Subtítulo
        Text(
              'El tesoro de las finanzas personales te espera',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white70,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            )
            .animate()
            .fadeIn(duration: 1000.ms, delay: 400.ms)
            .slideY(begin: 0.3, end: 0, duration: 1000.ms, delay: 400.ms),

        const SizedBox(height: 40),

        // Características del tesoro
        _buildTreasureFeatures(),
      ],
    );
  }

  Widget _buildTreasureFeatures() {
    final features = [
      {'icon': Icons.auto_awesome, 'text': 'Aprende con diversión'},
      {'icon': Icons.monetization_on, 'text': 'Gana monedas de oro'},
      {'icon': Icons.emoji_events, 'text': 'Desbloquea logros'},
      {'icon': Icons.trending_up, 'text': 'Mejora tus finanzas'},
    ];

    return Column(
      children: features.map((feature) {
        return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.wimiGold.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    feature['icon'] as IconData,
                    color: AppColors.wimiGold,
                    size: 24,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    feature['text'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
            .animate()
            .fadeIn(
              duration: 600.ms,
              delay: (features.indexOf(feature) * 100).ms,
            )
            .slideX(
              begin: -0.3,
              end: 0,
              duration: 600.ms,
              delay: (features.indexOf(feature) * 100).ms,
            );
      }).toList(),
    );
  }

  Widget _buildAuthButtons() {
    return Column(
      children: [
        // Botón de Google
        SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _signInWithGoogle,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.black87,
                          ),
                        ),
                      )
                    : Image.asset(
                        'assets/icons/google_logo.png',
                        width: 24,
                        height: 24,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.login, size: 24);
                        },
                      ),
                label: Text(
                  _isLoading ? 'Iniciando sesión...' : 'Continuar con Google',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
            .animate()
            .fadeIn(duration: 800.ms, delay: 600.ms)
            .slideY(begin: 0.3, end: 0, duration: 800.ms, delay: 600.ms),

        const SizedBox(height: 16),

        // Divider
        Row(
          children: [
            Expanded(child: Container(height: 1, color: Colors.white30)),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('o', style: TextStyle(color: Colors.white70)),
            ),
            Expanded(child: Container(height: 1, color: Colors.white30)),
          ],
        ),

        const SizedBox(height: 16),

        // Botón de registro manual
        SizedBox(
              width: double.infinity,
              height: 56,
              child: OutlinedButton.icon(
                onPressed: _isLoading ? null : () => context.go('/register'),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.wimiGold, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.person_add, size: 24),
                label: const Text(
                  'Crear cuenta nueva',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.wimiGold,
                  ),
                ),
              ),
            )
            .animate()
            .fadeIn(duration: 800.ms, delay: 800.ms)
            .slideY(begin: 0.3, end: 0, duration: 800.ms, delay: 800.ms),

        const SizedBox(height: 16),

        // Botón de login
        TextButton(
          onPressed: _isLoading ? null : () => context.go('/login'),
          child: const Text(
            '¿Ya tienes cuenta? Inicia sesión',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ).animate().fadeIn(duration: 600.ms, delay: 1000.ms),
      ],
    );
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authUser = await _googleAuthService.signInWithGoogle();

      if (authUser != null && mounted) {
        // Actualizar el provider de autenticación
        final authNotifier = ref.read(authStateProvider.notifier);
        await authNotifier.setUser(authUser);

        // Navegar al dashboard
        if (mounted) {
          context.go('/dashboard');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al iniciar sesión: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
