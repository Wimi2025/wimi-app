import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/theme/app_theme.dart';
import '../core/navigation/app_router.dart';
import '../core/providers/theme_provider.dart';

class WimiApp extends ConsumerWidget {
  const WimiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Wimi - Educación Financiera Gamificada',
      debugShowCheckedModeBanner: false,

      // Temas
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,

      // Navegación
      routerConfig: router,

      // Localización
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('es', 'ES'), // Español
        Locale('en', 'US'), // Inglés
      ],
      locale: const Locale('es', 'ES'),

      // Builder para manejar errores de navegación
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling, // Prevenir escalado excesivo
          ),
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}
