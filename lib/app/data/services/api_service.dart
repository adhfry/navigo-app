import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService extends GetConnect {
  @override
  void onInit() {
    httpClient.baseUrl = 'https://api.navigo.agribunker.id/api';

    // Interceptor untuk menambahkan token ke setiap request
    httpClient.addRequestModifier<dynamic>((request) async {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });

    // Interceptor untuk menangani error (misal: token expired)
    httpClient.addResponseModifier((request, response) async {
      if (response.statusCode == 401) {
        // Handle unauthorized, mungkin clear token dan redirect ke login
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        Get.offAllNamed('/login');
        Get.snackbar(
          'Sesi Berakhir',
          'Sesi Anda telah berakhir. Silakan masuk kembali.',
        );
      }
      return response;
    });
  }

  Future<Response> login(String email, String password) =>
      post('/auth/login', {'email': email, 'password': password});

  Future<Response> register(Map<String, dynamic> data) =>
      post('/auth/register', data);

  Future<Response> checkAuth() => get('/auth/me');
}
