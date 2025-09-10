import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../core/constants/app_colors.dart';

class GapWidget extends StatefulWidget {
  final String sentence;
  final String missing;
  final Function(bool isCorrect, String userAnswer) onAnswer;

  const GapWidget({
    super.key,
    required this.sentence,
    required this.missing,
    required this.onAnswer,
  });

  @override
  State<GapWidget> createState() => _GapWidgetState();
}

class _GapWidgetState extends State<GapWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _isAnswered = false;
  bool _isCorrect = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
          // Instrucciones
          Text(
                'Completa la oración con la palabra correcta:',
                style: const TextStyle(fontSize: 16, color: Colors.white70),
              )
              .animate()
              .fadeIn(duration: 600.ms)
              .slideY(begin: 0.3, end: 0, duration: 600.ms),

          const SizedBox(height: 16),

          // Oración con hueco
          _buildSentenceWithGap(),

          const SizedBox(height: 20),

          // Campo de entrada
          TextField(
                controller: _controller,
                enabled: !_isAnswered,
                style: const TextStyle(fontSize: 16, color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Escribe tu respuesta aquí...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.wimiGold.withOpacity(0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.wimiGold.withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: AppColors.wimiGold,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
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
                onPressed: _controller.text.trim().isNotEmpty
                    ? _confirmAnswer
                    : null,
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
                        'Tu respuesta: "${_controller.text.trim()}"',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Respuesta correcta: "${widget.missing}"',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
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

  Widget _buildSentenceWithGap() {
    final parts = widget.sentence.split('__');

    return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.wimiGold.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: parts[0],
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
                TextSpan(
                  text: '_____',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.wimiGold,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.wimiGold,
                    decorationThickness: 2,
                  ),
                ),
                if (parts.length > 1)
                  TextSpan(
                    text: parts[1],
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      height: 1.4,
                    ),
                  ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 600.ms, delay: 100.ms)
        .slideY(begin: 0.3, end: 0, duration: 600.ms, delay: 100.ms);
  }

  void _confirmAnswer() {
    final userAnswer = _controller.text.trim().toLowerCase();
    final correctAnswer = widget.missing.toLowerCase();

    setState(() {
      _isAnswered = true;
      _isCorrect = userAnswer == correctAnswer;
    });

    widget.onAnswer(_isCorrect, userAnswer);
  }
}
