import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/simple_demo/custom_component_data.dart';
import 'package:diagram_editor_apps/simple_demo/edit_dialog.dart';
import 'package:diagram_editor_apps/simple_demo/widget/component/base_component_body.dart';
import 'package:flutter/material.dart';

class BendRightBody extends StatelessWidget {
  final ComponentData componentData;

  const BendRightBody({
    Key key,
    this.componentData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseComponentBody(
      componentData: componentData,
      componentPainter: BendRightPainter(
        color: componentData.data.color,
        borderColor: componentData.data.borderColor,
        borderWidth: 2.0,
      ),
    );
  }
}

class BendRightPainter extends CustomPainter {
  final Color color;
  final Color borderColor;
  final double borderWidth;
  Size componentSize;

  BendRightPainter({
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
    path.moveTo(0, 0);
    path.lineTo(9 * componentSize.width / 10, 0);
    path.quadraticBezierTo(
      componentSize.width,
      componentSize.height / 5,
      componentSize.width,
      componentSize.height / 2,
    );
    path.quadraticBezierTo(
      componentSize.width,
      4 * componentSize.height / 5,
      9 * componentSize.width / 10,
      componentSize.height,
    );
    path.lineTo(0, componentSize.height);
    path.quadraticBezierTo(
      componentSize.width / 10,
      4 * componentSize.height / 5,
      componentSize.width / 10,
      componentSize.height / 2,
    );
    path.quadraticBezierTo(
      componentSize.width / 10,
      componentSize.height / 5,
      0,
      0,
    );
    path.close();
    return path;
  }
}
