import 'package:alfa_tool/ESPTouch.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

enum ProvisioningState { idle, provisioning, complete }

class ProvisioningController extends GetxController {
  var ssidController = TextEditingController(text: 'AlfaLoop');
  var passwordController = TextEditingController(text: '12345687');
  var customDataController = TextEditingController();
  var aesKeyController = TextEditingController();
  var mockBSSID = 'AA:BB:CC:DD:EE:FF';
  var agreeToTerms = true.obs;
  var showCustomFields = false.obs;

  var eventMessages = <String>[].obs;
  var provisioningState = ProvisioningState.idle.obs;

  @override
  void onInit() {
    super.onInit();
    print("OnInit");
    ESPTouch.setEventHandler((event, message) {
      print('listening for: $event');
      String eventMessage =
          'Event: $event\nMessage: ${message ?? 'No message'}';
      eventMessages.add(eventMessage);
      if (event == EventType.onProvisioningStart) {
        provisioningState.value = ProvisioningState.provisioning;
      } else if (event == EventType.onProvisioningScanResult.methodName) {
        provisioningState.value = ProvisioningState.complete;
      }
    });
  }

  Future<void> startProvisioning() async {
    provisioningState.value = ProvisioningState.provisioning;
    String ssid = ssidController.text;
    String bssid = mockBSSID; // Fetch the BSSID if needed
    String password = passwordController.text;
    await ESPTouch.startProvisioning(ssid, bssid, password);
  }

  Future<void> startSync() async {
    await ESPTouch.startSync();
  }

  void reset() {
    provisioningState.value = ProvisioningState.idle;
    eventMessages.clear();
  }
}
