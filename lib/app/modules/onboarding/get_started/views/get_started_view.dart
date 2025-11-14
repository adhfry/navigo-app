import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:navi_go/app/config/theme.dart';

import '../controllers/get_started_controller.dart';

class GetStartedView extends GetView<GetStartedController> {
  const GetStartedView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0c4a6e), // Deep Sea Blue
      body: SafeArea(
        child: Column(
          children: [
            // --- Bagian Skip ---
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 20.0,
                ),
                child: TextButton(
                  onPressed: controller.skip,
                  child: Text(
                    "Lewati",
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.8)),
                  ),
                ),
              ),
            ),

            // --- Bagian Slider (PageView) ---
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: controller.onboardingPages.length,
                itemBuilder: (context, index) {
                  final item = controller.onboardingPages[index];
                  return _buildPage(
                    assetPath: item.assetPath,
                    title: item.title,
                    description: item.description,
                  );
                },
              ),
            ),

            // --- Bagian Kontrol (Pagination & Tombol) ---
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                children: [
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        controller.onboardingPages.length,
                        (index) => _buildDot(index, context),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Obx(
                    () => ElevatedButton(
                      onPressed: controller.nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.secondaryColor,
                        foregroundColor: const Color(0xFF0c4a6e),
                        minimumSize: const Size(double.infinity, 56),
                      ),
                      child: Text(
                        controller.isLastPage.value
                            ? 'Ayo Mulai!'
                            : 'Selanjutnya',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk membangun satu halaman slide
  Widget _buildPage({
    required String assetPath,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: Get.width * 0.6,
            height: Get.width * 0.6,
            child: SvgPicture.asset(assetPath),
          ),
          const SizedBox(height: 48),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withValues(alpha: 0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk membangun titik paginasi
  Widget _buildDot(int index, BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(right: 5),
      height: 8,
      width: controller.currentPage.value == index ? 24 : 8,
      decoration: BoxDecoration(
        color: controller.currentPage.value == index
            ? AppTheme.secondaryColor
            : Colors.white.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

