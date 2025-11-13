import 'package:flutter/material.dart';
import 'package:get/get.dart';
// REVISI: Menambahkan import untuk semua halaman/view
import 'package:navi_go/app/modules/main/dashboard/views/home_view.dart';
import 'package:navi_go/app/modules/main/dashboard/views/activity_view.dart';
import 'package:navi_go/app/modules/main/dashboard/views/message_view.dart';
import 'package:navi_go/app/modules/main/dashboard/views/account_view.dart';

class DashboardController extends GetxController {
  // REVISI: Menambahkan state untuk BottomNavigationBar
  final RxInt currentIndex = 0.obs;
  late PageController pageController;

  // State untuk Carousel di HomeView
  final RxInt currentCarouselPage = 0.obs;

  // REVISI: Mengisi daftar halaman (pages) yang hilang
  final List<Widget> pages = [
    const HomeView(),
    const ActivityView(),
    const MessageView(),
    const AccountView(),
  ];

  @override
  void onInit() {
    super.onInit();
    // REVISI: Menginisialisasi PageController
    pageController = PageController(initialPage: currentIndex.value);
  }

  @override
  void onClose() {
    // REVISI: Menutup PageController
    pageController.dispose();
    super.onClose();
  }

  // REVISI: Menambahkan fungsi navigasi yang hilang
  void changePage(int index) {
    currentIndex.value = index;
    // Gunakan jumpToPage agar instan, atau animateToPage untuk efek
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
  }
  // --- Akhir Revisi ---

  // Fungsi untuk update index carousel
  void onCarouselPageChanged(int index) {
    currentCarouselPage.value = index;
  }
}
