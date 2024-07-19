import 'package:alfa_tool/localization/translations.dart';
import 'package:alfa_tool/services/ESPTouch_Service.dart';
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
  setupDependencies();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetCupertinoApp(
      translations: AppTranslations(),
      locale: Get.deviceLocale,
      initialBinding: BindingsBuilder(() {
        setupDependencies();
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

void setupDependencies() {
  Get.put(EventLogManager());
  Get.put<ProvisioningStateManagerInterface>(ProvisioningStateManager());
  Get.put<ESPTouchServiceInterface>(ESPTouchService());
  Get.put(AnimatedBackground());
}
