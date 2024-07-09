import 'package:flutter/services.dart';

class ESPTouch {
  static const platform = MethodChannel('com.example.esptouch');

  static Future<void> startProvisioning(
      String ssid, String bssid, String password) async {
    await platform.invokeMethod('startProvisioning', {
      'ssid': ssid,
      'bssid': bssid,
      'password': password,
    });
  }

  static Future<void> startSync() async {
    await platform.invokeMethod('startSync');
  }

  static void setEventHandler(Function(String event, String? message) handler) {
    platform.setMethodCallHandler((MethodCall methodCall) async {
      switch (methodCall.method) {
        default:
          final String event = methodCall.method;
          final String? message = methodCall.arguments;
          print('Event received: $event, message: $message'); // Dart 端日志输出
          handler(event, message);
          break;
      }
    });
  }
}

enum EventType {
  channelCreate("channelCreate"),
  onProvisioningStart("onProvisioningStart"),
  onProvisioningScanResult("onProvisioningScanResult"),
  onProvisioningStop("onProvisioningStop"),
  onProvisioningError("onProvisioningError"),
  onSyncStart("onSyncStart"),
  onSyncStop("onSyncStop"),
  onSyncError("onSyncError");

  final String methodName;
  const EventType(this.methodName);
}
