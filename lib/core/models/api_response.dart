import 'app_exception.dart';

class ApiResponse<T> {
  final T? data;
  final AppException? error;
  final bool isSuccess;

  const ApiResponse._({this.data, this.error, required this.isSuccess});

  factory ApiResponse.success(T data) {
    return ApiResponse._(data: data, isSuccess: true);
  }

  factory ApiResponse.error(AppException error) {
    return ApiResponse._(error: error, isSuccess: false);
  }

  bool get isError => !isSuccess;
}
