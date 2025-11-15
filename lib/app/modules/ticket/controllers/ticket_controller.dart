import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TicketController extends GetxController {
  final originController = TextEditingController();
  final destinationController = TextEditingController();
  
  final Rx<DateTime> selectedDate = DateTime.now().obs;
  final RxInt passengers = 1.obs;
  
  // Daftar pelabuhan sesuai Prisma schema
  final RxList<String> availablePorts = <String>[
    'Kalianget',
    'Kangean',
    'Sapeken',
    'Pagerungan Besar',
    'Pagerungan Kecil',
    'Raas',
    'Masalembu',
    'Arjasa',
  ].obs;
  
  final RxList<String> originSuggestions = <String>[].obs;
  final RxList<String> destinationSuggestions = <String>[].obs;
  final RxBool showOriginSuggestions = false.obs;
  final RxBool showDestinationSuggestions = false.obs;
  
  final RxList<Map<String, String>> popularRoutes = <Map<String, String>>[
    {'from': 'Kalianget', 'to': 'Kangean', 'duration': '4.5 jam'},
    {'from': 'Kalianget', 'to': 'Sapeken', 'duration': '6.5 jam'},
    {'from': 'Kangean', 'to': 'Kalianget', 'duration': '4.5 jam'},
    {'from': 'Sapeken', 'to': 'Kalianget', 'duration': '6.5 jam'},
    {'from': 'Kangean', 'to': 'Sapeken', 'duration': '3 jam'},
    {'from': 'Sapeken', 'to': 'Kangean', 'duration': '3 jam'},
  ].obs;
  
  void incrementPassengers() {
    if (passengers.value < 10) {
      passengers.value++;
    }
  }
  
  void decrementPassengers() {
    if (passengers.value > 1) {
      passengers.value--;
    }
  }
  
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0c4a6e),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Color(0xFF0c4a6e),
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
    }
  }
  
  void searchTickets() {
    if (originController.text.isEmpty || destinationController.text.isEmpty) {
      Get.snackbar(
        'Perhatian',
        'Mohon lengkapi pelabuhan asal dan tujuan',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }
    
    Get.toNamed('/schedule-detail', arguments: {
      'origin': originController.text,
      'destination': destinationController.text,
      'date': selectedDate.value,
      'passengers': passengers.value,
    });
  }
  
  void selectPopularRoute(Map<String, String>? route) {
    if (route == null) return;
    
    try {
      originController.text = route['from'] ?? '';
      destinationController.text = route['to'] ?? '';
      showOriginSuggestions.value = false;
      showDestinationSuggestions.value = false;
    } catch (e) {
      print('Error selecting popular route: $e');
    }
  }
  
  void onOriginChanged(String value) {
    if (value.isEmpty) {
      showOriginSuggestions.value = false;
      originSuggestions.clear();
      return;
    }
    
    originSuggestions.value = availablePorts
        .where((port) => port.toLowerCase().contains(value.toLowerCase()))
        .toList();
    showOriginSuggestions.value = originSuggestions.isNotEmpty;
  }
  
  void onDestinationChanged(String value) {
    if (value.isEmpty) {
      showDestinationSuggestions.value = false;
      destinationSuggestions.clear();
      return;
    }
    
    destinationSuggestions.value = availablePorts
        .where((port) => port.toLowerCase().contains(value.toLowerCase()))
        .toList();
    showDestinationSuggestions.value = destinationSuggestions.isNotEmpty;
  }
  
  void selectOrigin(String port) {
    originController.text = port;
    showOriginSuggestions.value = false;
  }
  
  void selectDestination(String port) {
    destinationController.text = port;
    showDestinationSuggestions.value = false;
  }
  
  @override
  void onClose() {
    originController.dispose();
    destinationController.dispose();
    super.onClose();
  }
}
