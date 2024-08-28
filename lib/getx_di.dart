import 'package:get/get.dart';
import 'controllers/audio_controller.dart';
// import 'package:get_storage/get_storage.dart';
import 'package:myapp/controllers/chat_controller.dart';

class GetXDependencyInjector {
  void onInit() {
    Get.put(ChatController());
    Get.put(AudioController());
    // Get.put(AuthController());
    // Get.put(GetStorage());
    // Get.put(LocationController());
    // Get.put(NavBarController());
    // Get.lazyPut(() => EventsController(), fenix: true);
    // Get.lazyPut(() => ProfileEditController(), fenix: true);
    // Get.lazyPut(() => ScheduleController(), fenix: true);
    // Get.lazyPut(() => ProfileController(), fenix: true);
    // Get.lazyPut(() => EventsSearchController(), fenix: true);
    // Get.lazyPut(() => StoriesController(), fenix: true);
    // Get.lazyPut(() => AnimController(), fenix: true);
    // Get.lazyPut(() => NavBarController(), fenix: true);
    // Get.lazyPut(() => NotificationController(), fenix: true);
    // Get.lazyPut(() => ThemeAnimationController(), fenix: true);
    // Get.lazyPut(() => ThemeController(), fenix: true);
  }
}
