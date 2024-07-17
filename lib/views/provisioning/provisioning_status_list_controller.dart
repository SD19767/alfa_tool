import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:alfa_tool/models/event_log.dart';
import 'package:alfa_tool/services/provisioning_state_manager.dart';
import 'package:alfa_tool/services/event_log_manager.dart';
import 'package:get/get_rx/get_rx.dart';

class ProvisioningStatusListController extends GetxController {
  RxList<EventLog> eventLogs = <EventLog>[].obs;
  Rx<ProvisioningState> provisioningState = ProvisioningState.idle.obs;
  final ProvisioningStateManager _stateManager =
      Get.find<ProvisioningStateManager>();
  final EventLogManager _logManager = Get.find<EventLogManager>();

  @override
  void onInit() {
    super.onInit();
    eventLogs.bindStream(_logManager.eventMessages.stream);
    provisioningState.bindStream(_stateManager.provisioningState.stream);
  }

  void onComplete() {
    switch (provisioningState.value) {
      case ProvisioningState.complete:
        _stateManager.updateProvisioningState(ProvisioningState.complete);
        break;
      case ProvisioningState.stop:
        _stateManager.updateProvisioningState(ProvisioningState.idle);
        _logManager.clearEventMessages();
        eventLogs.clear(); // This will trigger the list update
        break;
      default:
        break;
    }
  }

  String getButtonTitle() {
    switch (provisioningState.value) {
      case ProvisioningState.complete:
        return 'Complete';
      case ProvisioningState.stop:
        return 'retry';
      default:
        return '';
    }
  }

  bool getButtonShouldShow() {
    switch (provisioningState.value) {
      case ProvisioningState.complete:
        return true;
      case ProvisioningState.stop:
        return true;
      default:
        return false;
    }
  }
}
