import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:bmw_legal_assistant/core/theme/colors.dart';

class WinProbabilityPath extends StatelessWidget {
  final double strengthScore;

  const WinProbabilityPath({
    super.key, 
    required this.strengthScore,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 200,
          height: 60,
          child: CustomPaint(
            painter: _WinningRoadPainter(strengthScore),
            child: const SizedBox.expand(),
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${strengthScore.toInt()}%',
              style: TextStyle(
                color: AppColors.bmwBlue,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            Text(
              'Win Probability',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _WinningRoadPainter extends CustomPainter {
  final double strengthScore;

  _WinningRoadPainter(this.strengthScore);

  @override
  void paint(Canvas canvas, Size size) {
    // Road path
    final roadPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height / 2);
    path.quadraticBezierTo(
      size.width * 0.25, size.height * 0.2, 
      size.width * 0.5, size.height / 2
    );
    path.quadraticBezierTo(
      size.width * 0.75, size.height * 0.8, 
      size.width, size.height / 2
    );
    canvas.drawPath(path, roadPaint);

    // Car positioning
    final carBodyPaint = Paint()
      ..color = AppColors.bmwBlue
      ..style = PaintingStyle.fill;
    
    final carWindowPaint = Paint()
      ..color = Colors.white.withOpacity(0.7)
      ..style = PaintingStyle.fill;
    
    final wheelPaint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.fill;

    // Calculate car position based on strength score
    final carX = size.width * (strengthScore / 100);
    final carY = _calculateYOnCurve(path, carX);

    // Car body (side view)
    final carBodyPath = Path()
      ..moveTo(carX - 20, carY)  // Left bottom
      ..lineTo(carX - 20, carY - 10)  // Left top
      ..quadraticBezierTo(carX - 15, carY - 15, carX, carY - 15)  // Roof curve
      ..quadraticBezierTo(carX + 15, carY - 15, carX + 20, carY - 10)  // Right roof
      ..lineTo(carX + 20, carY)  // Right bottom
      ..close();
    canvas.drawPath(carBodyPath, carBodyPaint);

    // Windshield (side angle)
    final windshieldPath = Path()
      ..moveTo(carX - 15, carY - 10)
      ..lineTo(carX - 10, carY - 15)
      ..lineTo(carX + 10, carY - 15)
      ..lineTo(carX + 15, carY - 10)
      ..close();
    canvas.drawPath(windshieldPath, carWindowPaint);

    // Wheels (side view)
    canvas.drawCircle(Offset(carX - 12, carY + 2), 4, wheelPaint);
    canvas.drawCircle(Offset(carX + 12, carY + 2), 4, wheelPaint);
  }

  // Helper method to calculate Y position on the curved path
  double _calculateYOnCurve(Path path, double x) {
    return path.getBounds().center.dy + 
           (path.getBounds().height / 4) * 
           (math.sin((x / path.getBounds().width) * math.pi));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}