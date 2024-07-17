import 'package:alfa_tool/constants/animated_background_state.dart';
import 'package:alfa_tool/provisioning_state_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class BackgroundController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final currentState = BackgroundState.green.obs;
  late AnimationController animationController;
  final ProvisioningStateManager _stateManager =
      Get.find<ProvisioningStateManager>();
  @override
  void onInit() {
    super.onInit();
    currentState.bindStream(_stateManager.backgroundState.stream);
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
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
      animationController.duration = const Duration(seconds: 4);
      animationController.repeat();
    } else {
      animationController.duration = const Duration(seconds: 15);
      animationController.repeat();
    }
  }
}
