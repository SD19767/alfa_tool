import 'package:alfa_tool/localization/translations.dart';
import 'package:alfa_tool/services/esptouch_service.dart';
import 'package:alfa_tool/services/event_log_manager.dart';
import 'package:alfa_tool/services/provisioning_state_manager.dart';
import 'package:alfa_tool/views/animated_background/index.dart';
import 'package:alfa_tool/views/login/bindings.dart';
import 'package:alfa_tool/views/provisioning/bindings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart'; // 引入 url_launcher 包
import 'views/login/index.dart';
import 'views/provisioning/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化翻譯資料
  final appTranslations = AppTranslations();
  await appTranslations.loadTranslations();

  // 請求位置權限
  await requestLocationPermission();

  runApp(MyApp(translations: appTranslations));
}

class MyApp extends StatelessWidget {
  final AppTranslations translations;

  const MyApp({super.key, required this.translations});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: translations,
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
          page: () => const ProvisioningView(),
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
  // todo: 這個不應該出現在這裡，應該跟該頁面綁定生命週期。
  Get.put(const AnimatedBackground());
}

Future<void> requestLocationPermission() async {
  var status = await Permission.location.request();
  if (status.isGranted) {
    print("Alvin test: 位置權限已授予");
  } else if (status.isDenied) {
    print("Alvin test: 位置權限被拒絕");
  } else if (status.isPermanentlyDenied) {
    print("Alvin test: 位置權限被永久拒絕，請前往設置啟用");
    // 提示用戶前往設置
    openSettings();
  }
}

Future<void> openSettings() async {
  const url = 'App-Prefs:root=Privacy&path=LOCATION';
  final Uri uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    print("無法打開設置");
  }
}
