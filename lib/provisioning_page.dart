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

      final bool isProvisioning =
          controller.provisioningState.value == ProvisioningState.provisioning;

      return CupertinoPageScaffold(
        child: Stack(
          children: [
            Positioned.fill(child: AnimatedBackground()),
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
                    SizedBox(height: 50),
                    Center(
                      child: Text(
                        'Alfa Tool',
                        style: TextStyle(
                          fontFamily: '.SF Pro Text',
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
                      child: _buildInputFields(
                          context, isDarkMode, isProvisioning),
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

  Widget _buildInputFields(
      BuildContext context, bool isDarkMode, bool isProvisioning) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AnimatedOpacity(
          opacity: isProvisioning ? 0.0 : 1.0,
          duration: Duration(milliseconds: 300),
          child: AnimatedSize(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: Column(
              children: [
                if (!isProvisioning) ...[
                  _buildTextField(controller.ssidController, 'Enter SSID',
                      isDarkMode, false),
                  SizedBox(height: 16),
                  _buildTextField(controller.passwordController,
                      'Enter Password', isDarkMode, true),
                  SizedBox(height: 16),
                  if (controller.showCustomFields.value) ...[
                    _buildTextField(controller.customDataController,
                        'Enter Custom Data', isDarkMode, false),
                    SizedBox(height: 16),
                    _buildTextField(controller.aesKeyController,
                        'Enter AES Key', isDarkMode, false),
                    SizedBox(height: 16),
                  ],
                ],
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? CupertinoColors.systemIndigo.withOpacity(0.6)
                            : CupertinoColors.systemIndigo.withOpacity(0.6),
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
                if (!isProvisioning)
                  CupertinoButton(
                    child: Text('View Events'),
                    onPressed: () => _showEventLog(context),
                  ),
                SizedBox(height: 24),
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
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          obscureText: obscureText,
          style: TextStyle(
            color: isDarkMode ? CupertinoColors.white : CupertinoColors.black,
          ),
          decoration: BoxDecoration(
            color: isDarkMode
                ? CupertinoColors.black.withOpacity(0.4)
                : CupertinoColors.white.withOpacity(0.8),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }

  void _showEventLog(BuildContext context) {
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
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
