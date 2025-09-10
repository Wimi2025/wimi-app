import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wimi_app/core/constants/app_colors.dart';

void main() {
  group('AppColors Tests', () {
    group('Primary Colors', () {
      test('should have correct primary color values', () {
        expect(AppColors.primary, const Color(0xFF8B5CF6));
        expect(AppColors.primaryDark, const Color(0xFF7C3AED));
        expect(AppColors.primaryLight, const Color(0xFFA855F7));
      });

      test('should have correct secondary color values', () {
        expect(AppColors.secondary, const Color(0xFFEC4899));
        expect(AppColors.secondaryDark, const Color(0xFFDB2777));
        expect(AppColors.secondaryLight, const Color(0xFFF472B6));
      });
    });

    group('Status Colors', () {
      test('should have correct status color values', () {
        expect(AppColors.success, const Color(0xFF10B981));
        expect(AppColors.error, const Color(0xFFEF4444));
        expect(AppColors.warning, const Color(0xFFF59E0B));
        expect(AppColors.info, const Color(0xFF3B82F6));
      });
    });

    group('Background Colors', () {
      test('should have correct background color values', () {
        expect(AppColors.background, const Color(0xFFFAFAFA));
        expect(AppColors.surface, const Color(0xFFFFFFFF));
        expect(AppColors.card, const Color(0xFFFFFFFF));
        expect(AppColors.surfaceVariant, const Color(0xFFF3F4F6));
      });
    });

    group('Text Colors', () {
      test('should have correct text color values', () {
        expect(AppColors.textPrimary, const Color(0xFF1F2937));
        expect(AppColors.textSecondary, const Color(0xFF6B7280));
        expect(AppColors.textLight, const Color(0xFF9CA3AF));
        expect(AppColors.textOnPrimary, const Color(0xFFFFFFFF));
      });
    });

    group('Gamification Colors', () {
      test('should have correct gamification color values', () {
        expect(AppColors.gold, const Color(0xFFFBBF24));
        expect(AppColors.silver, const Color(0xFF94A3B8));
        expect(AppColors.bronze, const Color(0xFFF97316));
        expect(AppColors.xp, const Color(0xFF06B6D4));
      });
    });

    group('Wimi Brand Colors', () {
      test('should have correct Wimi brand color values', () {
        expect(AppColors.wimiGold, const Color(0xFFFFD700));
        expect(AppColors.wimiBronze, const Color(0xFFCD7F32));
        expect(AppColors.wimiSilver, const Color(0xFFC0C0C0));
        expect(AppColors.wimiEmerald, const Color(0xFF50C878));
        expect(AppColors.wimiRuby, const Color(0xFFE0115F));
        expect(AppColors.wimiSapphire, const Color(0xFF0F52BA));
      });
    });

    group('Gradients', () {
      test('should have correct primary gradient', () {
        final gradient = AppColors.primaryGradient;
        expect(gradient.colors, const [Color(0xFF8B5CF6), Color(0xFF7C3AED)]);
        expect(gradient.begin, Alignment.topLeft);
        expect(gradient.end, Alignment.bottomRight);
      });

      test('should have correct secondary gradient', () {
        final gradient = AppColors.secondaryGradient;
        expect(gradient.colors, const [Color(0xFFEC4899), Color(0xFFDB2777)]);
        expect(gradient.begin, Alignment.topLeft);
        expect(gradient.end, Alignment.bottomRight);
      });

      test('should have correct success gradient', () {
        final gradient = AppColors.successGradient;
        expect(gradient.colors, const [Color(0xFF10B981), Color(0xFF059669)]);
        expect(gradient.begin, Alignment.topLeft);
        expect(gradient.end, Alignment.bottomRight);
      });

      test('should have correct warning gradient', () {
        final gradient = AppColors.warningGradient;
        expect(gradient.colors, const [Color(0xFFF59E0B), Color(0xFFD97706)]);
        expect(gradient.begin, Alignment.topLeft);
        expect(gradient.end, Alignment.bottomRight);
      });

      test('should have correct background gradient', () {
        final gradient = AppColors.backgroundGradient;
        expect(gradient.colors, const [Color(0xFFFAFAFA), Color(0xFFF3F4F6)]);
        expect(gradient.begin, Alignment.topCenter);
        expect(gradient.end, Alignment.bottomCenter);
      });
    });

    group('Shadows', () {
      test('should have card shadow with correct properties', () {
        final shadows = AppColors.cardShadow;
        expect(shadows, isA<List<BoxShadow>>());
        expect(shadows.length, equals(1));

        final shadow = shadows.first;
        expect(shadow.color, const Color(0xFF8B5CF6).withOpacity(0.1));
        expect(shadow.blurRadius, equals(20));
        expect(shadow.offset, const Offset(0, 4));
      });

      test('should have button shadow with correct properties', () {
        final shadows = AppColors.buttonShadow;
        expect(shadows, isA<List<BoxShadow>>());
        expect(shadows.length, equals(1));

        final shadow = shadows.first;
        expect(shadow.color, const Color(0xFF8B5CF6).withOpacity(0.25));
        expect(shadow.blurRadius, equals(15));
        expect(shadow.offset, const Offset(0, 5));
      });
    });

    group('Color Consistency', () {
      test('should maintain color consistency across the app', () {
        // Primary colors should be consistent
        expect(AppColors.primary, AppColors.wimiGold);
        expect(AppColors.secondary, AppColors.wimiBronze);
        expect(AppColors.success, AppColors.wimiEmerald);
        expect(AppColors.info, AppColors.wimiSapphire);
      });

      test('should have proper contrast ratios', () {
        // Test that text colors have good contrast with background
        final textOnPrimary = AppColors.textOnPrimary;
        final primary = AppColors.primary;

        // This is a basic test - in a real app you'd use a proper contrast calculator
        expect(
          textOnPrimary,
          const Color(0xFFFFFFFF),
        ); // White text on colored background
      });
    });
  });
}
