import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // 引入 material 以使用 Colors.transparent
import 'package:get/get.dart';
import 'provisioning_controller.dart';

class ProvisioningPage extends GetView<ProvisioningController> {
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
                    color: const Color.fromARGB(255, 83, 40, 104).withOpacity(0.2),
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
                          color: CupertinoColors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 24),
                      CupertinoTextField(
                        controller: controller.ssidController,
                        placeholder: 'Enter SSID',
                        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                        decoration: BoxDecoration(
                          color: CupertinoColors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: CupertinoColors.white.withOpacity(0.3)),
                        ),
                      ),
                      SizedBox(height: 16),
                      CupertinoTextField(
                        controller: controller.passwordController,
                        placeholder: 'Enter Password',
                        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                        obscureText: true,
                        decoration: BoxDecoration(
                          color: CupertinoColors.white.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: CupertinoColors.white.withOpacity(0.3)),
                        ),
                      ),
                      SizedBox(height: 24),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Container(
                            color: CupertinoColors.systemPurple.withOpacity(0.9),
                            child: CupertinoButton(
                              color: Colors.transparent, // 使用 Colors.transparent
                              onPressed: controller.agreeToTerms.value
                                  ? controller.startProvisioning
                                  : null,
                              child: Text(
                                'Start Provisioning',
                                style: TextStyle(color: CupertinoColors.white),
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
                            color: CupertinoColors.white.withOpacity(0.2),
                            child: CupertinoButton(
                              color: Colors.transparent, // 使用 Colors.transparent
                              onPressed: controller.startSync,
                              child: Text(
                                'Start Sync',
                                style: TextStyle(color: CupertinoColors.white),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 16.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      CupertinoButton(
                        child: Text('View Events'),
                        onPressed: () {
                          showCupertinoModalPopup(
                            context: context,
                            builder: (context) {
                              return CupertinoActionSheet(
                                title: Text('Event Log'),
                                message: Container(
                                  height: 300,
                                  child: Obx(() => CupertinoScrollbar(
                                    child: ListView.builder(
                                      itemCount: controller.eventMessages.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CupertinoButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () {},
                                            child: Container(
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.all(12.0),
                                              color: CupertinoColors.systemGrey5,
                                              child: Text(
                                                controller.eventMessages[index],
                                                style: TextStyle(color: CupertinoColors.black),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  )),
                                ),
                                actions: [
                                  CupertinoActionSheetAction(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Close'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
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