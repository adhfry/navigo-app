import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../data/services/auth_service.dart';
import '../../../../data/models/user_model.dart';

class ProfileController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final ImagePicker _picker = ImagePicker();
  
  final formKey = GlobalKey<FormState>();
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController bioController;
  
  final selectedGender = ''.obs;
  final isLoading = false.obs;
  final isEditing = false.obs;
  final isGoogleConnected = false.obs;
  
  Rx<UserModel?> user = Rx<UserModel?>(null);
  
  @override
  void onInit() {
    super.onInit();
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    bioController = TextEditingController();
    
    loadUserData();
  }
  
  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    bioController.dispose();
    super.onClose();
  }
  
  void loadUserData() {
    user.value = _authService.currentUser.value;
    if (user.value != null) {
      fullNameController.text = user.value!.fullName;
      emailController.text = user.value!.email;
      phoneController.text = user.value!.phoneNumber;
      bioController.text = user.value!.bio ?? '';
      selectedGender.value = user.value!.gender ?? '';
      
      // Check if Google is connected
      // User yang login via Google memiliki profile picture dari googleusercontent
      // atau email verified otomatis (karena Google sudah verify)
      isGoogleConnected.value = (user.value!.profilePictureUrl != null &&
          user.value!.profilePictureUrl!.contains('googleusercontent'));
      
      print('🔍 Google Connected Status: ${isGoogleConnected.value}');
      print('🔍 Profile Picture URL: ${user.value!.profilePictureUrl}');
    }
  }
  
  void toggleEdit() {
    isEditing.value = !isEditing.value;
    if (!isEditing.value) {
      // Cancel edit, reload data
      loadUserData();
    }
  }
  
  Future<void> updateProfile() async {
    if (!formKey.currentState!.validate()) return;
    
    // Validate gender
    if (selectedGender.value.isEmpty) {
      Get.snackbar(
        'Error',
        'Pilih jenis kelamin terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return;
    }
    
    try {
      isLoading.value = true;
      
      // Call API to update profile
      final response = await _authService.updateProfile(
        fullName: fullNameController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        gender: selectedGender.value,
        bio: bioController.text.trim().isEmpty ? null : bioController.text.trim(),
      );
      
      if (response.isSuccess) {
        Get.snackbar(
          'Berhasil',
          response.message ?? 'Profile berhasil diupdate',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
        
        isEditing.value = false;
        loadUserData();
      } else {
        Get.snackbar(
          'Error',
          response.message ?? 'Gagal update profile',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          margin: const EdgeInsets.all(16),
          borderRadius: 12,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal update profile: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      
      if (image != null) {
        // TODO: Upload image to server
        // Image selected: ${image.path}
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memilih gambar',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
  Future<void> connectGoogleAccount() async {
    // TODO: Implement Google account linking
    Get.snackbar(
      'Info',
      'Fitur ini akan segera tersedia',
      snackPosition: SnackPosition.TOP,
    );
  }
  
  void logout() {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await _authService.logout();
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
