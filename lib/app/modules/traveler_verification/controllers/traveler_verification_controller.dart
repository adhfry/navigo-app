import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TravelerVerificationController extends GetxController {
  final notesController = TextEditingController();
  final RxBool isSubmitting = false.obs;
  
  final RxList<String> benefits = <String>[
    'Mendapat badge verifikasi',
    'Prioritas dalam penawaran jastip',
    'Tingkatkan kepercayaan pengguna',
    'Akses fitur eksklusif traveler',
    'Peningkatan rating otomatis',
  ].obs;
  
  final RxList<String> requirements = <String>[
    'KTP/Identitas yang masih berlaku',
    'Foto selfie dengan KTP',
    'Minimal 5 perjalanan selesai',
    'Rating minimal 4.5',
    'Tidak ada pelanggaran',
  ].obs;
  
  void submitVerification() {
    if (notesController.text.isEmpty) {
      Get.snackbar(
        'Perhatian',
        'Mohon isi catatan verifikasi',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }
    
    isSubmitting.value = true;
    
    Future.delayed(const Duration(seconds: 2), () {
      isSubmitting.value = false;
      Get.back();
      Get.snackbar(
        'Berhasil',
        'Permintaan verifikasi telah dikirim',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    });
  }
  
  @override
  void onClose() {
    notesController.dispose();
    super.onClose();
  }
}
