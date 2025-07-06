import 'package:flutter/material.dart';

class DashedBorderContainer extends StatelessWidget {
  final Widget child;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final Color color;
  final BorderRadius borderRadius;
  final EdgeInsets padding;

  DashedBorderContainer({
    this.strokeWidth = 1.0,
    this.dashWidth = 5.0,
    this.dashSpace = 3.0,
    this.color = Colors.black,
    this.borderRadius,
    this.padding = const EdgeInsets.all(8.0),
    @required this.child,
  }) : assert(child != null);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedBorderPainter(
        strokeWidth,
        dashWidth,
        dashSpace,
        color,
        borderRadius,
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;
  final Color color;
  final BorderRadius borderRadius;

  _DashedBorderPainter(
    this.strokeWidth,
    this.dashWidth,
    this.dashSpace,
    this.color,
    this.borderRadius,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = strokeWidth
      ..color = color
      ..style = PaintingStyle.stroke;

    final rect = Offset.zero & size;

    final path = Path();
    if (borderRadius != null) {
      path.addRRect(borderRadius.toRRect(rect));
    } else {
      path.addRect(rect);
    }

    _drawDashedPath(canvas, path, paint);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    final metrics = path.computeMetrics().toList();
    for (final metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, next),
          paint,
        );
        distance = next + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
