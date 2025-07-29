import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

/// Servicio centralizado para todas las llamadas API
/// Preparado para integración con ChatGPT API, Canva AI y otros servicios
class ApiService {
  static const String _baseUrl = 'https://api.wimi.com'; // Futuro endpoint
  static const Duration _timeout = Duration(seconds: 30);

  // Headers por defecto
  static Map<String, String> get _defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'User-Agent': 'WimiApp/1.0.0',
  };

  // ========== MÉTODOS HTTP BÁSICOS ==========

  static Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParams);
      final response = await http
          .get(uri, headers: {..._defaultHeaders, ...?headers})
          .timeout(_timeout);

      return _handleResponse<T>(response);
    } catch (e) {
      return ApiResponse.error('Error de conexión: $e');
    }
  }

  static Future<ApiResponse<T>> post<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = _buildUri(endpoint);
      final response = await http
          .post(
            uri,
            headers: {..._defaultHeaders, ...?headers},
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_timeout);

      return _handleResponse<T>(response);
    } catch (e) {
      return ApiResponse.error('Error de conexión: $e');
    }
  }

  static Future<ApiResponse<T>> put<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, dynamic>? body,
  }) async {
    try {
      final uri = _buildUri(endpoint);
      final response = await http
          .put(
            uri,
            headers: {..._defaultHeaders, ...?headers},
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(_timeout);

      return _handleResponse<T>(response);
    } catch (e) {
      return ApiResponse.error('Error de conexión: $e');
    }
  }

  static Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    try {
      final uri = _buildUri(endpoint);
      final response = await http
          .delete(uri, headers: {..._defaultHeaders, ...?headers})
          .timeout(_timeout);

      return _handleResponse<T>(response);
    } catch (e) {
      return ApiResponse.error('Error de conexión: $e');
    }
  }

  // ========== INTEGRACIÓN CHATGPT API ==========

  /// Generar contenido educativo usando ChatGPT
  static Future<ApiResponse<String>> generateEducationalContent({
    required String topic,
    required String difficulty,
    required String contentType, // 'lesson', 'quiz', 'exercise'
  }) async {
    if (kDebugMode) {
      // En desarrollo, retornar contenido mock
      return ApiResponse.success(
        _getMockEducationalContent(topic, contentType),
      );
    }

    // TODO: Implementar llamada real a ChatGPT API
    const openAiEndpoint = 'https://api.openai.com/v1/chat/completions';

    final prompt = _buildEducationalPrompt(topic, difficulty, contentType);

    return post<String>(
      openAiEndpoint,
      headers: {
        'Authorization':
            'Bearer \$OPENAI_API_KEY', // Desde variables de entorno
      },
      body: {
        'model': 'gpt-4',
        'messages': [
          {
            'role': 'system',
            'content': 'Eres un experto en educación financiera para jóvenes',
          },
          {'role': 'user', 'content': prompt},
        ],
        'max_tokens': 1000,
        'temperature': 0.7,
      },
    );
  }

  /// Evaluar respuestas de usuario usando ChatGPT
  static Future<ApiResponse<Map<String, dynamic>>> evaluateUserResponse({
    required String question,
    required String userAnswer,
    required String correctAnswer,
  }) async {
    if (kDebugMode) {
      return ApiResponse.success({
        'score': 85,
        'feedback': 'Buena respuesta, pero podrías mejorar...',
        'suggestions': ['Considera...', 'Recuerda que...'],
      });
    }

    // TODO: Implementar evaluación con ChatGPT
    return post<Map<String, dynamic>>(
      'https://api.openai.com/v1/chat/completions',
      body: {
        'model': 'gpt-4',
        'messages': [
          {
            'role': 'system',
            'content':
                'Evalúa respuestas de educación financiera y da feedback constructivo',
          },
          {
            'role': 'user',
            'content':
                'Pregunta: $question\nRespuesta del usuario: $userAnswer\nRespuesta correcta: $correctAnswer',
          },
        ],
      },
    );
  }

  // ========== INTEGRACIÓN CANVA AI ==========

  /// Generar imágenes educativas usando Canva AI
  static Future<ApiResponse<String>> generateEducationalImage({
    required String topic,
    required String style, // 'infographic', 'diagram', 'illustration'
  }) async {
    if (kDebugMode) {
      return ApiResponse.success('https://example.com/mock-image.png');
    }

    // TODO: Implementar integración con Canva API
    return post<String>(
      'https://api.canva.com/v1/designs',
      headers: {'Authorization': 'Bearer \$CANVA_API_KEY'},
      body: {
        'design_type': style,
        'title': 'Imagen educativa: $topic',
        'content': {
          'elements': [
            {'type': 'text', 'content': topic},
          ],
        },
      },
    );
  }

  // ========== UTILIDADES PRIVADAS ==========

  static Uri _buildUri(String endpoint, [Map<String, dynamic>? queryParams]) {
    var uri = Uri.parse('$_baseUrl$endpoint');
    if (queryParams != null && queryParams.isNotEmpty) {
      uri = uri.replace(
        queryParameters: queryParams.map(
          (key, value) => MapEntry(key, value.toString()),
        ),
      );
    }
    return uri;
  }

  static ApiResponse<T> _handleResponse<T>(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final data = jsonDecode(response.body);
        return ApiResponse.success(data);
      } catch (e) {
        return ApiResponse.success(response.body as T);
      }
    } else {
      return ApiResponse.error(
        'Error ${response.statusCode}: ${response.reasonPhrase}',
        statusCode: response.statusCode,
      );
    }
  }

  static String _buildEducationalPrompt(
    String topic,
    String difficulty,
    String contentType,
  ) {
    return '''
    Crea contenido educativo sobre "$topic" para educación financiera gamificada.
    
    Parámetros:
    - Dificultad: $difficulty
    - Tipo de contenido: $contentType
    - Audiencia: Jóvenes y adultos jóvenes
    - Estilo: Gamificado, divertido y fácil de entender
    
    El contenido debe ser:
    - Práctico y aplicable
    - Con ejemplos reales
    - Motivador y positivo
    - Preparado para una app móvil
    ''';
  }

  static String _getMockEducationalContent(String topic, String contentType) {
    switch (contentType) {
      case 'lesson':
        return '''
        # Lección: $topic
        
        ## Introducción
        Hoy aprenderemos sobre $topic de manera divertida y práctica.
        
        ## Conceptos Clave
        - Concepto 1: Definición y importancia
        - Concepto 2: Aplicación práctica
        - Concepto 3: Errores comunes
        
        ## Ejercicio Práctico
        Calcula tu presupuesto mensual usando la regla 50/30/20.
        
        ## Resumen
        El $topic es fundamental para tu salud financiera.
        ''';
      case 'quiz':
        return '''
        {
          "questions": [
            {
              "question": "¿Qué porcentaje de ingresos se recomienda ahorrar?",
              "options": ["10%", "20%", "30%", "50%"],
              "correct": 1,
              "explanation": "Se recomienda ahorrar al menos el 20% de tus ingresos."
            }
          ]
        }
        ''';
      default:
        return 'Contenido educativo sobre $topic';
    }
  }
}

/// Clase para manejar respuestas de API de manera consistente
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? error;
  final int? statusCode;

  const ApiResponse._({
    required this.success,
    this.data,
    this.error,
    this.statusCode,
  });

  factory ApiResponse.success(T data) {
    return ApiResponse._(success: true, data: data);
  }

  factory ApiResponse.error(String error, {int? statusCode}) {
    return ApiResponse._(success: false, error: error, statusCode: statusCode);
  }

  bool get isSuccess => success;
  bool get isError => !success;
}
