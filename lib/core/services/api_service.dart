import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../constants/api_constants.dart';
import '../models/api_response.dart';
import '../models/app_exception.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late Dio _dio;
  final Logger _logger = Logger();

  void initialize() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Interceptores
    _dio.interceptors.addAll([
      _LoggingInterceptor(),
      _AuthInterceptor(),
      _NetworkInterceptor(),
      _ErrorInterceptor(),
    ]);
  }

  // GET request
  Future<ApiResponse<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );
      return _handleResponse(response, fromJson);
    } catch (e) {
      return _handleError(e);
    }
  }

  // POST request
  Future<ApiResponse<T>> post<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return _handleResponse(response, fromJson);
    } catch (e) {
      return _handleError(e);
    }
  }

  // PUT request
  Future<ApiResponse<T>> put<T>(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
      );
      return _handleResponse(response, fromJson);
    } catch (e) {
      return _handleError(e);
    }
  }

  // DELETE request
  Future<ApiResponse<T>> delete<T>(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        queryParameters: queryParameters,
      );
      return _handleResponse(response, fromJson);
    } catch (e) {
      return _handleError(e);
    }
  }

  // Manejo de respuestas
  ApiResponse<T> _handleResponse<T>(
    Response response,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    if (response.statusCode! >= 200 && response.statusCode! < 300) {
      if (fromJson != null && response.data != null) {
        final data = fromJson(response.data as Map<String, dynamic>);
        return ApiResponse.success(data);
      }
      return ApiResponse.success(response.data as T);
    } else {
      return ApiResponse.error(
        AppException.serverError(
          'Server error: ${response.statusCode}',
          response.statusCode,
        ),
      );
    }
  }

  // Manejo de errores
  ApiResponse<T> _handleError<T>(dynamic error) {
    _logger.e('API Error: $error');

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return ApiResponse.error(
            AppException.networkError('Timeout de conexión'),
          );

        case DioExceptionType.badResponse:
          return ApiResponse.error(
            AppException.serverError(
              'Error del servidor: ${error.response?.statusCode}',
              error.response?.statusCode,
            ),
          );

        case DioExceptionType.cancel:
          return ApiResponse.error(
            AppException.requestCancelled('Petición cancelada'),
          );

        default:
          return ApiResponse.error(AppException.networkError('Error de red'));
      }
    }

    return ApiResponse.error(
      AppException.unknownError('Error desconocido: $error'),
    );
  }
}

// Interceptor de logging
class _LoggingInterceptor extends Interceptor {
  final Logger _logger = Logger();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.d('REQUEST: ${options.method} ${options.uri}');
    _logger.d('Headers: ${options.headers}');
    if (options.data != null) {
      _logger.d('Data: ${options.data}');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.d(
      'RESPONSE: ${response.statusCode} ${response.requestOptions.uri}',
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e('ERROR: ${err.message}');
    super.onError(err, handler);
  }
}

// Interceptor de autenticación
class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // TODO: Agregar token de autenticación si está disponible
    // final token = AuthService.getToken();
    // if (token != null) {
    //   options.headers['Authorization'] = 'Bearer $token';
    // }
    super.onRequest(options, handler);
  }
}

// Interceptor de conectividad
class _NetworkInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.connectionError,
          message: 'Sin conexión a internet',
        ),
      );
      return;
    }
    super.onRequest(options, handler);
  }
}

// Interceptor de manejo de errores
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Token expirado - redirigir a login
      // AuthService.logout();
      // NavigationService.pushAndRemoveUntil('/login');
    }
    super.onError(err, handler);
  }
}
