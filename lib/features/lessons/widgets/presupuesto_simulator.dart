import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';

class PresupuestoSimulator extends StatefulWidget {
  final Map<String, dynamic> params;
  final Function(String name, Map<String, dynamic> params) onComplete;

  const PresupuestoSimulator({
    super.key,
    required this.params,
    required this.onComplete,
  });

  @override
  State<PresupuestoSimulator> createState() => _PresupuestoSimulatorState();
}

class _PresupuestoSimulatorState extends State<PresupuestoSimulator> {
  late double _ingresos;
  late double _fijos;
  late double _variables;
  late double _ahorroObjetivo;

  double _ahorroCalculado = 0;
  double _diferencia = 0;
  bool _esPositivo = true;

  @override
  void initState() {
    super.initState();
    _ingresos = (widget.params['ingresos'] ?? 100000).toDouble();
    _fijos = (widget.params['fijos'] ?? 60000).toDouble();
    _variables = (widget.params['variables'] ?? 25000).toDouble();
    _ahorroObjetivo = (widget.params['ahorro_objetivo'] ?? 15000).toDouble();
    _calcularAhorro();
  }

  void _calcularAhorro() {
    setState(() {
      _ahorroCalculado = _ingresos - _fijos - _variables;
      _diferencia = _ahorroCalculado - _ahorroObjetivo;
      _esPositivo = _diferencia >= 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.wimiGold.withOpacity(0.1),
            AppColors.wimiBronze.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.wimiGold.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          Text(
                'Simulador de Presupuesto',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              )
              .animate()
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.3, end: 0, duration: 600.ms),

          const SizedBox(height: 8),

          Text(
                'Ajusta los valores y ve cómo cambia tu ahorro',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                ),
              )
              .animate()
              .fadeIn(duration: 600.ms, delay: 200.ms)
              .slideY(begin: 0.3, end: 0, duration: 600.ms, delay: 200.ms),

          const SizedBox(height: 24),

          // Controles
          _buildControls(),

          const SizedBox(height: 24),

          // Resultado
          _buildResult(),

          const SizedBox(height: 20),

          // Botón de completar
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => widget.onComplete('presupuesto', {
                'ingresos': _ingresos,
                'fijos': _fijos,
                'variables': _variables,
                'ahorro_calculado': _ahorroCalculado,
                'diferencia': _diferencia,
              }),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.wimiGold,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Completar Simulación',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Column(
      children: [
        _buildSliderControl('Ingresos Mensuales', _ingresos, 0, 500000, 5000, (
          value,
        ) {
          _ingresos = value;
          _calcularAhorro();
        }),

        const SizedBox(height: 16),

        _buildSliderControl('Gastos Fijos', _fijos, 0, _ingresos, 1000, (
          value,
        ) {
          _fijos = value;
          _calcularAhorro();
        }),

        const SizedBox(height: 16),

        _buildSliderControl(
          'Gastos Variables',
          _variables,
          0,
          _ingresos - _fijos,
          1000,
          (value) {
            _variables = value;
            _calcularAhorro();
          },
        ),
      ],
    );
  }

  Widget _buildSliderControl(
    String label,
    double value,
    double min,
    double max,
    double step,
    Function(double) onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '\$${value.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.wimiGold,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.wimiGold,
            inactiveTrackColor: Colors.white.withOpacity(0.3),
            thumbColor: AppColors.wimiGold,
            overlayColor: AppColors.wimiGold.withOpacity(0.2),
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            trackHeight: 4,
          ),
          child: Slider(
            value: value,
            min: min,
            max: max,
            divisions: ((max - min) / step).round(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildResult() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _esPositivo
            ? AppColors.wimiEmerald.withOpacity(0.2)
            : AppColors.wimiRuby.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _esPositivo
              ? AppColors.wimiEmerald.withOpacity(0.5)
              : AppColors.wimiRuby.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _esPositivo ? Icons.trending_up : Icons.trending_down,
                color: _esPositivo ? AppColors.wimiEmerald : AppColors.wimiRuby,
                size: 32,
              ),
              const SizedBox(width: 12),
              Text(
                'Ahorro Calculado',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(
            '\$${_ahorroCalculado.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: _esPositivo ? AppColors.wimiEmerald : AppColors.wimiRuby,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            _esPositivo
                ? '¡Excelente! Estás ahorrando más de lo esperado'
                : 'Necesitas ajustar tus gastos para alcanzar tu objetivo',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
              textAlign: TextAlign.center,
            ),
          ),

          if (_ahorroObjetivo > 0) ...[
            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Text(
                    'Objetivo: \$${_ahorroObjetivo.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                    style: const TextStyle(fontSize: 14, color: Colors.white70),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'Diferencia: \$${_diferencia.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _esPositivo
                          ? AppColors.wimiEmerald
                          : AppColors.wimiRuby,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0, duration: 600.ms);
  }
}
