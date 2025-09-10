import 'package:flutter/material.dart';

class AppColors {
  // Colores principales - Temática de búsqueda de tesoro
  static const Color primary = Color(0xFFFFD700); // Oro principal
  static const Color primaryDark = Color(0xFFB8860B); // Oro oscuro
  static const Color primaryLight = Color(0xFFFFF8DC); // Oro claro

  // Colores secundarios - Aventura y tesoro
  static const Color secondary = Color(0xFF8B4513); // Marrón tesoro
  static const Color secondaryDark = Color(0xFF654321); // Marrón oscuro
  static const Color secondaryLight = Color(0xFFD2691E); // Marrón claro

  // Colores de éxito y error - Actualizados para mejor contraste
  static const Color success = Color(0xFF10B981); // Verde moderno
  static const Color error = Color(0xFFEF4444); // Rojo moderno
  static const Color warning = Color(0xFFF59E0B); // Amarillo/naranja moderno
  static const Color info = Color(0xFF3B82F6); // Azul moderno

  // Colores de fondo - Más suaves
  static const Color background = Color(0xFFFAFAFA); // Gris muy claro
  static const Color surface = Color(0xFFFFFFFF); // Blanco
  static const Color card = Color(0xFFFFFFFF); // Blanco
  static const Color surfaceVariant = Color(0xFFF3F4F6); // Gris claro

  // Colores de texto - Mejorados
  static const Color textPrimary = Color(0xFF1F2937); // Gris oscuro
  static const Color textSecondary = Color(0xFF6B7280); // Gris medio
  static const Color textLight = Color(0xFF9CA3AF); // Gris claro
  static const Color textOnPrimary = Color(0xFFFFFFFF); // Blanco sobre morado

  // Colores de gamificación - Actualizados
  static const Color gold = Color(0xFFFBBF24); // Oro moderno
  static const Color silver = Color(0xFF94A3B8); // Plata moderna
  static const Color bronze = Color(0xFFF97316); // Bronce moderno
  static const Color xp = Color(0xFF06B6D4); // Cyan para XP

  // Colores específicos de Wimi - Temática de tesoro
  static const Color wimiGold = Color(0xFFFFD700); // Oro Wimi
  static const Color wimiBronze = Color(0xFFCD7F32); // Bronce Wimi
  static const Color wimiSilver = Color(0xFFC0C0C0); // Plata Wimi
  static const Color wimiEmerald = Color(0xFF50C878); // Esmeralda Wimi
  static const Color wimiRuby = Color(0xFFE0115F); // Rubí Wimi
  static const Color wimiSapphire = Color(0xFF0F52BA); // Zafiro Wimi

  // Gradientes - Temática de tesoro
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFD700), Color(0xFFB8860B)],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8B4513), Color(0xFF654321)],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF10B981), Color(0xFF059669)],
  );

  static const LinearGradient warningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
  );

  // Gradiente de fondo suave
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFAFAFA), Color(0xFFF3F4F6)],
  );

  // Sombras personalizadas
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0xFF8B5CF6).withOpacity(0.1),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: Color(0xFF8B5CF6).withOpacity(0.25),
      blurRadius: 15,
      offset: const Offset(0, 5),
    ),
  ];
}
