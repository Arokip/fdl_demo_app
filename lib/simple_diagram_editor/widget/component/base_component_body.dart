import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/data/custom_component_data.dart';
import 'package:flutter/material.dart';

class BaseComponentBody extends StatelessWidget {
  final ComponentData componentData;
  final CustomPainter componentPainter;

  const BaseComponentBody({
    super.key,
    required this.componentData,
    required this.componentPainter,
  });

  @override
  Widget build(BuildContext context) {
    final customData = componentData.data as MyComponentData?;

    return GestureDetector(
      child: CustomPaint(
        painter: componentPainter,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Align(
            alignment: customData?.textAlignment ?? Alignment.center,
            child: Text(
              customData?.text ?? '',
              style: TextStyle(fontSize: customData?.textSize ?? 20),
            ),
          ),
        ),
      ),
    );
  }
}
