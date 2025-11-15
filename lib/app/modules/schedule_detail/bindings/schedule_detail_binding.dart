import 'package:get/get.dart';
import '../controllers/schedule_detail_controller.dart';

class ScheduleDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScheduleDetailController>(
      () => ScheduleDetailController(),
    );
  }
}
