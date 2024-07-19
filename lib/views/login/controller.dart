import 'package:alfa_tool/constants/animated_background_state.dart';
import 'package:alfa_tool/models/event_log.dart';
import 'package:alfa_tool/services/event_log_manager.dart';
import 'package:alfa_tool/services/provisioning_state_manager.dart';
import 'package:alfa_tool/useCases/esp_event_handler_useCase.dart';
import 'package:alfa_tool/useCases/start_provisioning_useCase.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var ssidController = TextEditingController(text: 'AlfaLoop');
  var passwordController = TextEditingController(text: '12345687');
  var customDataController = TextEditingController();
  var aesKeyController = TextEditingController();
  StartProvisioningUseCase startProvisioningUseCase =
      Get.put(StartProvisioningUseCase());

  var showCustomFields = false.obs;
  RxList<EventLog> logs = <EventLog>[].obs;
  Rx<ProvisioningState> provisioningState = ProvisioningState.idle.obs;
  Rx<BackgroundState> backgroundState = BackgroundState.purple.obs;

  final ProvisioningStateManagerInterface _stateManager =
      Get.find<ProvisioningStateManagerInterface>();
  final EventLogManager _logManager = Get.find<EventLogManager>();
  final ESPEventHandlerUseCase _eventHandlerUseCase =
      Get.find<ESPEventHandlerUseCase>();

  @override
  void onInit() {
    super.onInit();
    logs.bindStream(_logManager.eventMessages.stream);
    provisioningState.bindStream(_stateManager.provisioningState.stream);
    backgroundState.bindStream(_stateManager.backgroundState.stream);
    _eventHandlerUseCase.setEventHandler();
  }

  Future<void> _startProvisioning() async {
    String ssid = ssidController.text;
    String password = passwordController.text;
    String reservedData = customDataController.text;
    String aesKey = aesKeyController.text;
    try {
      startProvisioningUseCase.validateAndPrepareProvisioningData(
          ssid: ssid,
          bssid: 'AA:BB:CC:DD:EE:FF',
          password: password,
          customData: reservedData,
          aesKey: aesKey);
      Get.toNamed('/provisioning', parameters: {
        'ssid': ssid,
        'bssid': 'AA:BB:CC:DD:EE:FF',
        'password': password,
        'customData': reservedData,
        'aesKey': aesKey
      });
    } catch (error) {
      _showErrorDialog(error.toString());
    }
  }

  Future<void> startProvisioningButtonTap() async {
    shouldStartProvisioning() ? _startProvisioning() : null;
  }

  bool shouldShowEventLog() =>
      provisioningState.value == ProvisioningState.idle;
  bool shouldStartProvisioning() =>
      provisioningState.value == ProvisioningState.idle;

  void _showErrorDialog(String message) {
    Get.dialog(
      CupertinoAlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('OK'),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
