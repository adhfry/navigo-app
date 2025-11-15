import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageController extends GetxController {
  final RxBool isSearching = false.obs;
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  
  final RxList<Map<String, dynamic>> allMessages = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> filteredMessages = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMessages();
    
    // Listen to search query changes
    searchController.addListener(() {
      searchQuery.value = searchController.text;
      filterMessages();
    });
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void loadMessages() {
    allMessages.value = [
      {
        'id': '1',
        'name': 'Ahmad Fauzi',
        'avatar': 'A',
        'avatarUrl': 'https://i.pravatar.cc/150?img=12',
        'lastMessage': 'Terima kasih sudah bantu kirim dokumen!',
        'time': '2 menit lalu',
        'unreadCount': 2,
        'isOnline': true,
        'type': 'JASTIP',
      },
      {
        'id': '2',
        'name': 'Operator Kapal',
        'avatar': 'O',
        'avatarUrl': 'https://i.pravatar.cc/150?img=33',
        'lastMessage': 'Jadwal keberangkatan sudah dikonfirmasi untuk besok pagi.',
        'time': '1 jam lalu',
        'unreadCount': 0,
        'isOnline': true,
        'type': 'BOOKING',
      },
      {
        'id': '3',
        'name': 'Siti Aminah',
        'avatar': 'S',
        'avatarUrl': 'https://i.pravatar.cc/150?img=45',
        'lastMessage': 'Barang sudah diterima dengan baik. Terima kasih banyak!',
        'time': '3 jam lalu',
        'unreadCount': 0,
        'isOnline': false,
        'type': 'JASTIP',
      },
      {
        'id': '4',
        'name': 'Customer Service',
        'avatar': 'CS',
        'avatarUrl': 'https://i.pravatar.cc/150?img=22',
        'lastMessage': 'Ada yang bisa kami bantu hari ini?',
        'time': 'Kemarin',
        'unreadCount': 1,
        'isOnline': true,
        'type': 'SUPPORT',
      },
      {
        'id': '5',
        'name': 'Budi Santoso',
        'avatar': 'B',
        'avatarUrl': 'https://i.pravatar.cc/150?img=68',
        'lastMessage': 'Oke, saya tunggu kabarnya ya.',
        'time': '2 hari lalu',
        'unreadCount': 0,
        'isOnline': false,
        'type': 'JASTIP',
      },
      {
        'id': '6',
        'name': 'NaviGo Notifications',
        'avatar': 'N',
        'avatarUrl': 'https://i.pravatar.cc/150?img=1',
        'lastMessage': 'Promo spesial untuk pengguna setia! Diskon 20% untuk pemesanan tiket.',
        'time': '3 hari lalu',
        'unreadCount': 0,
        'isOnline': false,
        'type': 'NOTIFICATION',
      },
    ];
    
    filteredMessages.value = allMessages;
  }

  void toggleSearch() {
    isSearching.value = !isSearching.value;
    if (!isSearching.value) {
      searchController.clear();
      searchQuery.value = '';
      filteredMessages.value = allMessages;
    }
  }

  void filterMessages() {
    if (searchQuery.value.isEmpty) {
      filteredMessages.value = allMessages;
    } else {
      filteredMessages.value = allMessages.where((message) {
        return message['name']
            .toString()
            .toLowerCase()
            .contains(searchQuery.value.toLowerCase());
      }).toList();
    }
  }

  void openChat(Map<String, dynamic> message) {
    Get.toNamed(
      '/chat',
      arguments: {
        'id': message['id'],
        'name': message['name'],
        'avatar': message['avatar'],
        'type': message['type'],
        'isOnline': message['isOnline'],
      },
    );
  }
}
