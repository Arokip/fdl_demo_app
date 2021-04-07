import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/simple_demo/custom_component_data.dart';
import 'package:diagram_editor_apps/simple_demo/edit_dialog.dart';
import 'package:flutter/material.dart';

class RhomboidBody extends StatelessWidget {
  final ComponentData componentData;

  const RhomboidBody({
    Key key,
    this.componentData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MyComponentData customData = componentData.data;

    return GestureDetector(
      onLongPress: () {
        showEditComponentDialog(context, componentData);
      },
      child: CustomPaint(
        painter: RhomboidPainter(
          color: customData.color,
          borderColor: customData.borderColor,
          borderWidth: 2.0,
        ),
        child: Center(
          child: Text(customData.text),
        ),
      ),
    );
  }
}

class RhomboidPainter extends CustomPainter {
  final Color color;
  final Color borderColor;
  final double borderWidth;
  Size componentSize;

  RhomboidPainter({
    this.color = Colors.grey,
    this.borderColor = Colors.black,
    this.borderWidth = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    componentSize = size;

    Path path = componentPath();

    canvas.drawPath(path, paint);

    paint
      ..style = PaintingStyle.stroke
      ..color = borderColor
      ..strokeWidth = borderWidth;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  @override
  bool hitTest(Offset position) {
    Path path = componentPath();
    return path.contains(position);
  }

  Path componentPath() {
    Path path = Path();
    path.moveTo(componentSize.width / 6, 0);
    path.lineTo(componentSize.width, 0);
    path.lineTo(5 * componentSize.width / 6, componentSize.height);
    path.lineTo(0, componentSize.height);
    path.close();
    return path;
  }
}
