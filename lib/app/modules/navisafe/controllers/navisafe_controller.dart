import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavisafeController extends GetxController {
  final RxList<Map<String, dynamic>> safetyTips = <Map<String, dynamic>>[
    {
      'icon': 'verified_user',
      'title': 'Verifikasi Traveler',
      'description': 'Pastikan traveler sudah terverifikasi',
      'color': '0xFF4CAF50',
    },
    {
      'icon': 'security',
      'title': 'Asuransi Perjalanan',
      'description': 'Dapatkan perlindungan untuk barang Anda',
      'color': '0xFF2196F3',
    },
    {
      'icon': 'support_agent',
      'title': 'Dukungan 24/7',
      'description': 'Tim kami siap membantu kapan saja',
      'color': '0xFFFF9800',
    },
    {
      'icon': 'policy',
      'title': 'Garansi Uang Kembali',
      'description': 'Jaminan 100% uang kembali jika terjadi masalah',
      'color': '0xFF9C27B0',
    },
  ].obs;
  
  final RxList<Map<String, dynamic>> emergencyContacts = <Map<String, dynamic>>[
    {
      'name': 'Customer Service',
      'phone': '081234567890',
      'available': '24/7',
    },
    {
      'name': 'Emergency Hotline',
      'phone': '112',
      'available': '24/7',
    },
    {
      'name': 'Polisi Laut',
      'phone': '115',
      'available': '24/7',
    },
  ].obs;
  
  void reportIssue() {
    Get.snackbar(
      'Laporan',
      'Fitur pelaporan akan segera hadir',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF0c4a6e),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
  
  void callEmergency(String phone) {
    Get.snackbar(
      'Menghubungi',
      'Menghubungi $phone...',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF0c4a6e),
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }
}
