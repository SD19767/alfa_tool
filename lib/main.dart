import 'package:alfa_tool/services/ESPTouch.dart';
import 'package:alfa_tool/services/ESPTouch_Service.dart';
import 'package:alfa_tool/services/event_log_manager.dart';
import 'package:alfa_tool/services/provisioning_state_manager.dart';
import 'package:alfa_tool/views/animated_background/index.dart';
import 'package:alfa_tool/views/provisioning/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'views/login/index.dart';
import 'views/login/controller.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(ProvisioningStateManager());
    Get.put(EventLogManager());
    Get.put(ESPTouchService());
    Get.put(ProvisioningController());
    Get.put(AnimatedBackground());
    return GetCupertinoApp(
      initialBinding: BindingsBuilder(() {
        Get.put(LoginController());
      }),
      home: LoginView(),
    );
  }
}
