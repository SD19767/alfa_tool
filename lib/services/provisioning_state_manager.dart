import 'package:alfa_tool/views/login/provisioning_controller.dart';
import 'package:alfa_tool/views/provisioning/provisioning_status_list_controller.dart';
import 'package:get/get.dart';
import 'package:alfa_tool/constants/animated_background_state.dart';

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
