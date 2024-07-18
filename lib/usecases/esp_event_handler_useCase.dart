import 'package:alfa_tool/constants/event_type.dart';
import 'package:alfa_tool/models/event_log.dart';
import 'package:alfa_tool/services/ESPTouch_Service.dart';
import 'package:alfa_tool/services/event_log_manager.dart';
import 'package:alfa_tool/services/provisioning_state_manager.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

/// This class is responsible for handling ESPTouch events and updating the provisioning state.
class ESPEventHandlerUseCase {
  final ESPTouchService _espTouchService = Get.find<ESPTouchService>();
  final EventLogManager _logManager = Get.find<EventLogManager>();
  final ProvisioningStateManager _stateManager =
      Get.find<ProvisioningStateManager>();

  /// Sets up the event handler for ESPTouch events.
  ///
  /// This method attaches a callback to the ESPTouch service that listens for incoming method calls.
  /// When a method call is received, it extracts the event name and message, constructs an event message,
  /// and logs the event using the EventLogManager. It also updates the provisioning state based on the event type.
  void setEventHandler() {
    _espTouchService.setEventHandler((MethodCall methodCall) async {
      final String event = methodCall.method;
      final String? message = methodCall.arguments;

      String eventMessage =
          'Event: $event\nMessage: ${message ?? 'No message'}';

      switch (EventType.fromMethodName(event)) {
        case EventType.onProvisioningStart:
          _logManager.addEventLog(
              eventMessage, message ?? "", EventLogType.success);
          _stateManager.updateProvisioningState(ProvisioningState.inProgress);
          break;
        case EventType.onProvisioningScanResult:
          _logManager.addEventLog(
              eventMessage, message ?? "", EventLogType.info);
          _stateManager.updateProvisioningState(ProvisioningState.complete);
          break;
        case EventType.onProvisioningError:
          _logManager.addEventLog(
              eventMessage, message ?? "", EventLogType.failure);
          _stateManager.updateProvisioningState(ProvisioningState.stop);
          break;
        case EventType.onProvisioningStop:
          _logManager.addEventLog(
              eventMessage, message ?? "", EventLogType.stop);
          _stateManager.updateProvisioningState(ProvisioningState.stop);
          break;
        default:
          _logManager.addEventLog(
              eventMessage, message ?? "", EventLogType.info);
          break;
      }
    });
  }
}
