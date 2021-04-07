import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/simple_demo/custom_data.dart';
import 'package:diagram_editor_apps/simple_demo/edit_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundRectBody extends StatelessWidget {
  final ComponentData componentData;

  const RoundRectBody({
    Key key,
    @required this.componentData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CustomData customData = componentData.data;

    return GestureDetector(
      onLongPress: () {
        showEditComponentDialog(context, componentData);
      },
      child: Container(
        decoration: BoxDecoration(
          color: customData.color,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          border: Border.all(
            width: 2.0,
            color: customData.borderColor,
          ),
        ),
        child: Center(child: Text(customData.text)),
      ),
    );
  }
}
