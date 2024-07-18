import 'package:flutter/services.dart';

class ESPTouch {
  static const platform = MethodChannel('com.example.esptouch');

  static Future<void> startProvisioning(String ssid, String bssid,
      String password, String? reservedData, String? aesKey) async {
    // 創建一個包含必要參數的 Map
    Map<String, String?> args = {
      'ssid': ssid,
      'password': password,
      'bssid': bssid.isNotEmpty ? bssid : null,
      'reservedData':
          reservedData != null && reservedData.isNotEmpty ? reservedData : null,
      'aesKey': aesKey != null && aesKey.isNotEmpty ? aesKey : null
    };

    await platform.invokeMethod('startProvisioning', args);
  }

  static Future<void> startSync() async {
    await platform.invokeMethod('startSync');
  }

  static Future<void> stopProvisioning() async {
    await platform.invokeMethod('stopProvisioning');
  }

  static void setEventHandler(Function(String event, String? message) handler) {
    platform.setMethodCallHandler((MethodCall methodCall) async {
      switch (methodCall.method) {
        default:
          final String event = methodCall.method;
          final String? message = methodCall.arguments;
          handler(event, message);
          break;
      }
    });
  }
}
