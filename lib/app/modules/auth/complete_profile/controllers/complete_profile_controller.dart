import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/services/auth_service.dart';
import '../../../../routes/app_pages.dart';

class CompleteProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late TextEditingController phoneController;
  final isLoading = false.obs;
  String? email;
  String? fullName;
  String? profilePictureUrl;

  @override
  void onInit() {
    super.onInit();
    phoneController = TextEditingController();
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null) {
      email = args['email'] as String?;
      fullName = args['fullName'] as String?;
      profilePictureUrl = args['profilePictureUrl'] as String?;
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }

  Future<void> completeProfile() async {
    if (!formKey.currentState!.validate()) return;
    if (email == null || fullName == null) {
      Get.snackbar(
        'Error',
        'Data tidak lengkap',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    try {
      isLoading.value = true;
      
      print('🔍 Completing Profile:');
      print('   Email: $email');
      print('   Full Name: $fullName');
      print('   Phone: ${phoneController.text.trim()}');
      print('   Profile Picture: $profilePictureUrl');
      
      final response = await _authService.completeGoogleProfile(
        phoneNumber: phoneController.text.trim(),
        email: email!,
        fullName: fullName!,
        profilePictureUrl: profilePictureUrl,
      );
      
      print('🔍 Complete Profile Response:');
      print('   Status: ${response.status}');
      print('   Success: ${response.isSuccess}');
      print('   Data: ${response.data}');
      
      if (response.isSuccess) {
        Get.snackbar(
          'Berhasil',
          'Selamat datang di NaviGo!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        
        // Navigate to home
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.snackbar(
          'Gagal',
          response.message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('❌ Error completing profile: $e');
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
