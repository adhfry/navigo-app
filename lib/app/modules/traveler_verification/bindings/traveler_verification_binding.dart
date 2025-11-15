import 'package:get/get.dart';
import '../controllers/traveler_verification_controller.dart';

class TravelerVerificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TravelerVerificationController>(
      () => TravelerVerificationController(),
    );
  }
}
