import 'package:flutter/material.dart';

import 'package:get/get.dart';

class AccountView extends GetView {
  const AccountView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Akun Saya'), centerTitle: true),
      body: const Center(
        child: Text('Halaman Akun', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
