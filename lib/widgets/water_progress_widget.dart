import 'dart:math';
import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

/// عرض دائري متحرك يوضح نسبة تقدم شرب الماء اليومي
class WaterProgressWidget extends StatelessWidget {
  final double progress; // 0.0 - 1.0
  final String centerLabel;
  final String subLabel;

  const WaterProgressWidget({
    super.key,
    required this.progress,
    required this.centerLabel,
    required this.subLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return CustomPaint(
                size: const Size(220, 220),
                painter: _WaterCirclePainter(
                  progress: value,
                  isDark: isDark,
                ),
              );
            },
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                centerLabel,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppTheme.deepBlue,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                subLabel,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WaterCirclePainter extends CustomPainter {
  final double progress;
  final bool isDark;

  _WaterCirclePainter({required this.progress, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    final backgroundPaint = Paint()
      ..color = isDark ? Colors.white12 : AppTheme.skyBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    final progressPaint = Paint()
      ..shader = SweepGradient(
        colors: const [AppTheme.lightBlue, AppTheme.primaryBlue, AppTheme.deepBlue],
        startAngle: 0,
        endAngle: 2 * pi,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _WaterCirclePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
