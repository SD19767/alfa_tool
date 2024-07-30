import 'package:alfa_tool/constants/animated_background_state.dart';
import 'package:alfa_tool/use_cases/start_provisioning_useCase.dart';
import 'package:get/get.dart';
import 'package:alfa_tool/models/event_log.dart';
import 'package:alfa_tool/services/provisioning_state_manager.dart';
import 'package:alfa_tool/services/event_log_manager.dart';

class ProvisioningController extends GetxController {
  RxList<EventLog> eventLogs = <EventLog>[].obs;
  Rx<ProvisioningState> provisioningState = ProvisioningState.idle.obs;
  final ProvisioningStateManagerInterface _stateManager =
      Get.find<ProvisioningStateManagerInterface>();
  final EventLogManager _logManager = Get.find<EventLogManager>();
  final StartProvisioningUseCase _startProvisioningUseCase =
      Get.find<StartProvisioningUseCase>();

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
    _stateManager.updateProvisioningState(ProvisioningState.idle);
    _logManager.clearEventMessages();
    _stateManager.updateBackgroundState(BackgroundState.purple);
    Get.back();
    eventLogs.clear();
  }

  void delayedAndStartProvisioning() {
    Future.delayed(const Duration(seconds: 1), () {
      _startProvisioningUseCase.startProvisioning(
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
        return 'close'.tr;
      case ProvisioningState.stop:
        return 'retry'.tr;
      default:
        return '';
    }
  }

  bool getButtonShouldShow() {
    switch (provisioningState.value) {
      case ProvisioningState.complete:
        return false;
      case ProvisioningState.stop:
        return true;
      default:
        return false;
    }
  }
}
