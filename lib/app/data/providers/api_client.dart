import 'dart:developer' as dev;
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:get_storage/get_storage.dart';
import '../../config/api_config.dart';

class ApiClient extends GetxService {
  late final Dio _dio;
  final _storage = GetStorage();

  Dio get dio => _dio;

  @override
  void onInit() {
    super.onInit();
    _initDio();
  }

  void _initDio() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        headers: ApiConfig.headers,
      ),
    );

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add token if exists
          final token = _storage.read<String?>('token');
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          dev.log(
            '🌐 ${options.method} ${options.uri}',
            name: 'API Request',
          );
          if (options.data != null) {
            dev.log('📤 ${options.data}', name: 'Request Data');
          }

          return handler.next(options);
        },
        onResponse: (response, handler) {
          dev.log(
            '✅ ${response.statusCode} ${response.requestOptions.path}',
            name: 'API Response',
          );
          return handler.next(response);
        },
        onError: (error, handler) {
          dev.log(
            '❌ ${error.message} - ${error.requestOptions.path}',
            name: 'API Error',
            error: error,
          );
          if (error.response?.data != null) {
            dev.log(
              '📥 ${error.response?.data}',
              name: 'Error Data',
            );
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get(path, queryParameters: queryParameters);
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.delete(path, queryParameters: queryParameters);
    } catch (e) {
      rethrow;
    }
  }
}
