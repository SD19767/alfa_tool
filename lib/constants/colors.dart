import 'package:alfa_tool/constants/animated_background_state.dart';
import 'package:flutter/material.dart';

class AppColor {
  static const Color black = Color(0xFF101010);
  static const Color white = Color(0xFFE5E5E5);
  static const Color indigo = Colors.indigo;
  static const Color red = Colors.red;
  static const Color redAccent = Color(0xFFFF5252);
  static const Color green = Colors.green;
  static const Color yellow = Colors.yellow;
  static const Color orange = Colors.orange;
  static const Color blue = Colors.blue;
  static const Color pink = Colors.pink;
  static const Color grey = Colors.grey;

  static Color textColor(bool isDarkMode) => isDarkMode ? white : black;

  static Color backgroundColor(bool isDarkMode, double opacity) =>
      isDarkMode ? black.withOpacity(opacity) : white.withOpacity(opacity);

  static List<Color> buttonColor(bool isDarkMode) => isDarkMode
      ? [
          _mixWithBlack(pink).withOpacity(0.3),
          _mixWithBlack(Colors.purple).withOpacity(0.5),
          _mixWithBlack(indigo).withOpacity(0.5)
        ]
      : [
          _mixWithWhite(pink).withOpacity(0.3),
          _mixWithWhite(Colors.purple).withOpacity(0.5),
          _mixWithWhite(indigo).withOpacity(0.5)
        ];

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
      Colors.teal.withOpacity(0.5),
      yellow.withOpacity(0.5),
    ],
    BackgroundState.galaxy: [
      red.withOpacity(0.5),
      orange.withOpacity(0.5),
      yellow.withOpacity(0.5),
      green.withOpacity(0.5),
      blue.withOpacity(0.5),
      Colors.purple.withOpacity(0.5),
    ],
    BackgroundState.purple: [
      Colors.purple.withOpacity(0.5),
      indigo.withOpacity(0.5),
      pink.withOpacity(0.5),
    ],
  };

  static final Map<BackgroundState, List<Color>> waveColors2 = {
    BackgroundState.green: [
      Colors.teal.withOpacity(0.5),
      green.withOpacity(0.5),
      blue.withOpacity(0.5),
    ],
    BackgroundState.galaxy: [
      Colors.purple.withOpacity(0.5),
      blue.withOpacity(0.5),
      green.withOpacity(0.5),
      yellow.withOpacity(0.5),
      orange.withOpacity(0.5),
      red.withOpacity(0.5),
    ],
    BackgroundState.purple: [
      indigo.withOpacity(0.5),
      Colors.purple.withOpacity(0.5),
      pink.withOpacity(0.5),
    ],
  };

  // Dark mode colors
  static final Map<BackgroundState, List<Color>> darkModeWaveColors1 = {
    BackgroundState.green: [
      green.withOpacity(0.5),
      Colors.teal.withOpacity(0.5),
      yellow.withOpacity(0.5),
    ],
    BackgroundState.galaxy: [
      red.withOpacity(0.5),
      orange.withOpacity(0.5),
      yellow.withOpacity(0.5),
      green.withOpacity(0.5),
      blue.withOpacity(0.5),
      Colors.purple.withOpacity(0.5),
    ],
    BackgroundState.purple: [
      Colors.purple.withOpacity(0.5),
      indigo.withOpacity(0.5),
      pink.withOpacity(0.5),
    ],
  };

  static final Map<BackgroundState, List<Color>> darkModeWaveColors2 = {
    BackgroundState.green: [
      Colors.teal.withOpacity(0.5),
      green.withOpacity(0.5),
      blue.withOpacity(0.5),
    ],
    BackgroundState.galaxy: [
      Colors.purple.withOpacity(0.5),
      blue.withOpacity(0.5),
      green.withOpacity(0.5),
      yellow.withOpacity(0.5),
      orange.withOpacity(0.5),
      red.withOpacity(0.5),
    ],
    BackgroundState.purple: [
      indigo.withOpacity(0.5),
      Colors.purple.withOpacity(0.5),
      pink.withOpacity(0.5),
    ],
  };

  static const Color darkModeBackground = Colors.black;
  static const Color darkModeText = Colors.white;
  static Color _mixWithWhite(Color color) {
    return Color.lerp(Colors.white, color, 0.4) ?? color;
  }

  static Color _mixWithBlack(Color color) {
    return Color.lerp(Colors.black, color, 0.4) ?? color;
  }
}
