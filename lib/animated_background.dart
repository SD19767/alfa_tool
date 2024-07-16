import 'package:flutter/cupertino.dart';
import 'dart:math';
import 'package:alfa_tool/animated_background_colors.dart';
import 'package:get/get.dart';
import 'background_controller.dart';

class AnimatedBackground extends StatefulWidget {
  @override
  _AnimatedBackgroundState createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // 动画持续时间
  final Duration animationDuration = Duration(seconds: 12);
  final Duration colorChangeDuration = Duration(seconds: 4);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: animationDuration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _getRandomFrequency(double minFrequency, double maxFrequency) {
    final random = Random();
    return minFrequency + random.nextDouble() * (maxFrequency - minFrequency);
  }

  Color _lerpColor(List<Color> colors, double t) {
    final double segmentLength = 1.0 / (colors.length - 1);
    final int segmentIndex = (t / segmentLength).floor();
    final double segmentProgress =
        (t - segmentIndex * segmentLength) / segmentLength;
    final Color startColor = colors[segmentIndex % colors.length];
    final Color endColor = colors[(segmentIndex + 1) % colors.length];
    return Color.lerp(startColor, endColor, segmentProgress)!;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return GetBuilder<BackgroundController>(
      builder: (controller) {
        return AnimatedBuilder(
          animation: controller.animationController,
          builder: (context, child) {
            final BackgroundState currentState = controller.currentState.value;
            final double colorProgress = (controller.animationController.value *
                    (animationDuration.inSeconds /
                        colorChangeDuration.inSeconds)) %
                1.0;
            final double screenHeight = MediaQuery.of(context).size.height;

            // 使用比例计算波浪高度和振幅
            final double waveHeight1 = screenHeight * 0.4;
            final double waveAmplitude1 = screenHeight * 0.1;
            final double waveHeight2 = screenHeight * 0.26;
            final double waveAmplitude2 = screenHeight * 0.1;

            final Color waveColor1 = currentState == BackgroundState.galaxy
                ? _lerpColor(waveColors1[currentState]!, colorProgress)
                : waveColors1[currentState]![0];
            final Color waveColor2 = currentState == BackgroundState.galaxy
                ? _lerpColor(waveColors2[currentState]!, colorProgress)
                : waveColors2[currentState]![0];

            final Color baseColor =
                isDarkMode ? CupertinoColors.black : CupertinoColors.white;
            final Color blendedBackgroundColor = Color.alphaBlend(
              waveColor1.withOpacity(0.1),
              Color.alphaBlend(
                waveColor2.withOpacity(0.1),
                baseColor,
              ),
            );

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    blendedBackgroundColor,
                    baseColor,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: CustomPaint(
                painter: BackgroundPainter(
                  progress: controller.animationController.value,
                  waveHeight1: waveHeight1,
                  waveFrequency1: _getRandomFrequency(0.08, 0.08),
                  waveAmplitude1: waveAmplitude1,
                  waveHeight2: waveHeight2,
                  waveFrequency2: _getRandomFrequency(0.2, 0.2),
                  waveAmplitude2: waveAmplitude2,
                  waveColor1: waveColor1,
                  waveColor2: waveColor2,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class BackgroundPainter extends CustomPainter {
  final double progress; // 动画进度
  final double waveHeight1; // 波浪1高度
  final double waveFrequency1; // 波浪1频率
  final double waveAmplitude1; // 波浪1振幅
  final double waveHeight2; // 波浪2高度
  final double waveFrequency2; // 波浪2频率
  final double waveAmplitude2; // 波浪2振幅
  final Color waveColor1; // 第一个波浪颜色
  final Color waveColor2; // 第二个波浪颜色

  BackgroundPainter({
    required this.progress,
    required this.waveHeight1,
    required this.waveFrequency1,
    required this.waveAmplitude1,
    required this.waveHeight2,
    required this.waveFrequency2,
    required this.waveAmplitude2,
    required this.waveColor1,
    required this.waveColor2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制第一个波浪
    _drawWave(canvas, size, waveColor1, progress, waveHeight1, waveAmplitude1,
        waveFrequency1);

    // 绘制第二个波浪
    _drawWave(canvas, size, waveColor2, progress + 0.5, waveHeight2,
        waveAmplitude2, waveFrequency2);
  }

  void _drawWave(Canvas canvas, Size size, Color color, double progress,
      double height, double amplitude, double frequency) {
    final Paint wavePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Path path = Path();
    final double waveLength = size.width;

    for (double i = 0; i <= size.width; i++) {
      double y = height +
          amplitude *
              sin((i / waveLength * frequency * 2 * pi) + (progress * 2 * pi));
      if (i == 0) {
        path.moveTo(i, size.height - y);
      } else {
        path.lineTo(i, size.height - y);
      }
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, wavePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
