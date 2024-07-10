import 'package:flutter/cupertino.dart';

enum BackgroundState { green, galaxy, purple }

final Map<BackgroundState, List<Color>> waveColors1 = {
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

final Map<BackgroundState, List<Color>> waveColors2 = {
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
