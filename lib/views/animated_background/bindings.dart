import 'package:get/get.dart';
import './controller.dart';

class AnimatedBackgroundBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(BackgroundController());
  }
}
