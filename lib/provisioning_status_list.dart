import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:alfa_tool/event_log.dart';
import 'package:alfa_tool/provisioning_status_list_controller.dart';

class ProvisioningStatusList extends GetView<ProvisioningStatusListController> {
  const ProvisioningStatusList({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidthPadding = screenWidth / 6;
    double screenHeightPadding = screenHeight / 4;

    return Container(
      padding: EdgeInsets.only(
        left: screenWidthPadding,
        right: screenWidthPadding,
        top: screenHeightPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: controller.eventLogs.length,
                itemBuilder: (context, index) {
                  return _buildItem(
                    context,
                    controller.eventLogs[index],
                    isDarkMode,
                    index,
                  );
                },
              );
            }),
          ),
          SizedBox(height: 24),
          Obx(() {
            return AnimatedOpacity(
              opacity: controller.getButtonShouldShow() ? 1.0 : 0.0,
              duration: Duration(milliseconds: 300),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemIndigo.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: CupertinoButton(
                      onPressed: controller.onComplete,
                      child: Text(
                        controller.getButtonTitle(),
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
            );
          }),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildItem(
    BuildContext context,
    EventLog event,
    bool isDarkMode,
    int index,
  ) {
    IconData icon;
    Color color;

    switch (event.type) {
      case EventLogType.success:
        icon = Icons.check_circle;
        color = isDarkMode ? Colors.blue : Colors.green;
        break;
      case EventLogType.failure:
        icon = Icons.error;
        color = isDarkMode ? Colors.red : Colors.redAccent;
        break;
      case EventLogType.info:
        icon = Icons.info;
        color = isDarkMode ? Colors.yellow : Colors.orange;
        break;
      case EventLogType.stop:
        icon = Icons.stop_circle;
        color = isDarkMode ? Colors.grey : Colors.grey;
        break;
      default:
        icon = Icons.circle;
        color = isDarkMode ? Colors.grey : Colors.grey;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 36.0),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
          ),
          SizedBox(width: 12.0),
          Expanded(
            child: Text(
              event.message,
              style: TextStyle(
                color:
                    isDarkMode ? CupertinoColors.white : CupertinoColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
