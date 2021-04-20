import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/data/custom_component_data.dart';
import 'package:diagram_editor_apps/simple_diagram_editor/dialog/pick_color_dialog.dart';
import 'package:flutter/material.dart';

void showEditComponentDialog(
    BuildContext context, ComponentData componentData) {
  MyComponentData customData = componentData.data;

  Color color = customData.color;
  Color borderColor = customData.borderColor;

  double borderWidthPick = customData.borderWidth;
  double maxBorderWidth = 40;
  double minBorderWidth = 0;
  double borderWidthDelta = 0.1;

  final textController = TextEditingController(text: customData.text ?? '');

  Alignment textAlignmentDropdown = customData.textAlignment;
  var alignmentValues = [
    Alignment.topLeft,
    Alignment.topCenter,
    Alignment.topRight,
    Alignment.centerLeft,
    Alignment.center,
    Alignment.centerRight,
    Alignment.bottomLeft,
    Alignment.bottomCenter,
    Alignment.bottomRight,
  ];
  double textSizeDropdown = customData.textSize;
  var textSizeValues =
      List<double>.generate(20, (int index) => index * 2 + 10.0);

  showDialog(
    barrierDismissible: false,
    useSafeArea: true,
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 600),
              Text('Edit component', style: TextStyle(fontSize: 20)),
              TextField(
                controller: textController,
                maxLines: 1,
                decoration: InputDecoration(
                  labelText: 'Text',
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Container(
                child: DropdownButton<Alignment>(
                  value: textAlignmentDropdown,
                  onChanged: (Alignment newValue) {
                    setState(() {
                      textAlignmentDropdown = newValue;
                    });
                  },
                  items: alignmentValues.map((Alignment alignment) {
                    return DropdownMenuItem<Alignment>(
                      value: alignment,
                      child: Text('$alignment'),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Text('Font size:'),
                  SizedBox(width: 8),
                  Container(
                    child: DropdownButton<double>(
                      value: textSizeDropdown,
                      onChanged: (double newValue) {
                        setState(() {
                          textSizeDropdown = newValue;
                        });
                      },
                      items: textSizeValues.map((double textSize) {
                        return DropdownMenuItem<double>(
                          value: textSize,
                          child: Text('${textSize.toStringAsFixed(0)}'),
                        );
                      }).toList(),
                    ),
                  ),
                ],
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Border width:'),
                  Row(
                    children: [
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
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            width: 32,
                            height: 32,
                            child: Center(child: Icon(Icons.remove, size: 16))),
                      ),
                      Column(
                        children: [
                          Text(
                              '${double.parse(borderWidthPick.toStringAsFixed(1))}'),
                          Slider(
                            value: borderWidthPick,
                            onChanged: (double newValue) {
                              setState(() {
                                borderWidthPick =
                                    double.parse(newValue.toStringAsFixed(1));
                              });
                            },
                            min: minBorderWidth,
                            max: maxBorderWidth,
                          ),
                        ],
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
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            width: 32,
                            height: 32,
                            child: Center(child: Icon(Icons.add, size: 16))),
                      ),
                    ],
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
                customData.textAlignment = textAlignmentDropdown;
                customData.textSize = textSizeDropdown;
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
