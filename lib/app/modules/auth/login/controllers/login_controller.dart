import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../data/services/auth_service.dart';
import '../../../../routes/app_pages.dart';

class LoginController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  // Kunci untuk validasi form
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  // Controller untuk text field
  late TextEditingController emailController;
  late TextEditingController passwordController;

  // State untuk menampilkan/menyembunyikan password
  final RxBool isPasswordHidden = true.obs;

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  // Fungsi untuk toggle password
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // Fungsi untuk proses login
  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) {
      return;
    }

    try {
      final response = await _authService.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (response.isSuccess) {
        Get.snackbar(
          "Login Berhasil",
          "Selamat datang kembali!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        // Navigate to home
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.snackbar(
          "Login Gagal",
          response.message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Terjadi kesalahan: ${e.toString()}",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // Fungsi untuk login dengan Google
  Future<void> loginWithGoogle() async {
    try {
      // Step 1: Initialize and Sign in with Google  
      final googleSignIn = GoogleSignIn(
        serverClientId: '241902729566-e8ln8cggeivfmp4aogk3f1au4bhs7rlb.apps.googleusercontent.com',
      );
      
      // Sign in - this will show Google account picker
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      
      // If user cancelled the sign-in, return silently
      if (googleUser == null) {
        // User cancelled, do nothing
        return;
      }
      
      // Show loading after user selects account
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      
      // Step 2: Get authentication details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      if (googleAuth.idToken == null) {
        if (Get.isDialogOpen ?? false) Get.back();
        Get.snackbar(
          "Error",
          "Gagal mendapatkan token dari Google",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return;
      }
      
      // Step 3: Send idToken to backend
      final response = await _authService.signInWithGoogle(
        googleAuth.idToken!,
      );
      
      // Close loading
      if (Get.isDialogOpen ?? false) Get.back();

      if (response.isSuccess && response.data != null) {
        final needsPhone = response.data!['needsPhone'] as bool? ?? false;
        
        if (needsPhone) {
          // Navigate to complete profile
          Get.toNamed(
            Routes.COMPLETE_PROFILE,
            arguments: {
              'tempToken': response.data!['tempToken'],
              'email': response.data!['email'],
              'fullName': response.data!['fullName'],
              'profilePictureUrl': response.data!['profilePictureUrl'],
            },
          );
        } else {
          // Login success
          Get.snackbar(
            "Login Berhasil",
            "Selamat datang kembali!",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );

          Get.offAllNamed(Routes.HOME);
        }
      } else {
        Get.snackbar(
          "Login Gagal",
          response.message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      // Close loading if still open
      if (Get.isDialogOpen ?? false) Get.back();
      
      // Only show error if it's not a user cancellation
      if (!e.toString().contains('sign_in_canceled') && 
          !e.toString().contains('CANCELED') &&
          !e.toString().contains('cancelled')) {
        Get.snackbar(
          "Error",
          "Terjadi kesalahan saat login dengan Google",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    }
  }
}
