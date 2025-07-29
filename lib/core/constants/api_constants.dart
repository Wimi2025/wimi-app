class ApiConstants {
  static const String baseUrl = 'https://api.wimi-app.com/v1';

  // Endpoints
  static const String auth = '/auth';
  static const String users = '/users';
  static const String lessons = '/lessons';
  static const String achievements = '/achievements';
  static const String leaderboard = '/leaderboard';

  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
}
