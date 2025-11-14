import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
// REVISI: Menambahkan import untuk semua halaman/view
import 'package:navi_go/app/modules/main/dashboard/views/home_view.dart';
import 'package:navi_go/app/modules/main/dashboard/views/activity_view.dart';
import 'package:navi_go/app/modules/main/dashboard/views/message_view.dart';
import 'package:navi_go/app/modules/main/profile/views/profile_view.dart';

class DashboardController extends GetxController {
  // REVISI: Menambahkan state untuk BottomNavigationBar
  final RxInt currentIndex = 0.obs;
  late PageController pageController;

  // State untuk Carousel di HomeView
  final RxInt currentCarouselPage = 0.obs;
  
  // User name for header
  final RxString userName = 'Guest'.obs;

  // REVISI: Mengisi daftar halaman (pages) yang hilang
  final List<Widget> pages = [
    const HomeView(),
    const ActivityView(),
    const MessageView(),
    const ProfileView(),
  ];

  @override
  void onInit() {
    super.onInit();
    // REVISI: Menginisialisasi PageController
    pageController = PageController(initialPage: currentIndex.value);
    _loadUserName();
  }
  
  // Load user name from storage
  void _loadUserName() async {
    try {
      final storage = Get.find<GetStorage>();
      final user = storage.read('user');
      if (user != null && user['fullName'] != null) {
        userName.value = user['fullName'];
      }
    } catch (e) {
      userName.value = 'Traveler';
    }
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
