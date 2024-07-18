import 'package:alfa_tool/constants/animated_background_state.dart';
import 'package:flutter/cupertino.dart';

class AppColor {
  static const Color black = Color(0xFF101010);
  static const Color white = Color(0xFFE5E5E5);
  static const Color indigo = CupertinoColors.systemIndigo;
  static const Color red = CupertinoColors.systemRed;
  static const Color redAccent = Color(0xFFFF5252);
  static const Color green = CupertinoColors.systemGreen;
  static const Color yellow = CupertinoColors.systemYellow;
  static const Color orange = CupertinoColors.systemOrange;
  static const Color blue = CupertinoColors.systemBlue;
  static const Color pink = CupertinoColors.systemPink;
  static const Color grey = CupertinoColors.systemGrey;

  static Color textColor(bool isDarkMode) => isDarkMode ? white : black;

  static Color backgroundColor(bool isDarkMode, double opacity) =>
      isDarkMode ? black.withOpacity(opacity) : white.withOpacity(opacity);

  static Color buttonColor(bool isDarkMode) => isDarkMode ? white : black;

  static Color buttonTextColor(bool isDarkMode) => isDarkMode ? white : black;

  static List<Color> getWaveColors1(BackgroundState state, bool isDarkMode) {
    return isDarkMode ? darkModeWaveColors1[state]! : waveColors1[state]!;
  }

  static List<Color> getWaveColors2(BackgroundState state, bool isDarkMode) {
    return isDarkMode ? darkModeWaveColors2[state]! : waveColors2[state]!;
  }

  static final Map<BackgroundState, List<Color>> waveColors1 = {
    BackgroundState.green: [
      green.withOpacity(0.5),
      CupertinoColors.systemTeal.withOpacity(0.5),
      yellow.withOpacity(0.5),
    ],
    BackgroundState.galaxy: [
      red.withOpacity(0.5),
      orange.withOpacity(0.5),
      yellow.withOpacity(0.5),
      green.withOpacity(0.5),
      blue.withOpacity(0.5),
      CupertinoColors.systemPurple.withOpacity(0.5),
    ],
    BackgroundState.purple: [
      CupertinoColors.systemPurple.withOpacity(0.5),
      indigo.withOpacity(0.5),
      pink.withOpacity(0.5),
    ],
  };

  static final Map<BackgroundState, List<Color>> waveColors2 = {
    BackgroundState.green: [
      CupertinoColors.systemTeal.withOpacity(0.5),
      green.withOpacity(0.5),
      blue.withOpacity(0.5),
    ],
    BackgroundState.galaxy: [
      CupertinoColors.systemPurple.withOpacity(0.5),
      blue.withOpacity(0.5),
      green.withOpacity(0.5),
      yellow.withOpacity(0.5),
      orange.withOpacity(0.5),
      red.withOpacity(0.5),
    ],
    BackgroundState.purple: [
      indigo.withOpacity(0.5),
      CupertinoColors.systemPurple.withOpacity(0.5),
      pink.withOpacity(0.5),
    ],
  };

  // Dark mode colors
  static final Map<BackgroundState, List<Color>> darkModeWaveColors1 = {
    BackgroundState.green: [
      green.withOpacity(0.5),
      CupertinoColors.systemTeal.withOpacity(0.5),
      yellow.withOpacity(0.5),
    ],
    BackgroundState.galaxy: [
      red.withOpacity(0.5),
      orange.withOpacity(0.5),
      yellow.withOpacity(0.5),
      green.withOpacity(0.5),
      blue.withOpacity(0.5),
      CupertinoColors.systemPurple.withOpacity(0.5),
    ],
    BackgroundState.purple: [
      CupertinoColors.systemPurple.withOpacity(0.5),
      indigo.withOpacity(0.5),
      pink.withOpacity(0.5),
    ],
  };

  static final Map<BackgroundState, List<Color>> darkModeWaveColors2 = {
    BackgroundState.green: [
      CupertinoColors.systemTeal.withOpacity(0.5),
      green.withOpacity(0.5),
      blue.withOpacity(0.5),
    ],
    BackgroundState.galaxy: [
      CupertinoColors.systemPurple.withOpacity(0.5),
      blue.withOpacity(0.5),
      green.withOpacity(0.5),
      yellow.withOpacity(0.5),
      orange.withOpacity(0.5),
      red.withOpacity(0.5),
    ],
    BackgroundState.purple: [
      indigo.withOpacity(0.5),
      CupertinoColors.systemPurple.withOpacity(0.5),
      pink.withOpacity(0.5),
    ],
  };

  static const Color darkModeBackground = CupertinoColors.black;
  static const Color darkModeText = CupertinoColors.white;
}
