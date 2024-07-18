import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ESPTouchService extends GetxService {
  static const platform = MethodChannel('com.example.esptouch');

  Future<void> startProvisioning(String ssid, String bssid, String password,
      String? reservedData, String? aesKey) async {
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

  Future<void> startSync() async {
    await platform.invokeMethod('startSync');
  }

  void setEventHandler(Function(MethodCall) callback) async {
    platform.setMethodCallHandler((MethodCall methodCall) async {
      callback(methodCall);
    });
  }
}
