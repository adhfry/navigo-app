import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart' as google;
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
      final google.GoogleSignIn googleSignIn = google.GoogleSignIn(
        scopes: <String>['email', 'profile'],
      );
      
      final google.GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      
      // User cancelled the sign-in - silently return without error
      if (googleUser == null) {
        return;
      }
      
      // Show loading dialog
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      
      final google.GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
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
    } on google.PlatformException catch (e) {
      // Handle Google Sign-In specific errors
      if (Get.isDialogOpen ?? false) Get.back();
      
      // Only show error if it's not a user cancellation
      if (e.code != 'sign_in_canceled' && 
          e.code != 'popup_closed_by_user' &&
          e.code != 'network_error') {
        Get.snackbar(
          "Error",
          "Terjadi kesalahan saat login dengan Google",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      
      // Check if error is user cancellation - silently ignore
      final errorString = e.toString().toLowerCase();
      if (!errorString.contains('sign_in_canceled') && 
          !errorString.contains('canceled') &&
          !errorString.contains('cancelled') &&
          !errorString.contains('popup_closed')) {
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
