import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

class ScheduleDetailController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> schedules = <Map<String, dynamic>>[].obs;
  
  // Search parameters
  String? searchOrigin;
  String? searchDestination;
  final Rx<DateTime> searchDate = DateTime.now().obs;
  int? searchPassengers;
  String? viewMode; // 'today' untuk lihat jadwal hari ini, null untuk pencarian biasa
  
  @override
  void onInit() {
    super.onInit();
    
    // Get search parameters from arguments
    final args = Get.arguments;
    if (args != null && args is Map) {
      searchOrigin = args['origin'];
      searchDestination = args['destination'];
      searchDate.value = args['date'] ?? DateTime.now();
      searchPassengers = args['passengers'];
      viewMode = args['viewMode'];
    }
    
    loadSchedules();
  }
  
  void changeDate(DateTime newDate) {
    searchDate.value = newDate;
    loadSchedules();
  }
  
  void loadSchedules() {
    isLoading.value = true;
    
    // Generate realistic schedules based on search or show all
    if (searchOrigin != null && searchDestination != null) {
      print('🔍 Searching: $searchOrigin → $searchDestination on ${searchDate.value}');
      
      // Jika mode "today", filter hanya jadwal 1 jam ke depan
      if (viewMode == 'today') {
        schedules.value = _generateTodaySchedules(
          searchOrigin!,
          searchDestination!,
          searchDate.value,
        );
      } else {
        schedules.value = _generateRealisticSchedules(
          searchOrigin!,
          searchDestination!,
          searchDate.value,
        );
      }
      print('✅ Found ${schedules.length} schedules');
    } else {
      print('📋 Loading default schedules');
      schedules.value = _getDefaultSchedules();
      print('✅ Loaded ${schedules.length} default schedules');
    }
    
    isLoading.value = false;
  }
  
  List<Map<String, dynamic>> _getDefaultSchedules() {
    return [
      {
        'id': 'sch-001',
        'route': {
          'originPort': {'name': 'Pelabuhan Kalianget'},
          'destinationPort': {'name': 'Pelabuhan Kangean'},
          'estimatedDurationHours': 4.5,
        },
        'ship': {
          'name': 'KMP Dharma Kencana',
          'capacity': 200,
          'description': 'Kapal cepat dan nyaman',
        },
        'operator': {
          'name': 'PT ASDP Indonesia Ferry',
          'contactPhone': '081234567890',
        },
        'departureTime': DateTime(2025, 11, 20, 9, 0),
        'estimatedArrivalTime': DateTime(2025, 11, 20, 13, 30),
        'price': 75000.0,
        'availableSeats': 45,
      },
      {
        'id': 'sch-002',
        'route': {
          'originPort': {'name': 'Pelabuhan Kalianget'},
          'destinationPort': {'name': 'Pelabuhan Kangean'},
          'estimatedDurationHours': 4.0,
        },
        'ship': {
          'name': 'KMP Mutiara Timur',
          'capacity': 150,
          'description': 'Kapal ekonomis',
        },
        'operator': {
          'name': 'PT ASDP Indonesia Ferry',
          'contactPhone': '081234567890',
        },
        'departureTime': DateTime(2025, 11, 20, 14, 0),
        'estimatedArrivalTime': DateTime(2025, 11, 20, 18, 0),
        'price': 65000.0,
        'availableSeats': 28,
      },
      {
        'id': 'sch-003',
        'route': {
          'originPort': {'name': 'Pelabuhan Kalianget'},
          'destinationPort': {'name': 'Pelabuhan Sapeken'},
          'estimatedDurationHours': 6.5,
        },
        'ship': {
          'name': 'KMP Nusa Sejahtera',
          'capacity': 250,
          'description': 'Kapal besar dan stabil',
        },
        'operator': {
          'name': 'PT ASDP Indonesia Ferry',
          'contactPhone': '081234567890',
        },
        'departureTime': DateTime(2025, 11, 21, 7, 0),
        'estimatedArrivalTime': DateTime(2025, 11, 21, 13, 30),
        'price': 95000.0,
        'availableSeats': 62,
      },
      {
        'id': 'sch-004',
        'route': {
          'originPort': {'name': 'Pelabuhan Kangean'},
          'destinationPort': {'name': 'Pelabuhan Kalianget'},
          'estimatedDurationHours': 4.5,
        },
        'ship': {
          'name': 'KMP Dharma Kencana',
          'capacity': 200,
          'description': 'Kapal cepat dan nyaman',
        },
        'operator': {
          'name': 'PT ASDP Indonesia Ferry',
          'contactPhone': '081234567890',
        },
        'departureTime': DateTime(2025, 11, 20, 16, 0),
        'estimatedArrivalTime': DateTime(2025, 11, 20, 20, 30),
        'price': 75000.0,
        'availableSeats': 33,
      },
    ];
  }
  
  List<Map<String, dynamic>> _generateRealisticSchedules(
    String origin,
    String destination,
    DateTime date,
  ) {
    print('🎫 Generating schedules for: $origin → $destination');
    final random = Random();
    final schedules = <Map<String, dynamic>>[];
    
    // Data kapal dan operator
    final ships = [
      {'name': 'KM Dharma Rucitra', 'capacity': 150},
      {'name': 'KM Sabuk Nusantara', 'capacity': 200},
      {'name': 'KM Kelud', 'capacity': 120},
      {'name': 'Express Bahari 1', 'capacity': 100},
      {'name': 'KM Nusa Kenari', 'capacity': 180},
      {'name': 'Fast Boat Marina', 'capacity': 80},
    ];
    
    final operators = [
      {'name': 'PT ASDP Indonesia Ferry', 'phone': '0324-321456'},
      {'name': 'PT Dharma Lautan Utama', 'phone': '0324-321789'},
      {'name': 'CV Bahtera Nusantara', 'phone': '0324-322123'},
      {'name': 'PT Pelayaran Nasional', 'phone': '0324-323456'},
    ];
    
    // Estimasi durasi berdasarkan rute (dalam jam)
    final durations = {
      'Kalianget-Kangean': 4.5,
      'Kalianget-Sapeken': 6.5,
      'Kalianget-Pagerungan Besar': 5.0,
      'Kalianget-Pagerungan Kecil': 5.5,
      'Kalianget-Raas': 3.0,
      'Kalianget-Masalembu': 8.0,
      'Kalianget-Arjasa': 2.5,
      'Kangean-Sapeken': 3.0,
      'Kangean-Pagerungan Besar': 2.5,
      'Kangean-Pagerungan Kecil': 3.0,
      'Kangean-Raas': 3.5,
      'Kangean-Masalembu': 5.0,
      'Pagerungan Besar-Sapeken': 2.0,
      'Pagerungan Besar-Pagerungan Kecil': 1.5,
      'Pagerungan Besar-Masalembu': 3.5,
      'Pagerungan Kecil-Sapeken': 2.5,
      'Sapeken-Masalembu': 4.0,
      'Sapeken-Raas': 5.0,
      'Raas-Masalembu': 6.0,
      'Arjasa-Kangean': 5.5,
      'Arjasa-Pagerungan Besar': 6.0,
    };
    
    // Harga dasar per rute
    final basePrices = {
      'Kalianget-Kangean': 85000,
      'Kalianget-Sapeken': 120000,
      'Kalianget-Pagerungan Besar': 95000,
      'Kalianget-Pagerungan Kecil': 100000,
      'Kalianget-Raas': 70000,
      'Kalianget-Masalembu': 150000,
      'Kalianget-Arjasa': 60000,
      'Kangean-Sapeken': 75000,
      'Kangean-Pagerungan Besar': 60000,
      'Kangean-Pagerungan Kecil': 65000,
      'Kangean-Raas': 70000,
      'Kangean-Masalembu': 110000,
      'Pagerungan Besar-Sapeken': 50000,
      'Pagerungan Besar-Pagerungan Kecil': 40000,
      'Pagerungan Besar-Masalembu': 85000,
      'Pagerungan Kecil-Sapeken': 55000,
      'Sapeken-Masalembu': 90000,
      'Sapeken-Raas': 95000,
      'Raas-Masalembu': 115000,
      'Arjasa-Kangean': 100000,
      'Arjasa-Pagerungan Besar': 110000,
    };
    
    final routeKey = '$origin-$destination';
    final reverseKey = '$destination-$origin';
    
    final duration = durations[routeKey] ?? durations[reverseKey] ?? 4.0;
    final basePrice = basePrices[routeKey] ?? basePrices[reverseKey] ?? 85000;
    
    print('⏱️ Duration: $duration hours, Base price: Rp $basePrice');
    
    // Generate 2-3 jadwal dengan waktu yang realistis
    final scheduleCount = 2 + random.nextInt(2); // 2 atau 3 jadwal
    print('📊 Generating $scheduleCount schedules...');
    
    // Waktu keberangkatan yang realistis (pagi, siang, sore)
    final departureTimes = [
      DateTime(date.year, date.month, date.day, 6, 0), // 06:00
      DateTime(date.year, date.month, date.day, 8, 30), // 08:30
      DateTime(date.year, date.month, date.day, 10, 0), // 10:00
      DateTime(date.year, date.month, date.day, 13, 0), // 13:00
      DateTime(date.year, date.month, date.day, 15, 30), // 15:30
    ];
    
    // Shuffle dan ambil sesuai count
    departureTimes.shuffle();
    final selectedTimes = departureTimes.take(scheduleCount).toList();
    selectedTimes.sort((a, b) => a.compareTo(b));
    
    for (int i = 0; i < scheduleCount; i++) {
      final ship = ships[random.nextInt(ships.length)];
      final operator = operators[random.nextInt(operators.length)];
      final departureTime = selectedTimes[i];
      final arrivalTime = departureTime.add(Duration(
        hours: duration.floor(),
        minutes: ((duration - duration.floor()) * 60).round(),
      ));
      
      // Variasi harga ±10%
      final priceVariation = basePrice + (random.nextInt(20000) - 10000);
      final price = (priceVariation / 5000).round() * 5000; // Round to 5000
      
      // Available seats (realistic)
      final totalSeats = ship['capacity'] as int;
      final bookedSeats = random.nextInt(totalSeats ~/ 2);
      final availableSeats = totalSeats - bookedSeats;
      
      schedules.add({
        'id': 'sch-${DateTime.now().millisecondsSinceEpoch}-$i',
        'route': {
          'originPort': {'name': origin},
          'destinationPort': {'name': destination},
          'estimatedDurationHours': duration,
        },
        'ship': ship,
        'operator': operator,
        'departureTime': departureTime,
        'estimatedArrivalTime': arrivalTime,
        'price': price.toDouble(),
        'availableSeats': availableSeats,
      });
      print('✅ Schedule $i: ${ship['name']} at ${_formatTime(departureTime)}');
    }
    
    print('🎉 Total schedules generated: ${schedules.length}');
    return schedules;
  }
  
  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
  
  List<Map<String, dynamic>> _generateTodaySchedules(
    String origin,
    String destination,
    DateTime date,
  ) {
    print('📅 Generating TODAY schedules starting from 1 hour ahead');
    final now = DateTime.now();
    final oneHourAhead = now.add(const Duration(hours: 1));
    
    final random = Random();
    final schedules = <Map<String, dynamic>>[];
    
    // Data kapal dan operator
    final ships = [
      {'name': 'KM Dharma Rucitra', 'capacity': 150},
      {'name': 'KM Sabuk Nusantara', 'capacity': 200},
      {'name': 'KM Kelud', 'capacity': 120},
      {'name': 'Express Bahari 1', 'capacity': 100},
    ];
    
    final operators = [
      {'name': 'PT ASDP Indonesia Ferry', 'phone': '0324-321456'},
      {'name': 'PT Dharma Lautan Utama', 'phone': '0324-321789'},
    ];
    
    // Duration Kalianget-Kangean
    final duration = 4.5;
    final basePrice = 85000;
    
    // Generate jadwal mulai 1 jam ke depan dengan interval 2-3 jam
    final scheduleCount = 3; // Tampilkan 3 jadwal ke depan
    
    for (int i = 0; i < scheduleCount; i++) {
      final ship = ships[random.nextInt(ships.length)];
      final operator = operators[random.nextInt(operators.length)];
      
      // Jadwal mulai 1 jam ke depan + (i * 2.5 jam)
      final hoursAhead = 1 + (i * 2.5);
      final departureTime = now.add(Duration(
        hours: hoursAhead.floor(),
        minutes: ((hoursAhead - hoursAhead.floor()) * 60).round(),
      ));
      
      final arrivalTime = departureTime.add(Duration(
        hours: duration.floor(),
        minutes: ((duration - duration.floor()) * 60).round(),
      ));
      
      // Variasi harga
      final priceVariation = basePrice + (random.nextInt(20000) - 10000);
      final price = (priceVariation / 5000).round() * 5000;
      
      // Available seats
      final totalSeats = ship['capacity'] as int;
      final bookedSeats = random.nextInt(totalSeats ~/ 2);
      final availableSeats = totalSeats - bookedSeats;
      
      schedules.add({
        'id': 'today-${DateTime.now().millisecondsSinceEpoch}-$i',
        'route': {
          'originPort': {'name': origin},
          'destinationPort': {'name': destination},
          'estimatedDurationHours': duration,
        },
        'ship': ship,
        'operator': operator,
        'departureTime': departureTime,
        'estimatedArrivalTime': arrivalTime,
        'price': price.toDouble(),
        'availableSeats': availableSeats,
      });
      print('✅ Today Schedule $i: ${ship['name']} at ${_formatTime(departureTime)}');
    }
    
    return schedules;
  }
  
  void bookSchedule(Map<String, dynamic>? schedule) {
    if (schedule == null) {
      print('Schedule data is null');
      return;
    }
    
    try {
      final ship = schedule['ship'] as Map<String, dynamic>?;
      final shipName = ship?['name'] ?? 'Kapal';
      final route = schedule['route'] as Map<String, dynamic>?;
      final origin = route?['originPort'] as Map<String, dynamic>?;
      final destination = route?['destinationPort'] as Map<String, dynamic>?;
      final originName = origin?['name'] ?? '';
      final destName = destination?['name'] ?? '';
      
      Get.snackbar(
        'Booking Tiket',
        'Anda akan memesan tiket $shipName${originName.isNotEmpty && destName.isNotEmpty ? '\n$originName → $destName' : ''}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF0c4a6e),
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        icon: const Icon(Icons.confirmation_number, color: Colors.white),
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      print('Error booking schedule: $e');
      Get.snackbar(
        'Error',
        'Terjadi kesalahan saat booking',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    }
  }
}
