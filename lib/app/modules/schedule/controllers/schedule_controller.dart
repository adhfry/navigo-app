import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/port_model.dart';
import '../../../data/models/schedule_model.dart';
import '../../../data/services/port_service.dart';
import '../../../data/services/schedule_service.dart';

class ScheduleController extends GetxController {
  final ScheduleService _scheduleService = Get.find<ScheduleService>();
  final PortService _portService = Get.find<PortService>();

  // Observables
  final isLoading = false.obs;
  final ports = <PortModel>[].obs;
  final schedules = <ScheduleModel>[].obs;
  final selectedOriginPort = Rxn<PortModel>();
  final selectedDestinationPort = Rxn<PortModel>();
  final selectedDate = Rxn<DateTime>();
  final errorMessage = RxnString();

  // Form key
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    _loadPorts();
    // Set default date to today
    selectedDate.value = DateTime.now();
  }

  /// Load all ports
  Future<void> _loadPorts() async {
    final response = await _portService.getAllPorts();
    if (response.isSuccess && response.data != null) {
      ports.value = response.data!;
    }
  }

  /// Search schedules
  Future<void> searchSchedules() async {
    if (formKey.currentState == null || !formKey.currentState!.validate()) {
      return;
    }

    if (selectedOriginPort.value == null) {
      _showError('Pilih pelabuhan keberangkatan');
      return;
    }

    if (selectedDestinationPort.value == null) {
      _showError('Pilih pelabuhan tujuan');
      return;
    }

    if (selectedOriginPort.value!.id == selectedDestinationPort.value!.id) {
      _showError('Pelabuhan keberangkatan dan tujuan tidak boleh sama');
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = null;

      final response = await _scheduleService.searchSchedules(
        originPortId: selectedOriginPort.value!.id,
        destinationPortId: selectedDestinationPort.value!.id,
        date: selectedDate.value,
      );

      if (response.isSuccess && response.data != null) {
        schedules.value = response.data!;

        if (schedules.isEmpty) {
          _showError(
            'Tidak ada jadwal tersedia untuk rute dan tanggal yang dipilih',
          );
        } else {
          Get.snackbar(
            'Berhasil',
            'Ditemukan ${schedules.length} jadwal',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        }
      } else {
        _showError(response.message);
      }
    } catch (e) {
      _showError('Terjadi kesalahan: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Select origin port
  void selectOriginPort(PortModel? port) {
    selectedOriginPort.value = port;
  }

  /// Select destination port
  void selectDestinationPort(PortModel? port) {
    selectedDestinationPort.value = port;
  }

  /// Select date
  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1E3A8A),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      selectedDate.value = picked;
    }
  }

  /// Swap ports
  void swapPorts() {
    final temp = selectedOriginPort.value;
    selectedOriginPort.value = selectedDestinationPort.value;
    selectedDestinationPort.value = temp;
  }

  /// Clear search
  void clearSearch() {
    selectedOriginPort.value = null;
    selectedDestinationPort.value = null;
    selectedDate.value = DateTime.now();
    schedules.clear();
    errorMessage.value = null;
  }

  /// Show error message
  void _showError(String message) {
    errorMessage.value = message;
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  /// Format date for display
  String formatDate(DateTime date) {
    final months = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember'
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }

  /// Format time
  String formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Format currency
  String formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }

  /// Format duration
  String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}
