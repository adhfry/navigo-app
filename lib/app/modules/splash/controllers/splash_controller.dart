import 'package:get/get.dart';
import 'package:navi_go/app/data/services/auth_service.dart';
import 'package:navi_go/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController {
  final RxDouble opacity = 0.0.obs;
  final AuthService authService = Get.find();

  @override
  void onReady() {
    super.onReady();
    // onReady adalah tempat yang tepat untuk memulai logika
    // setelah widget pertama kali ditampilkan.
    _checkFirstTimeOpen();
  }

  Future<void> _checkFirstTimeOpen() async {
    // 1. Tampilkan logo dengan animasi
    await Future.delayed(const Duration(milliseconds: 500));
    opacity.value = 1.0;

    // 2. Beri waktu agar animasi terlihat
    await Future.delayed(const Duration(seconds: 3));

    // 3. Cek data di penyimpanan perangkat
    try {
      final prefs = await SharedPreferences.getInstance();

      // Jika key 'isFirstTime' belum ada, nilainya akan null,
      // dan kita anggap sebagai true (pertama kali buka).
      final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

      if (isFirstTime) {
        // Jika ini pertama kali, arahkan ke halaman perkenalan
        Get.offAllNamed(Routes.GET_STARTED);
      } else {
        // Cek status login dari AuthService
        if (authService.isLoggedIn.value) {
          Get.offNamed(Routes.HOME);
        } else {
          Get.offNamed(Routes.LOGIN);
        }
      }
    } catch (e) {
      // Jika terjadi error saat mengakses SharedPreferences,
      // arahkan ke halaman login sebagai fallback aman.
      print("Error reading SharedPreferences: $e");
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
