import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/simple_demo/custom_component_data.dart';
import 'package:diagram_editor_apps/simple_demo/edit_dialog.dart';
import 'package:flutter/material.dart';

class RectBody extends StatelessWidget {
  final ComponentData componentData;

  const RectBody({
    Key key,
    @required this.componentData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MyComponentData customData = componentData.data;

    return GestureDetector(
      onLongPress: () {
        showEditComponentDialog(context, componentData);
      },
      child: Container(
        decoration: BoxDecoration(
          color: customData.color,
          border: Border.all(
            width: 2.0,
            color: customData.borderColor,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.tag_faces),
            Text(customData.text),
          ],
        ),
      ),
    );
  }
}
