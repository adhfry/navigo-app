import 'dart:developer' as dev;
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../models/api_response_model.dart';
import '../models/schedule_model.dart';
import '../providers/api_client.dart';

class ScheduleService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  final isLoading = false.obs;
  final schedules = <ScheduleModel>[].obs;

  /// Search schedules dengan filter
  Future<ApiResponse<List<ScheduleModel>>> searchSchedules({
    required String originPortId,
    required String destinationPortId,
    DateTime? date,
    int? minSeats,
  }) async {
    try {
      isLoading.value = true;

      final queryParams = <String, dynamic>{
        'from': originPortId,
        'to': destinationPortId,
      };

      if (date != null) {
        queryParams['date'] = date.toIso8601String();
      }
      if (minSeats != null) {
        queryParams['minSeats'] = minSeats;
      }

      final response = await _apiClient.get(
        '/schedules/search',
        queryParameters: queryParams,
      );

      final data = response.data['data'] as List;
      final scheduleList = data
          .map((json) => ScheduleModel.fromJson(json as Map<String, dynamic>))
          .toList();

      schedules.value = scheduleList;

      return ApiResponse<List<ScheduleModel>>(
        status: 'success',
        message: 'Berhasil mendapatkan jadwal',
        data: scheduleList,
      );
    } on DioException catch (e) {
      dev.log('Search schedules failed', name: 'ScheduleService', error: e);
      return ApiResponse<List<ScheduleModel>>(
        status: 'error',
        message: e.response?.data?['message'] ?? 'Gagal mencari jadwal',
      );
    } catch (e) {
      dev.log(
        'Unexpected error searching schedules',
        name: 'ScheduleService',
        error: e,
      );
      return ApiResponse<List<ScheduleModel>>(
        status: 'error',
        message: 'Terjadi kesalahan yang tidak diketahui',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get schedule by ID
  Future<ApiResponse<ScheduleModel>> getScheduleById(String scheduleId) async {
    try {
      isLoading.value = true;

      final response = await _apiClient.get('/schedules/$scheduleId');

      final schedule = ScheduleModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );

      return ApiResponse<ScheduleModel>(
        status: 'success',
        message: 'Berhasil mendapatkan detail jadwal',
        data: schedule,
      );
    } on DioException catch (e) {
      dev.log('Get schedule failed', name: 'ScheduleService', error: e);
      return ApiResponse<ScheduleModel>(
        status: 'error',
        message: e.response?.data?['message'] ?? 'Gagal mendapatkan jadwal',
      );
    } catch (e) {
      dev.log(
        'Unexpected error getting schedule',
        name: 'ScheduleService',
        error: e,
      );
      return ApiResponse<ScheduleModel>(
        status: 'error',
        message: 'Terjadi kesalahan yang tidak diketahui',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
