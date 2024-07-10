import 'dart:ui';
import 'package:alfa_tool/Animated_background_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'animated_background.dart';
import 'provisioning_controller.dart';
import 'background_controller.dart';

class ProvisioningPage extends GetView<ProvisioningController> {
  final BackgroundController backgroundController =
      Get.put(BackgroundController());
  late double _panStartPositionY;
  late double _panEndPositionY;

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Obx(() {
      BackgroundState backgroundState;
      switch (controller.provisioningState.value) {
        case ProvisioningState.provisioning:
          backgroundState = BackgroundState.galaxy;
          break;
        case ProvisioningState.complete:
          backgroundState = BackgroundState.green;
          break;
        case ProvisioningState.idle:
        default:
          backgroundState = BackgroundState.purple;
          break;
      }

      backgroundController.changeState(backgroundState);

      return CupertinoPageScaffold(
        child: Stack(
          children: [
            Positioned.fill(
              child: AnimatedBackground(),
            ),
            SafeArea(
              child: GestureDetector(
                onPanStart: (details) {
                  _panStartPositionY = details.globalPosition.dy;
                },
                onPanUpdate: (details) {
                  _panEndPositionY = details.globalPosition.dy;
                },
                onPanEnd: (details) {
                  if (_panStartPositionY != null && _panEndPositionY != null) {
                    double distance = _panEndPositionY - _panStartPositionY;
                    if (distance.abs() > 50) {
                      // 滑動距離大於 50 像素時觸發
                      if (distance < 0) {
                        // 向上滑动
                        controller.showCustomFields.value = true;
                      } else {
                        // 向下滑动
                        controller.showCustomFields.value = false;
                      }
                    }
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 50),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Alfa Tool',
                        style: TextStyle(
                          fontFamily: '.SF Pro Text', // 使用 Cupertino 系统字体
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode
                              ? CupertinoColors.white
                              : CupertinoColors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.end, // 從螢幕下方向上排列
                        children: [
                          // SSID 輸入框樣式
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                              child: CupertinoTextField(
                                controller: controller.ssidController,
                                placeholder: 'Enter SSID',
                                padding: EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 16.0),
                                style: TextStyle(
                                  color: isDarkMode
                                      ? CupertinoColors.white
                                      : CupertinoColors.black,
                                ),
                                decoration: BoxDecoration(
                                  color: isDarkMode
                                      ? CupertinoColors.black.withOpacity(0.4)
                                      : CupertinoColors.white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          // Password 輪入框樣式
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                              child: CupertinoTextField(
                                controller: controller.passwordController,
                                placeholder: 'Enter Password',
                                padding: EdgeInsets.symmetric(
                                    vertical: 16.0, horizontal: 16.0),
                                obscureText: true,
                                style: TextStyle(
                                  color: isDarkMode
                                      ? CupertinoColors.white
                                      : CupertinoColors.black,
                                ),
                                decoration: BoxDecoration(
                                  color: isDarkMode
                                      ? CupertinoColors.black.withOpacity(0.4)
                                      : CupertinoColors.white.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16),
                          // Custom Data 和 AES Key 输入框
                          AnimatedSize(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                            child: AnimatedOpacity(
                              opacity:
                                  controller.showCustomFields.value ? 1.0 : 0.0,
                              duration: Duration(milliseconds: 300),
                              child: controller.showCustomFields.value
                                  ? Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 5.0, sigmaY: 5.0),
                                            child: CupertinoTextField(
                                              controller: controller
                                                  .customDataController,
                                              placeholder: 'Enter Custom Data',
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 16.0,
                                                  horizontal: 16.0),
                                              style: TextStyle(
                                                color: isDarkMode
                                                    ? CupertinoColors.white
                                                    : CupertinoColors.black,
                                              ),
                                              decoration: BoxDecoration(
                                                color: isDarkMode
                                                    ? CupertinoColors.black
                                                        .withOpacity(0.4)
                                                    : CupertinoColors.white
                                                        .withOpacity(0.8),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 5.0, sigmaY: 5.0),
                                            child: CupertinoTextField(
                                              controller:
                                                  controller.aesKeyController,
                                              placeholder: 'Enter AES Key',
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 16.0,
                                                  horizontal: 16.0),
                                              style: TextStyle(
                                                color: isDarkMode
                                                    ? CupertinoColors.white
                                                    : CupertinoColors.black,
                                              ),
                                              decoration: BoxDecoration(
                                                color: isDarkMode
                                                    ? CupertinoColors.black
                                                        .withOpacity(0.4)
                                                    : CupertinoColors.white
                                                        .withOpacity(0.8),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 16),
                                      ],
                                    )
                                  : SizedBox.shrink(),
                            ),
                          ),
                          // Start Provisioning 按鈕
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: isDarkMode
                                      ? CupertinoColors.systemIndigo
                                          .withOpacity(0.6)
                                      : CupertinoColors.systemIndigo
                                          .withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: CupertinoButton(
                                  onPressed: controller.agreeToTerms.value
                                      ? controller.startProvisioning
                                      : null,
                                  child: Text(
                                    'Start Provisioning',
                                    style: TextStyle(
                                      color: isDarkMode
                                          ? CupertinoColors.white
                                          : CupertinoColors.black,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 24),
                          // View Events 按鈕
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
                                              itemCount: controller
                                                  .eventMessages.length,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: CupertinoButton(
                                                    padding: EdgeInsets.zero,
                                                    onPressed: () {},
                                                    child: Container(
                                                      alignment:
                                                          Alignment.centerLeft,
                                                      padding:
                                                          EdgeInsets.all(12.0),
                                                      color: CupertinoColors
                                                          .systemGrey5,
                                                      child: Text(
                                                        controller
                                                                .eventMessages[
                                                            index],
                                                        style: TextStyle(
                                                            color:
                                                                CupertinoColors
                                                                    .black),
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
                    SizedBox(height: 24), // 确保下方有足够的间距
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
