import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';

class SliderWidget extends StatefulWidget {
  final String label;
  final double min;
  final double max;
  final double step;
  final double? correct;
  final double tolerance;
  final Function(bool isCorrect, double value) onAnswer;

  const SliderWidget({
    super.key,
    required this.label,
    required this.min,
    required this.max,
    required this.step,
    this.correct,
    this.tolerance = 0,
    required this.onAnswer,
  });

  @override
  State<SliderWidget> createState() => _SliderWidgetState();
}

class _SliderWidgetState extends State<SliderWidget> {
  double _currentValue = 0;
  bool _isAnswered = false;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.min;
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
          // Pregunta
          Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.4,
                ),
              )
              .animate()
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.3, end: 0, duration: 600.ms),

          const SizedBox(height: 24),

          // Slider
          Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.wimiGold.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    // Valor actual
                    Text(
                          '${_currentValue.toInt()}%',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.wimiGold,
                          ),
                        )
                        .animate()
                        .fadeIn(duration: 300.ms)
                        .scale(
                          begin: const Offset(1.2, 1.2),
                          end: const Offset(1.0, 1.0),
                          duration: 300.ms,
                        ),

                    const SizedBox(height: 20),

                    // Slider
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: AppColors.wimiGold,
                        inactiveTrackColor: Colors.white.withOpacity(0.3),
                        thumbColor: AppColors.wimiGold,
                        overlayColor: AppColors.wimiGold.withOpacity(0.2),
                        thumbShape: const RoundSliderThumbShape(
                          enabledThumbRadius: 12,
                        ),
                        trackHeight: 6,
                      ),
                      child: Slider(
                        value: _currentValue,
                        min: widget.min,
                        max: widget.max,
                        divisions: ((widget.max - widget.min) / widget.step)
                            .round(),
                        onChanged: _isAnswered
                            ? null
                            : (value) {
                                setState(() {
                                  _currentValue = value;
                                });
                              },
                      ),
                    ),

                    // Rango
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.min.toInt()}%',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        Text(
                          '${widget.max.toInt()}%',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
              .animate()
              .fadeIn(duration: 600.ms, delay: 200.ms)
              .slideY(begin: 0.3, end: 0, duration: 600.ms, delay: 200.ms),

          const SizedBox(height: 20),

          // Botón de confirmar
          if (!_isAnswered) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _confirmAnswer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.wimiGold,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Confirmar Respuesta',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],

          // Resultado
          if (_isAnswered) ...[
            Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _isCorrect
                        ? AppColors.wimiEmerald.withOpacity(0.2)
                        : AppColors.wimiRuby.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isCorrect
                          ? AppColors.wimiEmerald.withOpacity(0.5)
                          : AppColors.wimiRuby.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _isCorrect ? Icons.check_circle : Icons.cancel,
                            color: _isCorrect
                                ? AppColors.wimiEmerald
                                : AppColors.wimiRuby,
                            size: 24,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _isCorrect ? '¡Correcto!' : 'Incorrecto',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: _isCorrect
                                  ? AppColors.wimiEmerald
                                  : AppColors.wimiRuby,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Text(
                        'Tu respuesta: ${_currentValue.toInt()}%',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),

                      if (widget.correct != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          'Respuesta correcta: ${widget.correct!.toInt()}%',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ],
                  ),
                )
                .animate()
                .fadeIn(duration: 600.ms)
                .slideY(begin: 0.3, end: 0, duration: 600.ms),
          ],
        ],
      ),
    );
  }

  void _confirmAnswer() {
    bool isCorrect = false;

    if (widget.correct != null) {
      final difference = (_currentValue - widget.correct!).abs();
      isCorrect = difference <= widget.tolerance;
    }

    setState(() {
      _isAnswered = true;
      _isCorrect = isCorrect;
    });

    widget.onAnswer(_isCorrect, _currentValue);
  }
}
