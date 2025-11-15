import 'package:get/get.dart';

class ActivityDetailController extends GetxController {
  final RxString activityId = ''.obs;
  final RxString activityType = ''.obs;
  final RxMap<String, dynamic> activityData = <String, dynamic>{}.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Get arguments from navigation
    if (Get.arguments != null) {
      activityId.value = Get.arguments['id'] ?? '';
      activityType.value = Get.arguments['type'] ?? '';
      activityData.value = Get.arguments['data'] ?? {};
    }
    loadActivityDetail();
  }

  void loadActivityDetail() {
    isLoading.value = true;
    
    // Simulate loading
    Future.delayed(const Duration(milliseconds: 500), () {
      isLoading.value = false;
    });
  }
}
