import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  final RxString chatId = ''.obs;
  final RxString chatName = ''.obs;
  final RxString chatAvatar = ''.obs;
  final RxString chatType = ''.obs;
  final RxBool isOnline = true.obs;
  
  final TextEditingController messageController = TextEditingController();
  final RxList<Map<String, dynamic>> messages = <Map<String, dynamic>>[].obs;
  final RxBool isTyping = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      chatId.value = Get.arguments['id'] ?? '';
      chatName.value = Get.arguments['name'] ?? '';
      chatAvatar.value = Get.arguments['avatar'] ?? '';
      chatType.value = Get.arguments['type'] ?? '';
      isOnline.value = Get.arguments['isOnline'] ?? true;
    }
    loadMessages();
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }

  void loadMessages() {
    // Dummy realistic chat messages based on type
    if (chatType.value == 'JASTIP') {
      messages.value = [
        {
          'id': '1',
          'text': 'Halo, saya butuh bantuan untuk kirim dokumen penting ke Kangean',
          'isMine': false,
          'timestamp': '10:15',
          'isRead': true,
        },
        {
          'id': '2',
          'text': 'Baik, saya bisa bantu. Kapan mau dikirim?',
          'isMine': true,
          'timestamp': '10:17',
          'isRead': true,
        },
        {
          'id': '3',
          'text': 'Besok pagi bisa? Saya harus kirim segera',
          'isMine': false,
          'timestamp': '10:18',
          'isRead': true,
        },
        {
          'id': '4',
          'text': 'Bisa, kebetulan saya ada jadwal ke Kangean besok jam 8 pagi',
          'isMine': true,
          'timestamp': '10:20',
          'isRead': true,
        },
        {
          'id': '5',
          'text': 'Sempurna! Berapa biayanya?',
          'isMine': false,
          'timestamp': '10:21',
          'isRead': true,
        },
        {
          'id': '6',
          'text': 'Untuk dokumen Rp 50.000 saja. Sudah termasuk ongkir sampai alamat tujuan',
          'isMine': true,
          'timestamp': '10:22',
          'isRead': true,
        },
        {
          'id': '7',
          'text': 'Oke deal! Saya transfer sekarang ya',
          'isMine': false,
          'timestamp': '10:25',
          'isRead': true,
        },
        {
          'id': '8',
          'text': 'Siap, tolong kirim bukti transfer ya. Alamat pengambilan dimana?',
          'isMine': true,
          'timestamp': '10:27',
          'isRead': true,
        },
        {
          'id': '9',
          'text': 'Jl. Trunojoyo No. 45. Saya tunggu besok pagi jam 7 ya',
          'isMine': false,
          'timestamp': '10:30',
          'isRead': true,
        },
      ];
    } else if (chatType.value == 'BOOKING') {
      messages.value = [
        {
          'id': '1',
          'text': 'Selamat siang, tiket Anda untuk keberangkatan hari ini sudah dikonfirmasi',
          'isMine': false,
          'timestamp': '11:30',
          'isRead': true,
        },
        {
          'id': '2',
          'text': 'Terima kasih. Jam berapa keberangkatannya?',
          'isMine': true,
          'timestamp': '11:32',
          'isRead': true,
        },
        {
          'id': '3',
          'text': 'Keberangkatan jam 14:30 dari Pelabuhan Kalianget. Harap datang 30 menit sebelumnya',
          'isMine': false,
          'timestamp': '11:33',
          'isRead': true,
        },
        {
          'id': '4',
          'text': 'Baik, noted. Ada fasilitas apa saja di kapal?',
          'isMine': true,
          'timestamp': '11:35',
          'isRead': true,
        },
        {
          'id': '5',
          'text': 'Kapal dilengkapi AC, toilet, mushola, dan kantin. Perjalanan sekitar 3 jam',
          'isMine': false,
          'timestamp': '11:36',
          'isRead': true,
        },
        {
          'id': '6',
          'text': 'Oke siap, terima kasih infonya',
          'isMine': true,
          'timestamp': '11:38',
          'isRead': true,
        },
      ];
    } else {
      messages.value = [
        {
          'id': '1',
          'text': 'Halo! Ada yang bisa kami bantu?',
          'isMine': false,
          'timestamp': '09:00',
          'isRead': true,
        },
      ];
    }
  }

  void sendMessage() {
    if (messageController.text.trim().isEmpty) return;

    final newMessage = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'text': messageController.text.trim(),
      'isMine': true,
      'timestamp': '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
      'isRead': false,
    };

    messages.add(newMessage);
    messageController.clear();

    // Simulate reply after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      isTyping.value = true;
      Future.delayed(const Duration(seconds: 1), () {
        isTyping.value = false;
        messages.add({
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'text': 'Terima kasih atas pesannya. Kami akan segera merespons.',
          'isMine': false,
          'timestamp': '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
          'isRead': false,
        });
      });
    });
  }
}
