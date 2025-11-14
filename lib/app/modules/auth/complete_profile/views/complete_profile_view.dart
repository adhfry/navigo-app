import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/complete_profile_controller.dart';

class CompleteProfileView extends GetView<CompleteProfileController> {
  const CompleteProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lengkapi Profil')),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: controller.formKey,
          child: Column(
            children: [
              TextFormField(
                controller: controller.phoneController,
                decoration: const InputDecoration(labelText: 'Nomor Telepon'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 20),
              Obx(() => ElevatedButton(
                onPressed: controller.isLoading.value ? null : controller.completeProfile,
                child: const Text('Selesai'),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
