import 'package:alfa_tool/ESPTouch_Service.dart';
import 'package:alfa_tool/animated_background_colors.dart';
import 'package:alfa_tool/event_log.dart';
import 'package:alfa_tool/event_log_manager.dart';
import 'package:alfa_tool/event_type.dart';
import 'package:alfa_tool/provisioning_state_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ProvisioningController extends GetxController {
  var ssidController = TextEditingController(text: 'AlfaLoop');
  var passwordController = TextEditingController(text: '12345687');
  var customDataController = TextEditingController();
  var aesKeyController = TextEditingController();
  var mockBSSID = 'AA:BB:CC:DD:EE:FF';
  var showCustomFields = false.obs;
  RxList<EventLog> logs = <EventLog>[].obs;
  Rx<ProvisioningState> provisioningState = ProvisioningState.idle.obs;
  Rx<BackgroundState> backgroundState = BackgroundState.purple.obs;

  final ProvisioningStateManager _stateManager =
      Get.find<ProvisioningStateManager>();
  final EventLogManager _logManager = Get.find<EventLogManager>();
  final ESPTouchService _espTouchService = Get.find<ESPTouchService>();
  @override
  void onInit() {
    super.onInit();
    logs.bindStream(_logManager.eventMessages.stream);
    provisioningState.bindStream(_stateManager.provisioningState.stream);
    backgroundState.bindStream(_stateManager.backgroundState.stream);
    _espTouchService.setEventHandler((event, message) {
      switch (event) {
        case EventType.onProvisioningStart:
          _stateManager.updateBackgroundState(BackgroundState.galaxy);
          break;
        case EventType.onProvisioningScanResult:
          _stateManager.updateBackgroundState(BackgroundState.green);
          break;
        case EventType.onProvisioningError:
          _stateManager.updateBackgroundState(BackgroundState.purple);
        case EventType.onProvisioningStop:
          _stateManager.updateBackgroundState(BackgroundState.purple);
        default:
          break;
      }
    });
  }

  Future<void> _startProvisioning() async {
    String ssid = ssidController.text;
    String bssid = mockBSSID; // Fetch the BSSID if needed
    String password = passwordController.text;
    String reservedData = customDataController.text;
    String aseKey = aesKeyController.text;
    await _espTouchService.startProvisioning(
        ssid, bssid, password, reservedData, aseKey);
  }

  Future<void> startProvisioningButtonTap() async {
    _startProvisioning();
  }
}
