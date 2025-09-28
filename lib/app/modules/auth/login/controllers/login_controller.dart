import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  // Kunci untuk validasi form
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  // Controller untuk text field
  late TextEditingController emailController;
  late TextEditingController passwordController;

  // State untuk menampilkan/menyembunyikan password
  final RxBool isPasswordHidden = true.obs;
  // State untuk loading saat tombol ditekan
  final RxBool isLoading = false.obs;

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
  void login() async {
    // 1. Validasi form
    if (loginFormKey.currentState!.validate()) {
      // Tampilkan loading
      isLoading.value = true;

      // 2. Simulasi pemanggilan API
      await Future.delayed(const Duration(seconds: 2));
      String email = emailController.text;
      String password = passwordController.text;
      print('Attempting login with Email: $email, Password: $password');

      // Sembunyikan loading
      isLoading.value = false;

      // 3. Tampilkan notifikasi (nanti akan diganti navigasi)
      Get.snackbar(
        "Login Berhasil",
        "Selamat datang kembali!",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      // TODO: Navigasi ke halaman utama berdasarkan role
    }
  }
}
