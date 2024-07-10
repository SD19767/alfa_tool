import 'package:alfa_tool/ESPTouch.dart';
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
    return GetCupertinoApp(
      initialBinding: BindingsBuilder(() {
        Get.put(ProvisioningController());
      }),
      home: ProvisioningPage(),
    );
  }
}
