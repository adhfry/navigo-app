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
      Get.snackbar('Error', 'Data tidak lengkap');
      return;
    }
    try {
      isLoading.value = true;
      final response = await _authService.completeGoogleProfile(
        phoneNumber: phoneController.text.trim(),
      );
      if (response.isSuccess) {
        Get.snackbar('Berhasil', 'Profil berhasil dilengkapi!',
          backgroundColor: Colors.green, colorText: Colors.white);
        Get.offAllNamed(Routes.dashboard);
      }
    } finally {
      isLoading.value = false;
    }
  }
}
