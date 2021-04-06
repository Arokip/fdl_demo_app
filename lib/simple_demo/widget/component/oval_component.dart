import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/simple_demo/custom_data.dart';
import 'package:diagram_editor_apps/simple_demo/edit_dialog.dart';
import 'package:flutter/material.dart';

class OvalBody extends StatelessWidget {
  final ComponentData componentData;

  const OvalBody({
    Key key,
    this.componentData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CustomData customData = componentData.data;

    return LayoutBuilder(builder: (context, size) {
      return GestureDetector(
        onLongPress: () {
          showEditComponentDialog(context, componentData);
        },
        child: Container(
          decoration: BoxDecoration(
            color: customData.color,
            borderRadius: BorderRadius.all(
              Radius.elliptical(size.maxWidth, size.maxHeight),
            ),
            border: Border.all(
              width: 2.0,
              color: customData.isHighlightVisible ? Colors.pink : Colors.black,
            ),
          ),
          child: Center(
            child: Text(customData.text),
          ),
        ),
      );
    });
  }
}
