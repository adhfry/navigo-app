import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:navi_go/app/config/theme.dart';
import 'package:navi_go/app/data/providers/api_client.dart';
import 'package:navi_go/app/data/services/auth_service.dart';
import 'package:navi_go/app/data/services/booking_service.dart';
import 'package:navi_go/app/data/services/jastip_service.dart';
import 'package:navi_go/app/data/services/payment_service.dart';
import 'package:navi_go/app/data/services/port_service.dart';
import 'package:navi_go/app/data/services/schedule_service.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage
  await GetStorage.init();

  // Initialize services
  await initServices();

  runApp(
    GetMaterialApp(
      title: "NaviGo",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
    ),
  );
}

Future<void> initServices() async {
  // Initialize API Client first
  Get.put(ApiClient());

  // Initialize all services
  Get.put(AuthService());
  Get.put(PortService());
  Get.put(ScheduleService());
  Get.put(BookingService());
  Get.put(JastipService());
  Get.put(PaymentService());
}
