import 'dart:ui';
import 'package:alfa_tool/ESPTouch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      home: ProvisioningPage(),
    );
  }
}

class ProvisioningPage extends StatefulWidget {
  @override
  _ProvisioningPageState createState() => _ProvisioningPageState();
}

class _ProvisioningPageState extends State<ProvisioningPage> {
  final TextEditingController _ssidController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _agreeToTerms = true;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/backgroundImage.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 50, 17, 71).withOpacity(0.5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Alfa Tool',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.normal,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      CupertinoTextField(
                        controller: _ssidController,
                        placeholder: 'Enter SSID',
                        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                      ),
                      SizedBox(height: 16),
                      CupertinoTextField(
                        controller: _passwordController,
                        placeholder: 'Enter Password',
                        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                        obscureText: true,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.white.withOpacity(0.3)),
                        ),
                      ),
                      SizedBox(height: 24),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Container(
                            color: Color.fromARGB(255, 105, 20, 147).withOpacity(0.8),
                            child: CupertinoButton(
                              color: Colors.transparent,
                              onPressed: _agreeToTerms
                                  ? () async {
                                      String ssid = _ssidController.text;
                                      String bssid = ""; // You might want to fetch the BSSID if needed
                                      String password = _passwordController.text;
                                      await ESPTouch.startProvisioning(ssid, bssid, password);
                                    }
                                  : null,
                              child: Text(
                                'Start Provisioning',
                                style: TextStyle(color: Colors.white),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Container(
                            color: Colors.white.withOpacity(0.2),
                            child: CupertinoButton(
                              color: Colors.transparent,
                              onPressed: () async {
                                await ESPTouch.startSync();
                              },
                              child: Text(
                                'Start Sync',
                                style: TextStyle(color: Colors.white),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
