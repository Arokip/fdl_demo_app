import 'package:diagram_editor/diagram_editor.dart';
import 'package:diagram_editor_apps/simple_demo/data/custom_link_data.dart';
import 'package:diagram_editor_apps/simple_demo/dialog/pick_color_dialog.dart';
import 'package:flutter/material.dart';

void showEditLinkDialog(BuildContext context, LinkData linkData) {
  // MyLinkData customData = linkData.data;
  // LinkStyle linkStyle = linkData.linkStyle;

  // TODO: change labels

  Color color = linkData.linkStyle.color;
  LineType lineTypeDropdown = linkData.linkStyle.lineType;
  ArrowType arrowTypeDropdown = linkData.linkStyle.arrowType;
  double arrowSizePick = linkData.linkStyle.arrowSize;
  double lineWidthPick = linkData.linkStyle.lineWidth;

  double maxArrowSize = 15;
  double minArrowSize = 1;
  double arrowSizeDelta = 0.5;
  double maxLineWidth = 10;
  double minLineWidth = 0.1;
  double widthDelta = 0.1;

  showDialog(
    barrierDismissible: false,
    useSafeArea: true,
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            content: Column(
              children: [
                SizedBox(width: 600),
                Text('Edit link style', style: TextStyle(fontSize: 20)),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text('Line type:'),
                    SizedBox(width: 16),
                    Container(
                      child: DropdownButton<LineType>(
                        value: lineTypeDropdown,
                        onChanged: (LineType newValue) {
                          setState(() {
                            lineTypeDropdown = newValue;
                          });
                        },
                        items: LineType.values.map((LineType lineType) {
                          return DropdownMenuItem<LineType>(
                            value: lineType,
                            child: Text(lineType.toString()),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text('Arrow type:'),
                    SizedBox(width: 16),
                    Container(
                      child: DropdownButton<ArrowType>(
                        value: arrowTypeDropdown,
                        onChanged: (ArrowType newValue) {
                          setState(() {
                            arrowTypeDropdown = newValue;
                          });
                        },
                        items: ArrowType.values.map((ArrowType arrowType) {
                          return DropdownMenuItem<ArrowType>(
                            value: arrowType,
                            child: Text('$arrowType'),
                          );
                        }).toList(),
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
                          arrowSizePick -= arrowSizeDelta;
                          if (arrowSizePick > maxArrowSize) {
                            arrowSizePick = maxArrowSize;
                          } else if (arrowSizePick < minArrowSize) {
                            arrowSizePick = minArrowSize;
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
                              text: arrowSizePick.toStringAsFixed(1)),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          arrowSizePick += arrowSizeDelta;
                          if (arrowSizePick > maxArrowSize) {
                            arrowSizePick = maxArrowSize;
                          } else if (arrowSizePick < minArrowSize) {
                            arrowSizePick = minArrowSize;
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
                SizedBox(height: 8),
                Row(
                  children: [
                    Text('Line width:'),
                    SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          lineWidthPick -= widthDelta;
                          if (lineWidthPick > maxLineWidth) {
                            lineWidthPick = maxLineWidth;
                          } else if (lineWidthPick < minLineWidth) {
                            lineWidthPick = minLineWidth;
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
                              text: lineWidthPick.toStringAsFixed(1)),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          lineWidthPick += widthDelta;
                          if (lineWidthPick > maxLineWidth) {
                            lineWidthPick = maxLineWidth;
                          } else if (lineWidthPick < minLineWidth) {
                            lineWidthPick = minLineWidth;
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
                SizedBox(height: 8),
                Row(
                  children: [
                    Text('Color:'),
                    SizedBox(width: 16),
                    GestureDetector(
                      onTap: () async {
                        var pickedColor =
                            // showPickColorDialog(context, linkData);
                            showPickColorDialog(
                                context, color, 'Pick a line color');
                        color = await pickedColor;
                        setState(() {});
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black),
                        ),
                      ),
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
                  linkData.linkStyle.color = color;
                  linkData.linkStyle.lineType = lineTypeDropdown;
                  linkData.linkStyle.arrowType = arrowTypeDropdown;
                  linkData.linkStyle.arrowSize = arrowSizePick;
                  linkData.linkStyle.lineWidth = lineWidthPick;

                  linkData.updateLink();
                  Navigator.of(context).pop();
                },
                child: Text('SAVE'),
              )
            ],
          );
        },
      );
    },
  );
}
