import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JastipController extends GetxController {
  final RxInt selectedTab = 0.obs; // 0: Antar, 1: Jemput
  final RxBool isLoading = false.obs;
  
  // Dummy data sesuai Prisma schema
  final RxList<Map<String, dynamic>> jastipRequests = <Map<String, dynamic>>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    loadJastipRequests();
  }
  
  void changeTab(int index) {
    selectedTab.value = index;
  }
  
  void loadJastipRequests() {
    isLoading.value = true;
    
    jastipRequests.value = [
      {
        'id': 'jast-001',
        'requestType': 'DELIVER',
        'requester': {
          'fullName': 'Ahmad Fauzi',
          'profilePictureUrl': 'https://i.pravatar.cc/150?img=12',
          'averageRating': 4.8,
        },
        'originPort': {'name': 'Kalianget'},
        'destinationPort': {'name': 'Kangean'},
        'itemName': 'Dokumen Penting',
        'itemDescription': 'Surat-surat berharga yang perlu diantar ke Kangean',
        'rewardAmount': 50000.0,
        'status': 'OPEN',
        'pickupAddressDetail': 'Jl. Trunojoyo No. 45, Kalianget',
        'deliveryAddressDetail': 'Jl. Merdeka No. 12, Kangean',
        'createdAt': DateTime.now().subtract(const Duration(hours: 2)),
      },
      {
        'id': 'jast-002',
        'requestType': 'DELIVER',
        'requester': {
          'fullName': 'Siti Aminah',
          'profilePictureUrl': 'https://i.pravatar.cc/150?img=25',
          'averageRating': 4.9,
        },
        'originPort': {'name': 'Kalianget'},
        'destinationPort': {'name': 'Sapeken'},
        'itemName': 'Paket Obat-obatan',
        'itemDescription': 'Obat untuk keluarga di Sapeken',
        'rewardAmount': 75000.0,
        'status': 'OPEN',
        'pickupAddressDetail': 'Apotek Sehat, Jl. Sudirman No. 23',
        'deliveryAddressDetail': 'Rumah Sakit Sapeken',
        'createdAt': DateTime.now().subtract(const Duration(hours: 5)),
      },
      {
        'id': 'jast-003',
        'requestType': 'PICKUP',
        'requester': {
          'fullName': 'Budi Santoso',
          'profilePictureUrl': 'https://i.pravatar.cc/150?img=33',
          'averageRating': 4.7,
        },
        'originPort': {'name': 'Kangean'},
        'destinationPort': {'name': 'Kalianget'},
        'itemName': 'Oleh-oleh Khas',
        'itemDescription': 'Makanan khas Kangean untuk keluarga',
        'rewardAmount': 40000.0,
        'status': 'OPEN',
        'pickupContactName': 'Ibu Fatimah',
        'pickupContactPhone': '081234567890',
        'deliveryAddressDetail': 'Jl. Ahmad Yani No. 78, Kalianget',
        'createdAt': DateTime.now().subtract(const Duration(hours: 1)),
      },
      {
        'id': 'jast-004',
        'requestType': 'DELIVER',
        'requester': {
          'fullName': 'Rizki Maulana',
          'profilePictureUrl': 'https://i.pravatar.cc/150?img=51',
          'averageRating': 4.6,
        },
        'originPort': {'name': 'Sapeken'},
        'destinationPort': {'name': 'Kalianget'},
        'itemName': 'Barang Elektronik',
        'itemDescription': 'Laptop untuk diperbaiki',
        'rewardAmount': 60000.0,
        'status': 'OPEN',
        'pickupAddressDetail': 'Toko Elektronik Jaya',
        'deliveryAddressDetail': 'Service Center Komputer',
        'createdAt': DateTime.now().subtract(const Duration(hours: 3)),
      },
    ];
    
    isLoading.value = false;
  }
  
  List<Map<String, dynamic>> get filteredRequests {
    if (selectedTab.value == 0) {
      return jastipRequests.where((req) => req['requestType'] == 'DELIVER').toList();
    } else {
      return jastipRequests.where((req) => req['requestType'] == 'PICKUP').toList();
    }
  }
  
  void createJastipRequest() {
    try {
      Get.snackbar(
        'Buat Jastip',
        'Fitur pembuatan jastip akan segera hadir',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0c4a6e),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.add_box, color: Colors.white),
      );
    } catch (e) {
      print('Error showing snackbar: $e');
    }
  }
  
  void viewJastipDetail(Map<String, dynamic>? jastip) {
    if (jastip == null) {
      print('Jastip data is null');
      return;
    }
    
    try {
      final itemName = jastip['itemName'] ?? 'Item';
      final requester = jastip['requester'] as Map<String, dynamic>? ?? {};
      final requesterName = requester['fullName'] ?? 'Unknown';
      
      Get.snackbar(
        'Detail Jastip',
        '$itemName dari $requesterName\nFitur detail jastip akan segera hadir',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0c4a6e),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.info_outline, color: Colors.white),
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      print('Error showing jastip detail: $e');
    }
  }
  
  void offerJastip(Map<String, dynamic>? jastip) {
    if (jastip == null) {
      print('Jastip data is null');
      return;
    }
    
    try {
      final itemName = jastip['itemName'] ?? 'Item';
      final ship = jastip['ship'] as Map<String, dynamic>?;
      final shipName = ship?['name'] ?? '';
      
      Get.snackbar(
        'Ambil Jastip',
        'Anda akan mengambil jastip "$itemName"${shipName.isNotEmpty ? ' dengan $shipName' : ''}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0c4a6e),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.handshake, color: Colors.white),
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      print('Error offering jastip: $e');
    }
  }
}
