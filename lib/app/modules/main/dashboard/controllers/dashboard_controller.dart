import 'package:flutter/material.dart';
import 'package:get/get.dart';
// REVISI: Menambahkan import untuk semua halaman/view
import 'package:navi_go/app/modules/main/dashboard/views/home_view.dart';
import 'package:navi_go/app/modules/main/dashboard/views/activity_view.dart';
import 'package:navi_go/app/modules/main/dashboard/views/message_view.dart';
import 'package:navi_go/app/modules/main/profile/views/profile_view.dart';
import 'package:navi_go/app/data/services/auth_service.dart';
import 'package:navi_go/app/modules/main/dashboard/controllers/message_controller.dart';

class DashboardController extends GetxController {
  // REVISI: Menambahkan state untuk BottomNavigationBar
  final RxInt currentIndex = 0.obs;
  late PageController pageController;

  // State untuk Carousel di HomeView
  final RxInt currentCarouselPage = 0.obs;
  
  // User name for header
  final RxString userName = 'Traveler'.obs;

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
    
    // Initialize MessageController
    Get.put(MessageController());
  }
  
  // Load user name from AuthService
  void _loadUserName() {
    try {
      final authService = Get.find<AuthService>();
      
      // Listen to currentUser changes
      ever(authService.currentUser, (user) {
        if (user != null && user.fullName.isNotEmpty) {
          userName.value = user.fullName;
          print('✅ User name updated: ${user.fullName}');
        } else {
          userName.value = 'Traveler';
          print('⚠️ No user data, using Traveler');
        }
      });
      
      // Set initial value
      if (authService.currentUser.value != null) {
        userName.value = authService.currentUser.value!.fullName;
        print('✅ Initial user name: ${authService.currentUser.value!.fullName}');
      }
    } catch (e) {
      userName.value = 'Traveler';
      print('❌ Error loading user: $e');
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
