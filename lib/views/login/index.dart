import 'dart:ui';
import 'package:alfa_tool/constants/colors.dart';
import 'package:alfa_tool/services/provisioning_state_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // Import for Flutter Material
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
            child: Form(
              autovalidateMode: AutovalidateMode.always,
              key: controller.formKey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CupertinoFormSection(
                  backgroundColor: Colors.red,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildFormField(
                        controller: controller.ssidController,
                        placeholder: 'enter_ssid'.tr,
                        isDarkMode: isDarkMode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'SSID cannot be empty';
                          }
                          return null;
                        },
                      ),
                    ),
                    _buildFormField(
                      controller: controller.passwordController,
                      placeholder: 'enter_password'.tr,
                      isDarkMode: isDarkMode,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password cannot be empty';
                        }
                        return null;
                      },
                    ),
                    if (controller.showCustomFields.value) ...[
                      _buildFormField(
                        controller: controller.customDataController,
                        placeholder: 'enter_custom_data'.tr,
                        isDarkMode: isDarkMode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Custom data cannot be empty';
                          }
                          return null;
                        },
                      ),
                      _buildFormField(
                        controller: controller.aesKeyController,
                        placeholder: 'enter_aes_key'.tr,
                        isDarkMode: isDarkMode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'AES key cannot be empty';
                          }
                          return null;
                        },
                      ),
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
                              if (_validateFields()) {
                                controller.startProvisioningButtonTap();
                              }
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
          ),
        ),
      ],
    );
  }

  Widget _buildFormField({
    required TextEditingController controller,
    required String placeholder,
    required bool isDarkMode,
    bool obscureText = false,
    required FormFieldValidator<String> validator,
  }) {
    return CupertinoTextFormFieldRow(
      controller: controller,
      placeholder: placeholder,
      obscureText: obscureText,
      style: TextStyle(color: AppColor.textColor(isDarkMode)),
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      decoration: BoxDecoration(
          color:
              Colors.blue, // Ensure the background is transparent here
          borderRadius: BorderRadius.circular(8.0),
          backgroundBlendMode: BlendMode.
          ),
      validator: validator,
    );
  }

  bool _validateFields() {
    // Validate each field manually
    bool isValid = true;

    // Validate each field manually
    if (controller.ssidController.text.isEmpty) {
      isValid = false;
    }
    if (controller.passwordController.text.isEmpty) {
      isValid = false;
    }
    if (controller.showCustomFields.value) {
      if (controller.customDataController.text.isEmpty) {
        isValid = false;
      }
      if (controller.aesKeyController.text.isEmpty) {
        isValid = false;
      }
    }

    return isValid;
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
