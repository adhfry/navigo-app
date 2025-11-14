import 'dart:developer' as dev;
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
    try {
      final savedToken = _storage.read<String?>('token');
      if (savedToken != null && savedToken.isNotEmpty) {
        token.value = savedToken;
        isLoggedIn.value = true;
        await getCurrentUser();
      }
    } catch (e) {
      dev.log('Failed to load token', name: 'AuthService', error: e);
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
        response.data as Map<String, dynamic>,
        (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        await saveToken(apiResponse.data!.accessToken);
        await getCurrentUser();
      }

      return apiResponse;
    } on DioException catch (e) {
      dev.log('Login failed', name: 'AuthService', error: e);
      if (e.response?.data != null) {
        final errorData = e.response!.data;
        return ApiResponse<LoginResponse>(
          status: 'error',
          message: errorData is Map<String, dynamic>
              ? (errorData['message'] as String? ?? 'Login gagal')
              : 'Login gagal',
        );
      }
      return ApiResponse<LoginResponse>(
        status: 'error',
        message: e.type == DioExceptionType.connectionTimeout ||
                e.type == DioExceptionType.receiveTimeout
            ? 'Koneksi timeout, periksa jaringan Anda'
            : 'Terjadi kesalahan koneksi',
      );
    } catch (e) {
      dev.log('Unexpected error during login', name: 'AuthService', error: e);
      return ApiResponse<LoginResponse>(
        status: 'error',
        message: 'Terjadi kesalahan yang tidak diketahui',
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
    String? gender,
  }) async {
    try {
      isLoading.value = true;

      final Map<String, dynamic> data = {
        'fullName': fullName,
        'email': email,
        'password': password,
        'phoneNumber': phoneNumber,
      };
      
      if (gender != null && gender.isNotEmpty) {
        data['gender'] = gender;
      }

      final response = await _apiClient.post(
        ApiConfig.register,
        data: data,
      );

      final apiResponse = ApiResponse<RegisterResponse>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => RegisterResponse.fromJson(json as Map<String, dynamic>),
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        await saveToken(apiResponse.data!.accessToken);
        await getCurrentUser();
      }

      return apiResponse;
    } on DioException catch (e) {
      dev.log('Register failed', name: 'AuthService', error: e);
      if (e.response?.data != null) {
        final errorData = e.response!.data;
        return ApiResponse<RegisterResponse>(
          status: 'error',
          message: errorData is Map<String, dynamic>
              ? (errorData['message'] as String? ?? 'Registrasi gagal')
              : 'Registrasi gagal',
        );
      }
      return ApiResponse<RegisterResponse>(
        status: 'error',
        message: e.type == DioExceptionType.connectionTimeout ||
                e.type == DioExceptionType.receiveTimeout
            ? 'Koneksi timeout, periksa jaringan Anda'
            : 'Terjadi kesalahan koneksi',
      );
    } catch (e) {
      dev.log(
        'Unexpected error during registration',
        name: 'AuthService',
        error: e,
      );
      return ApiResponse<RegisterResponse>(
        status: 'error',
        message: 'Terjadi kesalahan yang tidak diketahui',
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
        response.data as Map<String, dynamic>,
        (json) => UserModel.fromJson(json as Map<String, dynamic>),
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        currentUser.value = apiResponse.data;
      }
    } catch (e) {
      dev.log('Failed to get current user', name: 'AuthService', error: e);
    }
  }

  // Logout
  Future<void> logout() async {
    await clearToken();
  }

  // Forgot Password
  Future<ApiResponse<String>> forgotPassword({
    required String email,
  }) async {
    try {
      isLoading.value = true;

      final response = await _apiClient.post(
        '/auth/forgot-password',
        data: {'email': email},
      );

      return ApiResponse<String>(
        status: 'success',
        message: response.data['message'] as String? ??
            'Link reset password telah dikirim ke email Anda',
      );
    } on DioException catch (e) {
      dev.log('Forgot password failed', name: 'AuthService', error: e);
      if (e.response?.data != null) {
        final errorData = e.response!.data;
        return ApiResponse<String>(
          status: 'error',
          message: errorData is Map<String, dynamic>
              ? (errorData['message'] as String? ??
                  'Gagal mengirim email reset password')
              : 'Gagal mengirim email reset password',
        );
      }
      return ApiResponse<String>(
        status: 'error',
        message: e.type == DioExceptionType.connectionTimeout ||
                e.type == DioExceptionType.receiveTimeout
            ? 'Koneksi timeout, periksa jaringan Anda'
            : 'Terjadi kesalahan koneksi',
      );
    } catch (e) {
      dev.log(
        'Unexpected error sending forgot password',
        name: 'AuthService',
        error: e,
      );
      return ApiResponse<String>(
        status: 'error',
        message: 'Terjadi kesalahan yang tidak diketahui',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Google Sign In
  Future<ApiResponse<Map<String, dynamic>>> signInWithGoogle(
      String idToken) async {
    try {
      isLoading.value = true;

      final response = await _apiClient.post(
        '/auth/google',
        data: {'idToken': idToken},
      );

      dev.log('Google Sign-In Raw Response: ${response.data}', name: 'AuthService');

      final responseData = response.data as Map<String, dynamic>;
      final data = responseData['data'] as Map<String, dynamic>?;

      dev.log('Parsed data: $data', name: 'AuthService');

      if (data == null) {
        return ApiResponse<Map<String, dynamic>>(
          status: 'error',
          message: 'Invalid response from server',
        );
      }

      // Check if needs phone
      final needsPhone = data['needsPhone'] as bool? ?? false;

      dev.log('needsPhone: $needsPhone, access_token exists: ${data['access_token'] != null}', 
        name: 'AuthService');

      if (!needsPhone && data['access_token'] != null) {
        // User exists, save token
        dev.log('Saving token and getting user...', name: 'AuthService');
        await saveToken(data['access_token'] as String);
        await getCurrentUser();
      }

      return ApiResponse<Map<String, dynamic>>(
        status: 'success',
        message: responseData['message'] as String? ?? 'Success',
        data: data,
      );
    } on DioException catch (e) {
      dev.log('Google sign in failed', name: 'AuthService', error: e);
      if (e.response?.data != null) {
        final errorData = e.response!.data;
        return ApiResponse<Map<String, dynamic>>(
          status: 'error',
          message: errorData is Map<String, dynamic>
              ? (errorData['message'] as String? ??
                  'Login dengan Google gagal')
              : 'Login dengan Google gagal',
        );
      }
      return ApiResponse<Map<String, dynamic>>(
        status: 'error',
        message: e.type == DioExceptionType.connectionTimeout ||
                e.type == DioExceptionType.receiveTimeout
            ? 'Koneksi timeout, periksa jaringan Anda'
            : 'Terjadi kesalahan koneksi',
      );
    } catch (e) {
      dev.log(
        'Unexpected error during Google sign in',
        name: 'AuthService',
        error: e,
      );
      return ApiResponse<Map<String, dynamic>>(
        status: 'error',
        message: 'Terjadi kesalahan yang tidak diketahui',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Complete Google Profile (add phone number)
  Future<ApiResponse<UserModel>> completeGoogleProfile({
    required String phoneNumber,
  }) async {
    try {
      isLoading.value = true;

      final response = await _apiClient.post(
        '/auth/google/complete-profile',
        data: {'phoneNumber': phoneNumber},
      );

      final apiResponse = ApiResponse<UserModel>.fromJson(
        response.data as Map<String, dynamic>,
        (json) => UserModel.fromJson(json as Map<String, dynamic>),
      );

      if (apiResponse.isSuccess && apiResponse.data != null) {
        currentUser.value = apiResponse.data;
      }

      return apiResponse;
    } on DioException catch (e) {
      dev.log('Complete profile failed', name: 'AuthService', error: e);
      if (e.response?.data != null) {
        final errorData = e.response!.data;
        return ApiResponse<UserModel>(
          status: 'error',
          message: errorData is Map<String, dynamic>
              ? (errorData['message'] as String? ??
                  'Gagal melengkapi profil')
              : 'Gagal melengkapi profil',
        );
      }
      return ApiResponse<UserModel>(
        status: 'error',
        message: e.type == DioExceptionType.connectionTimeout ||
                e.type == DioExceptionType.receiveTimeout
            ? 'Koneksi timeout, periksa jaringan Anda'
            : 'Terjadi kesalahan koneksi',
      );
    } catch (e) {
      dev.log(
        'Unexpected error completing profile',
        name: 'AuthService',
        error: e,
      );
      return ApiResponse<UserModel>(
        status: 'error',
        message: 'Terjadi kesalahan yang tidak diketahui',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
