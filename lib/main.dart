import 'package:alfa_tool/ESPTouch.dart';
import 'package:alfa_tool/ESPTouch_Service.dart';
import 'package:alfa_tool/event_log_manager.dart';
import 'package:alfa_tool/provisioning_state_manager.dart';
import 'package:alfa_tool/provisioning_status_list_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'provisioning_page.dart';
import 'provisioning_controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(ProvisioningStateManager());
    Get.put(EventLogManager());
    Get.put(ESPTouchService());
    Get.put(ProvisioningStatusListController());
    return GetCupertinoApp(
      initialBinding: BindingsBuilder(() {
        Get.put(ProvisioningController());
      }),
      home: ProvisioningPage(),
    );
  }
}
