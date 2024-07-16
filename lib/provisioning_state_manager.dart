import 'package:alfa_tool/animated_background_colors.dart';
import 'package:alfa_tool/provisioning_controller.dart';
import 'package:alfa_tool/provisioning_status_list_controller.dart';
import 'package:get/get.dart';

enum ProvisioningState { idle, inProgress, complete, stop }

class ProvisioningStateManager extends GetxController {
  var provisioningState = ProvisioningState.idle.obs;
  var backgroundState = BackgroundState.purple.obs;

  void updateProvisioningState(ProvisioningState state) {
    provisioningState.value = state;
  }

  void updateBackgroundState(BackgroundState state) {
    backgroundState.value = state;
  }
}
