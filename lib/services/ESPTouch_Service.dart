import 'package:alfa_tool/services/ESPTouch.dart';
import 'package:alfa_tool/models/event_log.dart';
import 'package:alfa_tool/services/event_log_manager.dart';
import 'package:alfa_tool/constants/event_type.dart';
import 'package:alfa_tool/services/provisioning_state_manager.dart';
import 'package:get/get.dart';

class ESPTouchService extends GetxController {
  final EventLogManager _logManager = Get.find<EventLogManager>();
  final ProvisioningStateManager _stateManager =
      Get.find<ProvisioningStateManager>();

  @override
  Future<void> startProvisioning(String ssid, String bssid, String password,
      String reservedData, String aseKey) async {
    _stateManager.updateProvisioningState(ProvisioningState.inProgress);
    ESPTouch.startProvisioning(ssid, bssid, password, reservedData, aseKey);
  }

  void setEventHandler(Function(EventType event, String? message) handler) {
    ESPTouch.setEventHandler((event, message) {
      String eventMessage =
          'Event: $event\nMessage: ${message ?? 'No message'}';
      switch (EventType.fromMethodName(event)) {
        case EventType.onProvisioningStart:
          _logManager.addEventLog(
              eventMessage, message ?? "", EventLogType.success);
          handler(EventType.onProvisioningStart, message);
          break;
        case EventType.onProvisioningScanResult:
          _logManager.addEventLog(
              eventMessage, message ?? "", EventLogType.info);
          _stateManager.updateProvisioningState(ProvisioningState.complete);
          handler(EventType.onProvisioningScanResult, message);
          break;
        case EventType.onProvisioningError:
          _logManager.addEventLog(
              eventMessage, message ?? "", EventLogType.failure);
          _stateManager.updateProvisioningState(ProvisioningState.stop);
          handler(EventType.onProvisioningError, message);
          break;
        case EventType.onProvisioningStop:
          _logManager.addEventLog(
              eventMessage, message ?? "", EventLogType.stop);
          _stateManager.updateProvisioningState(ProvisioningState.stop);
          handler(EventType.onProvisioningStop, message);
          break;
        default:
          _logManager.addEventLog(
              eventMessage, message ?? "", EventLogType.info);
          handler(EventType.undefine, message);
          break;
      }
    });
  }
}
