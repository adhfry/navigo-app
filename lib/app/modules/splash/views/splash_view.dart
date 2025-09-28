import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:navi_go/app/config/theme.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor, // Background biru sesuai tema
      body: Center(
        child: Obx(
          () => AnimatedOpacity(
            opacity: controller.opacity.value,
            duration: const Duration(seconds: 2),
            child: Image.asset(
              'assets/images/NaviGo-logo-2x1.png', // Pastikan path ini benar
              width: Get.width * 0.6, // Lebar logo 60% dari lebar layar
            ),
          ),
        ),
      ),
    );
  }
}
