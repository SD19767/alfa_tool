import 'dart:ui';
import 'package:alfa_tool/constants/colors.dart';
import 'package:alfa_tool/services/provisioning_state_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../animated_background/index.dart';
import 'controller.dart';
import '../animated_background/controller.dart';

class LoginView extends GetView<LoginController> {
  final BackgroundController backgroundController =
      Get.put(BackgroundController());
  late double _panStartPositionY;
  late double _panEndPositionY;

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final AnimatedBackground animatedBackground =
        Get.find<AnimatedBackground>();

    return Obx(() {
      backgroundController.changeState(controller.backgroundState.value);

      return CupertinoPageScaffold(
        child: Stack(
          children: [
            Positioned.fill(child: animatedBackground),
            SafeArea(
              child: GestureDetector(
                onPanStart: (details) {
                  _panStartPositionY = details.globalPosition.dy;
                },
                onPanUpdate: (details) {
                  _panEndPositionY = details.globalPosition.dy;
                },
                onPanEnd: (details) {
                  double distance = _panEndPositionY - _panStartPositionY;
                  if (distance.abs() > 50) {
                    if (distance < 0) {
                      controller.showCustomFields.value = true;
                    } else {
                      controller.showCustomFields.value = false;
                    }
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 50),
                    Center(
                      child: SizedBox(
                        height: 60,
                        child: Text(
                          'app_title'.tr,
                          style: TextStyle(
                            fontFamily: '.SF Pro Text',
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: AppColor.textColor(isDarkMode),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: _buildInputFields(context, isDarkMode,
                          controller.provisioningState.value),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInputFields(BuildContext context, bool isDarkMode,
      ProvisioningState provisioningState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AnimatedOpacity(
          opacity: provisioningState == ProvisioningState.idle ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Column(
              children: [
                _buildTextField(controller.ssidController, 'enter_ssid'.tr,
                    isDarkMode, false),
                const SizedBox(height: 16),
                _buildTextField(controller.passwordController,
                    'enter_password'.tr, isDarkMode, true),
                const SizedBox(height: 16),
                if (controller.showCustomFields.value) ...[
                  _buildTextField(controller.customDataController,
                      'enter_custom_data'.tr, isDarkMode, false),
                  const SizedBox(height: 16),
                  _buildTextField(controller.aesKeyController,
                      'enter_aes_key'.tr, isDarkMode, false),
                  const SizedBox(height: 16),
                ],
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColor.backgroundColor(isDarkMode, 0.6),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: CupertinoButton(
                        onPressed: () {
                          controller.startProvisioningButtonTap();
                        },
                        child: Text(
                          'start_provisioning'.tr,
                          style: TextStyle(
                            color: AppColor.buttonTextColor(isDarkMode),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                IgnorePointer(
                  ignoring: controller.shouldShowEventLog() ? false : true,
                  child: CupertinoButton(
                    child: Text('view_events'.tr),
                    onPressed: controller.shouldShowEventLog()
                        ? () => _showEventLog(context, isDarkMode)
                        : null,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String placeholder,
      bool isDarkMode, bool obscureText) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: CupertinoTextField(
          controller: controller,
          placeholder: placeholder,
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          obscureText: obscureText,
          style: TextStyle(
            color: AppColor.textColor(isDarkMode),
          ),
          decoration: BoxDecoration(
            color: AppColor.backgroundColor(isDarkMode, 0.4),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }

  void _showEventLog(BuildContext context, bool isDarkMode) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: Text('event_log'.tr),
          message: Container(
            height: 300,
            child: Obx(() => CupertinoScrollbar(
                  child: ListView.builder(
                    itemCount: controller.logs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          child: Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              controller.logs[index].eventMessage,
                              style: TextStyle(
                                color: AppColor.textColor(isDarkMode),
                              ),
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
              onPressed: () => Navigator.pop(context),
              child: Text('close'.tr),
            ),
          ],
        );
      },
    );
  }
}
