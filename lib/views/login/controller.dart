import 'package:alfa_tool/constants/animated_background_state.dart';
import 'package:alfa_tool/models/event_log.dart';
import 'package:alfa_tool/services/event_log_manager.dart';
import 'package:alfa_tool/services/provisioning_state_manager.dart';
import 'package:alfa_tool/use_cases/esp_event_handler_useCase.dart';
import 'package:alfa_tool/use_cases/start_provisioning_useCase.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;

class LoginController extends GetxController {
  var ssidController = TextEditingController(text: '');
  var passwordController = TextEditingController(text: '');
  var customDataController = TextEditingController();
  var aesKeyController = TextEditingController();

  StartProvisioningUseCase startProvisioningUseCase =
      Get.put(StartProvisioningUseCase());

  var showCustomFields = false.obs;
  var showViewEventsButton = false.obs; // 新增屬性控制 view_events 按鈕顯示
  RxList<EventLog> logs = <EventLog>[].obs;
  Rx<ProvisioningState> provisioningState = ProvisioningState.idle.obs;
  Rx<BackgroundState> backgroundState = BackgroundState.purple.obs;

  final ProvisioningStateManagerInterface _stateManager =
      Get.find<ProvisioningStateManagerInterface>();
  final EventLogManager _logManager = Get.find<EventLogManager>();
  final ESPEventHandlerUseCase _eventHandlerUseCase =
      Get.find<ESPEventHandlerUseCase>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late int _clickCount; // 用於計算點擊次數

  @override
  void onInit() {
    super.onInit();
    _clickCount = 0; // 初始化點擊次數

    logs.bindStream(_logManager.logs.stream);
    provisioningState.bindStream(_stateManager.provisioningState.stream);
    backgroundState.bindStream(_stateManager.backgroundState.stream);

    _stateManager.provisioningState.listen((event) {
      provisioningState.refresh();
    });
    _logManager.logs.listen((event) {
      logs.refresh();
    });
    _eventHandlerUseCase.setEventHandler();
    _getCurrentSSID();
  }

  Future<void> _startProvisioning() async {
    if (formKey.currentState!.validate()) {
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

  Future<void> _getCurrentSSID() async {
    try {
      var status = await Permission.locationWhenInUse.status;
      if (status.isDenied) {
        status = await Permission.locationWhenInUse.request();
      }
      if (status.isGranted) {
        var wifiName = await NetworkInfo().getWifiName();
        if (wifiName != null) {
          if (Platform.isAndroid) {
            wifiName = wifiName.replaceAll('"', '');
          }
          ssidController.text = wifiName;
        } else {
          ssidController.text = 'Unknown SSID';
        }
      } else {
        ssidController.text = 'Permission denied';
      }
    } catch (e) {
      ssidController.text = 'Failed to get SSID';
    }
  }

  void handleTitleTap() {
    _clickCount++;
    if (_clickCount >= 10) {
      _clickCount = 0; // Reset count
      showCustomFields.value = !showCustomFields.value;
      showViewEventsButton.value =
          !showViewEventsButton.value; // 切換 view_events 按鈕顯示
    }
  }
}
