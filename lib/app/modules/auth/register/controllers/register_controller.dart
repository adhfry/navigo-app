import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
    GoogleSignInAccount? googleUser;
    
    try {
      print('🔍 Starting Google Sign-In (Register)...');
      
      final googleSignIn = GoogleSignIn.instance;
      
      // Initialize with Web Client ID for backend authentication
      await googleSignIn.initialize(
        serverClientId: '241902729566-e8ln8cggeivfmp4aogk3f1au4bhs7rlb.apps.googleusercontent.com',
      );
      
      print('🔍 Google Sign-In initialized');
      
      // Attempt lightweight authentication first
      final lightweightAuth = googleSignIn.attemptLightweightAuthentication();
      if (lightweightAuth != null) {
        print('🔍 Attempting lightweight authentication...');
        googleUser = await lightweightAuth;
      }
      
      // If lightweight fails or returns null, do full authentication
      if (googleUser == null) {
        print('🔍 Lightweight auth failed, starting full authentication...');
        googleUser = await googleSignIn.authenticate(
          scopeHint: ['email', 'profile'],
        );
      }
      
      print('🔍 Google User authenticated: ${googleUser.email}');
      
      // Show loading dialog
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      
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

      // Debug logging
      print('🔍 Google Sign-In Response:');
      print('   Status: ${response.status}');
      print('   Success: ${response.isSuccess}');
      print('   Data: ${response.data}');
      print('   Message: ${response.message}');

      if (response.isSuccess && response.data != null) {
        final needsPhone = response.data!['needsPhone'] as bool? ?? false;
        print('   Needs Phone: $needsPhone');
        
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
    } on PlatformException catch (e) {
      // Handle Google Sign-In specific errors
      if (Get.isDialogOpen ?? false) Get.back();
      
      // Only show error if it's not a user cancellation
      if (e.code != 'sign_in_canceled' && 
          e.code != 'popup_closed_by_user' &&
          e.code != 'network_error') {
        Get.snackbar(
          "Error",
          "Terjadi kesalahan saat mendaftar dengan Google",
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
          "Terjadi kesalahan saat mendaftar dengan Google",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    }
  }
}
