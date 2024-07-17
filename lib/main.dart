import 'package:alfa_tool/services/ESPTouch.dart';
import 'package:alfa_tool/services/ESPTouch_Service.dart';
import 'package:alfa_tool/services/event_log_manager.dart';
import 'package:alfa_tool/services/provisioning_state_manager.dart';
import 'package:alfa_tool/views/animated_background/index.dart';
import 'package:alfa_tool/views/provisioning/provisioning_status_list_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'views/login/provisioning_page.dart';
import 'views/login/provisioning_controller.dart';

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
    Get.put(AnimatedBackground());
    return GetCupertinoApp(
      initialBinding: BindingsBuilder(() {
        Get.put(ProvisioningController());
      }),
      home: ProvisioningPage(),
    );
  }
}
