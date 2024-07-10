import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'Animated_background_colors.dart';

class BackgroundController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var currentState = BackgroundState.green.obs;
  late AnimationController animationController;

  @override
  void onInit() {
    super.onInit();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 5),
    )..repeat();
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  void changeState(BackgroundState newState) {
    currentState.value = newState;
    if (newState == BackgroundState.galaxy) {
      animationController.duration = Duration(seconds: 2);
      animationController.repeat();
    } else {
      animationController.duration = Duration(seconds: 5);
      animationController.repeat();
    }
  }
}
