import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../data/services/auth_service.dart';

class ForgotPasswordController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final GlobalKey<FormState> forgotPasswordFormKey = GlobalKey<FormState>();
  late TextEditingController emailController;

  final isLoading = false.obs;
  final emailSent = false.obs;

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  /// Send password reset email
  Future<void> sendResetEmail() async {
    if (!forgotPasswordFormKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;

      // Call forgot password API
      final response = await _authService.forgotPassword(
        email: emailController.text.trim(),
      );

      if (response.isSuccess) {
        emailSent.value = true;
        Get.snackbar(
          'Email Terkirim',
          'Link reset password telah dikirim ke email Anda. Silakan cek inbox atau spam folder.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 5),
        );
      } else {
        Get.snackbar(
          'Gagal',
          response.message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: $e',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Reset form
  void resetForm() {
    emailController.clear();
    emailSent.value = false;
    forgotPasswordFormKey.currentState?.reset();
  }
}
