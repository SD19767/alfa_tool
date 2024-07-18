import 'package:alfa_tool/services/ESPTouch_Service.dart';
import 'package:alfa_tool/constants/animated_background_state.dart';
import 'package:alfa_tool/models/event_log.dart';
import 'package:alfa_tool/services/event_log_manager.dart';
import 'package:alfa_tool/constants/event_type.dart';
import 'package:alfa_tool/services/provisioning_state_manager.dart';
import 'package:alfa_tool/usecases/start_provisioning_usecase.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var ssidController = TextEditingController(text: 'AlfaLoop');
  var passwordController = TextEditingController(text: '12345687');
  var customDataController = TextEditingController();
  var aesKeyController = TextEditingController();
  StartProvisioningUsecase startProvisioningUsecase =
      Get.put(StartProvisioningUsecase());

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
          break;
        case EventType.onProvisioningStop:
          _stateManager.updateBackgroundState(BackgroundState.purple);
          break;
        default:
          break;
      }
    });
  }

  Future<void> _startProvisioning() async {
    String ssid = ssidController.text;
    String password = passwordController.text;
    String reservedData = customDataController.text;
    String aesKey = aesKeyController.text;
    try {
      startProvisioningUsecase.validateAndPrepareProvisioningData(
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
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('OK'),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
