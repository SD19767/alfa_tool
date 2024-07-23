import 'package:alfa_tool/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppTitleText extends StatelessWidget {
  final bool isDarkMode;

  const AppTitleText({
    super.key,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      'app_title'.tr,
      style: TextStyle(
        decoration: TextDecoration.none,
        fontFamily: '.SF Pro Text',
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: AppColor.textColor(isDarkMode),
      ),
      textAlign: TextAlign.center,
    );
  }
}
