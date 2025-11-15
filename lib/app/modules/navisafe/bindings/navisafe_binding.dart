import 'package:get/get.dart';
import '../controllers/navisafe_controller.dart';

class NavisafeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavisafeController>(
      () => NavisafeController(),
    );
  }
}
