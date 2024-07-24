import 'dart:ui'; // 需要導入 ImageFilter
import 'package:alfa_tool/constants/colors.dart';
import 'package:flutter/material.dart';

class AppElevatedButton extends StatelessWidget {
  final bool isDarkMode;
  final bool Function() shouldShow;
  final VoidCallback? onPressed;
  final String buttonTitle;

  const AppElevatedButton({
    super.key,
    required this.isDarkMode,
    required this.shouldShow,
    required this.onPressed,
    required this.buttonTitle,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: AppColor.buttonColor(isDarkMode),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: ElevatedButton(
            onPressed: shouldShow() ? onPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              elevation: 0,
            ),
            child: Text(
              buttonTitle,
              style: TextStyle(
                decoration: TextDecoration.none,
                color: AppColor.buttonTextColor(isDarkMode),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
