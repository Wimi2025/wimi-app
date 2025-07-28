import 'package:flutter/material.dart';

import 'app/app.dart';

void main() async {
  // Inicializar la aplicación
  await AppInitializer.initialize();
  
  runApp(const WimiApp());
}
