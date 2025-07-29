enum ExceptionType { networkError, serverError, requestCancelled, unknownError }

class AppException implements Exception {
  final String message;
  final ExceptionType type;
  final int? statusCode;

  const AppException({
    required this.message,
    required this.type,
    this.statusCode,
  });

  factory AppException.networkError(String message) {
    return AppException(message: message, type: ExceptionType.networkError);
  }

  factory AppException.serverError(String message, int? statusCode) {
    return AppException(
      message: message,
      type: ExceptionType.serverError,
      statusCode: statusCode,
    );
  }

  factory AppException.requestCancelled(String message) {
    return AppException(message: message, type: ExceptionType.requestCancelled);
  }

  factory AppException.unknownError(String message) {
    return AppException(message: message, type: ExceptionType.unknownError);
  }

  @override
  String toString() {
    return 'AppException: $message (Type: $type, Status: $statusCode)';
  }
}
