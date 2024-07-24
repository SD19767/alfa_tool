import 'package:alfa_tool/services/esptouch_service.dart';
import 'package:alfa_tool/services/provisioning_state_manager.dart';
import 'package:get/get.dart';

class StartProvisioningUseCase {
  final String mockBssid = 'AA:BB:CC:DD:EE:FF';
  final ESPTouchService _espTouchService = Get.find<ESPTouchService>();
  final ProvisioningStateManager _stateManager =
      Get.find<ProvisioningStateManager>();

  /// Starts the provisioning process by validating and preparing the provisioning data for ESPTouch.
  Future<void> startProvisioning({
    required String ssid,
    String? bssid,
    required String password,
    String? customData,
    String? aesKey,
  }) async {
    validateAndPrepareProvisioningData(
      ssid: ssid,
      bssid: bssid ?? mockBssid,
      password: password,
      customData: customData,
      aesKey: aesKey,
    );
    _stateManager.updateProvisioningState(ProvisioningState.inProgress);
    await _espTouchService.startProvisioning(
      ssid,
      bssid ?? mockBssid,
      password,
      customData?.isEmpty ?? true ? null : customData,
      aesKey?.isEmpty ?? true ? null : aesKey,
    );
  }

  /// Validates and prepares the provisioning data for ESPTouch.
  void validateAndPrepareProvisioningData({
    required String ssid,
    required String bssid,
    required String password,
    String? customData,
    String? aesKey,
  }) {
    _validateProvisioningData(
      ssid: ssid,
      password: password,
      aesKey: aesKey,
    );
  }

  /// Validates the provisioning data.
  void _validateProvisioningData({
    required String ssid,
    required String password,
    String? aesKey,
  }) {
    if (ssid.isEmpty) {
      throw Exception('SSID is required');
    }

    if (password.isEmpty) {
      throw Exception('Password is required');
    }

    if (aesKey != null && aesKey.isNotEmpty && aesKey.length != 16) {
      throw Exception('AES key should be 16 characters long');
    }
  }
}
