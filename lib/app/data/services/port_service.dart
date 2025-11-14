import 'dart:developer' as dev;
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../models/api_response_model.dart';
import '../models/port_model.dart';
import '../providers/api_client.dart';

class PortService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  final isLoading = false.obs;
  final ports = <PortModel>[].obs;

  /// Get all ports
  Future<ApiResponse<List<PortModel>>> getAllPorts() async {
    try {
      isLoading.value = true;

      final response = await _apiClient.get('/ports');

      final data = response.data['data'] as List;
      final portList = data
          .map((json) => PortModel.fromJson(json as Map<String, dynamic>))
          .toList();

      ports.value = portList;

      return ApiResponse<List<PortModel>>(
        status: 'success',
        message: 'Berhasil mendapatkan daftar pelabuhan',
        data: portList,
      );
    } on DioException catch (e) {
      dev.log('Get ports failed', name: 'PortService', error: e);
      return ApiResponse<List<PortModel>>(
        status: 'error',
        message:
            e.response?.data?['message'] ?? 'Gagal mendapatkan daftar pelabuhan',
      );
    } catch (e) {
      dev.log('Unexpected error getting ports', name: 'PortService', error: e);
      return ApiResponse<List<PortModel>>(
        status: 'error',
        message: 'Terjadi kesalahan yang tidak diketahui',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get port by ID
  Future<ApiResponse<PortModel>> getPortById(String portId) async {
    try {
      isLoading.value = true;

      final response = await _apiClient.get('/ports/$portId');

      final port = PortModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );

      return ApiResponse<PortModel>(
        status: 'success',
        message: 'Berhasil mendapatkan detail pelabuhan',
        data: port,
      );
    } on DioException catch (e) {
      dev.log('Get port failed', name: 'PortService', error: e);
      return ApiResponse<PortModel>(
        status: 'error',
        message: e.response?.data?['message'] ?? 'Gagal mendapatkan pelabuhan',
      );
    } catch (e) {
      dev.log('Unexpected error getting port', name: 'PortService', error: e);
      return ApiResponse<PortModel>(
        status: 'error',
        message: 'Terjadi kesalahan yang tidak diketahui',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
