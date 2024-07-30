import 'package:alfa_tool/constants/colors.dart';
import 'package:alfa_tool/models/event_log.dart';
import 'package:alfa_tool/widgets/app_elevated_button.dart';
import 'package:alfa_tool/widgets/app_title_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller.dart';
import '../animated_background/index.dart';

class ProvisioningView extends GetView<ProvisioningController> {
  const ProvisioningView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenWidthPadding = screenWidth / 6;
    double screenHeightPadding = 24;
    final AnimatedBackground animatedBackground =
        Get.find<AnimatedBackground>();

    return Stack(
      children: [
        Positioned.fill(child: animatedBackground),
        Container(
          padding: EdgeInsets.only(
            left: screenWidthPadding,
            right: screenWidthPadding,
            top: screenHeightPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 50),
              AppTitleText(isDarkMode: isDarkMode),
              const SizedBox(height: 50),
              Expanded(
                child: Obx(() {
                  return ListView.builder(
                    itemCount: controller.eventLogs.length,
                    itemBuilder: (context, index) {
                      return _buildItem(context, controller.eventLogs[index],
                          isDarkMode, index);
                    },
                  );
                }),
              ),
              const SizedBox(height: 24),
              Obx(() {
                return IgnorePointer(
                  ignoring: controller.getButtonShouldShow() ? false : true,
                  child: AnimatedOpacity(
                      opacity: controller.getButtonShouldShow() ? 1.0 : 0.0,
                      duration: const Duration(milliseconds: 300),
                      child: AppElevatedButton(
                          isDarkMode: isDarkMode,
                          shouldShow: controller.getButtonShouldShow,
                          onPressed: controller.onComplete,
                          buttonTitle: controller.getButtonTitle())),
                );
              }),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildItem(
      BuildContext context, EventLog event, bool isDarkMode, int index) {
    IconData icon;
    Color color;

    switch (event.type) {
      case EventLogType.success:
        icon = Icons.check_circle;
        color = isDarkMode ? AppColor.blue : AppColor.green;
        break;
      case EventLogType.failure:
        icon = Icons.error;
        color = AppColor.redAccent;
        break;
      case EventLogType.info:
        icon = Icons.info;
        color = isDarkMode ? AppColor.green : AppColor.blue;
        break;
      case EventLogType.stop:
        icon = Icons.stop_circle;
        color = AppColor.grey;
        break;
      default:
        icon = Icons.circle;
        color = AppColor.grey;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 36.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Text(
              event.message,
              style: TextStyle(
                decoration: TextDecoration.none,
                color: AppColor.textColor(isDarkMode),
                fontFamily: '.SF Pro Text',
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
