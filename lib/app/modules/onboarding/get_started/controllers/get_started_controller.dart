import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navi_go/app/routes/app_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingInfo {
  final String assetPath;
  final String title;
  final String description;

  OnboardingInfo(this.assetPath, this.title, this.description);
}

class GetStartedController extends GetxController {
  late final PageController pageController;

  // Rx untuk state reaktif
  final RxInt currentPage = 0.obs;
  final RxBool isLastPage = false.obs;

  @override
  void onInit() {
    super.onInit();
    pageController = PageController();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  // Daftar data untuk setiap halaman
  final List<OnboardingInfo> onboardingPages = [
    OnboardingInfo(
      'assets/svg/jastip-icon.svg',
      'Titip Barang Antarpulau?',
      'Kirim dan terima barang dengan mudah lewat pelancong yang searah. Aman, cepat, dan terpercaya.',
    ),
    OnboardingInfo(
      'assets/svg/ticket-icon.svg',
      'Cari Tiket Tanpa Ribet?',
      'Dapatkan jadwal kapal ter-update dan pesan tiket langsung dari aplikasi. Perjalanan jadi lebih pasti.',
    ),
    OnboardingInfo(
      'assets/svg/safety-icon.svg',
      'Pelayaran Lebih Aman',
      'Cek info cuaca maritim dan kondisi gelombang sebelum berangkat. Keselamatanmu prioritas kami.',
    ),
  ];

  // Dipanggil saat halaman berubah
  void onPageChanged(int index) {
    currentPage.value = index;
    isLastPage.value = index == onboardingPages.length - 1;
  }

  // Aksi untuk tombol "Selanjutnya" / "Ayo Mulai"
  void nextPage() {
    if (isLastPage.value) {
      // Jika halaman terakhir, jalankan fungsi getStarted
      getStarted();
    } else {
      // Jika bukan, pindah ke halaman berikutnya
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    }
  }

  // Aksi untuk tombol "Lewati"
  void skip() {
    getStarted();
  }

  // Fungsi final untuk menyelesaikan onboarding
  Future<void> getStarted() async {
    final prefs = await SharedPreferences.getInstance();
    // Set flag 'isFirstTime' menjadi false
    await prefs.setBool('isFirstTime', false);
    // Arahkan ke halaman login dan hapus riwayat navigasi sebelumnya
    Get.offAllNamed(Routes.LOGIN);
  }
}
