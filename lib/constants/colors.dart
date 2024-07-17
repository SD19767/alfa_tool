import 'package:alfa_tool/constants/animated_background_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppColor {
  static Color black = const Color(0xFF000000);
  static Color white = const Color(0xFFFFFFFF);

  static final Map<BackgroundState, List<Color>> waveColors1 = {
    BackgroundState.green: [
      CupertinoColors.systemGreen.withOpacity(0.5),
      CupertinoColors.systemTeal.withOpacity(0.5),
      CupertinoColors.systemYellow.withOpacity(0.5),
    ],
    BackgroundState.galaxy: [
      CupertinoColors.systemRed.withOpacity(0.5),
      CupertinoColors.systemOrange.withOpacity(0.5),
      CupertinoColors.systemYellow.withOpacity(0.5),
      CupertinoColors.systemGreen.withOpacity(0.5),
      CupertinoColors.systemBlue.withOpacity(0.5),
      CupertinoColors.systemPurple.withOpacity(0.5),
    ],
    BackgroundState.purple: [
      CupertinoColors.systemPurple.withOpacity(0.5),
      CupertinoColors.systemIndigo.withOpacity(0.5),
      CupertinoColors.systemPink.withOpacity(0.5),
    ],
  };

  static final Map<BackgroundState, List<Color>> waveColors2 = {
    BackgroundState.green: [
      CupertinoColors.systemTeal.withOpacity(0.5),
      CupertinoColors.systemGreen.withOpacity(0.5),
      CupertinoColors.systemBlue.withOpacity(0.5),
    ],
    BackgroundState.galaxy: [
      CupertinoColors.systemPurple.withOpacity(0.5),
      CupertinoColors.systemBlue.withOpacity(0.5),
      CupertinoColors.systemGreen.withOpacity(0.5),
      CupertinoColors.systemYellow.withOpacity(0.5),
      CupertinoColors.systemOrange.withOpacity(0.5),
      CupertinoColors.systemRed.withOpacity(0.5),
    ],
    BackgroundState.purple: [
      CupertinoColors.systemIndigo.withOpacity(0.5),
      CupertinoColors.systemPurple.withOpacity(0.5),
      CupertinoColors.systemPink.withOpacity(0.5),
    ],
  };
}
