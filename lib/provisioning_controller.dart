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

  var eventMessages = <EventLog>[].obs;
  var provisioningState = ProvisioningState.idle.obs;

  @override
  void onInit() {
    super.onInit();
    print("OnInit");
    ESPTouch.setEventHandler((event, message) {
      print('listening for: $event');
      String eventMessage =
          'Event: $event\nMessage: ${message ?? 'No message'}';
      switch (EventType.fromMethodName(event)) {
        case EventType.onProvisioningStart:
          eventMessages
              .add(EventLog(eventMessage, message ?? "", EventLogType.success));
          provisioningState.value = ProvisioningState.provisioning;
          break;
        case EventType.onProvisioningScanResult:
          eventMessages
              .add(EventLog(eventMessage, message ?? "", EventLogType.info));
          provisioningState.value = ProvisioningState.complete;
          break;
        case EventType.onProvisioningError:
          eventMessages
              .add(EventLog(eventMessage, message ?? "", EventLogType.failure));
          provisioningState.value = ProvisioningState.idle;
          break;
        case EventType.onProvisioningStop:
          eventMessages
              .add(EventLog(eventMessage, message ?? "", EventLogType.stop));
          provisioningState.value = ProvisioningState.idle;
        default:
          eventMessages
              .add(EventLog(eventMessage, message ?? "", EventLogType.info));
          break;
      }
    });
  }

  Future<void> startProvisioning() async {
    provisioningState.value = ProvisioningState.provisioning;
    String ssid = ssidController.text;
    String bssid = mockBSSID; // Fetch the BSSID if needed
    String password = passwordController.text;
    String reservedData = customDataController.text;
    String aseKey = aesKeyController.text;
    await ESPTouch.startProvisioning(
        ssid, bssid, password, reservedData, aseKey);
  }

  Future<void> startSync() async {
    await ESPTouch.startSync();
  }

  void reset() {
    provisioningState.value = ProvisioningState.idle;
    eventMessages.clear();
  }
}

class EventLog {
  String eventMessage;
  String message;
  EventLogType type;
  EventLog(this.eventMessage, this.message, this.type);
}

enum EventLogType { success, failure, info, stop }
