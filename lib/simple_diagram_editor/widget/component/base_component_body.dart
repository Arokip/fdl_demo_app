import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/data/custom_component_data.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/dialog/edit_component_dialog.dart';
import 'package:flutter/material.dart';

class BaseComponentBody extends StatelessWidget {
  final ComponentData componentData;
  final CustomPainter componentPainter;

  const BaseComponentBody({
    Key key,
    this.componentData,
    this.componentPainter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MyComponentData customData = componentData.data;

    return GestureDetector(
      // onLongPress: () {
      //   showEditComponentDialog(context, componentData);
      // },
      child: CustomPaint(
        painter: componentPainter,
        child: Center(
          child: Text(customData.text),
        ),
      ),
    );
  }
}
