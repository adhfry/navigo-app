import 'dart:developer' as dev;
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import '../models/api_response_model.dart';
import '../models/jastip_model.dart';
import '../providers/api_client.dart';

class JastipService extends GetxService {
  final ApiClient _apiClient = Get.find<ApiClient>();

  final isLoading = false.obs;
  final myRequests = <JastipRequestModel>[].obs;
  final myOffers = <JastipOfferModel>[].obs;
  final availableRequests = <JastipRequestModel>[].obs;

  /// Create jastip request
  Future<ApiResponse<JastipRequestModel>> createRequest({
    required String requestType,
    required String originPortId,
    required String destinationPortId,
    required String itemName,
    String? itemDescription,
    String? itemPhotoUrl,
    required double rewardAmount,
    String? receiverName,
    String? receiverPhone,
    String? pickupContactName,
    String? pickupContactPhone,
    String? pickupAddressDetail,
    double? pickupLatitude,
    double? pickupLongitude,
    String? deliveryAddressDetail,
    double? deliveryLatitude,
    double? deliveryLongitude,
  }) async {
    try {
      isLoading.value = true;

      final data = <String, dynamic>{
        'requestType': requestType,
        'originPortId': originPortId,
        'destinationPortId': destinationPortId,
        'itemName': itemName,
        'rewardAmount': rewardAmount,
      };

      if (itemDescription != null) data['itemDescription'] = itemDescription;
      if (itemPhotoUrl != null) data['itemPhotoUrl'] = itemPhotoUrl;
      if (receiverName != null) data['receiverName'] = receiverName;
      if (receiverPhone != null) data['receiverPhone'] = receiverPhone;
      if (pickupContactName != null) {
        data['pickupContactName'] = pickupContactName;
      }
      if (pickupContactPhone != null) {
        data['pickupContactPhone'] = pickupContactPhone;
      }
      if (pickupAddressDetail != null) {
        data['pickupAddressDetail'] = pickupAddressDetail;
      }
      if (pickupLatitude != null) data['pickupLatitude'] = pickupLatitude;
      if (pickupLongitude != null) data['pickupLongitude'] = pickupLongitude;
      if (deliveryAddressDetail != null) {
        data['deliveryAddressDetail'] = deliveryAddressDetail;
      }
      if (deliveryLatitude != null) data['deliveryLatitude'] = deliveryLatitude;
      if (deliveryLongitude != null) {
        data['deliveryLongitude'] = deliveryLongitude;
      }

      final response = await _apiClient.post('/jastip/requests', data: data);

      final request = JastipRequestModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );

      return ApiResponse<JastipRequestModel>(
        status: 'success',
        message: 'Permintaan jastip berhasil dibuat',
        data: request,
      );
    } on DioException catch (e) {
      dev.log('Create jastip request failed', name: 'JastipService', error: e);
      return ApiResponse<JastipRequestModel>(
        status: 'error',
        message:
            e.response?.data?['message'] ?? 'Gagal membuat permintaan jastip',
      );
    } catch (e) {
      dev.log(
        'Unexpected error creating jastip request',
        name: 'JastipService',
        error: e,
      );
      return ApiResponse<JastipRequestModel>(
        status: 'error',
        message: 'Terjadi kesalahan yang tidak diketahui',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get all available jastip requests
  Future<ApiResponse<List<JastipRequestModel>>> getAvailableRequests() async {
    try {
      isLoading.value = true;

      final response = await _apiClient.get('/jastip/requests');

      final data = response.data['data'] as List;
      final requestList = data
          .map((json) =>
              JastipRequestModel.fromJson(json as Map<String, dynamic>))
          .toList();

      availableRequests.value = requestList;

      return ApiResponse<List<JastipRequestModel>>(
        status: 'success',
        message: 'Berhasil mendapatkan daftar permintaan jastip',
        data: requestList,
      );
    } on DioException catch (e) {
      dev.log('Get jastip requests failed', name: 'JastipService', error: e);
      return ApiResponse<List<JastipRequestModel>>(
        status: 'error',
        message: e.response?.data?['message'] ??
            'Gagal mendapatkan daftar permintaan',
      );
    } catch (e) {
      dev.log(
        'Unexpected error getting jastip requests',
        name: 'JastipService',
        error: e,
      );
      return ApiResponse<List<JastipRequestModel>>(
        status: 'error',
        message: 'Terjadi kesalahan yang tidak diketahui',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get my jastip requests
  Future<ApiResponse<List<JastipRequestModel>>> getMyRequests() async {
    try {
      isLoading.value = true;

      final response = await _apiClient.get('/jastip/requests/me');

      final data = response.data['data'] as List;
      final requestList = data
          .map((json) =>
              JastipRequestModel.fromJson(json as Map<String, dynamic>))
          .toList();

      myRequests.value = requestList;

      return ApiResponse<List<JastipRequestModel>>(
        status: 'success',
        message: 'Berhasil mendapatkan permintaan saya',
        data: requestList,
      );
    } on DioException catch (e) {
      dev.log('Get my requests failed', name: 'JastipService', error: e);
      return ApiResponse<List<JastipRequestModel>>(
        status: 'error',
        message:
            e.response?.data?['message'] ?? 'Gagal mendapatkan permintaan saya',
      );
    } catch (e) {
      dev.log(
        'Unexpected error getting my requests',
        name: 'JastipService',
        error: e,
      );
      return ApiResponse<List<JastipRequestModel>>(
        status: 'error',
        message: 'Terjadi kesalahan yang tidak diketahui',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get jastip request by ID
  Future<ApiResponse<JastipRequestModel>> getRequestById(
    String requestId,
  ) async {
    try {
      isLoading.value = true;

      final response = await _apiClient.get('/jastip/requests/$requestId');

      final request = JastipRequestModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );

      return ApiResponse<JastipRequestModel>(
        status: 'success',
        message: 'Berhasil mendapatkan detail permintaan',
        data: request,
      );
    } on DioException catch (e) {
      dev.log('Get request failed', name: 'JastipService', error: e);
      return ApiResponse<JastipRequestModel>(
        status: 'error',
        message: e.response?.data?['message'] ?? 'Gagal mendapatkan permintaan',
      );
    } catch (e) {
      dev.log(
        'Unexpected error getting request',
        name: 'JastipService',
        error: e,
      );
      return ApiResponse<JastipRequestModel>(
        status: 'error',
        message: 'Terjadi kesalahan yang tidak diketahui',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Create offer for jastip request
  Future<ApiResponse<JastipOfferModel>> createOffer(String requestId) async {
    try {
      isLoading.value = true;

      final response = await _apiClient.post(
        '/jastip/requests/$requestId/offers',
      );

      final offer = JastipOfferModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );

      return ApiResponse<JastipOfferModel>(
        status: 'success',
        message: 'Penawaran berhasil dibuat',
        data: offer,
      );
    } on DioException catch (e) {
      dev.log('Create offer failed', name: 'JastipService', error: e);
      return ApiResponse<JastipOfferModel>(
        status: 'error',
        message: e.response?.data?['message'] ?? 'Gagal membuat penawaran',
      );
    } catch (e) {
      dev.log(
        'Unexpected error creating offer',
        name: 'JastipService',
        error: e,
      );
      return ApiResponse<JastipOfferModel>(
        status: 'error',
        message: 'Terjadi kesalahan yang tidak diketahui',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Get my offers
  Future<ApiResponse<List<JastipOfferModel>>> getMyOffers() async {
    try {
      isLoading.value = true;

      final response = await _apiClient.get('/jastip/offers/me');

      final data = response.data['data'] as List;
      final offerList = data
          .map(
            (json) => JastipOfferModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();

      myOffers.value = offerList;

      return ApiResponse<List<JastipOfferModel>>(
        status: 'success',
        message: 'Berhasil mendapatkan penawaran saya',
        data: offerList,
      );
    } on DioException catch (e) {
      dev.log('Get my offers failed', name: 'JastipService', error: e);
      return ApiResponse<List<JastipOfferModel>>(
        status: 'error',
        message:
            e.response?.data?['message'] ?? 'Gagal mendapatkan penawaran saya',
      );
    } catch (e) {
      dev.log(
        'Unexpected error getting my offers',
        name: 'JastipService',
        error: e,
      );
      return ApiResponse<List<JastipOfferModel>>(
        status: 'error',
        message: 'Terjadi kesalahan yang tidak diketahui',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Accept offer
  Future<ApiResponse<JastipRequestModel>> acceptOffer(String offerId) async {
    try {
      isLoading.value = true;

      final response = await _apiClient.post('/jastip/offers/$offerId/accept');

      final request = JastipRequestModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );

      return ApiResponse<JastipRequestModel>(
        status: 'success',
        message: 'Penawaran berhasil diterima',
        data: request,
      );
    } on DioException catch (e) {
      dev.log('Accept offer failed', name: 'JastipService', error: e);
      return ApiResponse<JastipRequestModel>(
        status: 'error',
        message: e.response?.data?['message'] ?? 'Gagal menerima penawaran',
      );
    } catch (e) {
      dev.log(
        'Unexpected error accepting offer',
        name: 'JastipService',
        error: e,
      );
      return ApiResponse<JastipRequestModel>(
        status: 'error',
        message: 'Terjadi kesalahan yang tidak diketahui',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Update request status
  Future<ApiResponse<JastipRequestModel>> updateRequestStatus({
    required String requestId,
    required String status,
  }) async {
    try {
      isLoading.value = true;

      final response = await _apiClient.put(
        '/jastip/requests/$requestId/status',
        data: {'status': status},
      );

      final request = JastipRequestModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );

      return ApiResponse<JastipRequestModel>(
        status: 'success',
        message: 'Status berhasil diperbarui',
        data: request,
      );
    } on DioException catch (e) {
      dev.log('Update status failed', name: 'JastipService', error: e);
      return ApiResponse<JastipRequestModel>(
        status: 'error',
        message: e.response?.data?['message'] ?? 'Gagal memperbarui status',
      );
    } catch (e) {
      dev.log(
        'Unexpected error updating status',
        name: 'JastipService',
        error: e,
      );
      return ApiResponse<JastipRequestModel>(
        status: 'error',
        message: 'Terjadi kesalahan yang tidak diketahui',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Confirm delivery
  Future<ApiResponse<JastipRequestModel>> confirmDelivery(
    String requestId,
  ) async {
    try {
      isLoading.value = true;

      final response = await _apiClient.post(
        '/jastip/requests/$requestId/confirm-delivery',
      );

      final request = JastipRequestModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );

      return ApiResponse<JastipRequestModel>(
        status: 'success',
        message: 'Pengiriman berhasil dikonfirmasi',
        data: request,
      );
    } on DioException catch (e) {
      dev.log('Confirm delivery failed', name: 'JastipService', error: e);
      return ApiResponse<JastipRequestModel>(
        status: 'error',
        message:
            e.response?.data?['message'] ?? 'Gagal mengonfirmasi pengiriman',
      );
    } catch (e) {
      dev.log(
        'Unexpected error confirming delivery',
        name: 'JastipService',
        error: e,
      );
      return ApiResponse<JastipRequestModel>(
        status: 'error',
        message: 'Terjadi kesalahan yang tidak diketahui',
      );
    } finally {
      isLoading.value = false;
    }
  }
}
