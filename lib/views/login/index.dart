import 'dart:ui';
import 'package:alfa_tool/constants/colors.dart';
import 'package:alfa_tool/helper/validation.dart';
import 'package:alfa_tool/services/provisioning_state_manager.dart';
import 'package:alfa_tool/widgets/app_elevated_button.dart';
import 'package:alfa_tool/widgets/app_title_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../animated_background/index.dart';
import 'controller.dart';
import '../animated_background/controller.dart';

class LoginView extends GetView<LoginController> {
  final BackgroundController backgroundController =
      Get.put(BackgroundController());
  final Validation validations = Get.find<Validation>();
  late int _clickCount;

  LoginView({super.key}) {
    _clickCount = 0; // Initialize click count
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    final AnimatedBackground animatedBackground =
        Get.find<AnimatedBackground>();

    return Obx(() {
      backgroundController.changeState(controller.backgroundState.value);

      return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Positioned.fill(child: animatedBackground),
            SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  GestureDetector(
                    onTap: _handleTitleTap,
                    child: AppTitleText(isDarkMode: isDarkMode),
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
          ],
        ),
      );
    });
  }

  void _handleTitleTap() {
    _clickCount++;
    if (_clickCount >= 10) {
      _clickCount = 0; // Reset count
      controller.showCustomFields.value = !controller.showCustomFields.value;
      // Toggle visibility of the view events button
      controller.showViewEventsButton.value =
          !controller.showViewEventsButton.value;
    }
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
              key: controller.formKey,
              child: Column(
                children: [
                  _buildTextField(controller.ssidController, 'enter_ssid'.tr,
                      isDarkMode, false, ValidationType.ssid),
                  const SizedBox(height: 16),
                  _buildTextField(
                      controller.passwordController,
                      'enter_password'.tr,
                      isDarkMode,
                      true,
                      ValidationType.password),
                  const SizedBox(height: 16),
                  if (controller.showCustomFields.value) ...[
                    _buildTextField(
                        controller.customDataController,
                        'enter_custom_data'.tr,
                        isDarkMode,
                        false,
                        ValidationType.reservedData),
                    const SizedBox(height: 16),
                    _buildTextField(
                        controller.aesKeyController,
                        'enter_aes_key'.tr,
                        isDarkMode,
                        false,
                        ValidationType.aesKey),
                    const SizedBox(height: 16),
                  ],
                  AppElevatedButton(
                      isDarkMode: isDarkMode,
                      shouldShow: () => true,
                      onPressed: () {
                        controller.startProvisioningButtonTap();
                      },
                      buttonTitle: 'start_provisioning'.tr),
                  const SizedBox(height: 24),
                  Obx(() {
                    return IgnorePointer(
                      ignoring: controller.shouldShowEventLog() ? false : true,
                      child: Visibility(
                        visible: controller.showViewEventsButton.value,
                        child: Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: controller.shouldShowEventLog()
                                ? () => _showEventLog(context, isDarkMode)
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppColor.backgroundColor(isDarkMode, 0.6),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text('view_events'.tr),
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String placeholder,
      bool isDarkMode, bool obscureText, ValidationType? validationType) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: placeholder,
        filled: true,
        fillColor: AppColor.backgroundColor(isDarkMode, 0.4),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      obscureText: obscureText,
      style: TextStyle(
        color: AppColor.textColor(isDarkMode),
      ),
      validator: validationType != null
          ? validations.validations[validationType]
          : null,
    );
  }

  void _showEventLog(BuildContext context, bool isDarkMode) {
    Get.defaultDialog(
      title: 'event_log'.tr,
      content: SizedBox(
        height: 300, // 設定對話框內容的最大高度
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Check if there are any logs to display
              if (controller.logs.isEmpty)
                Center(
                  child: Text(
                    'No events found', // 預設消息
                    style: TextStyle(
                      color: AppColor.textColor(isDarkMode),
                    ),
                  ),
                )
              else
                ...controller.logs.map((log) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      log.eventMessage,
                      style: TextStyle(
                        color: AppColor.textColor(isDarkMode),
                      ),
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: Text('close'.tr),
        ),
      ],
      barrierDismissible: true, // 使點擊外部區域也能關閉對話框
    );
  }
}
