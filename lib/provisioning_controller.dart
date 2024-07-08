import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'esptouch.dart';

class ProvisioningController extends GetxController {
  var ssidController = TextEditingController(text: 'AlfaLoop');
  var passwordController = TextEditingController(text: '12345687');
  var agreeToTerms = true.obs;

  // 用于存储所有事件信息的列表
  var eventMessages = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    ESPTouch.setEventHandler((event, message) {
      String eventMessage = 'Event: $event\nMessage: ${message ?? 'No message'}';
      eventMessages.add(eventMessage);
    });
  }

  Future<void> startProvisioning() async {
    String ssid = ssidController.text;
    String bssid = ""; // Fetch the BSSID if needed
    String password = passwordController.text;
    await ESPTouch.startProvisioning(ssid, bssid, password);
  }

  Future<void> startSync() async {
    await ESPTouch.startSync();
  }
}