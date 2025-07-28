import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'core/constants/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase inicializado correctamente!');

    await FirebaseFirestore.instance.enableNetwork();
    print('✅ Firestore conectado!');

    print('✅ Firebase Auth disponible!');

    runApp(const FirebaseTestApp());
  } catch (e) {
    print('❌ Error al inicializar Firebase: $e');
    runApp(const FirebaseErrorApp());
  }
}

class FirebaseTestApp extends StatelessWidget {
  const FirebaseTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Test - Wimi',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
        ),
      ),
      home: const FirebaseTestScreen(),
    );
  }
}

class FirebaseTestScreen extends StatefulWidget {
  const FirebaseTestScreen({super.key});

  @override
  State<FirebaseTestScreen> createState() => _FirebaseTestScreenState();
}

class _FirebaseTestScreenState extends State<FirebaseTestScreen> {
  String _status = 'Probando conexión...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _testFirebaseConnection();
  }

  Future<void> _testFirebaseConnection() async {
    try {
      setState(() {
        _status = 'Probando Firebase Auth...';
      });

      final auth = FirebaseAuth.instance;
      print('✅ Firebase Auth: ${auth.app.name}');

      setState(() {
        _status = 'Probando Firestore...';
      });

      final firestore = FirebaseFirestore.instance;
      await firestore.collection('test').doc('connection').set({
        'timestamp': FieldValue.serverTimestamp(),
        'message': 'Firebase conectado correctamente desde Flutter Web',
        'version': '1.0.0',
        'platform': 'web',
        'status': 'success',
      });

      final doc = await firestore.collection('test').doc('connection').get();
      if (doc.exists) {
        print('✅ Documento creado y leído correctamente: ${doc.data()}');
      }

      setState(() {
        _status = '🎉 ¡Firebase funciona perfectamente!';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _status = '❌ Error: $e';
        _isLoading = false;
      });
      print('❌ Error en test Firebase: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isLoading
                          ? Icons.cloud_sync
                          : _status.contains('❌')
                          ? Icons.cloud_off
                          : Icons.cloud_done,
                      size: 80,
                      color: _isLoading
                          ? AppColors.primary
                          : _status.contains('❌')
                          ? AppColors.error
                          : AppColors.success,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Prueba de Conexión Firebase',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                    ),
                    const SizedBox(height: 16),
                    if (_isLoading) const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    Text(
                      _status,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _testFirebaseConnection,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                      child: const Text('Probar Nuevamente'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FirebaseErrorApp extends StatelessWidget {
  const FirebaseErrorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Error - Wimi',
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.red, Colors.redAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: const Center(
            child: Card(
              margin: EdgeInsets.all(32),
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error, size: 80, color: Colors.red),
                    SizedBox(height: 16),
                    Text(
                      'Error al Inicializar Firebase',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Revisa la configuración en firebase_options.dart',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
