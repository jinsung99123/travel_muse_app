import 'dart:math';

import 'package:flutter/material.dart';

class CustomCircularIndicator extends StatefulWidget {
  const CustomCircularIndicator({super.key});

  @override
  State<CustomCircularIndicator> createState() =>
      _CustomCircularIndicatorState();
}

class _CustomCircularIndicatorState extends State<CustomCircularIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(); // 계속 회전
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: ShaderMask(
        shaderCallback: (bounds) {
          return const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomLeft,
            colors: [Color(0xFF1164E3), Color(0x00FFFFFF)],
            stops: [0.0, 1.0],
          ).createShader(bounds);
        },
        blendMode: BlendMode.srcIn,
        child: CustomPaint(size: const Size(54, 54), painter: _ArcPainter()),
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final startAngle = -pi / 2;
    final sweepAngle = 4 * pi / 3;

    final paint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6
          ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect.deflate(10), startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
