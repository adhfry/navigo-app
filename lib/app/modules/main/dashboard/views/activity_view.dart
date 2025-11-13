import 'package:flutter/material.dart';

import 'package:get/get.dart';

class ActivityView extends GetView {
  const ActivityView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aktivitas Saya'), centerTitle: true),
      body: const Center(
        child: Text('Halaman Aktivitas', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
