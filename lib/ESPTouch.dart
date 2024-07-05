import 'package:flutter/services.dart';

class ESPTouch {
  static const MethodChannel _channel = MethodChannel('com.example.esptouch');

  static Future<void> startProvisioning(String ssid, String bssid, String password) async {
    await _channel.invokeMethod('startProvisioning', {
      'ssid': ssid,
      'bssid': bssid,
      'password': password,
    });
  }

  static Future<void> startSync() async {
    await _channel.invokeMethod('startSync');
  }

  static void setEventHandler(Function(String event, String? message) handler) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onEvent') {
        final String event = call.arguments['event'];
        final String? message = call.arguments['message'];
        handler(event, message);
      }
    });
  }
}
