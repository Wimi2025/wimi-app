import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';

class MCQWidget extends StatefulWidget {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String rationale;
  final Function(bool isCorrect, int selectedIndex) onAnswer;

  const MCQWidget({
    super.key,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.rationale,
    required this.onAnswer,
  });

  @override
  State<MCQWidget> createState() => _MCQWidgetState();
}

class _MCQWidgetState extends State<MCQWidget> {
  int? _selectedIndex;
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
          // Pregunta
          Text(
                widget.question,
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

          // Opciones
          ...widget.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            return _buildOption(index, option);
          }).toList(),

          const SizedBox(height: 20),

          // Botón de confirmar
          if (!_isAnswered) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedIndex != null ? _confirmAnswer : null,
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

  Widget _buildOption(int index, String option) {
    final isSelected = _selectedIndex == index;
    final isCorrect = index == widget.correctAnswerIndex;
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
          margin: const EdgeInsets.only(bottom: 12),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: showResult ? null : () => _selectOption(index),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: borderColor, width: 1),
                ),
                child: Row(
                  children: [
                    // Letra de la opción
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: borderColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          String.fromCharCode(65 + index), // A, B, C, D
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: borderColor,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Texto de la opción
                    Expanded(
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor,
                          height: 1.3,
                        ),
                      ),
                    ),

                    // Icono de resultado
                    if (showResult) ...[
                      Icon(
                        isCorrect
                            ? Icons.check_circle
                            : (isSelected ? Icons.cancel : null),
                        color: isCorrect
                            ? AppColors.wimiEmerald
                            : (isSelected ? AppColors.wimiRuby : null),
                        size: 20,
                      ),
                    ] else if (isSelected) ...[
                      Icon(
                        Icons.radio_button_checked,
                        color: AppColors.wimiGold,
                        size: 20,
                      ),
                    ] else ...[
                      Icon(
                        Icons.radio_button_unchecked,
                        color: Colors.white.withOpacity(0.5),
                        size: 20,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 400.ms, delay: (index * 100).ms)
        .slideX(begin: 0.3, end: 0, duration: 400.ms, delay: (index * 100).ms);
  }

  void _selectOption(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _confirmAnswer() {
    if (_selectedIndex == null) return;

    setState(() {
      _isAnswered = true;
      _isCorrect = _selectedIndex == widget.correctAnswerIndex;
    });

    widget.onAnswer(_isCorrect, _selectedIndex!);
  }
}
