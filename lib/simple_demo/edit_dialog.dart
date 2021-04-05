import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/simple_demo/custom_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void showEditComponentDialog(
    BuildContext context, ComponentData componentData) {
  CustomData customData = componentData.data;

  final textController = TextEditingController(text: customData.text ?? '');

  showDialog(
    barrierDismissible: false,
    useSafeArea: true,
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: Column(
          children: [
            SizedBox(width: 600),
            Text('Edit component', style: TextStyle(fontSize: 20)),
            TextField(
              controller: textController,
              maxLines: 1,
              decoration: InputDecoration(
                labelText: 'Text',
                fillColor: Colors.white,
                contentPadding: EdgeInsets.only(left: 13),
              ),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                style: ButtonStyle(
                  textStyle: MaterialStateProperty.all(
                    TextStyle(color: Colors.grey[300]),
                  ),
                ),
                onPressed: () {
                  showPickColorDialog(context, componentData);
                },
                child: Text('Change color'),
              ),
            ),
          ],
        ),
        scrollable: true,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('DISCARD'),
          ),
          TextButton(
            onPressed: () {
              customData.text = textController.text;
              componentData.updateComponent();
              Navigator.of(context).pop();
            },
            child: Text('SAVE'),
          )
        ],
      );
    },
  );
}

void showPickColorDialog(BuildContext context, ComponentData componentData) {
  CustomData customData = componentData.data;

  Color currentColor =
      customData.color == null ? Colors.white : customData.color;

  showDialog(
    context: context,
    barrierDismissible: false,
    useSafeArea: true,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Pick a component color'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: currentColor,
            onColorChanged: (color) => currentColor = color,
            showLabel: true,
            pickerAreaHeightPercent: 0.8,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Set color'),
            onPressed: () {
              customData.color = currentColor;
              componentData.updateComponent();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
