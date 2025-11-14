class ApiConfig {
  // Base URL API (backend already has /api prefix in main.ts)
  static const String baseUrl = 'https://api.navigo.agribunker.id';
  
  // Timeout
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Endpoints (with /api prefix as per backend main.ts)
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';
  static const String me = '/api/auth/me';
  
  // Headers
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
