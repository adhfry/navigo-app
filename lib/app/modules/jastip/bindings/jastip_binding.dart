import 'package:get/get.dart';
import '../controllers/jastip_controller.dart';

class JastipBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JastipController>(
      () => JastipController(),
    );
  }
}
