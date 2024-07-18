import 'package:alfa_tool/usecases/start_provisioning_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:alfa_tool/models/event_log.dart';
import 'package:alfa_tool/services/provisioning_state_manager.dart';
import 'package:alfa_tool/services/event_log_manager.dart';
import 'package:get/get_rx/get_rx.dart';

class ProvisioningController extends GetxController {
  RxList<EventLog> eventLogs = <EventLog>[].obs;
  Rx<ProvisioningState> provisioningState = ProvisioningState.idle.obs;
  final ProvisioningStateManager _stateManager =
      Get.find<ProvisioningStateManager>();
  final EventLogManager _logManager = Get.find<EventLogManager>();
  StartProvisioningUsecase startProvisioningUsecase =
      Get.put(StartProvisioningUsecase());

  late final String ssid;
  late final String password;
  late final String customData;
  late final String aesKey;
  late final String bssid;

  @override
  void onInit() {
    super.onInit();
    eventLogs.bindStream(_logManager.eventMessages.stream);
    _logManager.eventMessages.stream.listen((event) {
      eventLogs.refresh();
    });

    provisioningState.bindStream(_stateManager.provisioningState.stream);
    final Map<String, String?> args = Get.parameters;
    ssid = args['ssid'] ?? '';
    password = args['password'] ?? '';
    customData = args['customData'] ?? '';
    aesKey = args['aesKey'] ?? '';
    bssid = args['bssid'] ?? '';
  }

  @override
  void onReady() {
    super.onReady();
    delayedAndStartProvisioning();
  }

  void onComplete() {
    switch (provisioningState.value) {
      case ProvisioningState.complete:
        _stateManager.updateProvisioningState(ProvisioningState.complete);
        break;
      case ProvisioningState.stop:
        _stateManager.updateProvisioningState(ProvisioningState.idle);
        _logManager.clearEventMessages();
        Get.back();
        eventLogs.clear(); // This will trigger the list update
        break;
      default:
        break;
    }
  }

  void delayedAndStartProvisioning() {
    Future.delayed(Duration(seconds: 1), () {
      startProvisioningUsecase.startProvisioning(
        ssid: ssid,
        bssid: bssid,
        password: password,
        customData: customData,
        aesKey: aesKey,
      );
    });
  }

  String getButtonTitle() {
    switch (provisioningState.value) {
      case ProvisioningState.complete:
        return 'Complete';
      case ProvisioningState.stop:
        return 'Retry';
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
