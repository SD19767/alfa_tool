import 'package:alfa_tool/localization/translations.dart';
import 'package:alfa_tool/services/esptouch_service.dart';
import 'package:alfa_tool/services/event_log_manager.dart';
import 'package:alfa_tool/services/provisioning_state_manager.dart';
import 'package:alfa_tool/views/animated_background/index.dart';
import 'package:alfa_tool/views/login/bindings.dart';
import 'package:alfa_tool/views/provisioning/bindings.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'views/login/index.dart';
import 'views/provisioning/index.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetCupertinoApp(
      translations: AppTranslations(),
      locale: Get.deviceLocale,
      initialBinding: BindingsBuilder(() {
        Get.put(ProvisioningStateManager());
        Get.put(EventLogManager());
        Get.put(ESPTouchService());
        Get.put(AnimatedBackground());
      }),
      initialRoute: '/login',
      getPages: [
        GetPage(
          name: '/login',
          page: () => LoginView(),
          binding: LoginBindings(),
        ),
        GetPage(
          name: '/provisioning',
          page: () => ProvisioningView(),
          binding: ProvisioningBindings(),
        ),
      ],
    );
  }
}
