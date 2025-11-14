import 'dart:developer' as dev;
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../models/api_response_model.dart';
import '../models/payment_model.dart';
import '../providers/api_client.dart';

class PaymentService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  final isLoading = false.obs;

  /// Initiate payment for booking
  Future<ApiResponse<MidtransSnapResponse>> initiateBookingPayment(
    String bookingId,
  ) async {
    try {
      isLoading.value = true;

      final response = await _apiClient.post(
        '/payments/bookings/$bookingId/initiate',
      );

      final snapResponse = MidtransSnapResponse.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );

      return ApiResponse<MidtransSnapResponse>(
        status: 'success',
        message: 'Pembayaran siap diproses',
        data: snapResponse,
      );
    } on DioException catch (e) {
      dev.log('Initiate payment failed', name: 'PaymentService', error: e);
      return ApiResponse<MidtransSnapResponse>(
        status: 'error',
        message: e.response?.data?['message'] ?? 'Gagal memulai pembayaran',
      );
    } catch (e) {
      dev.log(
        'Unexpected error initiating payment',
        name: 'PaymentService',
        error: e,
      );
      return ApiResponse<MidtransSnapResponse>(
        status: 'error',
        message: 'Terjadi kesalahan yang tidak diketahui',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Check payment status for booking
  Future<ApiResponse<PaymentModel>> checkBookingPaymentStatus(
    String bookingId,
  ) async {
    try {
      isLoading.value = true;

      final response = await _apiClient.get('/payments/bookings/$bookingId');

      final payment = PaymentModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );

      return ApiResponse<PaymentModel>(
        status: 'success',
        message: 'Status pembayaran berhasil didapatkan',
        data: payment,
      );
    } on DioException catch (e) {
      dev.log('Check payment status failed', name: 'PaymentService', error: e);
      return ApiResponse<PaymentModel>(
        status: 'error',
        message:
            e.response?.data?['message'] ?? 'Gagal memeriksa status pembayaran',
      );
    } catch (e) {
      dev.log(
        'Unexpected error checking payment status',
        name: 'PaymentService',
        error: e,
      );
      return ApiResponse<PaymentModel>(
        status: 'error',
        message: 'Terjadi kesalahan yang tidak diketahui',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
