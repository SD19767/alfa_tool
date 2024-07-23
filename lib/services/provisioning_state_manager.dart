import 'package:get/get.dart';
import 'package:alfa_tool/constants/animated_background_state.dart';

enum ProvisioningState { idle, inProgress, complete, stop }

abstract class ProvisioningStateManagerInterface {
  Rx<ProvisioningState> get provisioningState;
  Rx<BackgroundState> get backgroundState;

  void updateProvisioningState(ProvisioningState state);
  void updateBackgroundState(BackgroundState state);
}

class ProvisioningStateManager extends GetxController
    implements ProvisioningStateManagerInterface {
  final _provisioningState = ProvisioningState.idle.obs;
  final _backgroundState = BackgroundState.purple.obs;

  @override
  Rx<ProvisioningState> get provisioningState => _provisioningState;

  @override
  Rx<BackgroundState> get backgroundState => _backgroundState;

  @override
  void updateProvisioningState(ProvisioningState state) {
    _provisioningState.value = state;
  }

  @override
  void updateBackgroundState(BackgroundState state) {
    _backgroundState.value = state;
  }
}
