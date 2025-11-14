import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart' as google; // TODO: Uncomment when fixing Google Sign-In
import '../../../../data/services/auth_service.dart';
import '../../../../routes/app_pages.dart';

class RegisterController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();

  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController passwordController;
  late TextEditingController confirmPasswordController;

  final RxBool isPasswordHidden = true.obs;
  final RxBool isConfirmPasswordHidden = true.obs;
  final RxBool termsChecked = false.obs;
  final RxString selectedGender = ''.obs; // 'L' untuk Laki-laki, 'P' untuk Perempuan

  @override
  void onInit() {
    super.onInit();
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() =>
      isPasswordHidden.value = !isPasswordHidden.value;
  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;

  Future<void> register() async {
    if (!registerFormKey.currentState!.validate()) {
      return;
    }

    if (!termsChecked.value) {
      Get.snackbar(
        "Kesalahan",
        "Anda harus menyetujui Syarat & Ketentuan.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    try {
      final response = await _authService.register(
        fullName: fullNameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        phoneNumber: phoneController.text.trim(),
        gender: selectedGender.value.isEmpty ? null : selectedGender.value,
      );

      if (response.isSuccess) {
        Get.snackbar(
          "Pendaftaran Berhasil",
          "Akun Anda telah dibuat, selamat datang!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        // Navigate to home after successful registration
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.snackbar(
          "Pendaftaran Gagal",
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

  // Register/Login dengan Google
  Future<void> registerWithGoogle() async {
    // TODO: Implement Google Sign-In after fixing package issues
    Get.snackbar(
      "Coming Soon",
      "Daftar dengan Google akan segera tersedia",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
    
    /* Uncomment after fixing google_sign_in package issues
    try {
      final google.GoogleSignIn googleSignIn = google.GoogleSignIn(
        scopes: <String>['email', 'profile'],
      );
      
      final google.GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      
      if (googleUser == null) {
        return;
      }
      
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      
      final google.GoogleSignInAuthentication googleAuth = googleUser.authentication;
      
      if (googleAuth.idToken == null) {
        if (Get.isDialogOpen ?? false) Get.back();
        Get.snackbar(
          "Error",
          "Gagal mendapatkan token dari Google",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      
      final response = await _authService.signInWithGoogle(
        googleAuth.idToken!,
      );
      
      if (Get.isDialogOpen ?? false) Get.back();

      if (response.isSuccess && response.data != null) {
        final needsPhone = response.data!['needsPhone'] as bool? ?? false;
        
        if (needsPhone) {
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
          Get.snackbar(
            "Berhasil",
            "Selamat datang!",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );

          Get.offAllNamed(Routes.HOME);
        }
      } else {
        Get.snackbar(
          "Gagal",
          response.message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      
      if (!e.toString().contains('sign_in_canceled') && 
          !e.toString().contains('CANCELED') &&
          !e.toString().contains('cancelled')) {
        Get.snackbar(
          "Error",
          "Terjadi kesalahan saat mendaftar dengan Google",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    }
    */
  }
}
