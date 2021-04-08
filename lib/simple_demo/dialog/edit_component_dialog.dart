import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/simple_demo/data/custom_component_data.dart';
import 'package:diagram_editor_apps/simple_demo/dialog/pick_color_dialog.dart';
import 'package:flutter/material.dart';

void showEditComponentDialog(
    BuildContext context, ComponentData componentData) {
  MyComponentData customData = componentData.data;

  Color color = customData.color;
  Color borderColor = customData.borderColor;

  double borderWidthPick = customData.borderWidth;
  double maxBorderWidth = 20;
  double minBorderWidth = 0;
  double borderWidthDelta = 0.5;

  final textController = TextEditingController(text: customData.text ?? '');

  showDialog(
    barrierDismissible: false,
    useSafeArea: true,
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
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
              Row(
                children: [
                  Text('Component color:'),
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: () async {
                      var pickedColor = showPickColorDialog(
                          context, color, 'Pick a component color');
                      color = await pickedColor;
                      setState(() {});
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text('Border color:'),
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: () async {
                      var pickedColor = showPickColorDialog(context,
                          borderColor, 'Pick a component border color');
                      borderColor = await pickedColor;
                      setState(() {});
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                        border: Border.all(color: borderColor, width: 4),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text('Arrow size:'),
                  SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        borderWidthPick -= borderWidthDelta;
                        if (borderWidthPick > maxBorderWidth) {
                          borderWidthPick = maxBorderWidth;
                        } else if (borderWidthPick < minBorderWidth) {
                          borderWidthPick = minBorderWidth;
                        }
                      });
                    },
                    child: Container(
                        color: Colors.blue,
                        width: 20,
                        height: 20,
                        child: Center(child: Icon(Icons.remove, size: 12))),
                  ),
                  Container(
                    width: 50,
                    child: Center(
                      child: TextField(
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        readOnly: true,
                        controller: TextEditingController(
                            text: borderWidthPick.toStringAsFixed(1)),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        borderWidthPick += borderWidthDelta;
                        if (borderWidthPick > maxBorderWidth) {
                          borderWidthPick = maxBorderWidth;
                        } else if (borderWidthPick < minBorderWidth) {
                          borderWidthPick = minBorderWidth;
                        }
                      });
                    },
                    child: Container(
                        color: Colors.blue,
                        width: 20,
                        height: 20,
                        child: Center(child: Icon(Icons.add, size: 12))),
                  ),
                ],
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
                customData.color = color;
                customData.borderColor = borderColor;
                customData.borderWidth = borderWidthPick;
                componentData.updateComponent();
                Navigator.of(context).pop();
              },
              child: Text('SAVE'),
            )
          ],
        );
      });
    },
  );
}
