import 'package:alfa_tool/ESPTouch.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ESPTouch.setEventHandler((event, message) {
      print('Event: $event, Message: $message');
      // 根據事件和消息更新 UI 或進行其他操作
    });

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('ESPTouch Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  String ssid = "YourSSID";
                  String bssid = "YourBSSID";
                  String password = "YourPassword";
                  await ESPTouch.startProvisioning(ssid, bssid, password);
                },
                child: Text('Start Provisioning'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await ESPTouch.startSync();
                },
                child: Text('Start Sync'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
