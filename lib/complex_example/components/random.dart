import 'dart:math' as math;

import 'package:diagram_editor/diagram_editor.dart';
import 'package:flutter/material.dart';

class RandomComponent extends StatelessWidget {
  final ComponentData componentData;

  const RandomComponent({
    Key? key,
    required this.componentData,
  }) : super(key: key);

  Path componentPath() {
    Path path = Path();
    path.moveTo(
      componentData.size.width * math.Random().nextDouble(),
      componentData.size.height * math.Random().nextDouble(),
    );
    int maxI = math.Random().nextInt(16) + 4;
    for (int i = 0; i < maxI; i++) {
      path.quadraticBezierTo(
        componentData.size.width * math.Random().nextDouble(),
        componentData.size.height * math.Random().nextDouble(),
        componentData.size.width * math.Random().nextDouble(),
        componentData.size.height * math.Random().nextDouble(),
      );
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: CustomPaint(
        painter: RandomPainter(
          color: Colors.grey,
          borderColor: componentData.data.isHighlightVisible
              ? Colors.pink
              : Colors.black,
          borderWidth: 2,
          path: componentPath(),
          path2: componentPath(),
        ),
      ),
    );
  }
}

class RandomPainter extends CustomPainter {
  final Color color;
  final Color borderColor;
  final double borderWidth;
  final Path path;
  final Path path2;

  RandomPainter({
    this.color = Colors.grey,
    this.borderColor = Colors.black,
    this.borderWidth = 1.0,
    required this.path,
    required this.path2,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.amber
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);

    paint..color = color;

    canvas.drawPath(path2, paint);

    if (borderWidth > 0) {
      paint
        ..style = PaintingStyle.stroke
        ..color = borderColor
        ..strokeWidth = borderWidth;

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  @override
  bool hitTest(Offset position) {
    return path.contains(position) || path2.contains(position);
  }
}
