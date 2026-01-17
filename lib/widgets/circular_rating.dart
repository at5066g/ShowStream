import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Circular progress indicator for movie ratings
class CircularRating extends StatelessWidget {
  final double rating;
  final double size;
  final double strokeWidth;

  const CircularRating({
    super.key,
    required this.rating,
    this.size = 60,
    this.strokeWidth = 4,
  });

  Color _getRatingColor(double rating) {
    if (rating >= 7) {
      return const Color(0xFF21D07A); // Green for good
    } else if (rating >= 5) {
      return const Color(0xFFD2D531); // Yellow for average
    } else {
      return const Color(0xFFDB2360); // Red for poor
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getRatingColor(rating);
    final percentage = (rating / 10).clamp(0.0, 1.0);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: const Color(0xFF081C22),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          // Progress arc
          CustomPaint(
            size: Size(size, size),
            painter: _CircularProgressPainter(
              progress: percentage,
              color: color,
              backgroundColor: color.withOpacity(0.3),
              strokeWidth: strokeWidth,
            ),
          ),
          // Rating text
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${(rating * 10).round()}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size * 0.28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '%',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size * 0.12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  _CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2 - 4;

    // Background arc
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2, // Start from top
      2 * math.pi * progress, // Sweep angle
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
