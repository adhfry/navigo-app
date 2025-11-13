import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import '../models/api_response_model.dart';
import '../models/user_model.dart';
import '../providers/api_client.dart';
import '../../config/api_config.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find();

  final ApiClient _apiClient = Get.find<ApiClient>();
  final _storage = GetStorage();

  // Observables
  final isLoggedIn = false.obs;
  final token = RxnString();
  final currentUser = Rxn<UserModel>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final savedToken = _storage.read('token');
    if (savedToken != null) {
      token.value = savedToken;
      isLoggedIn.value = true;
      await getCurrentUser();
    }
  }

  Future<void> saveToken(String newToken) async {
    token.value = newToken;
    await _storage.write('token', newToken);
    isLoggedIn.value = true;
  }

  Future<void> clearToken() async {
    token.value = null;
    await _storage.remove('token');
    isLoggedIn.value = false;
    currentUser.value = null;
  }

  // Login dengan email & password
  Future<ApiResponse<LoginResponse>> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      final response = await _apiClient.post(
        ApiConfig.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      final apiResponse = ApiResponse<LoginResponse>.fromJson(
        response.data,
        (json) => LoginResponse.fromJson(json),
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        await saveToken(apiResponse.data!.accessToken);
        await getCurrentUser();
      }

      return apiResponse;
    } on DioException catch (e) {
      if (e.response != null) {
        return ApiResponse<LoginResponse>(
          status: 'error',
          message: e.response?.data['message'] ?? 'Login gagal',
        );
      }
      return ApiResponse<LoginResponse>(
        status: 'error',
        message: 'Terjadi kesalahan koneksi',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Register
  Future<ApiResponse<RegisterResponse>> register({
    required String fullName,
    required String email,
    required String password,
    required String phoneNumber,
  }) async {
    try {
      isLoading.value = true;

      final response = await _apiClient.post(
        ApiConfig.register,
        data: {
          'fullName': fullName,
          'email': email,
          'password': password,
          'phoneNumber': phoneNumber,
        },
      );

      final apiResponse = ApiResponse<RegisterResponse>.fromJson(
        response.data,
        (json) => RegisterResponse.fromJson(json),
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        await saveToken(apiResponse.data!.accessToken);
        await getCurrentUser();
      }

      return apiResponse;
    } on DioException catch (e) {
      if (e.response != null) {
        return ApiResponse<RegisterResponse>(
          status: 'error',
          message: e.response?.data['message'] ?? 'Registrasi gagal',
        );
      }
      return ApiResponse<RegisterResponse>(
        status: 'error',
        message: 'Terjadi kesalahan koneksi',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Get current user
  Future<void> getCurrentUser() async {
    try {
      final response = await _apiClient.get(ApiConfig.me);

      final apiResponse = ApiResponse<UserModel>.fromJson(
        response.data,
        (json) => UserModel.fromJson(json),
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        currentUser.value = apiResponse.data;
      }
    } catch (e) {
      print('❌ Get current user failed: $e');
    }
  }

  // Logout
  Future<void> logout() async {
    await clearToken();
  }

  // Google Sign In (akan diimplementasikan setelah backend ready)
  Future<ApiResponse<String>> signInWithGoogle() async {
    try {
      isLoading.value = true;

      // TODO: Implement Google Sign In API endpoint di backend
      // Endpoint belum tersedia di backend
      return ApiResponse<String>(
        status: 'error',
        message: 'Login dengan Google belum tersedia. Endpoint API belum diimplementasikan di backend.',
      );
    } catch (e) {
      return ApiResponse<String>(
        status: 'error',
        message: 'Terjadi kesalahan saat login dengan Google: $e',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
