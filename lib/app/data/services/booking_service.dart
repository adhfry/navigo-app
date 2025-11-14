import 'dart:developer' as dev;
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../models/api_response_model.dart';
import '../models/booking_model.dart';
import '../providers/api_client.dart';

class BookingService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  final isLoading = false.obs;
  final myBookings = <BookingModel>[].obs;

  /// Create new booking
  Future<ApiResponse<BookingModel>> createBooking({
    required String scheduleId,
  }) async {
    try {
      isLoading.value = true;

      final response = await _apiClient.post(
        '/bookings',
        data: {
          'scheduleId': scheduleId,
        },
      );

      final booking = BookingModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );

      return ApiResponse<BookingModel>(
        status: 'success',
        message: 'Booking berhasil dibuat',
        data: booking,
      );
    } on DioException catch (e) {
      dev.log('Create booking failed', name: 'BookingService', error: e);
      return ApiResponse<BookingModel>(
        status: 'error',
        message: e.response?.data?['message'] ?? 'Gagal membuat booking',
      );
    } catch (e) {
      dev.log(
        'Unexpected error creating booking',
        name: 'BookingService',
        error: e,
      );
      return ApiResponse<BookingModel>(
        status: 'error',
        message: 'Terjadi kesalahan yang tidak diketahui',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get my bookings
  Future<ApiResponse<List<BookingModel>>> getMyBookings() async {
    try {
      isLoading.value = true;

      final response = await _apiClient.get('/bookings/me');

      final data = response.data['data'] as List;
      final bookingList = data
          .map((json) => BookingModel.fromJson(json as Map<String, dynamic>))
          .toList();

      myBookings.value = bookingList;

      return ApiResponse<List<BookingModel>>(
        status: 'success',
        message: 'Berhasil mendapatkan riwayat booking',
        data: bookingList,
      );
    } on DioException catch (e) {
      dev.log('Get my bookings failed', name: 'BookingService', error: e);
      return ApiResponse<List<BookingModel>>(
        status: 'error',
        message:
            e.response?.data?['message'] ?? 'Gagal mendapatkan riwayat booking',
      );
    } catch (e) {
      dev.log(
        'Unexpected error getting bookings',
        name: 'BookingService',
        error: e,
      );
      return ApiResponse<List<BookingModel>>(
        status: 'error',
        message: 'Terjadi kesalahan yang tidak diketahui',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get booking by ID
  Future<ApiResponse<BookingModel>> getBookingById(String bookingId) async {
    try {
      isLoading.value = true;

      final response = await _apiClient.get('/bookings/$bookingId');

      final booking = BookingModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );

      return ApiResponse<BookingModel>(
        status: 'success',
        message: 'Berhasil mendapatkan detail booking',
        data: booking,
      );
    } on DioException catch (e) {
      dev.log('Get booking failed', name: 'BookingService', error: e);
      return ApiResponse<BookingModel>(
        status: 'error',
        message: e.response?.data?['message'] ?? 'Gagal mendapatkan booking',
      );
    } catch (e) {
      dev.log(
        'Unexpected error getting booking',
        name: 'BookingService',
        error: e,
      );
      return ApiResponse<BookingModel>(
        status: 'error',
        message: 'Terjadi kesalahan yang tidak diketahui',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Cancel booking
  Future<ApiResponse<BookingModel>> cancelBooking(String bookingId) async {
    try {
      isLoading.value = true;

      final response = await _apiClient.put('/bookings/$bookingId/cancel');

      final booking = BookingModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );

      // Update local list
      final index = myBookings.indexWhere((b) => b.id == bookingId);
      if (index != -1) {
        myBookings[index] = booking;
      }

      return ApiResponse<BookingModel>(
        status: 'success',
        message: 'Booking berhasil dibatalkan',
        data: booking,
      );
    } on DioException catch (e) {
      dev.log('Cancel booking failed', name: 'BookingService', error: e);
      return ApiResponse<BookingModel>(
        status: 'error',
        message: e.response?.data?['message'] ?? 'Gagal membatalkan booking',
      );
    } catch (e) {
      dev.log(
        'Unexpected error cancelling booking',
        name: 'BookingService',
        error: e,
      );
      return ApiResponse<BookingModel>(
        status: 'error',
        message: 'Terjadi kesalahan yang tidak diketahui',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
