import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';

class VFWidget extends StatefulWidget {
  final String statement;
  final bool correctAnswer;
  final String rationale;
  final Function(bool isCorrect, bool selectedAnswer) onAnswer;

  const VFWidget({
    super.key,
    required this.statement,
    required this.correctAnswer,
    required this.rationale,
    required this.onAnswer,
  });

  @override
  State<VFWidget> createState() => _VFWidgetState();
}

class _VFWidgetState extends State<VFWidget> {
  bool? _selectedAnswer;
  bool _isAnswered = false;
  bool _isCorrect = false;

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
          // Enunciado
          Text(
                widget.statement,
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

          // Opciones Verdadero/Falso
          Row(
            children: [
              Expanded(child: _buildOption(true, 'Verdadero')),
              const SizedBox(width: 16),
              Expanded(child: _buildOption(false, 'Falso')),
            ],
          ),

          const SizedBox(height: 20),

          // Botón de confirmar
          if (!_isAnswered) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedAnswer != null ? _confirmAnswer : null,
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

          // Resultado y explicación
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

                      if (widget.rationale.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        Text(
                          widget.rationale,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            height: 1.4,
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

  Widget _buildOption(bool value, String label) {
    final isSelected = _selectedAnswer == value;
    final isCorrect = value == widget.correctAnswer;
    final showResult = _isAnswered;

    Color backgroundColor;
    Color borderColor;
    Color textColor = Colors.white;

    if (showResult) {
      if (isCorrect) {
        backgroundColor = AppColors.wimiEmerald.withOpacity(0.2);
        borderColor = AppColors.wimiEmerald;
      } else if (isSelected && !isCorrect) {
        backgroundColor = AppColors.wimiRuby.withOpacity(0.2);
        borderColor = AppColors.wimiRuby;
      } else {
        backgroundColor = Colors.white.withOpacity(0.1);
        borderColor = Colors.white.withOpacity(0.3);
      }
    } else {
      backgroundColor = isSelected
          ? AppColors.wimiGold.withOpacity(0.2)
          : Colors.white.withOpacity(0.1);
      borderColor = isSelected
          ? AppColors.wimiGold
          : Colors.white.withOpacity(0.3);
    }

    return Container(
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: showResult ? null : () => _selectOption(value),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor, width: 1),
                ),
                child: Column(
                  children: [
                    // Icono
                    Icon(
                      value
                          ? Icons.check_circle_outline
                          : Icons.cancel_outlined,
                      color: borderColor,
                      size: 40,
                    ),

                    const SizedBox(height: 12),

                    // Texto
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms, delay: (value ? 0 : 100).ms)
        .scale(
          begin: const Offset(0.8, 0.8),
          end: const Offset(1.0, 1.0),
          duration: 400.ms,
          delay: (value ? 0 : 100).ms,
        );
  }

  void _selectOption(bool value) {
    setState(() {
      _selectedAnswer = value;
    });
  }

  void _confirmAnswer() {
    if (_selectedAnswer == null) return;

    setState(() {
      _isAnswered = true;
      _isCorrect = _selectedAnswer == widget.correctAnswer;
    });

    widget.onAnswer(_isCorrect, _selectedAnswer!);
  }
}
