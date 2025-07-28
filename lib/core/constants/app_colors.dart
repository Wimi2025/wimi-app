import 'package:flutter/material.dart';

class AppColors {
  // Colores principales - Nueva paleta morada basada en tu diseño
  static const Color primary = Color(0xFF8B5CF6); // Morado principal
  static const Color primaryDark = Color(0xFF7C3AED); // Morado oscuro
  static const Color primaryLight = Color(0xFFA855F7); // Morado claro

  // Colores secundarios
  static const Color secondary = Color(0xFFEC4899); // Rosa/fucsia
  static const Color secondaryDark = Color(0xFFDB2777); // Rosa oscuro
  static const Color secondaryLight = Color(0xFFF472B6); // Rosa claro

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

  // Colores específicos de Wimi
  static const Color wimiPurple = Color(0xFF8B5CF6); // Morado Wimi
  static const Color wimiPink = Color(0xFFEC4899); // Rosa Wimi
  static const Color wimiGreen = Color(0xFF10B981); // Verde Wimi
  static const Color wimiOrange = Color(0xFFF97316); // Naranja Wimi
  static const Color wimiBlue = Color(0xFF3B82F6); // Azul Wimi

  // Gradientes - Nuevos con paleta morada
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEC4899), Color(0xFFDB2777)],
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
